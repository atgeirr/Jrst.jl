using Sim
using Base.Test
tests = ["gridtest"]
for t in tests
    include("$(t).jl")
end
