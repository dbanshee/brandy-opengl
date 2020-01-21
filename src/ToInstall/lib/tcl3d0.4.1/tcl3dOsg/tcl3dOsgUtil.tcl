#******************************************************************************
#
#       Copyright:      2009 Paul Obermeier (obermeier@tcl3d.org)
#
#                       See the file "Tcl3D_License.txt" for information on
#                       usage and redistribution of this file, and for a
#                       DISCLAIMER OF ALL WARRANTIES.
#
#       Module:         Tcl3D -> tcl3dOsg
#       Filename:       tcl3dOsgUtil.tcl
#
#       Author:         Paul Obermeier
#
#       Description:    Tcl module with miscellaneous Tcl3D
#                       utility procedures related to the OSG module.
#
#******************************************************************************

interp alias {} osg::Vec2 {} osg::Vec2f
interp alias {} osg::Vec3 {} osg::Vec3f
interp alias {} osg::Vec4 {} osg::Vec4f

interp alias {} osg::Vec2Array {} osg::Vec2fArray
interp alias {} osg::Vec3Array {} osg::Vec3fArray
interp alias {} osg::Vec4Array {} osg::Vec4fArray

interp alias {} osg::Matrix {} osg::Matrixd

interp alias {} osg::BoundingBox    {} osg::BoundingBoxf
interp alias {} osg::BoundingSphere {} osg::BoundingSpheref

# From OSG 2.4 on, text enumerations have been moved from class Text to class
# TextBase. Make them visible under both names. This might be needed when
# porting older OSG code.

foreach var [info vars osgText::TextBase_*] {
    set newVar [string map {TextBase Text} $var]
    set createCmd [format "set %s $%s" $newVar $var]
    eval $createCmd
}

###############################################################################
#[@e
#       Name:           tcl3dOsgVecPrint     - Print a OSG vector.
#                       tcl3dOsgMatPrint     - Print a OSG matrix.
#                       tcl3dOsgBBoxPrint    - Print a OSG bounding box.
#                       tcl3dOsgBSpherePrint - Print a OSG bounding sphere.
#
#       Synopsis:       tcl3dOsgVecPrint     { vec { precisionString "%6.3f" } }
#                       tcl3dOsgMatPrint     { mat { precisionString "%6.3f" } }
#                       tcl3dOsgBBoxPrint    { box { precisionString "%6.3f" } }
#                       tcl3dOsgBSpherePrint { sph { precisionString "%6.3f" } }
#
#       Description:    vec             : osg::Vec
#                       mat             : osg::Matrix
#                       box             : osg::BoundingBox
#                       sph             : osg::BoundingSphere
#                       precisionString : string
#
#                       Print the values of the corresponding OSG classes onto
#                       stdout. The precisionString parameter can be optionally
#                       specified and must supply a format specification in a 
#                       C-printf style.
#
#       See also:      
#
###############################################################################

proc tcl3dOsgVecPrint { vec { precisionString "%6.3f" } } {
    set size [$vec size]
    for { set i 0 } { $i < $size } { incr i } {
        puts -nonewline [format "$precisionString " [$vec get $i]]
    }
    puts ""
}

proc tcl3dOsgMatPrint { mat { precisionString "%6.3f" } } {
    for { set row 0 } { $row < 4 } { incr row } {
        for { set col 0 } { $col < 4 } { incr col } {
            puts -nonewline [format "$precisionString " [$mat get $row $col]]
        }
        puts ""
    }
}

proc tcl3dOsgBBoxPrint { box { precisionString "%6.3f" } } {
    puts -nonewline "( "
    puts -nonewline [format "$precisionString " [$box xMin]]
    puts -nonewline [format "$precisionString " [$box yMin]]
    puts -nonewline [format "$precisionString " [$box zMin]]
    puts -nonewline ") ( "
    puts -nonewline [format "$precisionString " [$box xMax]]
    puts -nonewline [format "$precisionString " [$box yMax]]
    puts -nonewline [format "$precisionString " [$box zMax]]
    puts -nonewline ")"
    puts ""
}

