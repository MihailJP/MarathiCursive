# Makefile for MarathiCursive font

FONTS=MarathiCursive.otf MarathiCursiveT.ttf MarathiCursiveG.ttf
DOCUMENTS=license.txt README
SOURCE=MarathiCursive.sfd outlines.py truetype.py Makefile MarathiCursiveG.gdl
PKGS=MarathiCursive.7z MarathiCursive-source.7z
7ZOPT=-mx9

# Path to Graphite compiler
GRCOMPILER=/cygdrive/c/Apps/graphite/Graphite\ Compiler/GrCompiler

.PHONY: all
all: ${FONTS}

Outlines.sfd: MarathiCursive.sfd
	fontforge -script ./outlines.py

OutlinesTT.sfd: Outlines.sfd
	fontforge -script ./truetype.py
OutlinesG.sfd: OutlinesG.diff OutlinesTT.sfd
	patch -i $< -o $@

MarathiCursive.otf: Outlines.sfd
	for i in $?;do fontforge -lang=ff -c "Open(\"$$i\");SelectWorthOutputting();UnlinkReference();RemoveOverlap();Generate(\"$@\");Close()";done
MarathiCursiveT.ttf: OutlinesTT.sfd
	for i in $?;do fontforge -lang=ff -c "Open(\"$$i\");Generate(\"$@\");Close()";done

MarathiCursiveG.ttf: MarathiCursiveT.ttf MarathiCursiveG.gdl
	$(GRCOMPILER) $^ $@ "MarathiCursiveG"

.SUFFIXES: .7z
.PHONY: dist
dist: ${PKGS}

MarathiCursive.7z: ${FONTS} ${DOCUMENTS}
	-rm -rf $*
	mkdir $*
	cp ${FONTS} ${DOCUMENTS} $*
	7z a ${7ZOPT} $@ $*

MarathiCursive-source.7z: ${SOURCE} ${DOCUMENTS}
	-rm -rf $*
	mkdir $*
	cp ${SOURCE} ${DOCUMENTS} $*
	7z a ${7ZOPT} $@ $*

.PHONY: clean
clean:
	-rm Outlines.sfd OutlinesTT.sfd gdlerr.txt '$$_temp.gdl' ${FONTS}
	-rm -rf ${PKGS} ${PKGS:.7z=}
