#******************************************************************************
#
#       Copyright:      2005-2009 Paul Obermeier (obermeier@tcl3d.org)
#
#                       See the file "Tcl3D_License.txt" for information on
#                       usage and redistribution of this file, and for a
#                       DISCLAIMER OF ALL WARRANTIES.
#
#       Module:         Tcl3D -> tcl3dCg
#       Filename:       tcl3dCgUtil.tcl
#
#       Author:         Paul Obermeier
#
#       Description:    Tcl module with miscellaneous utility
#                       procedures related to the Cg module.
#
#******************************************************************************

###############################################################################
#[@e
#       Name:           tcl3dCgGetError - Check for a Cg error.
#
#       Synopsis:       tcl3dCgGetError { contextId { msg "" } }
#
#       Description:    contextId       : Cg context identifier
#                       msg             : Additional message string
#
#                       Check, if a Cg related error has occured. 
#                       The Cg context - as returned by cgCreateContext - has to
#                       be supplied with parameter "contextId".
#                       
#                       The procedure returns an empty string, if no error has
#                       occurred. Otherwise it returns the additional message
#                       string, the error number and Cg error message as supplied
#                       by the Cg library as a formatted string.
#
#       See also:       tcl3dOglGetError
#
###############################################################################

proc tcl3dCgGetError { contextId { msg "" } } {
    set err [cgGetError]

    if { $err == $::CG_NO_ERROR } {
        return ""
    }

    set ret [format "CG error (%s): %d (%s)" $msg $err [cgGetErrorString $err]]
    if { $err == $::CG_COMPILER_ERROR } {
        append ret [format "\nLast Listing:\n%s" [cgGetLastListing $contextId]]
    }
    return $ret
}

# Check, if a Cg related error has occured. 
# The procedure returns 0, if no error has occurred.
# It returns 1 and prints the corresponding error message
# onto standard error otherwise.

# OBSOLETE tcl3dCheckCgError 0.3.2 tcl3dCgGetError
proc tcl3dCheckCgError { contextId msg } {
    set err [cgGetError]

    if { $err == $::CG_NO_ERROR } {
        return 0
    }

    puts stderr [format "%s: CG error: %d (%s)\n" $msg $err \
                [cgGetErrorString $err]]
    if { $err == $::CG_COMPILER_ERROR } {
        puts stderr [format "LAST LISTING----%s----\n" \
                    [cgGetLastListing $contextId]]
    }
    return 1
}

###############################################################################
#[@e
#       Name:           tcl3dCgGetProfileList - Get a list of Cg profile names.
#
#       Synopsis:       tcl3dCgGetProfileList { }
#
#       Description:    Return a Tcl list of Cg profile names.
#
#                       The list consists of (key,value) pairs, where key is the
#                       profile name, like CG_PROFILE_FP30 and value is either 1,
#                       if the corresponding profile is supported, or 0, if it
#                       is not available.
#
#       See also:       tcl3dCgFindProfile
#                       tcl3dCgFindProfileByNum
#
###############################################################################

proc tcl3dCgGetProfileList {} {
    set profList {}
    foreach prof [lsort [info globals CG_PROFILE*]] {
        set enabled [cgGLIsProfileSupported [format "%s" $prof]]
        lappend profList $prof $enabled
    }
    return $profList
}

# OBSOLETE tcl3dGetCgProfileList 0.3.2 tcl3dCgGetProfileList
proc tcl3dGetCgProfileList {} {
    return [tcl3dCgGetProfileList]
}

###############################################################################
#[@e
#       Name:           tcl3dCgFindProfile - Find a supported Cg profile.
#
#       Synopsis:       tcl3dCgFindProfile { args }
#
#       Description:    args    : Profile names
#
#                       Find the first profile supported by the Cg implementation
#                       from the profile names supplied in "args".
#                       If successful, it returns the profile name, otherwise an
#                       empty string.
#
#       See also:       tcl3dCgGetProfileList
#                       tcl3dCgFindProfileByNum
#
###############################################################################

proc tcl3dCgFindProfile { args } {
    foreach prof $args {
        if { [cgGLIsProfileSupported $prof] } {
            return $prof
        }
    }
    return ""
}

# OBSOLETE tcl3dFindCgProfile 0.3.2 tcl3dCgFindProfile
proc tcl3dFindCgProfile { args } {
    return [eval tcl3dCgFindProfile $args]
}

###############################################################################
#[@e
#       Name:           tcl3dCgFindProfileByNum - Find a supported Cg profile.
#
#       Synopsis:       tcl3dCgFindProfileByNum { profileNum }
#
#       Description:    profileNum : int (CGprofile)
#
#                       Find a profile name by it's numerical value supplied 
#                       in "profileNum".
#                       If successful, it returns the profile name, otherwise
#                       an empty string.
#
#                       Note: The procedure does not check, if the profile is
#                             supported. Use tcl3dCgFindProfile to check for
#                             support by the underlying Cg implementation.
#
#       See also:       tcl3dCgGetProfileList
#                       tcl3dCgFindProfile
#
###############################################################################

proc tcl3dCgFindProfileByNum { profileNum } {
    foreach prof [info globals CG_PROFILE*] {
        set cmdStr [format "::%s" $prof]
        if { $profileNum == [set $cmdStr] } {
            return $prof
        }
    }
    return ""
}

# OBSOLETE tcl3dFindCgProfileByNum 0.3.2 tcl3dCgFindProfileByNum
proc tcl3dFindCgProfileByNum { profileNum } {
    return [tcl3dCgFindProfileByNum $profileNum]
}

###############################################################################
#[@e
#       Name:           tcl3dCgPrintProgramInfo - Print Cg program info.
#
#       Synopsis:       tcl3dCgPrintProgramInfo { progId { progFile "Unknown" } }
#
#       Description:    progId          : Cg Program identifier
#                       progFile        : string
#
#                       Print the profile name and the name of the entry function
#                       of the Cg program identified by "progId".
#                       The Cg program identifier is the identifier as returned 
#                       by calls to the cgCreateProgram familiy.
#                       An optional parameter "progFile" can be supplied to 
#                       specify the name of the file containing the Cg program 
#                       source code.
#
#       See also:
#
###############################################################################

proc tcl3dCgPrintProgramInfo { progId { progFile "Unknown" } } {
    puts [format "Source file %s: Profile: %s Entry: %s" \
         $progFile \
         [cgGetProgramString $progId CG_PROGRAM_PROFILE] \
         [cgGetProgramString $progId CG_PROGRAM_ENTRY]]
}

# OBSOLETE tcl3dPrintCgProgramInfo 0.3.2 tcl3dCgPrintProgramInfo
proc tcl3dPrintCgProgramInfo { progId progFile } {
    tcl3dCgPrintProgramInfo $progId $progFile
}
