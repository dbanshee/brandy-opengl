#******************************************************************************
#
#       Copyright:      2005-2009 Paul Obermeier (obermeier@tcl3d.org)
#
#                       See the file "Tcl3D_License.txt" for information on
#                       usage and redistribution of this file, and for a
#                       DISCLAIMER OF ALL WARRANTIES.
#
#       Module:         Tcl3D -> tcl3dCg
#       Filename:       tcl3dCgQuery.tcl
#
#       Author:         Paul Obermeier
#
#       Description:    Tcl module with query procedures related to
#                       the Cg module.
#
#******************************************************************************

###############################################################################
#[@e
#       Name:           tcl3dCgGetVersion - Get Cg version string.
#
#       Synopsis:       tcl3dCgGetVersion {}
#
#       Description:     Return the version string of the wrapped Cg library.
#                       The version is returned as "Major.Minor.Patch".
#
#       See also:       tcl3dOglGetVersions
#                       tcl3dGetLibraryInfo
#
###############################################################################

proc tcl3dCgGetVersion {} {
    if { [info commands cgGetString] ne "" } {
        return [cgGetString CG_VERSION]
    } else {
        return ""
    }
}
