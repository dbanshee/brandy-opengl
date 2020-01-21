#******************************************************************************
#
#       Copyright:      2006-2009 Paul Obermeier (obermeier@tcl3d.org)
#
#                       See the file "Tcl3D_License.txt" for information on
#                       usage and redistribution of this file, and for a
#                       DISCLAIMER OF ALL WARRANTIES.
#
#       Module:         Tcl3D -> tcl3dFTGL
#       Filename:       pkgIndex.tcl
#
#       Author:         Paul Obermeier
#
#       Description:    Tcl index file for the tcl3dFTGL package.
#
#******************************************************************************

proc __tcl3dFTGLSourcePkgs { dir } {
    source [file join $dir tcl3dFTGLQuery.tcl]
    load [file join $dir tcl3dFTGL[info sharedlibextension]] tcl3dFTGL
    source [file join $dir tcl3dFTGLUtil.tcl]
}

if {![package vsatisfies [package provide Tcl] 8.4]} {return}
package ifneeded tcl3dftgl 0.4.1 "[list __tcl3dFTGLSourcePkgs $dir]"
