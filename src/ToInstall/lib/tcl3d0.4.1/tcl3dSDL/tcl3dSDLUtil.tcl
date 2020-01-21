#******************************************************************************
#
#       Copyright:      2006-2009 Paul Obermeier (obermeier@tcl3d.org)
#
#                       See the file "Tcl3D_License.txt" for information on
#                       usage and redistribution of this file, and for a
#                       DISCLAIMER OF ALL WARRANTIES.
#
#       Module:         Tcl3D -> tcl3dSDL
#       Filename:       tcl3dSDLUtil.tcl
#
#       Author:         Paul Obermeier
#
#       Description:    Tcl module with miscellaneous utility
#                       procedures related to the SDL module.
#
#******************************************************************************

###############################################################################
#[@e
#       Name:           tcl3dSDLGetFocusName - Convert focus state bitfield.
#
#       Synopsis:       tcl3dSDLGetFocusName { state }
#
#       Description:    state : int
#
#                       Return a SDL focus state bitfield as the corresponding
#                       string representation.
#                       See file SDL_active.h for the definition of possible
#                       bitfield values. 
#
#       See also:       tcl3dSDLGetButtonName
#                       tcl3dSDLGetHatName
#                       tcl3dSDLGetEventName
#
###############################################################################

proc tcl3dSDLGetFocusName { state } {
    set stateStr ""
    if { $state & $::SDL_APPMOUSEFOCUS } {
        append stateStr "MouseFocus "
    } 
    if { $state & $::SDL_APPINPUTFOCUS } {
        append stateStr "InputFocus "
    } 
    if { $state & $::SDL_APPACTIVE } {
        append stateStr "Active "
    } 
    return $stateStr
}

###############################################################################
#[@e
#       Name:           tcl3dSDLGetButtonName - Convert button state bitfield.
#
#       Synopsis:       tcl3dSDLGetButtonName { state }
#
#       Description:    state : int
#
#                       Return a SDL button state bitfield as the corresponding
#                       string representation.
#                       See file SDL_mouse.h for the definition of possible
#                       bitfield values.
#
#       See also:       tcl3dSDLGetFocusName
#                       tcl3dSDLGetHatName
#                       tcl3dSDLGetEventName
#
###############################################################################

proc tcl3dSDLGetButtonName { state } {
    set stateStr ""
    if { $state & [expr 1 << ($::SDL_BUTTON_LEFT-1)] } {
        append stateStr "Left "
    }
    if { $state & [expr 1 << ($::SDL_BUTTON_MIDDLE-1)] } {
        append stateStr "Middle "
    }
    if { $state & [expr 1 << ($::SDL_BUTTON_RIGHT-1)] } {
        append stateStr "Right "
    }
    if { $state & [expr 1 << ($::SDL_BUTTON_WHEELUP-1)] } {
        append stateStr "WheelUp "
    } 
    if { $state & [expr 1 << ($::SDL_BUTTON_WHEELDOWN-1)] } {
        append stateStr "WheelDown "
    }
    return $stateStr
}

array set ::__tcl3dSDLHatNames [list \
    $::SDL_HAT_CENTERED         "HAT_CENTERED" \
    $::SDL_HAT_UP               "HAT_UP" \
    $::SDL_HAT_RIGHT            "HAT_RIGHT" \
    $::SDL_HAT_DOWN             "HAT_DOWN" \
    $::SDL_HAT_LEFT             "HAT_LEFT" \
    $::SDL_HAT_RIGHTUP          "HAT_RIGHTUP" \
    $::SDL_HAT_RIGHTDOWN        "HAT_RIGHTDOWN" \
    $::SDL_HAT_LEFTUP           "HAT_LEFTUP" \
    $::SDL_HAT_LEFTDOWN         "HAT_LEFTDOWN" \
]

###############################################################################
#[@e
#       Name:           tcl3dSDLGetHatName - Convert hat state bitfield.
#
#       Synopsis:       tcl3dSDLGetHatName { state }
#
#       Description:    state : int
#
#                       Return a SDL hat state bitfield as the corresponding
#                       string representation.
#                       See file SDL_joystick.h for the definition of possible
#                       bitfield values.
#
#       See also:       tcl3dSDLGetFocusName
#                       tcl3dSDLGetButtonName
#                       tcl3dSDLGetEventName
#
###############################################################################

proc tcl3dSDLGetHatName { state } {
    if { [info exists ::__tcl3dSDLHatNames($state)] } {
        return $::__tcl3dSDLHatNames($state)
    } else {
        return ""
    }
}

