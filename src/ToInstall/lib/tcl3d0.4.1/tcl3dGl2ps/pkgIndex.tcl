#******************************************************************************
#
#       Copyright:      2006-2009 Paul Obermeier (obermeier@tcl3d.org)
#
#                       See the file "Tcl3D_License.txt" for information on
#                       usage and redistribution of this file, and for a
#                       DISCLAIMER OF ALL WARRANTIES.
#
#       Module:         Tcl3D -> tcl3dGl2ps
#       Filename:       pkgIndex.tcl
#
#       Author:         Paul Obermeier
#
#       Description:    Tcl index file for the tcl3dGl2ps package.
#
#******************************************************************************

proc __tcl3dGl2psSourcePkgs { dir } {
    source [file join $dir tcl3dGl2psQuery.tcl]
    load [file join $dir tcl3dGl2ps[info sharedlibextension]] tcl3dGl2ps
    source [file join $dir tcl3dGl2psUtil.tcl]
}

if {![package vsatisfies [package provide Tcl] 8.4]} {return}
package ifneeded tcl3dgl2ps 0.4.1 "[list __tcl3dGl2psSourcePkgs $dir]"
