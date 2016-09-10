MD_PATHS, = glob_wildcards("./{md_path}.md")
STY_PATHS, = glob_wildcards("./style/{sty_paths}")

IDS = [os.path.basename(MD) for MD in MD_PATHS]
STY = [os.path.basename(STY) for STY in STY_PATHS]

MD_DICT = dict(zip(IDS, MD_PATHS))
STY_DICT = dict(zip(STY, STY_PATHS))

rule build:
    input: expand("build/{id}.tex", id=IDS), "build/thesis.tex", expand("build/style/{sty}", sty=STY)
    output:"build/thesis.pdf"
    message: "Building PDF..."
    shell: "cd build &&"
           "latexmk -pdf -pdflatex='pdflatex --shell-escape %O %S' thesis.tex"

rule convert:
    input: lambda wildcards: MD_DICT[wildcards.id] + ".md"
    output:"build/{id}.tex"
    message: "Converting {input} from md to tex..."
    shell: "pandoc -o {output} <(find . '{input}')"

rule copy_main:
    input: "thesis.tex"
    output: "build/thesis.tex"
    message: "Copying thesis.tex to build directory..."
    shell: "cp {input} {output}"

rule copy_style:
    input: lambda wildcards: "style/" + STY_DICT[wildcards.sty]
    output: "build/style/{sty}"
    message: "Copying style files to build directory..."
    shell: "cp {input} {output}"
