using Test

@testset "core" begin
    include("core/utils.jl")
    include("core/exceptions.jl")
    include("core/gle_script.jl")
    include("core/strings.jl")
end

@testset "types" begin
    include("types/style.jl")
    include("types/drawing_2d.jl")
end

@testset "apply" begin
    include("apply/figure.jl")
end

@testset "calls" begin
    include("calls/drawing_2d.jl")
end
