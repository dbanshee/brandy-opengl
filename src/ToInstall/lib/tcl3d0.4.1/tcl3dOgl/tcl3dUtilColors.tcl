#******************************************************************************
#
#       Copyright:      2005-2009 Paul Obermeier (obermeier@tcl3d.org)
#
#                       See the file "Tcl3D_License.txt" for information on
#                       usage and redistribution of this file, and for a
#                       DISCLAIMER OF ALL WARRANTIES.
#
#       Module:         Tcl3D -> tcl3dOgl
#       Filename:       tcl3dUtilColors.tcl
#
#       Author:         Paul Obermeier, Victor G. Bonilla
#
#       Description:    Tcl module to convert Tcl color names into Tcl3D
#                       color lists. Color names may be specified as numeric
#                       values or strings.
#                       Currently accepted Tcl color names:
#                               #RRGGBB
#                               All names as listed in the Tcl manual pages,
#                               section colors.
#
#                       This module has been inspired by Victor G. Bonilla, who
#                       wrote the first version of this file.
#
#******************************************************************************

###############################################################################
#[@e
#       Name:           tcl3dGetColorNames - Get all supported Tcl color names.
#
#       Synopsis:       tcl3dGetColorNames {}
#
#       Description:    Return a list of all supported Tcl color name strings.
#
#       See also:       tcl3dFindColorName
#
###############################################################################

proc tcl3dGetColorNames {} {
    global __tcl3dColorList

    set len [llength $__tcl3dColorList]
    for { set i 0 } { $i < $len } { incr i 4 } {
        lappend l [lindex $__tcl3dColorList $i]
    }
    return $l
}

###############################################################################
#[@e
#       Name:           tcl3dFindColorName - Validate Tcl color name.
#
#       Synopsis:       tcl3dFindColorName { colorName }
#
#       Description:    colorName : string
#
#                       Check, if supplied color name is a valid string color name.
#                       If true, return the supplied color name, otherwise 
#                       return an empty string.
#
#       See also:       tcl3dGetColorNames
#
###############################################################################

proc tcl3dFindColorName { colorName } {
    global __tcl3dColorList

    return [lsearch -inline $__tcl3dColorList $colorName]
}

###############################################################################
#[@e
#       Name:           tcl3dName2Hex - Convert color name to Tcl hexadecimal.
#
#       Synopsis:       tcl3dName2Hex { colorName } 
#
#       Description:    colorName : string
#
#                       Convert Tcl color name "colorName" into the corresponding 
#                       Tcl hexadecimal representation.
#                       Tcl colors are returned as string in the following format:
#                       #RRGGBB
#
#       See also:       tcl3dName2rgb
#                       tcl3dName2rgbf
#
###############################################################################

proc tcl3dName2Hex { colorName } {
    global __tcl3dColorList

    if {[string index $colorName 0] eq "#" } {
        return $colorName
    } else {
        set ind [lsearch $__tcl3dColorList $colorName]
        if { $ind >= 0 } {
            set rgb [lrange $__tcl3dColorList [expr $ind+1] [expr $ind+3]]
            return [eval "format \#%02X%02X%02X $rgb"]
        }
    }
    error "Invalid color name \"$colorName\" specified"
}

###############################################################################
#[@e
#       Name:           tcl3dName2Hexa - Convert color name to Tcl hexadecimal.
#
#       Synopsis:       tcl3dName2Hexa { colorName } 
#
#       Description:    colorName : string
#
#                       Convert Tcl color name "colorName" into the corresponding 
#                       Tcl hexadecimal representation.
#                       Tcl colors are returned as string in the following format:
#                       #RRGGBBAA
#
#       See also:       tcl3dName2rgba
#                       tcl3dName2rgbaf
#
###############################################################################

proc tcl3dName2Hexa { colorName } {
    return [eval "format %s%02X [tcl3dName2Hex $colorName] 255"]
}

###############################################################################
#[@e
#       Name:           tcl3dName2rgb - Convert color name to OpenGL RGB.
#
#       Synopsis:       tcl3dName2rgb { colorName }
#
#       Description:    colorName : string
#
#                       Convert Tcl color name "colorName" into the corresponding 
#                       OpenGL RGB representation.
#                       OpenGL colors are returned as a list of 3 unsigned 
#                       bytes: { r g b }
#
#       See also:       tcl3dName2rgba
#                       tcl3dName2rgbf
#
###############################################################################

proc tcl3dName2rgb { colorName } {
    global __tcl3dColorList

    if {[string index $colorName 0] eq "#" } {
        scan $colorName "#%2x%2x%2x" r g b
        return [list $r $g $b]
    } else {
        set ind [lsearch $__tcl3dColorList $colorName]
        if { $ind >= 0 } {
            return [lrange $__tcl3dColorList [expr $ind+1] [expr $ind+3]]
        }
    }
    error "Invalid color name \"$colorName\" specified"
}

