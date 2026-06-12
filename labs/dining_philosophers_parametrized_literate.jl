using DrWatson
@quickactivate "project"
include(srcdir("DiningPhilosophers.jl"))
using .DiningPhilosophers
using DataFrames, CSV, Plots

param_sets = [
    (N = 3, tmax = 30.0),
    (N = 5, tmax = 50.0),
    (N = 7, tmax = 70.0),
]

function run_experiment(N, tmax)
    println("N = $N, tmax = $tmax")

    net_classic, u0_classic, _ = build_classical_network(N)
    df_classic = simulate_stochastic(net_classic, u0_classic, tmax)
    CSV.write(datadir("dining_classic_N$(N).csv"), df_classic)
    dead_classic = detect_deadlock(df_classic, net_classic)

    net_arb, u0_arb, _ = build_arbiter_network(N)
    df_arb = simulate_stochastic(net_arb, u0_arb, tmax)
    CSV.write(datadir("dining_arbiter_N$(N).csv"), df_arb)
    dead_arb = detect_deadlock(df_arb, net_arb)

    return (N = N, tmax = tmax, deadlock_classic = dead_classic, deadlock_arbiter = dead_arb)
end

results = []
for params in param_sets
    result = run_experiment(params.N, params.tmax)
    push!(results, result)
end

df_results = DataFrame(results)
println("\n=== Результаты экспериментов ===")
println(df_results)
CSV.write(datadir("parameter_study_results.csv"), df_results)

plots_list = []
for params in param_sets
    N = params.N
    df = CSV.read(datadir("dining_classic_N$(N).csv"), DataFrame)
    eat_cols = [Symbol("Eat_$i") for i = 1:N]

    p = plot(
        df.time,
        Matrix(df[:, eat_cols]),
        label = ["Ф $i" for i = 1:N],
        xlabel = "Время",
        ylabel = "Ест",
        title = "N = $N (классическая сеть)",
    )
    push!(plots_list, p)
end

p_all = plot(plots_list..., layout = (length(param_sets), 1), size = (800, 300 * length(param_sets)))
savefig(plotsdir("parameter_comparison.png"))

println("\nГрафик сохранён в plots/parameter_comparison.png")
