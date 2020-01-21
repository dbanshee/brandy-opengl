#******************************************************************************
#
#       Copyright:      2009 Paul Obermeier (obermeier@tcl3d.org)
#
#                       See the file "Tcl3D_License.txt" for information on
#                       usage and redistribution of this file, and for a
#                       DISCLAIMER OF ALL WARRANTIES.
#
#       Module:         Tcl3D -> tcl3dOsg
#       Filename:       tcl3dOsgQuery.tcl
#
#       Author:         Paul Obermeier
#
#       Description:    Tcl module with query procedures related to
#                       the OSG module.
#
#******************************************************************************

###############################################################################
#[@e
#       Name:           tcl3dOsgGetVersion - Get OSG version string.
#
#       Synopsis:       tcl3dOsgGetVersion {}
#
#       Description:    Get the version of the wrapped OpenSceneGraph library.
#                       If no OpenGL context has been established (i.e. a Togl
#                       window has not been created), the function returns an 
#                       empty string.
#
#       See also:       tcl3dGetVersions
#                       tcl3dGetLibraryInfo
#
###############################################################################

proc tcl3dOsgGetVersion {} {
    if { [info commands osg::osgGetVersion] ne "" } {
        return [osg::osgGetVersion]
    } else {
        return ""
    }
}