###############################################################################
#[@e
#       Name:           tcl3dName2rgbf - Convert color name to OpenGL float RGB.
#
#       Synopsis:       tcl3dName2rgbf { colorName } 
#
#       Description:    colorName : string
#
#                       Convert Tcl color name "colorName" into the corresponding 
#                       OpenGL float RGB representation.
#                       OpenGL colors are returned as a list of 3 floats in the
#                       range [0..1]: { r g b }
#
#       See also:       tcl3dName2rgbaf
#                       tcl3dName2rgb
#
###############################################################################

proc tcl3dName2rgbf { colorName } {
    foreach elem [tcl3dName2rgb $colorName] {
        lappend l [expr {$elem / 255.0}]
    }
    return $l
}

###############################################################################
#[@e
#       Name:           tcl3dName2rgba - Convert color name to OpenGL RGBA.
#
#       Synopsis:       tcl3dName2rgba { colorName } 
#
#       Description:    colorName : string
#
#                       Convert Tcl color name "colorName" into the corresponding 
#                       OpenGL RGBA representation.
#                       OpenGL colors are returned as a list of 4 unsigned bytes:
#                       { r g b a }
#
#       See also:       tcl3dName2rgb
#                       tcl3dName2rgbaf
#
###############################################################################

proc tcl3dName2rgba { colorName } {
    return [linsert [tcl3dName2rgb $colorName] end 255]
}

###############################################################################
#[@e
#       Name:           tcl3dName2rgbaf - Convert color name to OpenGL float RGBA.
#
#       Synopsis:       tcl3dName2rgbaf { colorName } 
#
#       Description:    colorName : string
#
#                       Convert Tcl color name "colorName" into the corresponding 
#                       OpenGL float RGBA representation.
#                       OpenGL colors are returned as a list of 4 floats in the
#                       range [0..1]: { r g b a }
#
#       See also:       tcl3dName2rgba
#                       tcl3dName2rgbf
#
###############################################################################

proc tcl3dName2rgbaf { colorName } {
    foreach elem [tcl3dName2rgba $colorName] {
        lappend l [expr {$elem / 255.0}]
    }
    return $l
}

###############################################################################
#[@e
#       Name:           tcl3dRgb2Name - Convert OpenGL RGB to color name.
#
#       Synopsis:       tcl3dRgb2Name { r g b }
#
#       Description:    r, g, b : int
#
#                       Convert an OpenGL RGB color representation into a
#                       hexadecimal Tcl color name string.
#                       OpenGL colors are specified as unsigned bytes in the 
#                       range [0..255].
#
#                       Note: For performance issues no range checking is
#                             performed.
#                             If specifying color values outside the allowed
#                             range, the resulting Tcl color name may result 
#                             in an error like following: 
#                             can't parse color "#FD109142"
#
#       See also:       tcl3dName2rgb
#                       tcl3dRgba2Name
#
###############################################################################

proc tcl3dRgb2Name { r g b } {
    return [format "\#%02X%02X%02X" $r $g $b] 
}

###############################################################################
#[@e
#       Name:           tcl3dRgba2Name - Convert OpenGL RGBA to color name.
#
#       Synopsis:       tcl3dRgba2Name { r g b a }
#
#       Description:    r, g, b, a : int
#
#                       Convert an OpenGL RGBA color representation into a
#                       hexadecimal Tcl color name string.
#                       OpenGL colors are specified as unsigned bytes in the 
#                       range [0..255].
#
#                       Note: For performance issues no range checking is
#                             performed.
#                             If specifying color values outside the allowed
#                             range, the resulting Tcl color name may result 
#                             in an error like following: 
#                             can't parse color "#FD109142"
#
#       See also:       tcl3dName2rgba
#                       tcl3dRgb2Name
#
###############################################################################

proc tcl3dRgba2Name { r g b a } {
    return [format "\#%02X%02X%02X%02X" $r $g $b $a] 
}

###############################################################################
#[@e
#       Name:           tcl3dRgbf2Name - Convert OpenGL RGB to color name.
#
#       Synopsis:       tcl3dRgbf2Name { r g b }
#
#       Description:    r, g, b : float
#
#                       Convert an OpenGL RGB color representation into a
#                       hexadecimal Tcl color name string.
#                       OpenGL colors are specified as floats in the range
#                       [0..1].
#                       
#                       Note: For performance issues no range checking is
#                             performed.
#                             If specifying color values outside the allowed
#                             range, the resulting Tcl color name may result 
#                             in an error like following: 
#                             can't parse color "#FD109142"
#
#       See also:       tcl3dName2rgbf
#                       tcl3dRgbf2Name
#
###############################################################################

proc tcl3dRgbf2Name { r g b } {
    return [format "\#%02X%02X%02X" [expr {int ($r*255.0)}] \
                                    [expr {int ($g*255.0)}] \
                                    [expr {int ($b*255.0)}]] 
}

