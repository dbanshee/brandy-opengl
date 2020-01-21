
# @@ Meta Begin
# Package snit 2.3.1
# Meta activestatetags ActiveTcl Public Tcllib
# Meta as::build::date 2010-01-21
# Meta as::origin      http://sourceforge.net/projects/tcllib
# Meta license         BSD
# Meta platform        tcl
# Meta recommend       Tk
# Meta require         {Tcl 8.5}
# @@ Meta End


if {![package vsatisfies [package provide Tcl] 8.5]} return

package ifneeded snit 2.3.1 [string map [list @ $dir] {
        # ACTIVESTATE TEAPOT-PKG BEGIN REQUIREMENTS

        package require Tcl 8.5

        # ACTIVESTATE TEAPOT-PKG END REQUIREMENTS

            source [file join {@} snit2.tcl]

        # ACTIVESTATE TEAPOT-PKG BEGIN DECLARE

        package provide snit 2.3.1

        # ACTIVESTATE TEAPOT-PKG END DECLARE
    }]
