
# @@ Meta Begin
# Package struct::graph 2.4
# Meta activestatetags ActiveTcl Public Tcllib
# Meta as::build::date 2010-01-21
# Meta as::origin      http://sourceforge.net/projects/tcllib
# Meta category        Tcl Data Structures Tcl Data Structures
# Meta description     Create and manipulate directed graph objects Create
# Meta description     and manipulate directed graph objects
# Meta license         BSD
# Meta platform        tcl
# Meta recommend       tcllibc
# Meta require         {Tcl 8.4}
# Meta require         struct::list
# Meta require         struct::set
# Meta subject         cgraph graph graph loop subgraph edge serialization
# Meta subject         arc node vertex adjacent neighbour degree cgraph
# Meta summary         struct::graph v1 struct::graph
# @@ Meta End


if {![package vsatisfies [package provide Tcl] 8.4]} return

package ifneeded struct::graph 2.4 [string map [list @ $dir] {
        # ACTIVESTATE TEAPOT-PKG BEGIN REQUIREMENTS

        package require Tcl 8.4
        package require struct::list
        package require struct::set

        # ACTIVESTATE TEAPOT-PKG END REQUIREMENTS

            source [file join {@} graph.tcl]

        # ACTIVESTATE TEAPOT-PKG BEGIN DECLARE

        package provide struct::graph 2.4

        # ACTIVESTATE TEAPOT-PKG END DECLARE
    }]
