#******************************************************************************
#
#       Copyright:      2005-2009 Paul Obermeier (obermeier@tcl3d.org)
#
#                       See the file "Tcl3D_License.txt" for information on
#                       usage and redistribution of this file, and for a
#                       DISCLAIMER OF ALL WARRANTIES.
#
#       Module:         Tcl3D -> tcl3dCg
#       Filename:       pkgIndex.tcl
#
#       Author:         Paul Obermeier
#
#       Description:    Tcl index file for the tcl3dCg package.
#
#******************************************************************************

proc __tcl3dCgSourcePkgs { dir } {
    source [file join $dir tcl3dCgQuery.tcl]
    load [file join $dir tcl3dCg[info sharedlibextension]] tcl3dCg
    source [file join $dir tcl3dCgUtil.tcl]
}

if {![package vsatisfies [package provide Tcl] 8.4]} {return}
package ifneeded tcl3dcg 0.4.1 "[list __tcl3dCgSourcePkgs $dir]"
