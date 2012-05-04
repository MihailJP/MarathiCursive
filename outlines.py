#!/usr/local/bin/fontforge -script

##############################################################################
#
# MarathiCursive stroke to outline font conversion script
#
##############################################################################

import fontforge;

font = fontforge.open("MarathiCursive.sfd");
font.strokedfont = False;
font.selection.all();
font.stroke("eliptical",80,40,-30.0/180.0*3.141592653589793238,"square","round");
font.addExtrema();font.round();
font.simplify();font.round();
font.removeOverlap();font.round();
font.simplify();font.round();
font.addExtrema();font.round();
font.autoHint();
font.save("Outlines.sfd");
