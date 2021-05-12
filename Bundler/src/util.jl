function default_compressor()
    for c in DEFAULT_COMPRESSORS
        path = find_command(c)
        path !== nothing && return path
    end
    return nothing
end

function find_command(cmd)
    try
        path = strip(read(`sh -c "which $cmd"`, String))
        success(`$cmd --help`) && return path
    catch
    end
end

padto(s, l) = s * repeat(PAD_CHAR, l - length(s))

function gen_split(name, suffix=nothing)
    name = suffix === nothing ? name : "$(name)_$(suffix)"
    return "$(name)=\$(printf \"$(name):$(PADDING)\" | cut -d':' -f1)"
end

function gen_deserialize(var, out, sz, sha256, executable=false)
    str = """
    MS_dd \$0 \$OFFSET $sz > $(out)
    SHA256=\$(sha256sum $(out) | cut -d " " -f 1)
    if [[ \$SHA256 != $(sha256) ]]; then
        errorEcho "Detected sha256 mismatch for $(out)."
        errorEcho "Expected: "
        echo $(sha256)
        errorEcho "Got: "
        echo \$SHA256
        exit 1
    fi
    $(var)=$(out)
    OFFSET=\$(( OFFSET + $(sz) )) 
    """
    if executable
        str *= "chmod +x $(out)\n"
    end
    return str
end

function check_executable(path)
    return ispath(path) && Bool(operm(path) & 1) || error("Not an executable: $path")
end
