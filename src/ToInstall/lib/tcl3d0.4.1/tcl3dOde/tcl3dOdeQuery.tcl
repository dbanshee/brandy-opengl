#******************************************************************************
#
#       Copyright:      2007-2009 Paul Obermeier (obermeier@tcl3d.org)
#
#                       See the file "Tcl3D_License.txt" for information on
#                       usage and redistribution of this file, and for a
#                       DISCLAIMER OF ALL WARRANTIES.
#
#       Module:         Tcl3D -> tcl3dOde
#       Filename:       tcl3dOdeQuery.tcl
#
#       Author:         Paul Obermeier
#
#       Description:    Tcl module with query procedures related to
#                       the ODE module.
#
#******************************************************************************

###############################################################################
#[@e
#       Name:           tcl3dOdeGetVersion - Get ODE version string.
#
#       Synopsis:       tcl3dOdeGetVersion {}
#
#       Description:    Return the version string of the wrapped ODE library.
#                       The version is returned as "Major.Minor.Patch".
#
#                       Note: ODE does not support version numbers in the code,
#                             so the version number is hand-coded here.
#
#       See also:       tcl3dOglGetVersions
#                       tcl3dGetLibraryInfo
#
###############################################################################

proc tcl3dOdeGetVersion {} {
    if { [info commands dWorldCreate] ne "" } {
        return [format "%d.%d.%d" 0 7 0]
    } else {
        return ""
    }
}
