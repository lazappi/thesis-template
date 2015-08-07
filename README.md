# thesis-template

Template for writing a thesis using Markdown.

This project is designed to easily produce a well-formatted thesis document 
from multiple Markdown files using
[Make](https://www.gnu.org/software/make/), [Pandoc](http://pandoc.org) and
[latexmk](http://www.ctan.org/pkg/latexmk/) with statistics from
[texcount](http://app.uio.no/ifi/texcount/).

The example text and style comes from John Papandriopoulos' [Ph.D. Dissertation
Template](http://jpap.org/projects.html), designed to meet requirements at
the University of Melbourne.

## Structure

The directory structure is designed to as flexible as possible with the
following elements:

* `bibliography` - Bibliography files
* `figures` - Figure files and files to produce them
* `style` - Any required style files and packages
* `template` - Additional included .tex files (opposed to .md files that 
  contain the main text)
* `thesis.pdf` - Core document, acts as a Table of Contents linking remaining
  files
* `Makefile` - Manage document building

Markdown files containing the main text can be placed anywhere within the
project directory and will be located during the build process.

## Usage

### Building

The complete PDF document can be produced by running `make` or `make all`.

Several steps occur during this process:

1. A build directory is created with necessary subdirectories.
2. The project directory is searched for Markdown files which are converted
   to TeX files in the build directory.
3. TeX files are copied from the template directory to the build directory.
4. All files are copied from the style directory to a style subdirectory inside
   the build directory.
5. All files are copied from the bibliography directory to a bibliography
   subdirectory inside the build directory.
6. The figures directory is searched for image files which are copied to a
   figures subdirectory inside the build directory.
7. `latexmk` is used to build the output file in the build directory.
8. The output file is copied to the main directory.

This process has the advantage of avoiding cluttering the workspace with
auxiliary files created during the build process. The directory structure (for
Markdown and figure files) is flattened during the copying process which allows
simple inclusion of files while allowing whatever directory structure best
organises your files.

*NOTE:* This is currently a bug that causes an error in `latexmk` the first
time it is run, as the build directory is created. It may take a few runs for
the process to stabilise but it should be fine after that.

### Word count

The command `make count` produces a word count using the `texcount` script. By
default this is a summary of all included files but other options can be set
in the Makefile if desired.

### Archive

The command `make archive` will create a zipped copy of the build directory
inside an archive directory. This can be useful for recording important
milestones such as versions sent to supervisors, for example so `texdiff` can
be used. It would be possible to get the records from `git` but this is
easier.

### Clean

A `make clean` command also exists which simply removes the build directory.
This may be useful if there are problems with the build process.