###############################################################################
#[@e
#       Name:           tcl3dRgbaf2Name - Convert OpenGL RGBA to color name.
#
#       Synopsis:       tcl3dRgbaf2Name { r g b a }
#
#       Description:    r, g, b, a : float
#
#                       Convert an OpenGL RGBA color representation into a
#                       hexadecimal Tcl color name string.
#                       OpenGL colors are specified as floats in the range
#                       [0..1].
#
#                       Note: For performance issues no range checking is
#                             performed.
#                             If specifying color values outside the allowed
#                             range, the resulting Tcl color name may result 
#                             in an error like following: 
#                             can't parse color "#FD109142"
#
#       See also:       tcl3dName2rgbaf
#                       tcl3dRgbaf2Name
#
###############################################################################

proc tcl3dRgbaf2Name { r g b a } {
    return [format "\#%02X%02X%02X%02X" [expr {int ($r*255.0)}] \
                                        [expr {int ($g*255.0)}] \
                                        [expr {int ($b*255.0)}] \
                                        [expr {int ($a*255.0)}]] 
}

set ::__tcl3dColorList {
    "alice blue"               240   248   255
    "AliceBlue"                240   248   255
    "antique white"            250   235   215
    "AntiqueWhite"             250   235   215
    "AntiqueWhite1"            255   239   219
    "AntiqueWhite2"            238   223   204
    "AntiqueWhite3"            205   192   176
    "AntiqueWhite4"            139   131   120
    "aquamarine"               127   255   212
    "aquamarine1"              127   255   212
    "aquamarine2"              118   238   198
    "aquamarine3"              102   205   170
    "aquamarine4"               69   139   116
    "azure"                    240   255   255
    "azure1"                   240   255   255
    "azure2"                   224   238   238
    "azure3"                   193   205   205
    "azure4"                   131   139   139
    "beige"                    245   245   220
    "bisque"                   255   228   196
    "bisque1"                  255   228   196
    "bisque2"                  238   213   183
    "bisque3"                  205   183   158
    "bisque4"                  139   125   107
    "blanched almond"          255   235   205
    "BlanchedAlmond"           255   235   205
    "blue violet"              138    43   226
    "blue1"                      0     0   255
    "blue2"                      0     0   238
    "blue3"                      0     0   205
    "blue4"                      0     0   139
    "BlueViolet"               138    43   226
    "brown"                    165    42    42
    "brown1"                   255    64    64
    "brown2"                   238    59    59
    "brown3"                   205    51    51
    "brown4"                   139    35    35
    "burlywood"                222   184   135
    "burlywood1"               255   211   155
    "burlywood2"               238   197   145
    "burlywood3"               205   170   125
    "burlywood4"               139   115    85
    "cadet blue"                95   158   160
    "CadetBlue"                 95   158   160
    "CadetBlue1"               152   245   255
    "CadetBlue2"               142   229   238
    "CadetBlue3"               122   197   205
    "CadetBlue4"                83   134   139
    "chartreuse"               127   255     0
    "chartreuse1"              127   255     0
    "chartreuse2"              118   238     0
    "chartreuse3"              102   205     0
    "chartreuse4"               69   139     0
    "chocolate"                210   105    30
    "chocolate1"               255   127    36
    "chocolate2"               238   118    33
    "chocolate3"               205   102    29
    "chocolate4"               139    69    19
    "coral"                    255   127    80
    "coral1"                   255   114    86
    "coral2"                   238   106    80
    "coral3"                   205    91    69
    "coral4"                   139    62    47
    "cornflower blue"          100   149   237
    "CornflowerBlue"           100   149   237
    "cornsilk1"                255   248   220
    "cornsilk2"                238   232   205
    "cornsilk3"                205   200   177
    "cornsilk4"                139   136   120
    "cornsilk"                 255   248   220
    "cyan1"                      0   255   255
    "cyan2"                      0   238   238
    "cyan3"                      0   205   205
    "cyan4"                      0   139   139
    "dark blue"                  0     0   139
    "dark cyan"                  0   139   139
    "dark goldenrod"           184   134    11
    "dark gray"                169   169   169
    "dark green"                 0   100     0
    "dark grey"                169   169   169
    "dark khaki"               189   183   107
    "dark magenta"             139     0   139
    "dark olive green"          85   107    47
    "dark orange"              255   140     0
    "dark orchid"              153    50   204
    "dark red"                 139     0     0
    "dark salmon"              233   150   122
    "dark sea green"           143   188   143
    "dark slate blue"           72    61   139
    "dark slate gray"           47    79    79
    "dark slate grey"           47    79    79
    "dark turquoise"             0   206   209
    "dark violet"              148     0   211
    "DarkBlue"                   0     0   139
    "DarkCyan"                   0   139   139
    "DarkGoldenrod"            184   134    11
    "DarkGoldenrod1"           255   185    15
    "DarkGoldenrod2"           238   173    14
    "DarkGoldenrod3"           205   149    12
    "DarkGoldenrod4"           139   101     8
    "DarkGray"                 169   169   169
    "DarkGreen"                  0   100     0
    "DarkGrey"                 169   169   169
    "DarkKhaki"                189   183   107
    "DarkMagenta"              139     0   139
    "DarkOliveGreen"            85   107    47
    "DarkOliveGreen1"          202   255   112
    "DarkOliveGreen2"          188   238   104
    "DarkOliveGreen3"          162   205    90
    "DarkOliveGreen4"          110   139    61
    "DarkOrange"               255   140     0
    "DarkOrange1"              255   127     0
    "DarkOrange2"              238   118     0
    "DarkOrange3"              205   102     0
    "DarkOrange4"              139    69     0
    "DarkOrchid"               153    50   204
    "DarkOrchid1"              191    62   255
    "DarkOrchid2"              178    58   238
    "DarkOrchid3"              154    50   205
    "DarkOrchid4"              104    34   139
    "DarkRed"                  139     0     0
    "DarkSalmon"               233   150   122
    "DarkSeaGreen"             143   188   143
    "DarkSeaGreen1"            193   255   193
    "DarkSeaGreen2"            180   238   180
    "DarkSeaGreen3"            155   205   155
    "DarkSeaGreen4"            105   139   105
    "DarkSlateBlue"             72    61   139
    "DarkSlateGray1"           151   255   255
    "DarkSlateGray2"           141   238   238
    "DarkSlateGray3"           121   205   205
    "DarkSlateGray4"            82   139   139
    "DarkSlateGray"             47    79    79
    "DarkSlateGrey"             47    79    79
    "DarkTurquoise"              0   206   209
    "DarkViolet"               148     0   211
    "deep pink"                255    20   147
    "deep sky blue"              0   191   255
    "DeepPink1"                255    20   147
    "DeepPink2"                238    18   137
    "DeepPink3"                205    16   118
    "DeepPink4"                139    10    80
    "DeepPink"                 255    20   147
    "DeepSkyBlue1"               0   191   255
    "DeepSkyBlue2"               0   178   238
    "DeepSkyBlue3"               0   154   205
    "DeepSkyBlue4"               0   104   139
    "DeepSkyBlue"                0   191   255
    "dim gray"                 105   105   105
    "dim grey"                 105   105   105
    "DimGray"                  105   105   105
    "DimGrey"                  105   105   105
    "dodger blue"               30   144   255
    "DodgerBlue1"               30   144   255
    "DodgerBlue2"               28   134   238
    "DodgerBlue3"               24   116   205
    "DodgerBlue4"               16    78   139
    "DodgerBlue"                30   144   255
    "firebrick1"               255    48    48
    "firebrick2"               238    44    44
    "firebrick3"               205    38    38
    "firebrick4"               139    26    26
    "firebrick"                178    34    34
    "floral white"             255   250   240
    "FloralWhite"              255   250   240
    "forest green"              34   139    34
    "ForestGreen"               34   139    34
    "gainsboro"                220   220   220
    "ghost white"              248   248   255
    "GhostWhite"               248   248   255
    "gold1"                    255   215     0
    "gold2"                    238   201     0
    "gold3"                    205   173     0
    "gold4"                    139   117     0
    "gold"                     255   215     0
    "goldenrod1"               255   193    37
    "goldenrod2"               238   180    34
    "goldenrod3"               205   155    29
    "goldenrod4"               139   105    20
    "goldenrod"                218   165    32
    "gray"                     190   190   190
    "gray0"                      0     0     0
    "gray1"                      3     3     3
    "gray2"                      5     5     5
    "gray3"                      8     8     8
    "gray4"                     10    10    10
    "gray5"                     13    13    13
    "gray6"                     15    15    15
    "gray7"                     18    18    18
    "gray8"                     20    20    20
    "gray9"                     23    23    23
    "gray10"                    26    26    26
    "gray11"                    28    28    28
    "gray12"                    31    31    31
    "gray13"                    33    33    33
    "gray14"                    36    36    36
    "gray15"                    38    38    38
    "gray16"                    41    41    41
    "gray17"                    43    43    43
    "gray18"                    46    46    46
    "gray19"                    48    48    48
    "gray20"                    51    51    51
    "gray21"                    54    54    54
    "gray22"                    56    56    56
    "gray23"                    59    59    59
    "gray24"                    61    61    61
    "gray25"                    64    64    64
    "gray26"                    66    66    66
    "gray27"                    69    69    69
    "gray28"                    71    71    71
    "gray29"                    74    74    74
    "gray30"                    77    77    77
    "gray31"                    79    79    79
    "gray32"                    82    82    82
    "gray33"                    84    84    84
    "gray34"                    87    87    87
    "gray35"                    89    89    89
    "gray36"                    92    92    92
    "gray37"                    94    94    94
    "gray38"                    97    97    97
    "gray39"                    99    99    99
    "gray40"                   102   102   102
    "gray41"                   105   105   105
    "gray42"                   107   107   107
    "gray43"                   110   110   110
    "gray44"                   112   112   112
    "gray45"                   115   115   115
    "gray46"                   117   117   117
    "gray47"                   120   120   120
    "gray48"                   122   122   122
    "gray49"                   125   125   125
    "gray50"                   127   127   127
    "gray51"                   130   130   130
    "gray52"                   133   133   133
    "gray53"                   135   135   135
    "gray54"                   138   138   138
    "gray55"                   140   140   140
    "gray56"                   143   143   143
    "gray57"                   145   145   145
    "gray58"                   148   148   148
    "gray59"                   150   150   150
    "gray60"                   153   153   153
    "gray61"                   156   156   156
    "gray62"                   158   158   158
    "gray63"                   161   161   161
    "gray64"                   163   163   163
    "gray65"                   166   166   166
    "gray66"                   168   168   168
    "gray67"                   171   171   171
    "gray68"                   173   173   173
    "gray69"                   176   176   176
    "gray70"                   179   179   179
    "gray71"                   181   181   181
    "gray72"                   184   184   184
    "gray73"                   186   186   186
    "gray74"                   189   189   189
    "gray75"                   191   191   191
    "gray76"                   194   194   194
    "gray77"                   196   196   196
    "gray78"                   199   199   199
    "gray79"                   201   201   201
    "gray80"                   204   204   204
    "gray81"                   207   207   207
    "gray82"                   209   209   209
    "gray83"                   212   212   212
    "gray84"                   214   214   214
    "gray85"                   217   217   217
    "gray86"                   219   219   219
    "gray87"                   222   222   222
    "gray88"                   224   224   224
    "gray89"                   227   227   227
    "gray90"                   229   229   229
    "gray91"                   232   232   232
    "gray92"                   235   235   235
    "gray93"                   237   237   237
    "gray94"                   240   240   240
    "gray95"                   242   242   242
    "gray96"                   245   245   245
    "gray97"                   247   247   247
    "gray98"                   250   250   250
    "gray99"                   252   252   252
    "gray100"                  255   255   255
    "green yellow"             173   255    47
    "green1"                     0   255     0
    "green2"                     0   238     0
    "green3"                     0   205     0
    "green4"                     0   139     0
    "GreenYellow"              173   255    47
    "grey0"                      0     0     0
    "grey1"                      3     3     3
    "grey2"                      5     5     5
    "grey3"                      8     8     8
    "grey4"                     10    10    10
    "grey5"                     13    13    13
    "grey6"                     15    15    15
    "grey7"                     18    18    18
    "grey8"                     20    20    20
    "grey9"                     23    23    23
    "grey10"                    26    26    26
    "grey11"                    28    28    28
    "grey12"                    31    31    31
    "grey13"                    33    33    33
    "grey14"                    36    36    36
    "grey15"                    38    38    38
    "grey16"                    41    41    41
    "grey17"                    43    43    43
    "grey18"                    46    46    46
    "grey19"                    48    48    48
    "grey20"                    51    51    51
    "grey21"                    54    54    54
    "grey22"                    56    56    56
    "grey23"                    59    59    59
    "grey24"                    61    61    61
    "grey25"                    64    64    64
    "grey26"                    66    66    66
    "grey27"                    69    69    69
    "grey28"                    71    71    71
    "grey29"                    74    74    74
    "grey30"                    77    77    77
    "grey31"                    79    79    79
    "grey32"                    82    82    82
    "grey33"                    84    84    84
    "grey34"                    87    87    87
    "grey35"                    89    89    89
    "grey36"                    92    92    92
    "grey37"                    94    94    94
    "grey38"                    97    97    97
    "grey39"                    99    99    99
    "grey40"                   102   102   102
    "grey41"                   105   105   105
    "grey42"                   107   107   107
    "grey43"                   110   110   110
    "grey44"                   112   112   112
    "grey45"                   115   115   115
    "grey46"                   117   117   117
    "grey47"                   120   120   120
    "grey48"                   122   122   122
    "grey49"                   125   125   125
    "grey50"                   127   127   127
    "grey51"                   130   130   130
    "grey52"                   133   133   133
    "grey53"                   135   135   135
    "grey54"                   138   138   138
    "grey55"                   140   140   140
    "grey56"                   143   143   143
    "grey57"                   145   145   145
    "grey58"                   148   148   148
    "grey59"                   150   150   150
    "grey60"                   153   153   153
    "grey61"                   156   156   156
    "grey62"                   158   158   158
    "grey63"                   161   161   161
    "grey64"                   163   163   163
    "grey65"                   166   166   166
    "grey66"                   168   168   168
    "grey67"                   171   171   171
    "grey68"                   173   173   173
    "grey69"                   176   176   176
    "grey70"                   179   179   179
    "grey71"                   181   181   181
    "grey72"                   184   184   184
    "grey73"                   186   186   186
    "grey74"                   189   189   189
    "grey75"                   191   191   191
    "grey76"                   194   194   194
    "grey77"                   196   196   196
    "grey78"                   199   199   199
    "grey79"                   201   201   201
    "grey80"                   204   204   204
    "grey81"                   207   207   207
    "grey82"                   209   209   209
    "grey83"                   212   212   212
    "grey84"                   214   214   214
    "grey85"                   217   217   217
    "grey86"                   219   219   219
    "grey87"                   222   222   222
    "grey88"                   224   224   224
    "grey89"                   227   227   227
    "grey90"                   229   229   229
    "grey91"                   232   232   232
    "grey92"                   235   235   235
    "grey93"                   237   237   237
    "grey94"                   240   240   240
    "grey95"                   242   242   242
    "grey96"                   245   245   245
    "grey97"                   247   247   247
    "grey98"                   250   250   250
    "grey99"                   252   252   252
    "grey100"                  255   255   255
    "grey"                     190   190   190
    "honeydew1"                240   255   240
    "honeydew2"                224   238   224
    "honeydew3"                193   205   193
    "honeydew4"                131   139   131
    "honeydew"                 240   255   240
    "hot pink"                 255   105   180
    "HotPink1"                 255   110   180
    "HotPink2"                 238   106   167
    "HotPink3"                 205    96   144
    "HotPink4"                 139    58    98
    "HotPink"                  255   105   180
    "indian red"               205    92    92
    "IndianRed1"               255   106   106
    "IndianRed2"               238    99    99
    "IndianRed3"               205    85    85
    "IndianRed4"               139    58    58
    "IndianRed"                205    92    92
    "ivory1"                   255   255   240
    "ivory2"                   238   238   224
    "ivory3"                   205   205   193
    "ivory4"                   139   139   131
    "ivory"                    255   255   240
    "khaki1"                   255   246   143
    "khaki2"                   238   230   133
    "khaki3"                   205   198   115
    "khaki4"                   139   134    78
    "khaki"                    240   230   140
    "lavender"                 230   230   250
    "lavender blush"           255   240   245
    "LavenderBlush1"           255   240   245
    "LavenderBlush2"           238   224   229
    "LavenderBlush3"           205   193   197
    "LavenderBlush4"           139   131   134
    "LavenderBlush"            255   240   245
    "lawn green"               124   252     0
    "LawnGreen"                124   252     0
    "lemon chiffon"            255   250   205
    "LemonChiffon1"            255   250   205
    "LemonChiffon2"            238   233   191
    "LemonChiffon3"            205   201   165
    "LemonChiffon4"            139   137   112
    "LemonChiffon"             255   250   205
    "light blue"               173   216   230
    "light coral"              240   128   128
    "light cyan"               224   255   255
    "light goldenrod"          238   221   130
    "light goldenrod yellow"   250   250   210
    "light gray"               211   211   211
    "light green"              144   238   144
    "light grey"               211   211   211
    "light pink"               255   182   193
    "light salmon"             255   160   122
    "light sea green"           32   178   170
    "light sky blue"           135   206   250
    "light slate blue"         132   112   255
    "light slate gray"         119   136   153
    "light slate grey"         119   136   153
    "light steel blue"         176   196   222
    "light yellow"             255   255   224
    "LightBlue1"               191   239   255
    "LightBlue2"               178   223   238
    "LightBlue3"               154   192   205
    "LightBlue4"               104   131   139
    "LightBlue"                173   216   230
    "LightCoral"               240   128   128
    "LightCyan1"               224   255   255
    "LightCyan2"               209   238   238
    "LightCyan3"               180   205   205
    "LightCyan4"               122   139   139
    "LightCyan"                224   255   255
    "LightGoldenrod1"          255   236   139
    "LightGoldenrod2"          238   220   130
    "LightGoldenrod3"          205   190   112
    "LightGoldenrod4"          139   129    76
    "LightGoldenrod"           238   221   130
    "LightGoldenrodYellow"     250   250   210
    "LightGray"                211   211   211
    "LightGreen"               144   238   144
    "LightGrey"                211   211   211
    "LightPink1"               255   174   185
    "LightPink2"               238   162   173
    "LightPink3"               205   140   149
    "LightPink4"               139    95   101
    "LightPink"                255   182   193
    "LightSalmon1"             255   160   122
    "LightSalmon2"             238   149   114
    "LightSalmon3"             205   129    98
    "LightSalmon4"             139    87    66
    "LightSalmon"              255   160   122
    "LightSeaGreen"             32   178   170
    "LightSkyBlue1"            176   226   255
    "LightSkyBlue2"            164   211   238
    "LightSkyBlue3"            141   182   205
    "LightSkyBlue4"             96   123   139
    "LightSkyBlue"             135   206   250
    "LightSlateBlue"           132   112   255
    "LightSlateGray"           119   136   153
    "LightSlateGrey"           119   136   153
    "LightSteelBlue1"          202   225   255
    "LightSteelBlue2"          188   210   238
    "LightSteelBlue3"          162   181   205
    "LightSteelBlue4"          110   123   139
    "LightSteelBlue"           176   196   222
    "LightYellow1"             255   255   224
    "LightYellow2"             238   238   209
    "LightYellow3"             205   205   180
    "LightYellow4"             139   139   122
    "LightYellow"              255   255   224
    "lime green"                50   205    50
    "LimeGreen"                 50   205    50
    "linen"                    250   240   230
    "magenta1"                 255     0   255
    "magenta2"                 238     0   238
    "magenta3"                 205     0   205
    "magenta4"                 139     0   139
    "magenta"                  255     0   255
    "maroon1"                  255    52   179
    "maroon2"                  238    48   167
    "maroon3"                  205    41   144
    "maroon4"                  139    28    98
    "maroon"                   176    48    96
    "medium aquamarine"        102   205   170
    "medium blue"                0     0   205
    "medium orchid"            186    85   211
    "medium purple"            147   112   219
    "medium sea green"          60   179   113
    "medium slate blue"        123   104   238
    "medium spring green"        0   250   154
    "medium turquoise"          72   209   204
    "medium violet red"        199    21   133
    "MediumAquamarine"         102   205   170
    "MediumBlue"                 0     0   205
    "MediumOrchid1"            224   102   255
    "MediumOrchid2"            209    95   238
    "MediumOrchid3"            180    82   205
    "MediumOrchid4"            122    55   139
    "MediumOrchid"             186    85   211
    "MediumPurple1"            171   130   255
    "MediumPurple2"            159   121   238
    "MediumPurple3"            137   104   205
    "MediumPurple4"             93    71   139
    "MediumPurple"             147   112   219
    "MediumSeaGreen"            60   179   113
    "MediumSlateBlue"          123   104   238
    "MediumSpringGreen"          0   250   154
    "MediumTurquoise"           72   209   204
    "MediumVioletRed"          199    21   133
    "midnight blue"             25    25   112
    "MidnightBlue"              25    25   112
    "mint cream"               245   255   250
    "MintCream"                245   255   250
    "misty rose"               255   228   225
    "MistyRose1"               255   228   225
    "MistyRose2"               238   213   210
    "MistyRose3"               205   183   181
    "MistyRose4"               139   125   123
    "MistyRose"                255   228   225
    "moccasin"                 255   228   181
    "navajo white"             255   222   173
    "NavajoWhite1"             255   222   173
    "NavajoWhite2"             238   207   161
    "NavajoWhite3"             205   179   139
    "NavajoWhite4"             139   121    94
    "NavajoWhite"              255   222   173
    "navy"                       0     0   128
    "navy blue"                  0     0   128
    "NavyBlue"                   0     0   128
    "old lace"                 253   245   230
    "OldLace"                  253   245   230
    "olive drab"               107   142    35
    "OliveDrab1"               192   255    62
    "OliveDrab2"               179   238    58
    "OliveDrab3"               154   205    50
    "OliveDrab4"               105   139    34
    "OliveDrab"                107   142    35
    "orange red"               255    69     0
    "orange1"                  255   165     0
    "orange2"                  238   154     0
    "orange3"                  205   133     0
    "orange4"                  139    90     0
    "orange"                   255   165     0
    "OrangeRed1"               255    69     0
    "OrangeRed2"               238    64     0
    "OrangeRed3"               205    55     0
    "OrangeRed4"               139    37     0
    "OrangeRed"                255    69     0
    "orchid1"                  255   131   250
    "orchid2"                  238   122   233
    "orchid3"                  205   105   201
    "orchid4"                  139    71   137
    "orchid"                   218   112   214
    "pale goldenrod"           238   232   170
    "pale green"               152   251   152
    "pale turquoise"           175   238   238
    "pale violet red"          219   112   147
    "PaleGoldenrod"            238   232   170
    "PaleGreen1"               154   255   154
    "PaleGreen2"               144   238   144
    "PaleGreen3"               124   205   124
    "PaleGreen4"                84   139    84
    "PaleGreen"                152   251   152
    "PaleTurquoise1"           187   255   255
    "PaleTurquoise2"           174   238   238
    "PaleTurquoise3"           150   205   205
    "PaleTurquoise4"           102   139   139
    "PaleTurquoise"            175   238   238
    "PaleVioletRed1"           255   130   171
    "PaleVioletRed2"           238   121   159
    "PaleVioletRed3"           205   104   127
    "PaleVioletRed4"           139    71    93
    "PaleVioletRed"            219   112   147
    "papaya whip"              255   239   213
    "PapayaWhip"               255   239   213
    "peach puff"               255   218   185
    "PeachPuff1"               255   218   185
    "PeachPuff2"               238   203   173
    "PeachPuff3"               205   175   149
    "PeachPuff4"               139   119   101
    "PeachPuff"                255   218   185
    "peru"                     205   133    63
    "pink1"                    255   181   197
    "pink2"                    238   169   184
    "pink3"                    205   145   158
    "pink4"                    139    99   108
    "pink"                     255   192   203
    "plum1"                    255   187   255
    "plum2"                    238   174   238
    "plum3"                    205   150   205
    "plum4"                    139   102   139
    "plum"                     221   160   221
    "powder blue"              176   224   230
    "PowderBlue"               176   224   230
    "purple1"                  155    48   255
    "purple2"                  145    44   238
    "purple3"                  125    38   205
    "purple4"                   85    26   139
    "purple"                   160    32   240
    "red1"                     255     0     0
    "red2"                     238     0     0
    "red3"                     205     0     0
    "red4"                     139     0     0
    "rosy brown"               188   143   143
    "RosyBrown1"               255   193   193
    "RosyBrown2"               238   180   180
    "RosyBrown3"               205   155   155
    "RosyBrown4"               139   105   105
    "RosyBrown"                188   143   143
    "royal blue"                65   105   225
    "RoyalBlue1"                72   118   255
    "RoyalBlue2"                67   110   238
    "RoyalBlue3"                58    95   205
    "RoyalBlue4"                39    64   139
    "RoyalBlue"                 65   105   225
    "saddle brown"             139    69    19
    "SaddleBrown"              139    69    19
    "salmon1"                  255   140   105
    "salmon2"                  238   130    98
    "salmon3"                  205   112    84
    "salmon4"                  139    76    57
    "salmon"                   250   128   114
    "sandy brown"              244   164    96
    "SandyBrown"               244   164    96
    "sea green"                 46   139    87
    "SeaGreen1"                 84   255   159
    "SeaGreen2"                 78   238   148
    "SeaGreen3"                 67   205   128
    "SeaGreen4"                 46   139    87
    "SeaGreen"                  46   139    87
    "seashell1"                255   245   238
    "seashell2"                238   229   222
    "seashell3"                205   197   191
    "seashell4"                139   134   130
    "seashell"                 255   245   238
    "sienna1"                  255   130    71
    "sienna2"                  238   121    66
    "sienna3"                  205   104    57
    "sienna4"                  139    71    38
    "sienna"                   160    82    45
    "sky blue"                 135   206   235
    "SkyBlue1"                 135   206   255
    "SkyBlue2"                 126   192   238
    "SkyBlue3"                 108   166   205
    "SkyBlue4"                  74   112   139
    "SkyBlue"                  135   206   235
    "slate blue"               106    90   205
    "slate gray"               112   128   144
    "slate grey"               112   128   144
    "SlateBlue1"               131   111   255
    "SlateBlue2"               122   103   238
    "SlateBlue3"               105    89   205
    "SlateBlue4"                71    60   139
    "SlateBlue"                106    90   205
    "SlateGray1"               198   226   255
    "SlateGray2"               185   211   238
    "SlateGray3"               159   182   205
    "SlateGray4"               108   123   139
    "SlateGray"                112   128   144
    "SlateGrey"                112   128   144
    "snow1"                    255   250   250
    "snow2"                    238   233   233
    "snow3"                    205   201   201
    "snow4"                    139   137   137
    "snow"                     255   250   250
    "spring green"               0   255   127
    "SpringGreen1"               0   255   127
    "SpringGreen2"               0   238   118
    "SpringGreen3"               0   205   102
    "SpringGreen4"               0   139    69
    "SpringGreen"                0   255   127
    "steel blue"                70   130   180
    "SteelBlue1"                99   184   255
    "SteelBlue2"                92   172   238
    "SteelBlue3"                79   148   205
    "SteelBlue4"                54   100   139
    "SteelBlue"                 70   130   180
    "tan1"                     255   165    79
    "tan2"                     238   154    73
    "tan3"                     205   133    63
    "tan4"                     139    90    43
    "tan"                      210   180   140
    "thistle1"                 255   225   255
    "thistle2"                 238   210   238
    "thistle3"                 205   181   205
    "thistle4"                 139   123   139
    "thistle"                  216   191   216
    "tomato1"                  255    99    71
    "tomato2"                  238    92    66
    "tomato3"                  205    79    57
    "tomato4"                  139    54    38
    "tomato"                   255    99    71 
    "turquoise1"                 0   245   255
    "turquoise2"                 0   229   238
    "turquoise3"                 0   197   205
    "turquoise4"                 0   134   139
    "turquoise"                 64   224   208
    "violet red"               208    32   144
    "VioletRed1"               255    62   150
    "VioletRed2"               238    58   140
    "VioletRed3"               205    50   120
    "VioletRed4"               139    34    82
    "VioletRed"                208    32   144
    "wheat1"                   255   231   186
    "wheat2"                   238   216   174
    "wheat3"                   205   186   150
    "wheat4"                   139   126   102
    "wheat"                    245   222   179
    "white smoke"              245   245   245
    "WhiteSmoke"               245   245   245
    "yellow green"             154   205    50
    "yellow1"                  255   255     0
    "yellow2"                  238   238     0
    "yellow3"                  205   205     0
    "yellow4"                  139   139     0
    "YellowGreen"              154   205    50
    "blue"                       0     0   255
    "cyan"                       0   255   255
    "green"                      0   255     0
    "red"                      255     0     0
    "black"                      0     0     0
    "yellow"                   255   255     0
    "violet"                   238   130   238
    "white"                    255   255   255
}
