#
# Tcl package index file
#
# Note sqlite*3* init specifically
#
package ifneeded sqlite3 3.6.22 \
    [list load [file join $dir sqlite3622.dll] Sqlite3]
