#******************************************************************************
#
#       Copyright:      2007 Paul Obermeier (obermeier@tcl3d.org)
#
#                       See the file "Tcl3D_License.txt" for information on
#                       usage and redistribution of this file, and for a
#                       DISCLAIMER OF ALL WARRANTIES.
#
#       Module:         Tcl3D -> tcl3dOsg
#       Filename:       pkgIndex.tcl
#
#       Author:         Paul Obermeier
#
#       Description:    Tcl index file for the tcl3dOsg package.
#
#******************************************************************************

proc __tcl3dOsgSourcePkgs { dir } {
    source [file join $dir tcl3dOsgQuery.tcl]
    load [file join $dir tcl3dOsg[info sharedlibextension]]            tcl3dOsg
    load [file join $dir tcl3dOsgDB[info sharedlibextension]]          tcl3dOsgDB
    load [file join $dir tcl3dOsgFX[info sharedlibextension]]          tcl3dOsgFX
    load [file join $dir tcl3dOsgGA[info sharedlibextension]]          tcl3dOsgGA
    load [file join $dir tcl3dOsgManipulator[info sharedlibextension]] tcl3dOsgManipulator
    load [file join $dir tcl3dOsgOpenThreads[info sharedlibextension]] tcl3dOsgOpenThreads
    load [file join $dir tcl3dOsgParticle[info sharedlibextension]]    tcl3dOsgParticle
    load [file join $dir tcl3dOsgSim[info sharedlibextension]]         tcl3dOsgSim
    load [file join $dir tcl3dOsgShadow[info sharedlibextension]]      tcl3dOsgShadow
    load [file join $dir tcl3dOsgTerrain[info sharedlibextension]]     tcl3dOsgTerrain
    load [file join $dir tcl3dOsgText[info sharedlibextension]]        tcl3dOsgText
    load [file join $dir tcl3dOsgUtil[info sharedlibextension]]        tcl3dOsgUtil
    load [file join $dir tcl3dOsgViewer[info sharedlibextension]]      tcl3dOsgViewer
    source [file join $dir tcl3dOsgUtil.tcl]
    source [file join $dir tcl3dOsgKeysym.tcl]
    source [file join $dir tcl3dOsgBitmaps.tcl]
}

if {![package vsatisfies [package provide Tcl] 8.4]} {return}
package ifneeded tcl3dosg 0.4.1 "[list __tcl3dOsgSourcePkgs $dir]"
