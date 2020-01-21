#******************************************************************************
#
#       Copyright:      2007-2009 Paul Obermeier (obermeier@tcl3d.org)
#
#                       See the file "Tcl3D_License.txt" for information on
#                       usage and redistribution of this file, and for a
#                       DISCLAIMER OF ALL WARRANTIES.
#
#       Module:         Tcl3D -> tcl3dFTGL
#       Filename:       tcl3dFTGLQuery.tcl
#
#       Author:         Paul Obermeier
#
#       Description:    Tcl module with with query procedures related to
#                       the FTGL module.
#
#******************************************************************************

###############################################################################
#[@e
#       Name:           tcl3dFTGLGetVersion - Get FTGL version string.
#
#       Synopsis:       tcl3dFTGLGetVersion {}
#
#       Description:    Return the version string of the wrapped FTGL library.
#                       The version is returned as "Major.Minor.Patch".
#
#                       Note: FTGL does not support version numbers in the code,
#                             so the version number is hand-coded here.
#
#       See also:       tcl3dOglGetVersions
#                       tcl3dGetLibraryInfo
#
###############################################################################

proc tcl3dFTGLGetVersion {} {
    if { [info commands FTGLBitmapFont] ne "" } {
        return [format "%d.%d.%d" 2 1 2]
    } else {
        return ""
    }
}
