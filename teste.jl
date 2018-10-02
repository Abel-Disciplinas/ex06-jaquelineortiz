using Plots, Base.Test
gr(size=(600,400))

include("integral.jl")

function teste()
    # Simpson com ϵ
    k = 1
    for (f, a, b, Iexato, M) in [(x -> exp(4x), 0, 2, (exp(8) - 1)/4, 4^4 * exp(8)),
                                 (x -> (exp(x) - sin(x + 2) + x), 0, 2, cos(4) - cos(2) + exp(2) + 1, exp(2) - sin(4)),
                                 (x -> (cos(pi * x) + x), 1, 2, 1.5, pi^4 * cos(pi * 2)),
                                 (x -> sin(3 + x), 0, pi/2, cos(3) - sin(4), cos(3 + pi/2)]
        @testset "Função $k" begin
            @test abs(Iexato - simpsoneps(f, a, b, 1e-8, M=M)) < 1e-8
            @test abs(Iexato - simpson_adaptivo(f, a, b, 1e-8)) < 1e-8
        end

        ϵ_array, ES_array, EA_array = [], [], []
        ϵ = 1.0
        while ϵ > 1e-12 * max(M, 1.0)
            I = simpsoneps(f, a, b, ϵ, M = M)
            E = max(abs(Iexato - I), 1e-20)
            push!(ϵ_array, ϵ)
            push!(ES_array, E)

            I = simpson_adaptivo(f, a, b, ϵ)
            E = max(abs(Iexato - I), 1e-20)
            push!(EA_array, E)
            ϵ /= 2
        end
        scatter(ϵ_array, ES_array, ms=3, c=:blue, lab="SR")
        scatter!(ϵ_array, EA_array, ms=3, c=:red, lab="SA")
        plot!(ϵ_array, ϵ_array, ms=3, c=:green, lab="", xaxis=:log, yaxis=:log,
              leg=:topleft)

        title!("Simpson repetido e adaptivo")
        png("compara$k")
        k += 1
    end
end

teste()
