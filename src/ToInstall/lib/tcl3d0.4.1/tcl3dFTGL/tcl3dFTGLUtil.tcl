#******************************************************************************
#
#       Copyright:      2006-2009 Paul Obermeier (obermeier@tcl3d.org)
#
#                       See the file "Tcl3D_License.txt" for information on
#                       usage and redistribution of this file, and for a
#                       DISCLAIMER OF ALL WARRANTIES.
#
#       Module:         Tcl3D -> tcl3dFTGL
#       Filename:       tcl3dFTGLUtil.tcl
#
#       Author:         Paul Obermeier
#
#       Description:    Tcl module with miscellaneous utility
#                       procedures related to the FTGL module.
#
#******************************************************************************

###############################################################################
#[@e
#       Name:           tcl3dFTGLGetBBox - Get bounding box of a string.
#
#       Synopsis:       tcl3dFTGLGetBBox { font str }
#
#       Description:    font    : string (Font identifier)
#                       str     : string
#
#                       Return the bounding box of string "str" displayed in
#                       font "font".
#                       The bounding box is returned as a list of 6 values: 
#                       { xmin ymin zmin xmax ymax zmax }
#                       "font" must be an identifier as returned by one of the
#                       FTGL*Font functions (ex. FTGLBitmapFont).
#
#       See also:       
#
###############################################################################

proc tcl3dFTGLGetBBox { font str } {
    set vx1 [tcl3dVector GLfloat 1]
    set vy1 [tcl3dVector GLfloat 1]
    set vz1 [tcl3dVector GLfloat 1]
    set vx2 [tcl3dVector GLfloat 1]
    set vy2 [tcl3dVector GLfloat 1]
    set vz2 [tcl3dVector GLfloat 1]
    $font BBox $str $vx1 $vy1 $vz1 $vx2 $vy2 $vz2
    set x1 [$vx1 get 0]
    set y1 [$vy1 get 0]
    set z1 [$vz1 get 0]
    set x2 [$vx2 get 0]
    set y2 [$vy2 get 0]
    set z2 [$vz2 get 0]
    $vx1 delete
    $vy1 delete
    $vz1 delete
    $vx2 delete
    $vy2 delete
    $vz2 delete
    return [list $x1 $y1 $z1 $x2 $y2 $z2]
}
