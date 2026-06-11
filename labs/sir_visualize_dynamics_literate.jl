# # Сводная визуализация результатов
#
# Скрипт загружает результаты сканирования коэффициента заразности
# и строит составной график с основными эпидемиологическими показателями.
#
# ## Подготовка окружения

using DrWatson
@quickactivate "project"

using Agents
using DataFrames
using Plots
using CSV

include(srcdir("sir_model.jl"))

# ## Загрузка результатов

df = CSV.read(
    datadir("beta_scan_all.csv"),
    DataFrame,
)

# ## Построение графиков

p1 = plot(
    df.beta,
    df.peak,
    label = "Пик",
    xlabel = "β",
    ylabel = "Доля инфицированных",
)

plot!(
    p1,
    df.beta,
    df.final_inf,
    label = "Конечная",
)

p2 = plot(
    df.beta,
    df.deaths,
    xlabel = "β",
    ylabel = "Число умерших",
)

p3 = plot(
    df.beta,
    df.final_rec,
    xlabel = "β",
    ylabel = "Доля выздоровевших",
)

# ## Формирование итоговой визуализации

plot(
    p1,
    p2,
    p3,
    layout = (3, 1),
    size = (800, 900),
)

savefig(
    plotsdir("comprehensive_analysis.png"),
)
