# # Дискретно-событийная модель SIR
#
# Реализация эпидемиологической модели SIR (Susceptible–Infectious–Recovered)
# с использованием дискретно-событийного подхода.
# Каждый индивид — отдельный агент со своим жизненным циклом.
#
# Модель описывает переходы между состояниями:
# - S (восприимчивые) → I (инфицированные) при контакте с I
# - I (инфицированные) → R (выздоровевшие) по истечении времени болезни
#
# Параметры:
# - β = 0.05 — вероятность заражения при контакте
# - c = 10.0 — частота контактов (среднее число контактов в единицу времени)
# - γ = 0.25 — интенсивность выздоровления

using DrWatson
@quickactivate "project"
include(srcdir("sir_model.jl"))
using .sir_model

using Random, StatsPlots, BenchmarkTools

# ### Параметры модели

tmax = 40.0
u0 = [990, 10, 0]              # S, I, R
p = [0.05, 10.0, 0.25]         # β, c, γ

# ### Фиксация зерна для воспроизводимости

Random.seed!(1234)

# ### Запуск модели

des_model = sir_model.MakeSIRModel(u0, p)
sir_model.activate(des_model)
sir_model.sir_run(des_model, tmax)
data_des = sir_model.out(des_model)

# ### Визуализация

@df data_des plot(
    :t,
    [:S :I :R],
    labels = ["S" "I" "R"],
    xlab = "Время",
    ylab = "Численность",
    title = "Дискретно-событийная SIR модель",
)
savefig(plotsdir("sir_des.png"))

println("График сохранён в plots/sir_des.png")
