#******************************************************************************
#
#       Copyright:      2005-2009 Paul Obermeier (obermeier@tcl3d.org)
#
#                       See the file "Tcl3D_License.txt" for information on
#                       usage and redistribution of this file, and for a
#                       DISCLAIMER OF ALL WARRANTIES.
#
#       Module:         Tcl3D -> tcl3dOsg
#       Filename:       tcl3dOsgKeysym.tcl
#
#       Author:         Paul Obermeier
#
#       Description:    Tcl module for mapping keysym values.
#                       Taken from Wiki page http://wiki.tcl.tk/13162.
#
#******************************************************************************

set ::__tcl3dOsgKeysyms {
 space 32 exclam 33 quotedbl 34 numbersign 35 dollar 36 percent 37
 ampersand 38 quoteright 39 parenleft 40 parenright 41 asterisk 42
 plus 43 comma 44 minus 45 period 46 slash 47 0 48 1 49 2 50 3 51
 4 52 5 53 6 54 7 55 8 56 9 57 colon 58 semicolon 59 less 60 equal 61
 greater 62 question 63 at 64 A 65 B 66 C 67 D 68 E 69 F 70 G 71
 H 72 I 73 J 74 K 75 L 76 M 77 N 78 O 79 P 80 Q 81 R 82 S 83 T 84
 U 85 V 86 W 87 X 88 Y 89 Z 90 bracketleft 91 backslash 92 bracketright 93
 asciicircum 94 underscore 95 quoteleft 96 a 97 b 98 c 99 d 100
 e 101 f 102 g 103 h 104 i 105 j 106 k 107 l 108 m 109 n 110 o 111
 p 112 q 113 r 114 s 115 t 116 u 117 v 118 w 119 x 120 y 121 z 122
 braceleft 123 bar 124 braceright 125 asciitilde 126 nobreakspace 160
 exclamdown 161 cent 162 sterling 163 currency 164 yen 165 brokenbar 166
 section 167 diaeresis 168 copyright 169 ordfeminine 170 guillemotleft 171
 notsign 172 hyphen 173 registered 174 macron 175 degree 176 plusminus 177
 twosuperior 178 threesuperior 179 acute 180 mu 181 paragraph 182
 periodcentered 183 cedilla 184 onesuperior 185 masculine 186
 guillemotright 187 onequarter 188 onehalf 189 threequarters 190
 questiondown 191 Agrave 192 Aacute 193 Acircumflex 194 Atilde 195
 Adiaeresis 196 Aring 197 AE 198 Ccedilla 199 Egrave 200 Eacute 201
 Ecircumflex 202 Ediaeresis 203 Igrave 204 Iacute 205 Icircumflex 206
 Idiaeresis 207 Eth 208 Ntilde 209 Ograve 210 Oacute 211 Ocircumflex 212
 Otilde 213 Odiaeresis 214 multiply 215 Ooblique 216 Ugrave 217
 Uacute 218 Ucircumflex 219 Udiaeresis 220 Yacute 221 Thorn 222
 ssharp 223 agrave 224 aacute 225 acircumflex 226 atilde 227 adiaeresis 228
 aring 229 ae 230 ccedilla 231 egrave 232 eacute 233 ecircumflex 234
 ediaeresis 235 igrave 236 iacute 237 icircumflex 238 idiaeresis 239
 eth 240 ntilde 241 ograve 242 oacute 243 ocircumflex 244 otilde 245
 odiaeresis 246 division 247 oslash 248 ugrave 249 uacute 250
 ucircumflex 251 udiaeresis 252 yacute 253 thorn 254 ydiaeresis 255
 Aogonek 417 breve 418 Lstroke 419 Lcaron 421 Sacute 422 Scaron 425
 Scedilla 426 Tcaron 427 Zacute 428 Zcaron 430 Zabovedot 431 aogonek 433
 ogonek 434 lstroke 435 lcaron 437 sacute 438 caron 439 scaron 441
 scedilla 442 tcaron 443 zacute 444 doubleacute 445 zcaron 446
 zabovedot 447 Racute 448 Abreve 451 Cacute 454 Ccaron 456 Eogonek 458
 Ecaron 460 Dcaron 463 Nacute 465 Ncaron 466 Odoubleacute 469
 Rcaron 472 Uring 473 Udoubleacute 475 Tcedilla 478 racute 480
 abreve 483 cacute 486 ccaron 488 eogonek 490 ecaron 492 dcaron 495
 nacute 497 ncaron 498 odoubleacute 501 rcaron 504 uring 505 udoubleacute 507
 tcedilla 510 abovedot 511 Hstroke 673 Hcircumflex 678 Iabovedot 681
 Gbreve 683 Jcircumflex 684 hstroke 689 hcircumflex 694 idotless 697
 gbreve 699 jcircumflex 700 Cabovedot 709 Ccircumflex 710 Gabovedot 725
 Gcircumflex 728 Ubreve 733 Scircumflex 734 cabovedot 741 ccircumflex 742
 gabovedot 757 gcircumflex 760 ubreve 765 scircumflex 766 kappa 930
 Rcedilla 931 Itilde 933 Lcedilla 934 Emacron 938 Gcedilla 939
 Tslash 940 rcedilla 947 itilde 949 lcedilla 950 emacron 954 gacute 955
 tslash 956 ENG 957 eng 959 Amacron 960 Iogonek 967 Eabovedot 972
 Imacron 975 Ncedilla 977 Omacron 978 Kcedilla 979 Uogonek 985
 Utilde 989 Umacron 990 amacron 992 iogonek 999 eabovedot 1004
 imacron 1007 ncedilla 1009 omacron 1010 kcedilla 1011 uogonek 1017
 utilde 1021 umacron 1022 overline 1150 kana_fullstop 1185 kana_openingbracket 1186
 kana_closingbracket 1187 kana_comma 1188 kana_middledot 1189
 kana_WO 1190 kana_a 1191 kana_i 1192 kana_u 1193 kana_e 1194
 kana_o 1195 kana_ya 1196 kana_yu 1197 kana_yo 1198 kana_tu 1199
 prolongedsound 1200 kana_A 1201 kana_I 1202 kana_U 1203 kana_E 1204
 kana_O 1205 kana_KA 1206 kana_KI 1207 kana_KU 1208 kana_KE 1209
 kana_KO 1210 kana_SA 1211 kana_SHI 1212 kana_SU 1213 kana_SE 1214
 kana_SO 1215 kana_TA 1216 kana_TI 1217 kana_TU 1218 kana_TE 1219
 kana_TO 1220 kana_NA 1221 kana_NI 1222 kana_NU 1223 kana_NE 1224
 kana_NO 1225 kana_HA 1226 kana_HI 1227 kana_HU 1228 kana_HE 1229
 kana_HO 1230 kana_MA 1231 kana_MI 1232 kana_MU 1233 kana_ME 1234
 kana_MO 1235 kana_YA 1236 kana_YU 1237 kana_YO 1238 kana_RA 1239
 kana_RI 1240 kana_RU 1241 kana_RE 1242 kana_RO 1243 kana_WA 1244
 kana_N 1245 voicedsound 1246 semivoicedsound 1247 Arabic_comma 1452
 Arabic_semicolon 1467 Arabic_question_mark 1471 Arabic_hamza 1473
 Arabic_maddaonalef 1474 Arabic_hamzaonalef 1475 Arabic_hamzaonwaw 1476
 Arabic_hamzaunderalef 1477 Arabic_hamzaonyeh 1478 Arabic_alef 1479
 Arabic_beh 1480 Arabic_tehmarbuta 1481 Arabic_teh 1482 Arabic_theh 1483
 Arabic_jeem 1484 Arabic_hah 1485 Arabic_khah 1486 Arabic_dal 1487
 Arabic_thal 1488 Arabic_ra 1489 Arabic_zain 1490 Arabic_seen 1491
 Arabic_sheen 1492 Arabic_sad 1493 Arabic_dad 1494 Arabic_tah 1495
 Arabic_zah 1496 Arabic_ain 1497 Arabic_ghain 1498 Arabic_tatweel 1504
 Arabic_feh 1505 Arabic_qaf 1506 Arabic_kaf 1507 Arabic_lam 1508
 Arabic_meem 1509 Arabic_noon 1510 Arabic_heh 1511 Arabic_waw 1512
 Arabic_alefmaksura 1513 Arabic_yeh 1514 Arabic_fathatan 1515
 Arabic_dammatan 1516 Arabic_kasratan 1517 Arabic_fatha 1518 Arabic_damma 1519
 Arabic_kasra 1520 Arabic_shadda 1521 Arabic_sukun 1522 Serbian_dje 1697
 Macedonia_gje 1698 Cyrillic_io 1699 Ukranian_je 1700 Macedonia_dse 1701
 Ukranian_i 1702 Ukranian_yi 1703 Serbian_je 1704 Serbian_lje 1705
 Serbian_nje 1706 Serbian_tshe 1707 Macedonia_kje 1708 Byelorussian_shortu 1710
 Serbian_dze 1711 numerosign 1712 Serbian_DJE 1713 Macedonia_GJE 1714
 Cyrillic_IO 1715 Ukranian_JE 1716 Macedonia_DSE 1717 Ukranian_I 1718
 Ukranian_YI 1719 Serbian_JE 1720 Serbian_LJE 1721 Serbian_NJE 1722
 Serbian_TSHE 1723 Macedonia_KJE 1724 Byelorussian_SHORTU 1726
 Serbian_DZE 1727 Cyrillic_yu 1728 Cyrillic_a 1729 Cyrillic_be 1730
 Cyrillic_tse 1731 Cyrillic_de 1732 Cyrillic_ie 1733 Cyrillic_ef 1734
 Cyrillic_ghe 1735 Cyrillic_ha 1736 Cyrillic_i 1737 Cyrillic_shorti 1738
 Cyrillic_ka 1739 Cyrillic_el 1740 Cyrillic_em 1741 Cyrillic_en 1742
 Cyrillic_o 1743 Cyrillic_pe 1744 Cyrillic_ya 1745 Cyrillic_er 1746
 Cyrillic_es 1747 Cyrillic_te 1748 Cyrillic_u 1749 Cyrillic_zhe 1750
 Cyrillic_ve 1751 Cyrillic_softsign 1752 Cyrillic_yeru 1753 Cyrillic_ze 1754
 Cyrillic_sha 1755 Cyrillic_e 1756 Cyrillic_shcha 1757 Cyrillic_che 1758
 Cyrillic_hardsign 1759 Cyrillic_YU 1760 Cyrillic_A 1761 Cyrillic_BE 1762
 Cyrillic_TSE 1763 Cyrillic_DE 1764 Cyrillic_IE 1765 Cyrillic_EF 1766
 Cyrillic_GHE 1767 Cyrillic_HA 1768 Cyrillic_I 1769 Cyrillic_SHORTI 1770
 Cyrillic_KA 1771 Cyrillic_EL 1772 Cyrillic_EM 1773 Cyrillic_EN 1774
 Cyrillic_O 1775 Cyrillic_PE 1776 Cyrillic_YA 1777 Cyrillic_ER 1778
 Cyrillic_ES 1779 Cyrillic_TE 1780 Cyrillic_U 1781 Cyrillic_ZHE 1782
 Cyrillic_VE 1783 Cyrillic_SOFTSIGN 1784 Cyrillic_YERU 1785 Cyrillic_ZE 1786
 Cyrillic_SHA 1787 Cyrillic_E 1788 Cyrillic_SHCHA 1789 Cyrillic_CHE 1790
 Cyrillic_HARDSIGN 1791 Greek_ALPHAaccent 1953 Greek_EPSILONaccent 1954
 Greek_ETAaccent 1955 Greek_IOTAaccent 1956 Greek_IOTAdiaeresis 1957
 Greek_IOTAaccentdiaeresis 1958 Greek_OMICRONaccent 1959 Greek_UPSILONaccent 1960
 Greek_UPSILONdieresis 1961 Greek_UPSILONaccentdieresis 1962 Greek_OMEGAaccent 1963
 Greek_alphaaccent 1969 Greek_epsilonaccent 1970 Greek_etaaccent 1971
 Greek_iotaaccent 1972 Greek_iotadieresis 1973 Greek_iotaaccentdieresis 1974
 Greek_omicronaccent 1975 Greek_upsilonaccent 1976 Greek_upsilondieresis 1977
 Greek_upsilonaccentdieresis 1978 Greek_omegaaccent 1979 Greek_ALPHA 1985
 Greek_BETA 1986 Greek_GAMMA 1987 Greek_DELTA 1988 Greek_EPSILON 1989
 Greek_ZETA 1990 Greek_ETA 1991 Greek_THETA 1992 Greek_IOTA 1993
 Greek_KAPPA 1994 Greek_LAMBDA 1995 Greek_MU 1996 Greek_NU 1997
 Greek_XI 1998 Greek_OMICRON 1999 Greek_PI 2000 Greek_RHO 2001
 Greek_SIGMA 2002 Greek_TAU 2004 Greek_UPSILON 2005 Greek_PHI 2006
 Greek_CHI 2007 Greek_PSI 2008 Greek_OMEGA 2009 Greek_alpha 2017
 Greek_beta 2018 Greek_gamma 2019 Greek_delta 2020 Greek_epsilon 2021
 Greek_zeta 2022 Greek_eta 2023 Greek_theta 2024 Greek_iota 2025
 Greek_kappa 2026 Greek_lambda 2027 Greek_mu 2028 Greek_nu 2029
 Greek_xi 2030 Greek_omicron 2031 Greek_pi 2032 Greek_rho 2033
 Greek_sigma 2034 Greek_finalsmallsigma 2035 Greek_tau 2036 Greek_upsilon 2037
 Greek_phi 2038 Greek_chi 2039 Greek_psi 2040 Greek_omega 2041
 leftradical 2209 topleftradical 2210 horizconnector 2211 topintegral 2212
 botintegral 2213 vertconnector 2214 topleftsqbracket 2215 botleftsqbracket 2216
 toprightsqbracket 2217 botrightsqbracket 2218 topleftparens 2219
 botleftparens 2220 toprightparens 2221 botrightparens 2222 leftmiddlecurlybrace 2223
 rightmiddlecurlybrace 2224 topleftsummation 2225 botleftsummation 2226
 topvertsummationconnector 2227 botvertsummationconnector 2228
 toprightsummation 2229 botrightsummation 2230 rightmiddlesummation 2231
 lessthanequal 2236 notequal 2237 greaterthanequal 2238 integral 2239
 therefore 2240 variation 2241 infinity 2242 nabla 2245 approximate 2248
 similarequal 2249 ifonlyif 2253 implies 2254 identical 2255 radical 2262
 includedin 2266 includes 2267 intersection 2268 union 2269 logicaland 2270
 logicalor 2271 partialderivative 2287 function 2294 leftarrow 2299
 uparrow 2300 rightarrow 2301 downarrow 2302 blank 2527 soliddiamond 2528
 checkerboard 2529 ht 2530 ff 2531 cr 2532 lf 2533 nl 2536 vt 2537
 lowrightcorner 2538 uprightcorner 2539 upleftcorner 2540 lowleftcorner 2541
 crossinglines 2542 horizlinescan1 2543 horizlinescan3 2544 horizlinescan5 2545
 horizlinescan7 2546 horizlinescan9 2547 leftt 2548 rightt 2549
 bott 2550 topt 2551 vertbar 2552 emspace 2721 enspace 2722 em3space 2723
 em4space 2724 digitspace 2725 punctspace 2726 thinspace 2727
 hairspace 2728 emdash 2729 endash 2730 signifblank 2732 ellipsis 2734
 doubbaselinedot 2735 onethird 2736 twothirds 2737 onefifth 2738
 twofifths 2739 threefifths 2740 fourfifths 2741 onesixth 2742
 fivesixths 2743 careof 2744 figdash 2747 leftanglebracket 2748
 decimalpoint 2749 rightanglebracket 2750 marker 2751 oneeighth 2755
 threeeighths 2756 fiveeighths 2757 seveneighths 2758 trademark 2761
 signaturemark 2762 trademarkincircle 2763 leftopentriangle 2764
 rightopentriangle 2765 emopencircle 2766 emopenrectangle 2767
 leftsinglequotemark 2768 rightsinglequotemark 2769 leftdoublequotemark 2770
 rightdoublequotemark 2771 prescription 2772 minutes 2774 seconds 2775
 latincross 2777 hexagram 2778 filledrectbullet 2779 filledlefttribullet 2780
 filledrighttribullet 2781 emfilledcircle 2782 emfilledrect 2783
 enopencircbullet 2784 enopensquarebullet 2785 openrectbullet 2786
 opentribulletup 2787 opentribulletdown 2788 openstar 2789 enfilledcircbullet 2790
 enfilledsqbullet 2791 filledtribulletup 2792 filledtribulletdown 2793
 leftpointer 2794 rightpointer 2795 club 2796 diamond 2797 heart 2798
 maltesecross 2800 dagger 2801 doubledagger 2802 checkmark 2803
 ballotcross 2804 musicalsharp 2805 musicalflat 2806 malesymbol 2807
 femalesymbol 2808 telephone 2809 telephonerecorder 2810 phonographcopyright 2811
 caret 2812 singlelowquotemark 2813 doublelowquotemark 2814 cursor 2815
 leftcaret 2979 rightcaret 2982 downcaret 2984 upcaret 2985 overbar 3008
 downtack 3010 upshoe 3011 downstile 3012 underbar 3014 jot 3018
 quad 3020 uptack 3022 circle 3023 upstile 3027 downshoe 3030
 rightshoe 3032 leftshoe 3034 lefttack 3036 righttack 3068 hebrew_aleph 3296
 hebrew_beth 3297 hebrew_gimmel 3298 hebrew_daleth 3299 hebrew_he 3300
 hebrew_waw 3301 hebrew_zayin 3302 hebrew_het 3303 hebrew_teth 3304
 hebrew_yod 3305 hebrew_finalkaph 3306 hebrew_kaph 3307 hebrew_lamed 3308
 hebrew_finalmem 3309 hebrew_mem 3310 hebrew_finalnun 3311 hebrew_nun 3312
 hebrew_samekh 3313 hebrew_ayin 3314 hebrew_finalpe 3315 hebrew_pe 3316
 hebrew_finalzadi 3317 hebrew_zadi 3318 hebrew_kuf 3319 hebrew_resh 3320
 hebrew_shin 3321 hebrew_taf 3322
}

###############################################################################
#[@e
#       Name:           tcl3dOsgKeysym - Convert a keysym into decimal and 
#                       vice versa.
#
#       Synopsis:       tcl3dOsgKeysym { key }
#
#       Description:    Convert a Tk keysym into it's decimal value and vice 
#                       versa.
#                       Example:
#                       tcl3dOsgKeysym A  --> 65
#                       tcl3dOsgKeysym 65 --> A
#
#       See also:
#
###############################################################################

proc tcl3dOsgKeysym { key } {
    global __tcl3dOsgKeysyms

    set pos [lsearch -exact $__tcl3dOsgKeysyms $key]
    if {$pos >= 0} {lindex $__tcl3dOsgKeysyms [expr {$pos+1-2*($pos%2)}]}
}