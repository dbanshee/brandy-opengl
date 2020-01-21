#******************************************************************************
#
#       Copyright:      2005-2009 Paul Obermeier (obermeier@tcl3d.org)
#
#                       See the file "Tcl3D_License.txt" for information on
#                       usage and redistribution of this file, and for a
#                       DISCLAIMER OF ALL WARRANTIES.
#
#       Module:         Tcl3D -> tcl3dOde
#       Filename:       pkgIndex.tcl
#
#       Author:         Paul Obermeier
#
#       Description:    Tcl index file for the tcl3dOde package.
#
#******************************************************************************

proc __tcl3dOdeSourcePkgs { dir } {
    source [file join $dir tcl3dOdeQuery.tcl]
    load [file join $dir tcl3dOde[info sharedlibextension]] tcl3dOde
    source [file join $dir tcl3dOdeUtil.tcl]
}

if {![package vsatisfies [package provide Tcl] 8.4]} {return}
package ifneeded tcl3dode 0.4.1 "[list __tcl3dOdeSourcePkgs $dir]"
