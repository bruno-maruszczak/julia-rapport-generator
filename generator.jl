using Literate;
using  ArgParse;
using URIs;

cli_settings = ArgParseSettings()
@add_arg_table! cli_settings begin
    "--input", "-i"
        help = "Name of the input file"
        arg_type = String
        default = "source"
    "--output", "-o"
        help = "Name of the output file"
        arg_type = String
        default = "out"
    "--md2html"
        help = "convert from Markdown to HTML and save it as such"
        action = :store_true
    "--jl2md"
        help = "convert from Julia source to Markdown and save it as such"
        action = :store_true
    "--jl2html"
        help = "convert from Julia source to HTML and save it as such"
        action = :store_true
end
args = parse_args(cli_settings)


if args["jl2md"] == true || args["jl2html"] == true
    Literate.markdown(
    "$(args["input"]).jl", 
    name = "$(args["output"])", 
    execute = true, 
    credit = false, 
    codefence = "````julia" => "````", 
    flavor = Literate.CommonMarkFlavor())
end


if args["md2html"] == true || args["jl2html"] == true

    md_input = ""
    html_out = args["output"] * ".html"

    if args["md2html"] == true && args["jl2html"] == false
        md_input = args["input"] * ".md"
    end

    if args["jl2html"] == true
        md_input = args["output"] * ".md"
    end

    pwd_path = splitpath(pwd())
    pwd_path[2:end] = pwd_path[2:end] .|> escapeuri
    pwd_path[1] = pwd_path[1][1:2]
    css_path = "file:///" * join(pwd_path, "/") * "/style.css"
    convert_to_html = `pandoc $md_input --mathjax --syntax-definition ./julia-syntax.xml --highlight-style ./code.theme --css $css_path -s -o $html_out`
    run(convert_to_html)
end