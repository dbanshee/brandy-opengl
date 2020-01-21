#******************************************************************************
#
#       Copyright:      2007-2009 Paul Obermeier (obermeier@tcl3d.org)
#
#                       See the file "Tcl3D_License.txt" for information on
#                       usage and redistribution of this file, and for a
#                       DISCLAIMER OF ALL WARRANTIES.
#
#       Module:         Tcl3D -> tcl3dSDL
#       Filename:       tcl3dSDLQuery.tcl
#
#       Author:         Paul Obermeier
#
#       Description:    Tcl module with query procedures related to
#                       the SDL module.
#
#******************************************************************************

###############################################################################
#[@e
#       Name:           tcl3dSDLGetVersion - Get SDL version string.
#
#       Synopsis:       tcl3dSDLGetVersion {}
#
#       Description:    Return the version string of the wrapped SDL library.
#                       The version is returned as "Major.Minor.Patch".
#
#       See also:       tcl3dOglGetVersions
#                       tcl3dGetLibraryInfo
#
###############################################################################

proc tcl3dSDLGetVersion {} {
    if { [info commands SDL_Linked_Version] ne "" } {
        set vers [SDL_Linked_Version]
        return [format "%d.%d.%d" \
                [$vers cget -major] \
                [$vers cget -minor] \
                [$vers cget -patch]]
    } else {
        return ""
    }
}
