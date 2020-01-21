#******************************************************************************
#
#       Copyright:      2006-2009 Paul Obermeier (obermeier@tcl3d.org)
#
#                       See the file "Tcl3D_License.txt" for information on
#                       usage and redistribution of this file, and for a
#                       DISCLAIMER OF ALL WARRANTIES.
#
#       Module:         Tcl3D -> tcl3dOde
#       Filename:       tcl3dOdeUtil.tcl
#
#       Author:         Paul Obermeier
#
#       Description:    Tcl module with miscellaneous utility
#                       procedures related to the ODE module.
#
#******************************************************************************

proc tcl3dOdeVector3 {} {
    return [tcl3dVector dReal 4]
}

proc tcl3dOdeVector4 {} {
    return [tcl3dVector dReal 4]
}

proc tcl3dOdeMatrix3 {} {
    return [tcl3dVector dReal 12]
}

proc tcl3dOdeMatrix4 {} {
    return [tcl3dVector dReal 16]
}

proc tcl3dOdeMatrix6 {} {
    return [tcl3dVector dReal 48]
}

proc tcl3dOdeQuaternion {} {
    return [tcl3dVector dReal 4]
}

# Print the contents of an ODE vector onto standard output.

proc tcl3dOdeVector3Print { vec } {
    puts [format "%6.3f %6.3f %6.3f" [$vec get 0] [$vec get 1] [$vec get 2]]
}

proc tcl3dOdeVector4Print { vec } {
    puts [format "%6.3f %6.3f %6.3f %6.3f" \
          [$vec get 0] [$vec get 1] [$vec get 2] [$vec get 3]]
}

proc tcl3dOdeQuaternionPrint { quat } {
    puts [format "%6.3f %6.3f %6.3f %6.3f" \
          [$quat get 0] [$quat get 1] [$quat get 2] [$quat get 3]]
}

# Print the contents of an ODE matrix onto standard output.

proc tcl3dOdeMatrixPrint { mat row col } {
     for { set i 0 } { $i < $row } { incr i } {
         for { set j 0 } { $j < $col } { incr j } {
            puts -nonewline [format "%6.3f " [$mat get [expr $row*$j + $i]]]
        }
        puts ""
    }
}

proc tcl3dOdeMatrix3Print { mat } {
    tcl3dOdeMatrixPrint $mat 4 3
}

proc tcl3dOdeMatrix4Print { mat } {
    tcl3dOdeMatrixPrint $mat 4 4
}

proc tcl3dOdeMatrix6Print { mat } {
    tcl3dOdeMatrixPrint $mat 8 6
}
