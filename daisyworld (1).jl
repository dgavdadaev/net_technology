using Literate

Literate.notebook("notebooks/sir_run_basic.jl", "notebooks")
Literate.quarto("notebooks/sir_run_basic.jl", "notebooks")
