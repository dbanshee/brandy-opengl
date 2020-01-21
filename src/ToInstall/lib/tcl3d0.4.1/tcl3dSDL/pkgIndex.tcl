#******************************************************************************
#
#       Copyright:      2005-2009 Paul Obermeier (obermeier@tcl3d.org)
#
#                       See the file "Tcl3D_License.txt" for information on
#                       usage and redistribution of this file, and for a
#                       DISCLAIMER OF ALL WARRANTIES.
#
#       Module:         Tcl3D -> tcl3dSDL
#       Filename:       pkgIndex.tcl
#
#       Author:         Paul Obermeier
#
#       Description:    Tcl index file for the tcl3dSDL package.
#
#******************************************************************************

proc __tcl3dSDLSourcePkgs { dir } {
    source [file join $dir tcl3dSDLQuery.tcl]
    load [file join $dir tcl3dSDL[info sharedlibextension]] tcl3dSDL
    source [file join $dir tcl3dSDLUtil.tcl]
}

if {![package vsatisfies [package provide Tcl] 8.4]} {return}
package ifneeded tcl3dsdl 0.4.1 "[list __tcl3dSDLSourcePkgs $dir]"
