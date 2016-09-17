MD_PATHS, = glob_wildcards("./{md_path}.md")
STY, = glob_wildcards("./style/{sty}")
BIB, = glob_wildcards("./bibliography/{bib}")
FIG_PATHS, = glob_wildcards("./figures/{fig_path}.pdf")
TMPL, = glob_wildcards("./template/{tmpl}.tex")
print(FIG_PATHS)
print(TMPL)

IDS = [os.path.basename(MD) for MD in MD_PATHS]
FIGS = [os.path.basename(FIG) for FIG in FIG_PATHS]

MD_DICT = dict(zip(IDS, MD_PATHS))
FIG_DICT = dict(zip(FIGS, FIG_PATHS))

rule build:
    input: expand("build/{id}.tex", id=IDS), "build/thesis.tex",
           expand("build/style/{sty}", sty=STY),
           expand("build/bibliography/{bib}", bib=BIB),
           expand("build/figures/{fig}.pdf", fig=FIGS),
           expand("build/{tmpl}.tex", tmpl=TMPL)
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
    input: "style/{sty}"
    output: "build/style/{sty}"
    message: "Copying {input} to {output}..."
    shell: "cp {input} {output}"

rule copy_bib:
    input: "bibliography/{bib}"
    output: "build/bibliography/{bib}"
    message: "Copying {input} to {output}..."
    shell: "cp {input} {output}"

rule copy_fig:
    input: lambda wildcards: "figures/" + FIG_DICT[wildcards.fig] + ".pdf"
    output:"build/figures/{fig}.pdf"
    message: "Copying {input} to {output}..."
    shell: "cp {input} {output}"

rule copy_template:
    input: "template/{tmpl}.tex"
    output: "build/{tmpl}.tex"
    message: "Copying {input} to {output}..."
    shell: "cp {input} {output}"


