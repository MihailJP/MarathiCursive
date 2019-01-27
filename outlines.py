#!/usr/local/bin/fontforge -script

##############################################################################
#
# MarathiCursive stroke to outline font conversion script
#
##############################################################################

import fontforge;

font = fontforge.open("MarathiCursive.sfd");
font.strokedfont = False;
for glyph in font.glyphs():
    if glyph.isWorthOutputting():
        print("Processing glyph " + glyph.glyphname)
        glyph.stroke("eliptical",80,40,-30.0/180.0*3.141592653589793238,"square","round")
        glyph.addExtrema();glyph.round()
        glyph.simplify();glyph.round()
        glyph.removeOverlap();glyph.round()
        glyph.simplify();glyph.round()
        glyph.addExtrema();glyph.round()
        glyph.autoHint()
font.save("Outlines.sfd");
