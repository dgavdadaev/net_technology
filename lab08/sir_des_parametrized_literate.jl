using DrWatson
@quickactivate "project"
include(srcdir("sir_model.jl"))
using .sir_model

using Random, StatsPlots, BenchmarkTools
using DataFrames, CSV

param_sets = [
    (β = 0.03, c = 10.0, γ = 0.25, label = "β=0.03 (слабая)"),
    (β = 0.05, c = 10.0, γ = 0.25, label = "β=0.05 (умеренная)"),
    (β = 0.07, c = 10.0, γ = 0.25, label = "β=0.07 (сильная)"),
]

tmax = 40.0
u0 = [990, 10, 0]  # S, I, R
seed = 1234

function run_experiment(u0, β, c, γ, tmax, seed)
    Random.seed!(seed)
    p = [β, c, γ]
    des_model = sir_model.MakeSIRModel(u0, p)
    sir_model.activate(des_model)
    sir_model.sir_run(des_model, tmax)
    data = sir_model.out(des_model)
    return data
end

results = []
plots_list = []

for params in param_sets
    println("Запуск: $(params.label)")
    data = run_experiment(u0, params.β, params.c, params.γ, tmax, seed)

    peak_I = maximum(data.I)
    final_R = data.R[end]

    push!(results, (
        β = params.β,
        γ = params.γ,
        label = params.label,
        peak_I = peak_I,
        final_R = final_R,
    ))

    p = @df data plot(
        :t,
        [:S :I :R],
        labels = ["S" "I" "R"],
        xlab = "Время",
        ylab = "Численность",
        title = params.label,
    )
    push!(plots_list, p)

    filename = "sir_des_$(replace(params.label, " " => "_")).csv"
    CSV.write(datadir(filename), data)
end

df_results = DataFrame(results)
println("\n=== Результаты ===")
show(df_results, allcols = true)
CSV.write(datadir("sir_des_param_study.csv"), df_results)

all_plots = plot(
    plots_list...,
    layout = (length(param_sets), 1),
    size = (800, 250 * length(param_sets)),
)
savefig(plotsdir("sir_des_comparison.png"))

println("\nРезультаты сохранены в data/ и plots/")
