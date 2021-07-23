module M

# using Pkg
# ENV["PYTHON"]=""
# Pkg.build("PyCall")

using IBKR

const TWS_REAL_PORT = 7496
const TWS_PAPER_PORT = 7497

function ib(f::Function, host="localhost", port=TWS_PAPER_PORT; kwargs...)
    ib = IBKR.ib_insync.IB()
    try
        ib.connect(host, port; kwargs...)
        f(ib)
    finally
        if ib.isConnected()
            ib.disconnect()
        end
    end
end

function account(ib, name)
    a = Dict()
    for (name2, tag, value, currency, model_code) in ib.accountSummary(name)
        @assert name == name2
        @assert !haskey(a, tag)
        a[tag] = d = Dict()
        d["value"] = value
        currency   != "" && (d["currency"]   = currency)
        model_code != "" && (d["model_code"] = model_code)
    end
    return a
end

function accounts(ib)
    as = Dict()
    for name in ib.managedAccounts()
        as[name] = account(ib, name)
    end
    return as
end

function main(ib)
    as = accounts(ib)
    (;ib, as) 
end

r = ib(main)

end # module
