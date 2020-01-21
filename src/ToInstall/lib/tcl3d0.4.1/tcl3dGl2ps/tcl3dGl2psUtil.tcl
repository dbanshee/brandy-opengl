#******************************************************************************
#
#       Copyright:      2006-2009 Paul Obermeier (obermeier@tcl3d.org)
#
#                       See the file "Tcl3D_License.txt" for information on
#                       usage and redistribution of this file, and for a
#                       DISCLAIMER OF ALL WARRANTIES.
#
#       Module:         Tcl3D -> tcl3dGl2ps
#       Filename:       tcl3dGl2psUtil.tcl
#
#       Author:         Paul Obermeier
#
#       Description:    Tcl module with miscellaneous utility
#                       procedures related to the GL2PS module.
#
#******************************************************************************

###############################################################################
#[@e
#       Name:           tcl3dGl2psCreatePdf - Create PDF from OpenGL content.
#
#       Synopsis:       tcl3dGl2psCreatePdf { toglwin filename
#                               { title "Tcl3D Screenshot" }
#                               { drawBackground 0 }
#                               { producer "Tcl3D" } }
#
#       Description:    toglwin        : string (Togl identifier)
#                       filename       : string
#                       title          : string
#                       drawBackground : boolean
#                       producer       : string
#
#                       Create a PDF file from current Togl window content.
#                       The PDF is created from the Togl window identified by
#                       "toglwin" and written to file "filename".
#                       The following optional parameters set PDF specific
#                       values:
#                       "title" is the name of the document title as
#                       listed in the document properties of the PDF file.
#                       If "drawBackground" is set to true, the background
#                       color of the Togl window is also used as the background
#                       color of the PDf document. Otherwise the PDF background
#                       color is set to white.
#                       "procuder" is the name of the producer property as
#                       listed in the document properties of the PDF file.
#
#       See also:
#
###############################################################################

proc tcl3dGl2psCreatePdf { toglwin filename { title "Tcl3D Screenshot" } \
                         { drawBackground 0 } { producer "Tcl3D" } } {
    set retVal [catch {fopen $filename wb} fp]
    if { $retVal != 0 } {
        error "Could not open file $filename for writing"
    }

    set opt [expr {$::GL2PS_OCCLUSION_CULL | \
                   $::GL2PS_USE_CURRENT_VIEWPORT | \
                   $::GL2PS_SILENT}]
    if { $drawBackground } {
        set opt [expr {$opt | $::GL2PS_DRAW_BACKGROUND}]
    }

    set bufSize 0
    set state $::GL2PS_OVERFLOW
    while { $state == $::GL2PS_OVERFLOW } {
        set bufSize [expr {$bufSize + 1024*1024}]
        set retVal [gl2psBeginPage $title $producer NULL $::GL2PS_PDF \
                                   $::GL2PS_SIMPLE_SORT $opt $::GL_RGBA \
                                   0 NULL 0 0 0 \
                                   $bufSize $fp $title]
        if { $retVal == $::GL2PS_ERROR } {
            error "Could not initialize PDF creation: gl2psBeginPage"
        }

        $toglwin render

        set state [gl2psEndPage]
        if { $retVal == $::GL2PS_ERROR } {
            error "Could not write PDF: gl2psEndPage"
        }
    }
    fclose $fp
}

# OBSOLETE tcl3dCreatePdf 0.3.2 tcl3dGl2psCreatePdf
proc tcl3dCreatePdf { toglwin filename { title "Tcl3D Screenshot" } \
                      { drawBackground 0 } { producer "Tcl3D" } } {
    tcl3dGl2psCreatePdf $toglwin $filename $title $drawBackground $producer
}
