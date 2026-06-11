ERROR: Julia server returned error after receiving "run" command:

Failed to run notebook: /home/dgavdadaev/2026-1--study--simulation-modeling/labs/lab04/project/markdown/sir_visualize_dynamics_literate.qmd

The underlying Julia error was:

EvaluationError: Encountered 1 error during evaluation

Error 1 of 1
@ /home/dgavdadaev/2026-1--study--simulation-modeling/labs/lab04/project/markdown/sir_visualize_dynamics_literate.qmd:8
LoadError: ArgumentError: Package StatsBase not found in current path.
- Run `import Pkg; Pkg.add("StatsBase")` to install the StatsBase package.
in expression starting at /home/dgavdadaev/2026-1--study--simulation-modeling/labs/lab04/project/src/sir_model.jl:3
Stacktrace:
 [1] macro expansion
   @ ./loading.jl:2405 [inlined]
 [2] macro expansion
   @ ./lock.jl:376 [inlined]
 [3] __require(into::Module, mod::Symbol)
   @ Base ./loading.jl:2388
 [4] require(into::Module, mod::Symbol)
   @ Base ./loading.jl:2364
 [5] include(fname::String)
   @ QuartoNotebookWorker.NotebookInclude ~/.julia/packages/QuartoNotebookRunner/evCNi/src/QuartoNotebookWorker/src/NotebookInclude.jl:10
 [6] top-level scope
   @ ~/2026-1--study--simulation-modeling/labs/lab04/project/markdown/sir_visualize_dynamics_literate.qmd:17


Stack trace:
    at writeJuliaCommand (file:///opt/quarto/share/extension-subtrees/julia-engine/_extensions/julia-engine/julia-engine.js:1215:13)
    at async executeJulia (file:///opt/quarto/share/extension-subtrees/julia-engine/_extensions/julia-engine/julia-engine.js:1102:20)
    at async Object.execute (file:///opt/quarto/share/extension-subtrees/julia-engine/_extensions/julia-engine/julia-engine.js:741:20)
    at async renderExecute (file:///opt/quarto/bin/quarto.js:136636:25)
    at async renderFileInternal (file:///opt/quarto/bin/quarto.js:136889:35)
    at async renderFiles (file:///opt/quarto/bin/quarto.js:136685:9)
    at async render (file:///opt/quarto/bin/quarto.js:142339:19)
    at async _Command.actionHandler (file:///opt/quarto/bin/quarto.js:142584:24)
    at async _Command.execute (file:///opt/quarto/bin/quarto.js:102069:7)
    at async _Command.parseCommand (file:///opt/quarto/bin/quarto.js:101946:14)
    at async quarto4 (file:///opt/quarto/bin/quarto.js:187954:5)
    at async file:///opt/quarto/bin/quarto.js:187983:5
    at async file:///opt/quarto/bin/quarto.js:187837:14
    at async mainRunner (file:///opt/quarto/bin/quarto.js:187839:5)
    at async file:///opt/quarto/bin/quarto.js:187976:3