proc tcl3dOsgBSpherePrint { sph { precisionString "%6.3f" } } {
    puts -nonewline "( "
    set cen [$sph center]
    puts -nonewline [format "$precisionString " [$cen x]]
    puts -nonewline [format "$precisionString " [$cen y]]
    puts -nonewline [format "$precisionString " [$cen z]]
    puts -nonewline ") "
    puts -nonewline [format "$precisionString " [$sph radius]]
    puts ""
}


###############################################################################
#[@e
#       Name:           tcl3dOsgVecArrayPrint    - Print an array of vectors.
#                       tcl3dOsgScalarArrayPrint - Print an array of scalars.
#                       tcl3dOsgObjectArrayPrint - Print an array of objects.
#
#       Synopsis:       tcl3dOsgVecArrayPrint    { arr { precisionString "%6.3f" } }
#                       tcl3dOsgScalarArrayPrint { arr { precisionString "%6.3f" } }
#                       tcl3dOsgObjectArrayPrint { arr { precisionString "%s" } }
#
#       Description:    arr             : osg::VecArray, std::vector, osg::MixinVector
#                       precisionString : string
#
#                       Print the values of all elements of container "arr".
#                       "arr" can be either a osg::VecArrary, a std::vector or a
#                       osg::MixinVector container.
#                       Depending on the element type, special functions are available:
#                       tcl3dOsgVecArrayPrint prints the value of all osg::Vec's 
#                       contained in the array.
#                       tcl3dOsgScalarArrayPrint prints the value of all scalars 
#                       contained in the array.
#                       tcl3dOsgObjectArrayPrint prints the name of all osg::Object's
#                       contained in the array.
#
#                       The precisionString parameter can be optionally
#                       specified and must supply a format specification in a 
#                       C-printf style.
#
#       See also:      tcl3dOsgScalarArrayPrint
#
###############################################################################

proc tcl3dOsgVecArrayPrint { arr { precisionString "%6.3f" } } {
    set size [$arr size]
    for { set i 0 } { $i < $size } { incr i } {
        set vec [$arr get $i]
        set vecSize [$vec size]
        puts -nonewline "{"
        for { set j 0 } { $j < $vecSize } { incr j } {
            puts -nonewline [format "$precisionString " [$vec get $j]]
        }
        puts -nonewline "} "
    }
    puts ""
}

proc tcl3dOsgScalarArrayPrint { arr { precisionString "%6.3f" } } {
    set size [$arr size]
    for { set i 0 } { $i < $size } { incr i } {
        puts -nonewline [format "$precisionString " [$arr get $i]]
    }
    puts ""
}

proc tcl3dOsgObjectArrayPrint { arr { precisionString "%s" } } {
    set size [$arr size]
    for { set i 0 } { $i < $size } { incr i } {
        set obj [$arr get $i]
        puts -nonewline [format "$precisionString " [$obj getName]]
    }
    puts ""
}

array set ::__osg_NodeVisitor_VisitorTypeNames [list \
    $::osg::NodeVisitor_NODE_VISITOR             "NODE_VISITOR" \
    $::osg::NodeVisitor_UPDATE_VISITOR           "UPDATE_VISITOR" \
    $::osg::NodeVisitor_EVENT_VISITOR            "EVENT_VISITOR" \
    $::osg::NodeVisitor_COLLECT_OCCLUDER_VISITOR "COLLECT_OCCLUDER_VISITOR" \
    $::osg::NodeVisitor_CULL_VISITOR             "CULL_VISITOR" \
]

array set ::__osg_NodeVisitor_TraversalModeNames [list \
    $::osg::NodeVisitor_TRAVERSE_NONE            "TRAVERSE_NONE" \
    $::osg::NodeVisitor_TRAVERSE_PARENTS         "TRAVERSE_PARENTS" \
    $::osg::NodeVisitor_TRAVERSE_ALL_CHILDREN    "TRAVERSE_ALL_CHILDREN" \
    $::osg::NodeVisitor_TRAVERSE_ACTIVE_CHILDREN "TRAVERSE_ACTIVE_CHILDREN" \
]

