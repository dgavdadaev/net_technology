module MMcQueue

using ConcurrentSim
using ResumableFunctions
using Distributions
using StableRNGs
using DataFrames

export run_mmc_simulation

const rng = StableRNG(123)

@resumable function customer(
    env::Environment,
    server::Resource,
    id::Int,
    arrival_time::Float64,
    service_dist,
    log_data,
)

    @yield timeout(env, arrival_time)

    arrival = now(env)

    @yield request(server)

    service_start = now(env)

    wait_time = service_start - arrival

    service_time = rand(rng, service_dist)

    @yield timeout(env, service_time)

    departure = now(env)

    push!(
        log_data,
        (
            id = id,
            arrival = arrival,
            service_start = service_start,
            departure = departure,
            wait_time = wait_time,
            service_time = service_time,
        ),
    )

    @yield unlock(server)

end

function run_mmc_simulation(
    num_customers;
    c = 2,
    λ = 0.9,
    μ = 0.5,
)

    arrival_dist = Exponential(1 / λ)
    service_dist = Exponential(1 / μ)

    sim = Simulation()
    server = Resource(sim, c)

    log_data = []

    arrival_time = 0.0

    for i in 1:num_customers

        arrival_time += rand(rng, arrival_dist)

        @process customer(
            sim,
            server,
            i,
            arrival_time,
            service_dist,
            log_data,
        )

    end

    run(sim)

    DataFrame(log_data)

end

end
