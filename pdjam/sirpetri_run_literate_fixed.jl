# # Базовый запуск модели SIR
#
# Выполняется моделирование эпидемического процесса.

using DrWatson
@quickactivate "project"

using Random
include(srcdir("SIRPetri.jl"))
using .SIRPetri
using DataFrames, CSV, Plots

# Параметры модели
β = 0.3
γ = 0.1
tmax = 100.0

# Создание сети Петри
net, u0, states = build_sir_network(β, γ)

# Детерминированная и стохастическая симуляции