###############################################################################
#[@e
#       Name:           tcl3dOsgGetVisitorTypeName - Get visitor type name.
#
#       Synopsis:       tcl3dOsgGetVisitorTypeName { visitorType }
#
#       Description:    visitorType : int
#
#                       Return the string representation of a
#                       osg::NodeVisitor::VisitorType enumeration type.
#
#       See also:       tcl3dOsgGetTraversalModeName
#
###############################################################################

proc tcl3dOsgGetVisitorTypeName { visitorType } {
    if { [info exists ::__osg_NodeVisitor_VisitorTypeNames($visitorType)] } {
        return $::__osg_NodeVisitor_VisitorTypeNames($visitorType)
    } else {
        return "UnknownVisitorType"
    }
}

###############################################################################
#[@e
#       Name:           tcl3dOsgGetTraversalModeName - Get traversal mode name.
#
#       Synopsis:       tcl3dOsgGetTraversalModeName { travMode }
#
#       Description:    travMode : int
#
#                       Return the string representation of a
#                       osg::NodeVisitor::TraversalMode enumeration type.
#
#       See also:       tcl3dOsgGetVisitorTypeName
#
###############################################################################

proc tcl3dOsgGetTraversalModeName { travMode } {
    if { [info exists ::__osg_NodeVisitor_TraversalModeNames($travMode)] } {
        return $::__osg_NodeVisitor_TraversalModeNames($travMode)
    } else {
        return "UnknownTraversalMode"
    }
}

###############################################################################
#[@e
#       Name:           tcl3dOsgSendButtonPress 
#                       tcl3dOsgSendButtonRelease
#                       tcl3dOsgSendMouseMotion
#                       tcl3dOsgSendKeyPress
#                       tcl3dOsgSendKeyRelease
#                       tcl3dOsgSendWindowResize
#                       - Send the corresponding event down to OSG.
#
#       Synopsis:       tcl3dOsgSendButtonPress { osgwin x y buttonNum }
#                       tcl3dOsgSendButtonRelease { osgwin x y buttonNum }
#                       tcl3dOsgSendMouseMotion { osgwin x y }
#                       tcl3dOsgSendKeyPress { osgwin key }
#                       tcl3dOsgSendKeyRelease { osgwin key }
#                       tcl3dOsgSendWindowResize { osgwin w h }
#
#       Description:    osgwin    : int
#                       x, y      : int (cursor position)
#                       w, h      : int (window width and height)
#                       buttonNum : int (Button number)
#                       key       : int (KeySym)
#
#                       tcl3dOsgSend* procedures transfer a Tcl/Tk event down
#                       to OSG. Note, that no redraw is done. You must either
#                       use "after idle" with a postredisplay command or use
#                       the utility commands without the "Send" in the name.
#
#       See also:       
#
###############################################################################


proc tcl3dOsgSendButtonPress { osgwin x y buttonNum } {
    if { [$osgwin valid] } {
        set ev [$osgwin getEventQueue]
        osgGA::EventQueue_mouseButtonPress $ev $x $y $buttonNum
    }
}

proc tcl3dOsgSendButtonRelease { osgwin x y buttonNum } {
    if { [$osgwin valid] } {
        set ev [$osgwin getEventQueue]
        osgGA::EventQueue_mouseButtonRelease $ev $x $y $buttonNum
    }
}

proc tcl3dOsgSendMouseMotion { osgwin x y } {
    if { [$osgwin valid] } {
        set ev [$osgwin getEventQueue]
        osgGA::EventQueue_mouseMotion $ev $x $y
    }
}

proc tcl3dOsgSendKeyPress { osgwin key } {
    if { [$osgwin valid] } {
        set ev [$osgwin getEventQueue]
        osgGA::EventQueue_keyPress $ev $key
    }
}

