# ACTIVESTATE TEAPOT-PKG BEGIN TM -*- tcl -*-
# -- Tcl Module

# @@ Meta Begin
# Package tablelist 4.12.1
# Meta activestatetags ActiveTcl Public Tklib
# Meta as::build::date 2010-01-21
# Meta as::origin      http://sourceforge.net/projects/tcllib
# Meta license         BSD
# Meta platform        tcl
# Meta require         {Tcl 8}
# Meta require         {Tk 8}
# Meta require         {tablelist::common 4.12.1-4.12.1}
# @@ Meta End


# ACTIVESTATE TEAPOT-PKG BEGIN REQUIREMENTS

package require Tcl 8
package require Tk 8
package require -exact tablelist::common 4.12.1

# ACTIVESTATE TEAPOT-PKG END REQUIREMENTS

# ACTIVESTATE TEAPOT-PKG BEGIN DECLARE

package provide tablelist 4.12.1

# ACTIVESTATE TEAPOT-PKG END DECLARE
# ACTIVESTATE TEAPOT-PKG END TM
#==============================================================================
# Main Tablelist package module.
#
# Copyright (c) 2000-2009  Csaba Nemethi (E-mail: csaba.nemethi@t-online.de)
#==============================================================================

package require Tcl 8
package require Tk  8
package require -exact tablelist::common 4.12.1

package provide tablelist $::tablelist::version
package provide Tablelist $::tablelist::version

::tablelist::useTile 0
::tablelist::createBindings
