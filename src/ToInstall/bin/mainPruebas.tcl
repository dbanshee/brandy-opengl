#
#	Main para pruebas del VisorGL
#

console show

source Fich.tcl
source Conf.tcl
source Data.tcl
source VisorGL.tcl

puts "--------------------------------------------------"
puts "-                                                -"
puts "-  VISORGL MOLECULAR ENGINE    -   BANSHEE 2010  -"
puts "-                                                -"
puts "-  Version en Desarrollo                         -"
puts "-                                                -"
puts "--------------------------------------------------\n\n"



Conf::newConf c
Conf::inicializarConf c "conf.ini" "colors.ini"
Data::newData molec0
Fich::leeFichMol "p.mol" molec0 c
#Fich::leeFichMol "cafeina.mol" molec2 c

Data::newData molec1
#Fich::leeFichMol "p2.mol" molec2 c
Fich::leeFichMol "cafeina.mol" molec1 c
#Fich::leeFichMol "c.mol" molec1 c




Data::newData molec2
Fich::leeFichMol "aspirina.mol" molec2 c
#Fich::leeFichMol "dna.mol" molec2 c
#Fich::leeFichMol "cuboagua.mol" molec2 c


VisorGL::newVisorGL v c
VisorGL::enablePresentation v
#VisorGL::cargaVisorMolData v molec0 c
#VisorGL::cargaVisorMolData v molec1 c
#VisorGL::cargaVisorMolData v molec2 c

#VisorGL::delVisorMolData v molec1
#VisorGL::delVisorMolData v molec0


VisorGL::cargaVisorMolData v molec1 c
VisorGL::cargaVisorMolData v molec2 c


#VisorGL::leerFichMaya "salida.bma"



wm title . "VisorGL Molecular Engine - Banshee 2010"


frame .fr 
pack .fr -expand 1 -fill both


#Button .fr.b1 -activebackground #a0a0a0  -helptext "Convertir" -text "Texto"
#togl .fr.toglWin 	-width 650 -height 650 -createproc "VisorGL::inicializarVisorGL v" -displayproc "VisorGL::displayVisorGL v" -reshapeproc "VisorGL::reshapeVisorGL v" -double true -depth true
togl .fr.toglWin -createproc "VisorGL::inicializarVisorGL v"

#tcl3dOglLogoRandomize
update

VisorGL::startPresentation v

#pack .fr.b1 -fill x
pack .fr.toglWin -expand 1 -fill both
#grid .fr.toglWin -row 0 -column 0 -sticky news

#update



#bind .fr.toglWin <1> "VisorGL::actualizarCamara v; .fr.toglWin postredisplay"
bind . <Key-Left> "VisorGL::camaraAzimuth v 5 ;.fr.toglWin postredisplay"
bind . <Key-Right> "VisorGL::camaraAzimuth v -5;  .fr.toglWin postredisplay"
bind . <Key-Up> "VisorGL::camaraElevation v 5;  .fr.toglWin postredisplay"
bind . <Key-Down> "VisorGL::camaraElevation v -5;  .fr.toglWin postredisplay"


#update

#bind . <Key-Right> "set VisorGL::v(camaraRotH) [expr $VisorGL::v(camaraRotH) + 1.0] ; puts derecha ; .fr.toglWin postredisplay"

bind .fr.toglWin <ButtonPress-1> "VisorGL::manejadorLBPE v %x %y"
bind .fr.toglWin <ButtonRelease-1> "VisorGL::manejadorLBRE v %x %y"
bind .fr.toglWin <ButtonPress-3> "VisorGL::manejadorRBPE v %x %y"
bind .fr.toglWin <ButtonRelease-3> "VisorGL::manejadorRBRE v %x %y"
bind .fr.toglWin <B1-Motion> "VisorGL::manejadorMME v %x %y"
bind .fr.toglWin <B3-Motion> "VisorGL::manejadorMME v %x %y"
bind . <MouseWheel>  "VisorGL::manejadorScroll v %D"
bind .fr.toglWin <2> "VisorGL::camaraReset v ; .fr.toglWin postredisplay"
#bind . <Key-space> "VisorGL::stopIdle v"
#bind . <Key-i> "VisorGL::startIdle v"
bind . <KeyPress> "VisorGL::manejadorKPE v %K"
bind . <KeyRelease> "VisorGL::manejadorKRE v %K"
bind .fr.toglWin <Double-Button-1> "VisorGL::manejadorDCE v"
#
#update

. configure  -height 500 -width 780 -borderwidth 2
wm geometry . +40+40



#VisorGL::actualizarCamara v

#VisorGL::cambiaRepresentacionVisor v C
VisorGL::camaraReset v
#VisorGL::startIdle v
#VisorGL::insertarDistancia v "0 6" "0 11"
VisorGL::insertarAngulo v "0 4" "0 10" "0 9"
#VisorGL::insertarTorsion v "0 8" "0 2" "0 1" "0 7" 

#VisorGL::rotarMolsEje2 v [list molec0] "1.0 1.0 1.0" "3.0 2.0 0.0" -3
#VisorGL::rotarMolsEje v [list molec0] "1.0 1.0 1.0" "3.0 2.0 0.0" 3
#VisorGL::rotarMolsEje3 v [list molec0] "1.0 1.0 1.0" "3.0 2.0 0.0" -3

#for {set x 0} {$x < 100} {incr x} {
#	VisorGL::rotarMolsEje v [list molec0] "1.0 1.0 1.0" "3.0 2.0 0.0" 3
#	.fr.toglWin postredisplay
	
#}
#VisorGL::orbtemp v
#update

#wm deiconify .
focus -force .


update