proc tcl3dOsgSendKeyRelease { osgwin key } {
    if { [$osgwin valid] } {
        set ev [$osgwin getEventQueue]
        osgGA::EventQueue_keyRelease $ev $key
    }
}

proc tcl3dOsgSendWindowResize { osgwin w h } {
    if { [$osgwin valid] } {
        set winX [$osgwin getX]
        set winY [$osgwin getY]
        $osgwin resized $winX $winY $w $h
        set ev [$osgwin getEventQueue]
        osgGA::EventQueue_windowResize $ev $winX $winY $w $h
    }
}

proc tcl3dOsgButtonPress { toglwin osgwin x y buttonNum } {
    tcl3dOsgSendButtonPress $osgwin $x $y $buttonNum
    $toglwin postredisplay
}

proc tcl3dOsgButtonRelease { toglwin osgwin x y buttonNum } {
    tcl3dOsgSendButtonRelease $osgwin $x $y $buttonNum
    $toglwin postredisplay
}

proc tcl3dOsgMouseMotion { toglwin osgwin x y } {
    tcl3dOsgSendMouseMotion $osgwin $x $y
    $toglwin postredisplay
}

proc tcl3dOsgKeyPress { toglwin osgwin key } {
    tcl3dOsgSendKeyPress $osgwin $key
    $toglwin postredisplay
}

proc tcl3dOsgKeyRelease { toglwin osgwin key } {
    tcl3dOsgSendKeyRelease $osgwin $key
    $toglwin postredisplay
}

proc tcl3dOsgWindowResize { toglwin osgwin w h } {
    tcl3dOsgSendWindowResize $osgwin $w $h
    $toglwin postredisplay
}

###############################################################################
#[@e
#       Name:           tcl3dOsgAddTrackballBindings 
#                       - Add OS independent mouse bindings for trackball usage.
#
#       Synopsis:       tcl3dOsgAddTrackballBindings { toglwin osgwin }
#
#       Description:    toglwin   : Togl window identifier
#                       osgwin    : int
#
#       See also:       
#
###############################################################################

proc tcl3dOsgAddTrackballBindings { toglwin osgwin } {
    tcl3dAddEvents
    bind $toglwin <<LeftMousePress>>     "tcl3dOsgButtonPress   $toglwin $osgwin %x %y 1"
    bind $toglwin <<LeftMouseRelease>>   "tcl3dOsgButtonRelease $toglwin $osgwin %x %y 1"
    bind $toglwin <<LeftMouseMotion>>    "tcl3dOsgMouseMotion   $toglwin $osgwin %x %y"
    bind $toglwin <<MiddleMousePress>>   "tcl3dOsgButtonPress   $toglwin $osgwin %x %y 2"
    bind $toglwin <<MiddleMouseRelease>> "tcl3dOsgButtonRelease $toglwin $osgwin %x %y 2"
    bind $toglwin <<MiddleMouseMotion>>  "tcl3dOsgMouseMotion   $toglwin $osgwin %x %y"
    bind $toglwin <<RightMousePress>>    "tcl3dOsgButtonPress   $toglwin $osgwin %x %y 3"
    bind $toglwin <<RightMouseRelease>>  "tcl3dOsgButtonRelease $toglwin $osgwin %x %y 3"
    bind $toglwin <<RightMouseMotion>>   "tcl3dOsgMouseMotion   $toglwin $osgwin %x %y"
}

# The next 2 procedures are just a hack. Must be replaced in the future.
proc tcl3dOsgSetOsgWin { osgwin } {
    global __tcl3dOsgWindow

    set __tcl3dOsgWindow $osgwin
}

proc tcl3dOsgGetOsgWin {} {
    global __tcl3dOsgWindow

    if { [info exists __tcl3dOsgWindow] } {
        return $__tcl3dOsgWindow
    } else {
        error "No OSG window specified"
    }
}
