using Sim
using Test
tests = ["gridtest"]
for t in tests
    include("$(t).jl")
end
