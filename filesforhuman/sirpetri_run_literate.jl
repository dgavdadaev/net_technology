# # Базовый запуск модели SIR
#
# Выполняется детерминированное и стохастическое моделирование
# эпидемического процесса с последующим сохранением результатов.

using DrWatson
@quickactivate "lab_06_SIR_petri"

include(srcdir("SIRPetri.jl"))

using CSV
using Plots
using Random

function main()

    # Параметры модели
    beta = 0.3
    gamma = 0.1
    tmax = 100.0

    # Построение сети Петри
    net, u0, _ = SIRPetri.build_sir_network(beta, gamma)

    # Детерминированная симуляция
    df_det = SIRPetri.simulate_deterministic(
        net,
        u0,
        (0.0, tmax);
        saveat = 0.5,
        rates = [beta, gamma],
    )
    CSV.write(datadir("sir_det.csv"), df_det)

    # Стохастическая симуляция
    Random.seed!(123)
    df_stoch = SIRPetri.simulate_stochastic(
        net,
        u0,
        (0.0, tmax);
        rates = [beta, gamma],
    )
    CSV.write(datadir("sir_stoch.csv"), df_stoch)

    # Построение и сохранение графиков
    p_det = SIRPetri.plot_sir(df_det)
    savefig(p_det, plotsdir("sir_det_dynamics.png"))

    p_stoch = SIRPetri.plot_sir(df_stoch)
    savefig(p_stoch, plotsdir("sir_stoch_dynamics.png"))

    println("Baseline SIR runs completed.")
end

main()
