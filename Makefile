# GNU-Makefile para compilação em ambientes Unix
# Apenas digite com um terminal aberto nessa pasta, em ambientes Linux:
# $ make
# ou, em ambientes BSD ou Mac-OS:
# $ gmake
# para construir o seu pdf!

TEX = pdflatex # Qual compilador LaTeX usar?
BIB = bibtex   # Qual compilador de referências usar?
TEXFLAGS = -interaction nonstop -halt-on-error -file-line-error
#            |                      |           +-> Acusa a linha do erro
#            |                      +-> Pare ao ver erro
#            +-> Não fique aguardando que o usuário digite algo ao ver um erro

# Todas as figuras geradas no processo de compilação
# Todos os arquivos aqui serão apagados no make clean!
FIG_TEMPS = figuras/brasao_usp-eps-converted-to.pdf

###############################################################################
# Daqui para baixo você provavelmente não vai precisar mexer                  #
###############################################################################

# Nome do arquivo (sem estensão) a ser compilado
FILE=modelo
TARGET_FILE = $(FILE).pdf # Arquivo de saída

TEX_FILES = $(FILE).tex fichacatalografica.tex folhaaprovacao.tex versocapa.tex \
            fearp.cls
AUX_FILES = $(FILE).aux
BIB_FILES = referencias/referencias.bib # Arquivo de bibliografia
IMAGE_FILES = $(shell find 'figuras/')  # Todas as imagens
TABLE_FILES = $(shell find 'tabelas/')  # Todas as tabelas

# Lista todas as dependências desse projeto.
OTHER_FILES = $(BIB_FILES) $(IMAGE_FILES) $(TABLE_FILES) Makefile

RM = rm -f # Comando para apagar arquivos em ambientes Unix

# Todos os possíveis temporários que podem ser gerados na compilação
TEX_TEMPS = *.log *.out *.aux *.fdb_latexmk *.bbl *.dvi *.fls *.spl *.blg \
			*.idx *.toc


# Primeira regra de compilação. Também é a padrão. Isso é o que será executado
# ao digitar `$ make all' no terminal.  No caso, ele vai executar a regra cujo
# o nome é a expansão da variável TARGET_FILE, definida acima.
all: $(TARGET_FILE)

# Agora sim, define o que a regra vai fazer. Após o :, lista todas as
# dependências para fazer esse arquivo. No caso, é a expansão da variável
# TEX_FILES e OTHER_FILES
.ONESHELL:
$(TARGET_FILE): $(TEX_FILES) $(OTHER_FILES)
	bibtex_run=1;
	\
	check_for_errors(){ \
		if [ $$1 -ne 0 ]; then \
			echo '\e[91m Ocorreu pelo menos um erro na compilação! \033[0m' \
			exit; \
		fi; \
	}
	\
	maybe_run_bibtex(){ \
		if [ $$bibtex_run -eq 1 ]; then \
			$(BIB) $(AUX_FILES); \
			bibtex_run=0; \
			check_for_errors $$?; \
		fi; \
	}
	\
	for i in $$(seq 1 3); do \
		$(TEX) $(TEXFLAGS) $<; \
		check_for_errors $$?; \
		maybe_run_bibtex; \
	done;

# Regras para limpar a bagunça. Digite `$ make clean' para apagar todos os arquivos
# temporários e gerados.

.PHONY: clean
clean:
	$(RM) $(TARGET_FILE) $(TEX_TEMPS) $(FIG_TEMPS)

# Em caso de typo do usuário. Eu costumo digitar rápido :)
clena: clean
