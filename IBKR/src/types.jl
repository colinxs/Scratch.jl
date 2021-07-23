abstract type Contract end

struct Stock <: Contract
    symbol::String
    exchange::String
    currency::String
end
