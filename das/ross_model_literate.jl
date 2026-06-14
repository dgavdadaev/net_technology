# # Модель Росса: система с резервом и ремонтом
#
# Дискретно-событийное моделирование системы с N работающими машинами,
# S запасными и несколькими ремонтниками. Исследование влияния числа
# машин на время до падения системы, сравнение с аналитической оценкой.
#
# Параметры:
# - N ∈ {5, 10, 20, 30} — количество работающих машин
# - S = 3 — количество запасных машин
# - repairers = 2 — количество ремонтников
# - λ = 100.0 — средняя наработка до отказа (часов)
# - μ = 1.0 — среднее время ремонта (часов)

using DrWatson
@quickactivate "project"
using ResumableFunctions
using ConcurrentSim
using Distributions
using StableRNGs
using DataFrames
using Statistics
using CSV
using Plots

# ### Параметры моделирования

RUNS = 10
machine_counts = [5, 10, 20, 30]
S = 3
repairers = 2
LAMBDA = 100.0
MU = 1.0

# ### Аналитическая оценка времени до падения

function analytical_estimate(N, S, λ, μ)
    λ_total = N / λ
    reserve_factor = S + 1
    return reserve_factor / max(λ_total - μ, 1e-6)
end

# ### Корутина машины (работа, отказ, ремонт)

@resumable function machine(
    env::Environment,
    repair_facility::Resource,
    spares::Store{Process},
    repair_queue_log,
    working_log,
    rng,
    F,
    G,
    N,
)
    while true
        try
            @yield timeout(env, Inf)
        catch
        end
        @yield timeout(env, rand(rng, F))
        current_working = N + length(spares.items) - 1
        push!(working_log, (now(env), current_working))
        get_spare = take!(spares)
        push!(repair_queue_log, (now(env), length(repair_facility.put_queue)))
        @yield get_spare | timeout(env)
        if state(get_spare) != ConcurrentSim.idle
            @yield interrupt(value(get_spare))
        else
            throw(StopSimulation("No more spares!"))
        end
        req = request(repair_facility)
        @yield req
        @yield timeout(env, rand(rng, G))
        @yield unlock(repair_facility)
        @yield put!(spares, active_process(env))
    end
end

# ### Инициализация системы

@resumable function start_sim(
    env::Environment,
    repair_facility::Resource,
    spares::Store{Process},
    repair_queue_log,
    working_log,
    rng,
    F,
    G,
    N,
    S,
)
    for i in 1:N
        proc = @process machine(env, repair_facility, spares, repair_queue_log, working_log, rng, F, G, N)
        @yield interrupt(proc)
    end
    for i in 1:S
        proc = @process machine(env, repair_facility, spares, repair_queue_log, working_log, rng, F, G, N)
        @yield put!(spares, proc)
    end
end

# ### Сбор результатов

results = DataFrame(machines = Int[], crash_time = Float64[], analytical = Float64[], avg_queue = Float64[])
plots_list = []

# ### Запуск экспериментов для разного числа машин

for N in machine_counts
    crash_times = Float64[]
    queue_means = Float64[]
    final_working_log = nothing

    for run_id in 1:RUNS
        rng = StableRNG(run_id)
        F = Exponential(LAMBDA)
        G = Exponential(MU)
        sim = Simulation()
        repair_facility = Resource(sim, repairers)
        spares = Store{Process}(sim)
        repair_queue_log = DataFrame(time = Float64[], queue = Int[])
        working_log = DataFrame(time = Float64[], working = Int[])

        @process start_sim(sim, repair_facility, spares, repair_queue_log, working_log, rng, F, G, N, S)
        run(sim)
        stop_time = now(sim)
        push!(crash_times, stop_time)
        qmean = isempty(repair_queue_log.queue) ? 0.0 : mean(repair_queue_log.queue)
        push!(queue_means, qmean)
        final_working_log = working_log
    end

    analytical = analytical_estimate(N, S, LAMBDA, MU)
    push!(results, (N, mean(crash_times), analytical, mean(queue_means)))

    p = plot(final_working_log.time, final_working_log.working, xlabel="Time", ylabel="Working machines", title="Machines dynamics N=$N", legend=false)
    push!(plots_list, p)
end

# ### Вывод сводной таблицы

println(results)
CSV.write(datadir("ross_model_results.csv"), results)

# ### График: среднее время до падения

p1 = bar(results.machines, results.crash_time, xlabel="Machines", ylabel="Crash time", title="Average crash time", label="Simulation")
plot!(p1, results.machines, results.analytical, lw=3, label="Analytical")

# ### График: средняя очередь на ремонт

p2 = plot(results.machines, results.avg_queue, marker=:circle, xlabel="Machines", ylabel="Queue", title="Average repair queue", label=false)

# ### Итоговый график

final_plot = plot(p1, p2, plots_list..., layout=(2,3), size=(1500,900))
display(final_plot)
savefig(plotsdir("ross_model_plots.png"))

println("Результаты сохранены в data/ и plots/")
