include("../utils.jl")

@testset "isdef, isanydef" begin
    @test G.isdef(1)
    @test !G.isdef(nothing)

    struct Foo_isdef
        a::G.Option{Int}
        b::G.Option{Int}
    end
    Foo = Foo_isdef

    f1 = Foo(1,2)
    f2 = Foo(1,nothing)
    f3 = Foo(nothing,2)
    f4 = Foo(nothing,nothing)
    @test G.isanydef(f1) && G.isanydef(f2) && G.isanydef(f3)
    @test !G.isanydef(f4)
end

@testset "reset!" begin
    mutable struct Foo_reset
        a::Int
        b::Int
    end
    Foo_reset(; bar=1) = Foo_reset(1, bar)
    Foo = Foo_reset

    f  = Foo(3, 2)
    f2 = Foo(3, 2)
    f3 = Foo(3, 2)
    G.reset!(f)
    G.reset!(f2, exclude=[:b])
    G.reset!(f3, bar=7)
    @test f.a == 1 == f.b
    @test f2.a == 1 && f2.b == 2
    @test f3.a == 1 && f3.b == 7
end

@testset "nvec" begin
    mutable struct Foo_nvec
        a::Int
    end
    Foo_nvec() = Foo_nvec(1)
    Foo = Foo_nvec

    v = G.nvec(2, Foo)
    @test length(v) == 2
    @test eltype(v) == Foo_nvec
    @test v[1].a == v[2].a == 1
end
