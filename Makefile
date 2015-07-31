#------------------------------------------------------------------------------#
#                               ***************                                #
#                               MAKE MY THESIS!                                #
#                               ***************                                #
#------------------------------------------------------------------------------#

#-----------------------------------{LATEX}------------------------------------#

##-----[LATEX SETTINGS]------##

LTX        := pdflatex
LTX_OPTS   := --shell-escape

##----[LATEXMK SETTINGS]-----##

LTXMK      := latexmk
LTXMK_OPTS := -pdf #-silent -logfilewarnings

#-----------------------------------{PANDOC}-----------------------------------#

##-----[PANDOC SETTINGS]-----##

PNDOC      := pandoc
PNDOC_OPTS := 

#----------------------------------{TEXCOUNT}----------------------------------#

##-----[TEXCOUNT SETTINGS]-----##

TXC        := texcount
TXC_OPTS   := -merge

#----------------------------------{TARGETS}-----------------------------------#

##-------[MAIN TARGET]-------##
TARGET     := thesis.pdf
TGT_IN     := $(TARGET:.pdf=.tex)

##-----[BUILD DIRECTORY]-----##

BUILD_DIR  := build

##------[SOURCE FILES]-------##

### Markdown files to convert to tex and include in document ###

MD         := $(shell find . -type f -name '*.md')          # Find MD files
FILES      := $(notdir $(MD))
MD_PATHS   := $(sort $(dir $(MD)))
TEX        := $(addprefix $(BUILD_DIR)/, $(FILES:.md=.tex)) # Tex names

##-------[STYLE FILES]-------##

### Additional style files ###

STY_DIR    := style
STY        := $(addprefix $(BUILD_DIR)/, $(wildcard $(STY_DIR)/*)) 

##-----[TEMPLATE FILES]------##

### Additional tex files included in the document ###

TMPL_DIR   := template
TMPL       := $(addprefix $(BUILD_DIR)/, \
    		$(notdir $(wildcard $(TMPL_DIR)/*.tex)))

##------[FIGURE FILES]-------##

### Figures included in the document ###

FIG_DIR    := figures
FIG_EXT    := .pdf
FIG_IN     := $(shell find $(FIG_DIR) -type f -name '*$(FIG_EXT)') # Find figs
FILES      := $(notdir $(FIG_IN))
FIG_PATHS  := $(sort $(dir $(FIG_IN)))
FIG        := $(addprefix $(BUILD_DIR)/$(FIG_DIR)/, $(FILES))      # Build names

##--------[BIB FILES]--------##

### Required bibliorgraphy files ###

BIB_DIR    := bibliography
BIB        := $(addprefix $(BUILD_DIR)/, $(wildcard $(BIB_DIR)/*))

##-------[ALL SOURCES]-------##

SOURCES    := $(BUILD_DIR)/$(TGT_IN) $(TEX) $(FIG) $(STY) $(BIB) $(TMPL) \
    	      Makefile

#-----------------------------------{PATHS}------------------------------------#

### Paths to search to find targets

vpath %.md $(MD_PATHS)         # MD path
vpath %$(FIG_EXT) $(FIG_PATHS) # Figure path

#-----------------------------------{RULES}------------------------------------#

##----------[PHONY]----------##

.PHONY: build clean count

##------[BUILD TARGET]-------##

all: $(TARGET)

$(TARGET): $(SOURCES)
	@echo Removing $(TARGET)...
	@rm -f $(TARGET)
	@echo Starting latexmk...
	@cd $(BUILD_DIR) && \
	    $(LTXMK) $(LTXMK_OPTS) \
	    	-pdflatex="$(LTX) $(LTX_OPTS) %O %S" $(TGT_IN)
	@echo Coping $(TARGET)...
	@cp $(BUILD_DIR)/$(TARGET) $(TARGET)

##-------[CONVERT MD]--------##

$(BUILD_DIR)/%.tex: %.md
	@echo Converting $< to $@...
	@$(PNDOC) $(PNDOC_OPTS) -o $@ $<

##-------[BUILD COPY]--------##

### Copy files to build directory ###

$(BUILD_DIR)/%.tex: $(TMPL_DIR)/%.tex
	@echo Copying $< to $@...
	@cp $< $@

$(BUILD_DIR)/$(FIG_DIR)/%$(FIG_EXT): %$(FIG_EXT)
	@echo Copying $< to $@...
	@cp $< $@

$(BUILD_DIR)/$(STY_DIR)/%: $(STY_DIR)/%
	@echo Copying $< to $@...
	@cp $< $@

$(BUILD_DIR)/$(BIB_DIR)/%: $(BIB_DIR)/%
	@echo Copying $< to $@...
	@cp $< $@

$(BUILD_DIR)/$(TGT_IN): $(TGT_IN)
	@echo Copying $< to $@...
	@cp $< $@

##--------[MAKE DIRS]--------##

### Create build directories if needed ##

$(TEX): | $(BUILD_DIR)

$(BUILD_DIR)/$(TGT_IN): | $(BUILD_DIR)

$(BUILD_DIR):
	@echo Making $(BUILD_DIR)...
	@mkdir -p $(BUILD_DIR)

$(FIG): | $(BUILD_DIR)/$(FIG_DIR)

$(BUILD_DIR)/$(FIG_DIR):
	@echo Making $(BUILD_DIR)/$(FIG_DIR)
	@mkdir -p $(BUILD_DIR)/$(FIG_DIR)

$(STY): | $(BUILD_DIR)/$(STY_DIR)

$(BUILD_DIR)/$(STY_DIR):
	@echo Making $(BUILD_DIR)/$(STY_DIR)
	@mkdir -p $(BUILD_DIR)/$(STY_DIR)

$(BIB): | $(BUILD_DIR)/$(BIB_DIR)

$(BUILD_DIR)/$(BIB_DIR):
	@echo Making $(BUILD_DIR)/$(BIB_DIR)
	@mkdir -p $(BUILD_DIR)/$(BIB_DIR)

##----------[COUNT]----------##

### Produce word count ###

count:
	@echo Counting words...
	@cd $(BUILD_DIR) && \
	    $(TXC) $(TXC_OPTS) $(TGT_IN)

##----------[CLEAN]----------##

### Remove build files ###

clean:
	@echo Removing build directory...
	@rm -rf $(BUILD_DIR)

##---------[PRINT VAR]-------##

print-% : ; @echo $* = $($*)
