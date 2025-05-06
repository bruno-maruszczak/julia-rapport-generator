# Julia Rapport Generator

A simple command‐line tool to generate reports from Julia source or Markdown files using [Literate.jl](https://github.com/fredrikekre/Literate.jl) and [Pandoc](https://pandoc.org/). Originally crafted to speed up university homework workflows (and avoid endless LaTeX fiddling), it converts:

* Julia scripts (`.jl`) to Markdown
* Julia scripts (`.jl`) to standalone HTML
* Markdown (`.md`) to standalone HTML

> **Note:** Nowadays I use [Typst](https://typst.app/) for typesetting, but this script went a long way to help back then.


## Features

* Automatic syntax highlighting
* MathJax support
* custom CSS


## Prerequisites

* [Julia](https://julialang.org/)
* [Pandoc](https://pandoc.org/) (with MathJax, a custom syntax definition for Julia, and a CSS stylesheet)


## Installation

1. Clone or download this repository.
2. Install Julia dependencies:

   ```sh
   julia -e 'using Pkg; Pkg.add.(["Literate","ArgParse","URIs"])'
   ```
3. Ensure `pandoc` is in your PATH
4. Ensure `julia-syntax.xml`, `code.theme`, and `style.css` are available in the working directory.


## Usage

```sh
julia generator.jl [OPTIONS]
```

### Options

| Flag        | Alias | Description                                                        | Default  |
| ----------- | ----- | ------------------------------------------------------------------ | -------- |
| `--input`   | `-i`  | Base name of the input file (without extension)                    | `source` |
| `--output`  | `-o`  | Base name of the output file (without extension)                   | `out`    |
| `--jl2md`   |       | Convert `$(input).jl` → `$(output).md`, execute code, no HTML      | `false`  |
| `--jl2html` |       | Convert `$(input).jl` → `$(output).html` via Markdown intermediate | `false`  |
| `--md2html` |       | Convert `$(input).md` → `$(output).html`                           | `false`  |

> At least one of `--jl2md`, `--jl2html`, or `--md2html` must be specified.


## Examples

1. **Generate a Markdown report from Julia**

   ```sh
   julia reportgen.jl -i analysis -o report --jl2md
   ```

   Produces `report.md`.

2. **Generate HTML directly from Julia**

   ```sh
   julia reportgen.jl -i analysis -o report --jl2html
   ```

   Executes `analysis.jl`, writes `report.md`, then renders to `report.html`.

3. **Convert existing Markdown to HTML**

   ```sh
   julia reportgen.jl -i summary -o web --md2html
   ```

   Reads `summary.md`, writes `web.html` (with MathJax, Julia syntax highlighting, and `style.css`).


## How It Works

1. **Argument Parsing**
   Uses `ArgParse.jl` to read flags and options.
2. **Julia → Markdown**
   If `--jl2md` or `--jl2html` is set, calls:

   `````julia
   Literate.markdown(
     "$(args["input"]).jl"; 
     name = "$(args["output"])", 
     execute = true, 
     credit = false, 
     codefence = "````julia" => "````", 
     flavor = Literate.CommonMarkFlavor()
   )
   `````
3. **Markdown → HTML**
   If `--md2html` or `--jl2html` is set, builds and runs:

   ```sh
   pandoc <in.md> \
     --mathjax \
     --syntax-definition ./julia-syntax.xml \
     --highlight-style ./code.theme \
     --css file:///<absolute-path>/style.css \
     -s \
     -o <out.html>
   ```

---

## Customization

* **CSS**: Edit `style.css` to tweak fonts, colors, margins, etc. (mind that printing pages to pdf has very variable results between browsers)
* **Syntax**: Edit `code.theme` for different highlighting.
* **Extensions**: Modify the Pandoc flags in the script.

---

## License

MIT License. Feel free to adapt and share!

---

*Happy report generating!*
