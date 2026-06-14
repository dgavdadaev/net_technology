# # Параметризованные эксперименты: модель M/M/c
#
# Исследование влияния параметров (λ, μ, c) на характеристики
# системы массового обслуживания: время ожидания, вероятность
# ожидания, сравнение с аналитическими формулами.

using DrWatson
@quickactivate "project"
using StableRNGs
using Distributions
using ConcurrentSim
using ResumableFunctions
using DataFrames
using Statistics
using CSV
using Plots
using Random

# ### Наборы параметров

param_sets = [
    (lam = 0.5, mu = 0.5, c = 1, label = "M/M/1, ρ=1.0"),
    (lam = 0.5, mu = 0.5, c = 2, label = "M/M/2, ρ=0.5"),
    (lam = 0.9, mu = 0.5, c = 2, label = "M/M/2, ρ=0.9"),
    (lam = 0.9, mu = 0.5, c = 3, label = "M/M/3, ρ=0.6"),
    (lam = 1.5, mu = 0.5, c = 4, label = "M/M/4, ρ=0.75"),
]

NUM_CUSTOMERS = 500
SEED = 123

# ### Аналитический расчёт вероятности ожидания (формула Эрланга)

function analytical_Pwait(lam, mu, c)
    rho = lam / (c * mu)
    if rho >= 1
        return NaN
    end
    sum_term = sum(((c * rho)^n / factorial(n)) for n = 0:(c-1))
    P0 = (sum_term + (c * rho)^c / (factorial(c) * (1 - rho)))^(-1)
    Pwait = (c * rho)^c / (factorial(c) * (1 - rho)) * P0
    return Pwait
end

# ### Корутина заявки

@resumable function customer(
    env::Environment,
    server::Resource,
    id::Int,
    t_a::Float64,
    service_dist::Distribution,
    rng::StableRNG,
    log_df::DataFrame,
)
    @yield timeout(env, t_a)
    arrival_time = now(env)
    req = request(server)
    @yield req
    service_start = now(env)
    wait_time = service_start - arrival_time
    service_time = rand(rng, service_dist)
    @yield timeout(env, service_time)
    finish_time = now(env)
    @yield unlock(server)
    push!(log_df, (id, arrival_time, service_start, finish_time, wait_time, service_time))
end

# ### Функция запуска одного эксперимента

function run_experiment(lam, mu, c, num_customers, seed)
    rng = StableRNG(seed)
    arrival_dist = Exponential(1 / lam)
    service_dist = Exponential(1 / mu)

    log_df = DataFrame(
        id = Int[],
        arrival = Float64[],
        start_service = Float64[],
        finish = Float64[],
        waiting = Float64[],
        service = Float64[],
    )

    sim = Simulation()
    server = Resource(sim, c)
    global arrival_time = 0.0

    for i in 1:num_customers
        global arrival_time += rand(rng, arrival_dist)
        @process customer(sim, server, i, arrival_time, service_dist, rng, log_df)
    end

    run(sim)

    avg_wait = mean(log_df.waiting)
    avg_total = mean(log_df.finish .- log_df.arrival)
    max_wait = maximum(log_df.waiting)
    Pwait_sim = sum(log_df.waiting .> 0) / nrow(log_df)

    return (avg_wait = avg_wait, avg_total = avg_total, max_wait = max_wait, Pwait_sim = Pwait_sim)
end

# ### Запуск всех экспериментов

results = []

for params in param_sets
    println("Запуск: $(params.label)")
    stats = run_experiment(params.lam, params.mu, params.c, NUM_CUSTOMERS, SEED)
    Pwait_anal = analytical_Pwait(params.lam, params.mu, params.c)
    push!(results, merge(params, stats, (Pwait_anal = Pwait_anal,)))
end

# ### Сводная таблица

df = DataFrame(results)
println("\n=== Сводная таблица ===")
show(df, allcols=true)
CSV.write(datadir("mmc_param_study.csv"), df)

# ### Графики сравнения

p1 = bar([r.label for r in results], [r.avg_wait for r in results], xlabel="Конфигурация", ylabel="Среднее время ожидания", title="Сравнение среднего времени ожидания", legend=false)
xticks!(p1, 1:length(results), [r.label for r in results], rotation=45)

p2 = bar([r.label for r in results], [r.Pwait_sim for r in results], xlabel="Конфигурация", ylabel="P(ожидание)", title="Вероятность ожидания (симуляция)", legend=false)
xticks!(p2, 1:length(results), [r.label for r in results], rotation=45)

p3 = plot([r.Pwait_anal for r in results], [r.Pwait_sim for r in results], xlabel="Pwait (аналит.)", ylabel="Pwait (симуляция)", title="Сравнение с аналитикой", marker=:circle, legend=false)
plot!([0,1], [0,1], lw=1, ls=:dash, color=:gray)

final_plot = plot(p1, p2, p3, layout=(1,3), size=(1500,400))
display(final_plot)
savefig(plotsdir("mmc_param_plots.png"))

println("\nРезультаты сохранены в data/ и plots/")
