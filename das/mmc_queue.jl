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

rng = StableRNG(123)

num_customers = 1000
num_servers = 2

mu = 0.5
lam = 0.9

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

@resumable function customer(
    env::Environment,
    server::Resource,
    id::Int,
    t_a::Float64,
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

sim = Simulation()
server = Resource(sim, num_servers)

global arrival_time = 0.0

for i in 1:num_customers

    global arrival_time += rand(rng, arrival_dist)

    @process customer(
        sim,
        server,
        i,
        arrival_time,
    )
end

run(sim)

println("Среднее время ожидания: ", mean(log_df.waiting))
println("Среднее время обслуживания: ", mean(log_df.service))

CSV.write(datadir("mmc_results.csv"), log_df)

p1 = histogram(log_df.waiting, bins=30, xlabel="Waiting time", ylabel="Count", title="Waiting time distribution", legend=false)
p2 = histogram(log_df.service, bins=30, xlabel="Service time", ylabel="Count", title="Service time distribution", legend=false)
p3 = plot(log_df.id, cumsum(log_df.waiting)./(1:nrow(log_df)), xlabel="Customer", ylabel="Average waiting", title="Average waiting dynamics", legend=false)
p4 = scatter(log_df.arrival, log_df.waiting, xlabel="Arrival time", ylabel="Waiting time", title="Waiting vs arrival", legend=false)

final_plot = plot(p1, p2, p3, p4, layout=(2,2), size=(1200,800))
display(final_plot)
savefig(plotsdir("mmc_plots.png"))

println("Результаты сохранены в data/ и plots/")
