module IBKR

using PyCall

const ib_insync = PyNULL()

include("types.jl")

function __init__()
    copy!(ib_insync, pyimport_conda("ib_insync", "ib-insync", "conda-forge"))
end

end
