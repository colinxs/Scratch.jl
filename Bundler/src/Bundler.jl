module Bundler

# TODO bundle coreutils

using SHA

export bundle

include("util.jl")

const PAD_LEN = 32
const PAD_CHAR = "X"
const PADDING = repeat(PAD_CHAR, PAD_LEN)

const DEFAULT_COMPRESSORS = ("lz4", "zstd", "gzip", "xz")
const COMPRESSOR_DEFAULTS = Dict(
    "lz4" => ["--favor-decSpeed", "--sparse", "-10", "-BD"], "zstd" => ["-7", "--threads=0"]
)

function bundle(;
    path,
    main=nothing,
    out="$(joinpath(dirname(path), basename(path))).sh",
    compressor_path=default_compressor(),
    compressor_args=[],
    compress=true,
    tar_path=find_command("tar"),
    cleanup=true,
)
    if cleanup && main === nothing
        error("Either a main program needs to be specified or cleanup must be false")
    end

    main === nothing ||
        ispath(joinpath(path, main)) ||
        error("Main program not found: $main")

    tar_path = find_command(tar_path)
    check_executable(tar_path)

    if compress == true
        compressor_path = find_command(compressor_path)
        check_executable(compressor_path)
        cmp_name = basename(compressor_path)
        cmp_cmd = "$cmp_name $(join(compressor_args, " "))"
        cmp = read(compressor_path)
        cmp_sz = sizeof(cmp)
        cmp_sha256 = bytes2hex(sha256(cmp))
    end

    tar_name = basename(tar_path)
    tar = read(tar_path)
    tar_sz = sizeof(tar)
    tar_sha256 = bytes2hex(sha256(tar))

    dat = (
        if compress
            read(`$tar_path -C $(path) -I "$cmp_cmd" -hc . -O`)
        else
            read(`$tar_path -C $(path) -hc . -O`)
        end
    )
    dat_sz = sizeof(dat)
    dat_sha256 = bytes2hex(sha256(dat))

    header = """
    #!/usr/bin/env bash

    if [[ ! -z "\$PACKER_DEBUG" ]]; then
        set -ex
    fi

    $(read(joinpath(@__DIR__, "util.sh"), String))

    TEMP="\$(mktemp -d)"
    BIN="\$TEMP/bin"
    RUN="\$TEMP/run"
    mkdir "\$RUN"
    mkdir "\$BIN"

    export PATH="\$BIN\${PATH:+:\${PATH}}"
    export USER_PWD="$(pwd)"

    $(gen_split("OFFSET")) 

    $(compress ? gen_deserialize("CMP", "\$BIN/$(cmp_name)", cmp_sz, cmp_sha256, true) : "")
    $(gen_deserialize("TAR", "\$BIN/$(tar_name)", tar_sz, tar_sha256, true))
    $(gen_deserialize("DAT", "\$TEMP/data", dat_sz, dat_sha256))

    cd "\$RUN"

    $(compress ? "\$TAR -I '$cmp_cmd' -xf \"\$DAT\"" : "\$TAR -xf \"\$DAT\"")

    $(main === nothing ? "ret=0" : """
    chmod +x ./$(main)
    ./$(main)
    ret=\$?
    """)

    $(cleanup ? "rm -rf \$TEMP" : "")

    exit \$ret
    """

    orig = "OFFSET:$(PADDING)"
    new = padto("$(sizeof(header)):", length(orig))
    header = replace(header, orig => new)

    open(out, "w") do io
        write(io, header)
        compress && write(io, cmp)
        write(io, tar)
        write(io, dat)
    end

    chmod(out, 0o775)

    return nothing
end

end
