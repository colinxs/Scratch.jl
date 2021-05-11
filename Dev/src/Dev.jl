module Dev

# Write your package code here.
#

macro exportall()
    exports = Expr[]
    for n in names(__module__, all=true)
        if Base.isidentifier(n) && n ∉ (Symbol(__module__), :eval, :include)
            push!(exports, :(export $n))
        end
    end
    return Expr(:block, exports...)
end

end
