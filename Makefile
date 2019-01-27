# Makefile for MarathiCursive font

FONTS=MarathiCursive.otf MarathiCursiveT.ttf MarathiCursiveG.ttf
DOCUMENTS=license.txt README
SOURCE=MarathiCursive.sfd outlines.py truetype.py Makefile MarathiCursiveG.gdl
PKGS=MarathiCursive.tar.xz MarathiCursive-source.tar.xz

# Path to Graphite compiler

# On Windows (Cygwin) uncomment:
#GRCOMPILER=/cygdrive/c/Program\ Files/Graphite\ Compiler/GrCompiler
# For systems other than Windows:
GRCOMPILER=wine ~/.wine/drive_c/Program\ Files/Graphite\ Compiler/GrCompiler.exe

.PHONY: all
all: ${FONTS}

Outlines.sfd: MarathiCursive.sfd
	fontforge -script ./outlines.py

OutlinesTT.sfd: Outlines.sfd
	fontforge -script ./truetype.py

MarathiCursive.otf: Outlines.sfd
	for i in $?;do fontforge -lang=ff -c "Open(\"$$i\");SelectWorthOutputting();UnlinkReference();RemoveOverlap();Generate(\"$@\");Close()";done
MarathiCursiveT.ttf: OutlinesTT.sfd
	for i in $?;do fontforge -lang=ff -c "Open(\"$$i\");Generate(\"$@\");Close()";done

MarathiCursiveG.ttf: MarathiCursiveT.ttf MarathiCursiveG.gdl
	$(GRCOMPILER) $^ $@ "MarathiCursiveG"

.SUFFIXES: .tar.xz
.PHONY: dist
dist: ${PKGS}

MarathiCursive.tar.xz: ${FONTS} ${DOCUMENTS}
	-rm -rf $*
	mkdir $*
	cp ${FONTS} ${DOCUMENTS} $*
	tar -cJf $@ $*

MarathiCursive-source.tar.xz: ${SOURCE} ${DOCUMENTS}
	-rm -rf $*
	mkdir $*
	cp ${SOURCE} ${DOCUMENTS} $*
	tar -cJf $@ $*

.PHONY: clean
clean:
	-rm Outlines.sfd OutlinesTT.sfd gdlerr.txt '$$_temp.gdl' ${FONTS}
	-rm -rf ${PKGS} ${PKGS:.tar.xz=}
