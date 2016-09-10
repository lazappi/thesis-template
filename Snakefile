MD_PATHS, = glob_wildcards("./{md_path}.md")
IDS = [os.path.basename(MD) for MD in MD_PATHS]
MD_DICT = dict(zip(IDS, MD_PATHS))

rule build:
    input: expand("build/{id}.tex", id=IDS), "build/thesis.tex"
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
