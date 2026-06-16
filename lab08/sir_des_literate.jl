using DrWatson
@quickactivate "project"
include(srcdir("sir_model.jl"))
using .sir_model

using Random, StatsPlots, BenchmarkTools

tmax = 40.0
u0 = [990, 10, 0]              # S, I, R
p = [0.05, 10.0, 0.25]         # β, c, γ

Random.seed!(1234)

des_model = sir_model.MakeSIRModel(u0, p)
sir_model.activate(des_model)
sir_model.sir_run(des_model, tmax)
data_des = sir_model.out(des_model)

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
