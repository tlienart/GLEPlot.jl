include("../utils.jl")


@testset "NotImplementedError" begin
    e = G.NotImplementedError("foo")
    @test e.msg // "[foo] hasn't been implemented."
end


@testset "UnknownOptionError" begin
    e = G.UnknownOptionError("foo", 5)
    @test e.msg // "[foo] is not recognised as a valid option name for Int64."
end


@testset "OptionValueError" begin
    e = G.OptionValueError("foo", 5, "Bool")
    @test e.msg // "[foo] value given (5) didn't meet the expected format Bool."
end
