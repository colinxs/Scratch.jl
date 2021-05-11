function generate(;
    path,
    main,
    out = "$(joinpath(@__DIR__, basename(path)))-packed",
    compressor_path,
    compressor_args = [],
    tar_path,
)
    compressor_name = basename(compressor_path) 
    compressor   = "$compressor_path -z $(join(compressor_args, " "))"
    decompressor = "$compressor_path -d $(join(compressor_args, " "))"

    # TODO include cat, base64
    cmp64 = read(pipeline(`cat $compressor_path`, `base64 -w 0`))
    tar64 = read(pipeline(`cat $tar_path`, `base64 -w 0`))
    data64 = read(pipeline(`$tar_path -C $(path) -I "$compressor" -c . -O`, `base64 -w 0`))

    header = """
    #!/usr/bin/env sh 
    echo "ENTER"
    """

    footer = """
    echo "YO"
    TEMP="\$(mktemp -d)"

    BIN="\$TEMP/bin"
    mkdir -p "\$BIN"
    export PATH="\$BIN\${PATH:+:\${PATH}}"

    CMP="\$BIN/$(compressor_name)"
    TAR="\$BIN/tar"
    DATA="\$TEMP/data"

    echo "ONE"
    printf "\$CMP64" | base64 --decode > "\$CMP"
    echo "TWO"
    printf "\$TAR64" | base64 --decode > "\$TAR"
    echo "THREE"
    printf "\$DATA64" | base64 --decode  > "\$DATA"

    chmod +x "\$CMP"
    chmod +x "\$TAR"
    
    RUN="\$TEMP/run"
    mkdir -p "\$RUN"
    cd "\$RUN"
    echo "TARRRRRRRRRR"
    \$TAR -I "$decompressor" -xf "\$DATA"

    chmod +x ./$(main)
    ./$(main) || 1

    rm -rf "\$TEMP"
    pwd
    """
    
    open(out, "w") do io
        write(io, header, '\n')
        write(io, "CMP64=", '"', cmp64, '"', '\n')
        write(io, "TAR64=", '"', tar64, '"', '\n')
        write(io, "DATA64=", '"', data64, '"', '\n')
        write(io, footer, '\n')
    end
end

generate(
    path=joinpath(@__DIR__, "example"),
    main = "foo.sh",
    compressor_path = "/nix/store/0qbrrwaaf3fpzgf0cahand0vch168dc2-zstd-static-x86_64-unknown-linux-musl-1.4.9-bin/bin/zstd",
    # compressor_path = "/usr/bin/lz4",
    tar_path = "/nix/store/4hibd90qi12b3l0pahpg3w67njxvmd07-gnutar-static-x86_64-unknown-linux-musl-1.34/bin/tar",
    compressor_args = [ "--fast=20" "--threads=0" ],
    # compressor_args = [ "--fast=20" "--favor-decSpeed" "--sparse" ],
)
@info read(`du -sh example-packed`, String)