array set ::__tcl3dSDLEventNames [list \
    $::SDL_NOEVENT              "NOEVENT" \
    $::SDL_ACTIVEEVENT          "ACTIVEEVENT" \
    $::SDL_KEYDOWN              "KEYDOWN" \
    $::SDL_KEYUP                "KEYUP" \
    $::SDL_MOUSEMOTION          "MOUSEMOTION" \
    $::SDL_MOUSEBUTTONDOWN      "MOUSEBUTTONDOWN" \
    $::SDL_MOUSEBUTTONUP        "MOUSEBUTTONUP" \
    $::SDL_JOYAXISMOTION        "JOYAXISMOTION" \
    $::SDL_JOYBALLMOTION        "JOYBALLMOTION" \
    $::SDL_JOYHATMOTION         "JOYHATMOTION" \
    $::SDL_JOYBUTTONDOWN        "JOYBUTTONDOWN" \
    $::SDL_JOYBUTTONUP          "JOYBUTTONUP" \
    $::SDL_QUIT                 "QUIT" \
    $::SDL_SYSWMEVENT           "SYSWMEVENT" \
    $::SDL_EVENT_RESERVEDA      "EVENT_RESERVEDA" \
    $::SDL_EVENT_RESERVEDB      "EVENT_RESERVEDB" \
    $::SDL_VIDEORESIZE          "VIDEORESIZE" \
    $::SDL_VIDEOEXPOSE          "VIDEOEXPOSE" \
    $::SDL_EVENT_RESERVED2      "EVENT_RESERVED2" \
    $::SDL_EVENT_RESERVED3      "EVENT_RESERVED3" \
    $::SDL_EVENT_RESERVED4      "EVENT_RESERVED4" \
    $::SDL_EVENT_RESERVED5      "EVENT_RESERVED5" \
    $::SDL_EVENT_RESERVED6      "EVENT_RESERVED6" \
    $::SDL_EVENT_RESERVED7      "EVENT_RESERVED7" \
    $::SDL_USEREVENT            "USEREVENT" \
]

###############################################################################
#[@e
#       Name:           tcl3dSDLGetEventName - Convert event enumeration.
#
#       Synopsis:       tcl3dSDLGetEventName { state }
#
#       Description:    state : int (SDL event enumeration)
#
#                       Return SDL event related enumeration as the 
#                       corresponding string representation.
#                       See file SDL_events.h for the definition of possible
#                       enumeration values.
#
#       See also:       tcl3dSDLGetFocusName
#                       tcl3dSDLGetButtonName
#                       tcl3dSDLGetHatName
#
###############################################################################

proc tcl3dSDLGetEventName { state } {
    if { [info exists ::__tcl3dSDLEventNames($state)] } {
        return $::__tcl3dSDLEventNames($state)
    } else {
        return ""
    }
}

# Utilities for the SDL CD support.

###############################################################################
#[@e
#       Name:           tcl3dSDLFrames2MSF - Convert CD frames.
#
#       Synopsis:       tcl3dSDLFrames2MSF { frames }
#
#       Description:    frames : int
#
#                       Return CD frame as minutes/seconds/frames as a list
#                       of 3 integers.
#
#       See also:
#
###############################################################################

proc tcl3dSDLFrames2MSF { frames } {
    set l [list 0 0 0]
    lset l 2 [expr $frames % $::CD_FPS]
    set frames [expr $frames / $::CD_FPS]
    lset l 1 [expr $frames%60]
    set frames [expr $frames / 60]
    lset l 0 $frames
    return $l
}

array set ::__tcl3dSDLTrackTypeNames [list \
    $::SDL_AUDIO_TRACK "AUDIO_TRACK" \
    $::SDL_DATA_TRACK  "DATA_TRACK" \
]

###############################################################################
#[@e
#       Name:           tcl3dSDLGetTrackTypeName  - Convert track type bitfield. 
#
#       Synopsis:       tcl3dSDLGetTrackTypeName { type }
#
#       Description:    type : int
#
#                       Return SDL CD track type bitfield as the corresponding
#                       string representation.
#                       See file SDL_cdrom.h for the definition of possible
#                       bitfield values.
#
#       See also:       tcl3dSDLGetCdStatusName
#
###############################################################################

proc tcl3dSDLGetTrackTypeName { type } {
    if { [info exists ::__tcl3dSDLTrackTypeNames($type)] } {
        return $::__tcl3dSDLTrackTypeNames($type)
    } else {
        return ""
    }
}

array set ::__tcl3dSDLCdStatusNames [list \
    $::CD_TRAYEMPTY "TRAYEMPTY" \
    $::CD_STOPPED   "STOPPED" \
    $::CD_PLAYING   "PLAYING" \
    $::CD_PAUSED    "PAUSED" \
    $::CD_ERROR     "ERROR" \
]

###############################################################################
#[@e
#       Name:           tcl3dSDLGetCdStatusName  - Convert CD status enumeration.
#
#       Synopsis:       tcl3dSDLGetCdStatusName { status }
#
#       Description:    status : int (CD status enumeration)
#
#                       Return SDL CD status enumeration as the 
#                       corresponding string representation.
#                       See file SDL_cdrom.h for the definition of possible
#                       enumeration values (CDstatus).
#
#       See also:       tcl3dSDLGetTrackTypeName
#
###############################################################################

proc tcl3dSDLGetCdStatusName { status } {
    if { [info exists ::__tcl3dSDLCdStatusNames($status)] } {
        return $::__tcl3dSDLCdStatusNames($status)
    } else {
        return ""
    }
}
