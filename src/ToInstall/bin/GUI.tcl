#######################################################################################################
#	
#	AUTOR : OSCAR NOEL AMAYA GARCIA - 2006/07
#
#							- MODULO PARA EL MANEJO DE LA GUI -
#									 --------------------
# Manejo de la GUI.
# 
#
#	Definido dentro del
#			namespace eval GUI
#
#	base(): array que representara la instancia de la GUI
#	
#	Objetos Fijos de la GUI
#		base(conf)				--> instancia de Conf
#		base(visor)				--> instancia de Visor
#
#		base(mainframe)			--> nombre de la ventana principal del sistema

#		base(progressBar)		--> ProgressBar
#		base(varProgressBar)	--> variable asociada a la ProgressBar
#		base(labelFichActual)	--> etiqueta q contiene el nobre del fichero actual
#		base(butonCancelProc)


#		base(resultadoTink)		--> variable q almacenara el resultado q de Tinker una vez llamado
#		base(cancelarProceso)	--> variable q indicara : 0 No cancelado el Proceso Tink, 1 cancelado Proceso Tinker
#
#		base(semillaLogs)		--> nuemero de logs q han sido cargados en el sistema
#		base(semillaFichCargados) --> numero de ficheros q has sido cargados en el sistema
#										a partir de el se generaran los nombres para los Data
#		base(fichCargados)		--> lista con los baseData de las moleculas q se encuentran cargados en el sistema
#
#		base(resolucion)		--> lista 		
#		base(modoInteraccion) 	--> modo de interaction, rotar, desplazar, mover

#		#para el mapa de reaccion
#		base(ficheroMR1) 			--> nombre del fichero base del mapa de reaccion
#		base(ficheroMR2)			--> nombre del fichero a renumerar
#		base(baseDataMR1)			--> baseData del fichero1
#		base(baseDataMR1)			-->	baseData del fichero2
#		base(listaF1)			--> lista de atomos del fichero 1
#		base(listaF2)			--> lista de atomos del fichero 2
#		base(listaFinal)		--> lista de asociaciones
#
#		

#		base(resultadoMopac)




#	protegidas : 
#		base(menuMedir)
#		base(medirMenu)
#		base(menuScan)
#		base(scanMenu)
#		base(menuMopac)
#		base(mopacMenu)
#
#	Define :
#		proc newGUI { base baseData baseVisor }		
#		proc salta { menu val }
#
#
#
#
############################################################################################################

#package require BWidget
#package require twapi
package require math::constants
#package require http

namespace eval GUI {
	namespace import -force ::msgcat::mc
	#para generar una GUI le doy datos y un visor
	proc newGUI { base baseVisor baseConf } {
		
		
		#le asocio una base para datos y un visor
		variable $base
		upvar #0 GUI::$base gui
		
		
		set gui(visor) $baseVisor
		set gui(conf) $baseConf
		upvar #0 Conf::$gui(conf) config
		upvar #0 VisorGL::$gui(visor) visor
		
		set gui(hud) 1
		
		set gui(consola) 0
		
		set gui(semaforoProceso) 0
		set gui(labelSemaforo) [mc "Ready"]
		
		set gui(cancelarProceso) 0
		set gui(varProgressBar) -1
		set gui(resultadoTink) "ERROR"
		#inicializo variables por defecto
		set gui(semillaLogs) 0
		set gui(semillaFichCargados) 0
		set gui(fichCargados) [list]
		
		set ${base}(proyeccion) 0
		set ${base}(resolucion) "M"
		set ${base}(modoInteraccion) "rotar"
		set ${base}(labels) 0
		
		set ${base}(ejes) 1
		
		#para la configuracion
		set gui(mainConfig) ".config"
		set gui(colores) [list]
		set gui(elementos) [list]
		set gui(listBoxColors) ""
		set gui(labelColor) ""
		set gui(dirData) ""
		
		set gui(colorEtq) ""
		set gui(labelColorEtq) ""
		
		set gui(colorFondo) ""
		set gui(labelColorFondo) ""
		
		set gui(etqId) 0
		set gui(etqCodB) 0 
		set gui(etqCarga) 0
		set gui(etqCodTink) 0
		set gui(etqQuira) 0
		
		
		
		#la escala del cpk
		set gui(escalaCPK) $config(escalaCPK)
		set gui(scaleWCPK) ""
		
		
		#para las propiedades 
		set gui(mainProp) ".prop"
		
		#para los puentes de hidrogeno
		set gui(mainPH) ".ph"
		set gui(phO) N
		set gui(phN) N
		set gui(phS) N
		set gui(phF) N
		set gui(phDist) 3
		
		#para la edicion de tinker
		set gui(mainfEdTink) ".edtink"
		
		
		#para la superficie
		set gui(repreSuperficie) "Surface"
		
		#para el mapa de reaccion
		set gui(mainfMR) ".mreaccion"
		set gui(ficheroMR1) ""
		set gui(ficheroMR2) ""	
		set gui(baseDataMR1) ""
		set gui(baseDataMR2) ""
		set gui(listBoxMR1) ""
		set gui(listaBoxMR2) ""
		set gui(listBoxMRF) ""	
		
		set gui(listaAsignadosMR1) [list]
		set gui(listaAsignadosMR2) [list]
		
		
		set gui(resultadoMopac) "ERROR"
		
		
		#para el acerca de
		set gui(mainAcercaDe) ".acercaDe"
		
		#creaComandosMenu $base $baseVisor $baseConf
		
		#configuracion incial de la ventana
		. configure  -height 550 -width 780 -borderwidth 2
		wm title . "BrandyMol"
		wm geometry . +0+40
		wm iconbitmap . -default brandy.ico
		. configure -menu 
		
		#defino un menu

		set menu [menu .menuPpal -tearoff 0]
		$menu add cascade -label [mc File] -menu $menu.archivo
			set menarch [menu $menu.archivo -tearoff 0]
			$menarch add command -label [mc "Open Mol File"] -command "GUI::abrirFicheroMol $base"
			$menarch add command -label [mc "Save"] -command "GUI::guardar $base"
			$menarch add command -label [mc "Save As"] -command "GUI::guardarComo $base 0"
			$menarch add separator
			$menarch add command -label [mc "Import"] -command "GUI::importarFicheroMol $base"
			$menarch add separator
			$menarch add check -label [mc "Show/Hide Console"] -command "GUI::ocultarMostrarConsola $base" -variable GUI::${base}(consola)
			$menarch add command -label [mc "Options"] -command "GUI::ventanaConfiguracion $base"
			$menarch add separator
			$menarch add command -label [mc "Exit"] -command "GUI::delGUI $base"
		
		$menu add cascade -label [mc "Edit"] -menu $menu.edicion
			set menedit [menu $menu.edicion -tearoff 0]
			#$menedit add command -label [mc "Refresh"] -command "VisorVTK::render $gui(visor)"
			$menedit add command -label [mc "Refresh"] -command "VisorGL::render $gui(visor)"
			$menedit add separator
			$menedit add command -label [mc "Copy"] -command "GUI::copiar $base" 
			$menedit add command -label [mc "Cut"] -command "GUI::cortar $base"
			$menedit add command -label [mc "Paste"] -command "GUI::pegar $base" -accelerator Ctrl-F2
			$menedit add separator
			#$menedit add command -label [mc "Select All"] -command "VisorVTK::seleccionarTodo $gui(visor) $gui(conf)"
			$menedit add command -label [mc "Select All"] -command "VisorGL::seleccionarTodo $gui(visor); VisorGL::render $gui(visor)"
			#$menedit add command -label [mc "Unselect All"] -command "VisorVTK::deseleccionarTodo $gui(visor) $gui(conf)"
			$menedit add command -label [mc "Unselect All"] -command "VisorGL::deseleccionarTodo $gui(visor); VisorGL::render $gui(visor)"
			$menedit add separator
			$menedit add command -label [mc "Move"]  -command "GUI::manejadorMenuIzq $base mover"
			$menedit add command -label [mc "Rotate"]  -command "GUI::manejadorMenuIzq $base rotar"
			$menedit add command -label [mc "Translate"]  -command "GUI::manejadorMenuIzq $base desplazar"
			$menedit add command -label [mc "Zoom"]  -command "GUI::manejadorMenuIzq $base ampliar"
		
		$menu add cascade -label [mc "Tinker"] -menu $menu.tinker
			set mentink [menu $menu.tinker -tearoff 0]
			$mentink add command -label [mc "Modelling with Tinker"] -command "GUI::modelizarTinker $base $baseConf 0" 
			$mentink add cascade -label [mc "Conformational Search"] -menu $mentink.busqconform 
				set menubc [menu $mentink.busqconform -tearoff 0]
				$menubc add command -label [mc "Conformational Search (Newton)"] -command "GUI::modelizarTinker $base $baseConf 1" -command "GUI::modelizarTinker $base $baseConf 1" 
				$menubc add command -label [mc "Conformational Search (Optimizar)"] -command "GUI::modelizarTinker $base $baseConf 2" -command "GUI::modelizarTinker $base $baseConf 2" 
			$mentink add command -label  [mc "Transition State/Reaction Path"] -command "GUI::modelizarTinker $base $baseConf 5" 
			$mentink add separator
			$mentink add command -label [mc "Calculate Vibrations"] -command "GUI::modelizarTinker $base $baseConf 3" 
			$mentink add command -label [mc "View Vibrations"] -command "GUI::modelizarTinker $base $baseConf 4" 
			$mentink add separator
			$mentink add command -label [mc "Edit LOG"] -command "GUI::abrirFichLog $base"
			$mentink add command -label [mc "Edit KEY"] -command "GUI::editarTinker $base"
			
		$menu add cascade -label [mc "Mopac"] -menu $menu.mopac
			set menmop [menu $menu.mopac -tearoff 0]
			$menmop add command -label [mc "Modelling with MOPAC"] -command "GUI::modelizarMopac $base $baseConf 0"
			$menmop add separator
			$menmop add command -label [mc "Show Orbitals"] -command "GUI::modelizarMopac $base $baseConf 3"
			$menmop add command -label [mc "Show Charge"] -command "GUI::modelizarMopac $base $baseConf 1"
			$menmop add command -label [mc "View Vibrations"]  -command "GUI::modelizarMopac $base $baseConf 2"
			$menmop add separator
			$menmop add command -label [mc "Edit MNO"] -command "GUI::abrirFichMNO $base"
			
		$menu add cascade -label [mc "View"] -menu $menu.ver
			set menver [menu $menu.ver -tearoff 0]
			$menver add cascade -label [mc "Display as"] -menu $menver.est
				set menest [menu $menver.est -tearoff 0]
				$menest add command -label [mc "Wireframe"] -command "GUI::manejadorMenuIzq $base lineas"
				$menest add command -label [mc "Sticks"] -command "GUI::manejadorMenuIzq $base cilindros"
				$menest add command -label [mc "Ball & Sticks"] -command "GUI::manejadorMenuIzq $base cilYbolas"
				$menest add command -label [mc "CPK"] -command "GUI::manejadorMenuIzq $base cpk"
			$menver add separator
			$menver add command -label [mc "Hydrogens Bonds"] -command "GUI::ventanaPuentesHidrogeno $base"
			#$menver add cascade -label "Superficie" -menu $menver.super
			#	set mensup [menu $menver.super -tearoff 0]
				#$mensup add command -label "Crear" -command "GUI::crearSuperficie $base"
				#$mensup add cascade -label "Estilo" -menu $mensup.estilo
				#	set menest [menu $mensup.estilo -tearoff 0]
				#	$menest add command -label "Suave"
				#	$menest add command -label "VdW"
				#	$menest add command -label "Transparente"
				#	$menest add radio -label "Sólido" -variable "GUI::${base}(repreSuperficie)" -value "Surface" -command "GUI::cambiarRepresentacionSuperficie $base"
				#	$menest add radio -label "Alambres" -variable "GUI::${base}(repreSuperficie)" -value "Wireframe" -command "GUI::cambiarRepresentacionSuperficie $base"
				#	$menest add radio -label "Puntos" -variable "GUI::${base}(repreSuperficie)" -value "Points" -command "GUI::cambiarRepresentacionSuperficie $base"
				#$mensup add separator
				#$mensup add command -label "Quitar" -command "VisorVTK::eliminarSuperficiesVisorVTK $gui(visor)"
			$menver add separator	
			$menver add command -label [mc "Fit to Screen"] -command "GUI::manejadorMenuIzq $base centrar"
		
		$menu add cascade -label [mc "Tools"] -menu $menu.herramientas
			set menherr [menu $menu.herramientas -tearoff 0]
			$menherr add cascade -label [mc "Hydrogens"] -menu $menherr.hidrogenos
				set menhid [menu $menherr.hidrogenos -tearoff 0]
				$menhid add command -label [mc "Add"] -command "GUI::anadirHidrogenos $base"
				$menhid add command -label [mc "Remove"] -command "GUI::quitarHidrogenos $base"
			$menherr add separator
			$menherr add cascade -label [mc "Measurements"] -menu $menherr.medicion
				set menmed [menu $menherr.medicion -tearoff 0]
				$menmed add command -label [mc "Length"] -command "GUI::manejadorMedidas $base 0"
				$menmed add command -label [mc "Angle"] -command "GUI::manejadorMedidas $base 0"
				$menmed add command -label [mc "Torsion"] -command "GUI::manejadorMedidas $base 0"
				$menmed add separator
				$menmed add command -label [mc "Remove"] -command "GUI::manejadorMedidas $base 1"
			$menherr add cascade -label [mc "Labels"] -menu $menherr.etiquetas
				set menetq [menu $menherr.etiquetas -tearoff 0]
				$menetq add check -label [mc "ID"] -variable "GUI::${base}(etqId)" -command "GUI::manejadorEtiquetas $base ID"
				$menetq add check -label [mc "BrandyMol Code"] -variable "GUI::${base}(etqCodB)" -command "GUI::manejadorEtiquetas $base CODB"
				$menetq add check -label [mc "Charge"] -variable "GUI::${base}(etqCarga)" -command "GUI::manejadorEtiquetas $base CARGA"
				$menetq add check -label [mc "Tinker Code"] -variable "GUI::${base}(etqCodTink)" -command "GUI::manejadorEtiquetas $base CODTINK"
				$menetq add check -label [mc "Inchi Chirality"] -variable "GUI::${base}(etqQuira)" -command "GUI::manejadorEtiquetas $base QUIRA"
				
			$menherr add separator
			$menherr add command -label [mc "Specular Image"] -command "GUI::imagenEspecular $base"
			$menherr add separator
			$menherr add command -label [mc "Superpose Molecules"] -command "GUI::modelizarTinker $base $baseConf 6"
			$menherr add separator
			$menherr add command -label [mc "Reaction Map"] -command "GUI::ventanaMapaReaccion $base"
		
		$menu add cascade -label [mc "Help"] -menu $menu.ayuda
		
		set menayu [menu $menu.ayuda -tearoff 0]
		$menayu add command -label [mc "Help Contents"] -command "GUI::manejadorAyuda $base Acerca_de"
		$menayu add command -label [mc "About"] -command "GUI::acercaDe $base"
		
		#fin menu
		
		. config -menu $menu
		
		#defino la ventana principal y le asocio un menu
		#mirar q es -textvariable
		set mainframe [MainFrame .main]
		#set mainframe .
		
		set ${base}(mainframe) $mainframe
		
		#creo una toolbar
		#CREACION DE LA TOOL BAR
		set tb1 [$mainframe addtoolbar]
		#set tb1 $mainframe
		set frame [frame $tb1.frame]
		set frameb [frame $frame.prg]
		
		#creo una ProgressBar en frameb
		set prog [ProgressBar $frameb.prg -type infinite -width 140 -height 15 -variable GUI::g(varProgressBar)]
		
		#set Tinker::${base}(varProgressBar) -1
		pack $prog -side left -anchor w -fill x		
		
		
		
		#creacion de la primera caja de botones
		set boxcaja1 [ButtonBox $frameb.bbox1 -spacing 0 -padx 1 -pady 1]
		set ${base}(butonCancelProc) [$boxcaja1 add -image $Icon::cancelicon -activebackground #a0a0a0 -takefocus 0 -relief link -borderwidth 1 \
			-padx 1 -pady 1 -helptext [mc "Cancel"] -command "set GUI::${base}(cancelarProceso) 1" -state disable]
		pack $boxcaja1 -side left -anchor w
		
		#añado separador vertical
		set sep [Separator $frameb.sep -orient vertical]
		pack $sep -side left -fill y -padx 8 -anchor w

		set boxcaja1 [ButtonBox $frameb.bbox10 -spacing 0 -padx 1 -pady 1]
			$boxcaja1 add -image $Icon::especicon -activebackground #a0a0a0 -takefocus 0 -relief link -borderwidth 1 \
				-padx 1 -pady 1 -helptext [mc "Specular Image"] -command "GUI::imagenEspecular $base"
			$boxcaja1 add -image $Icon::supericon -activebackground #a0a0a0 -takefocus 0 -relief link -borderwidth 1 \
				-padx 1 -pady 1 -helptext [mc "Superpose Molecules"] -command "GUI::modelizarTinker $base $baseConf 6"
			$boxcaja1 add -image $Icon::couplicon -activebackground #a0a0a0 -takefocus 0 -relief link -borderwidth 1 \
				-padx 1 -pady 1 -helptext [mc "Coupling Constant Calculation"] -command "GUI::ventanaCteAcoplamiento $base"
			$boxcaja1 add -image $Icon::trashicon -activebackground #a0a0a0 -takefocus 0 -relief link -borderwidth 1 \
				-padx 1 -pady 1 -helptext [mc "Delete All"] -command "GUI::eliminaMoleculas $base"

		#empaqueto
		pack $boxcaja1 -side left -anchor w
		pack $frameb -side top -anchor w
		
		#pongo un separador
		set sep [Separator $frame.sep -orient horizontal]
		pack $sep -side top -fill x -pady 1 -anchor w
		
		
		set framec [frame $frame.framec]
		#introduzco botones de herramientas
		set boxcaja1 [ButtonBox $framec.bbox2 -spacing 0 -padx 1 -pady 1]

		# LOS SIGUIENTES BOOTONES SON ADDHIDRO, QUITAHIDRO, Y LOS BOTONES DE FICHEROS 
		$boxcaja1 add -image $Icon::idrawicon -activebackground #a0a0a0 -takefocus 0 -relief link -borderwidth 1 \
			 -padx 1 -pady 1 -helptext [mc "Open Isis Draw"] -command "GUI::manejadorCajaBot1 $base abreISIS"
		$boxcaja1 add -image $Icon::guardarcomoicon -activebackground #a0a0a0 -takefocus 0 -relief link -borderwidth 1 \
			-padx 1 -pady 1 -helptext [mc "Save the Molecule"] -command "GUI::manejadorCajaBot1 $base guardar"
		$boxcaja1 add -image $Icon::abriricon -activebackground #a0a0a0 -takefocus 0 -relief link -borderwidth 1 \
			-padx 1 -pady 1 -helptext [mc "Open Mol File"] -command "GUI::manejadorCajaBot1 $base abrir"
		$boxcaja1 add -image $Icon::importaricon -activebackground #a0a0a0 -takefocus 0 -relief link -borderwidth 1 \
			-padx 1 -pady 1 -helptext [mc "Import a Molecule"] -command "GUI::manejadorCajaBot1 $base importar"
		$boxcaja1 add -image $Icon::pfe32icon -activebackground #a0a0a0 -takefocus 0 -relief link -borderwidth 1 \
			-padx 1 -pady 1 -helptext [mc "Text Editor"] -command "GUI::manejadorCajaBot1 $base editor"
		$boxcaja1 add -image $Icon::helpicon -activebackground #a0a0a0 -takefocus 0 -relief link -borderwidth 1 \
			-padx 1 -pady 1 -helptext [mc "About"] -command "GUI::manejadorAyuda $base Acerca_de"

		pack $boxcaja1 -side left -anchor w
		set sep [Separator $framec.sepa -orient vertical]
		pack $sep -side left -fill y -padx 8 -anchor w
		
		set boxcaja1 [ButtonBox $framec.bbox11 -spacing 0 -padx 1 -pady 1]
		#
		
		#esto es un menu q se desplegara al pulsar en el boton medirmenur
		set gui(menuMedir) [menu .popupMenumedir -tearoff 0]
			$gui(menuMedir) add command -label [mc "Length"] -command "GUI::manejadorMedidas $base 0"
			$gui(menuMedir) add command -label [mc "Angle"] -command "GUI::manejadorMedidas $base 0"
			$gui(menuMedir) add command -label [mc "Torsion"] -command "GUI::manejadorMedidas $base 0"
			$gui(menuMedir) add separator
			$gui(menuMedir) add command -label [mc "Remove"] -command "GUI::manejadorMedidas $base 1"
		
		
		
		set gui(medirMenu) [$boxcaja1 add -image $Icon::rulericon -activebackground #a0a0a0 -takefocus 0 -relief link -borderwidth 1 \
			-padx 1 -pady 1 -helptext [mc "MeasurementMode"] ]
		
		set x GUI::${base}(menuMedir)
		set y GUI::${base}(medirMenu)
		bind $gui(medirMenu) <ButtonRelease-1> "GUI::salta $x $y"
		
		
		$boxcaja1 add -image $Icon::renumicon -activebackground #a0a0a0 -takefocus 0 -relief link -borderwidth 1 \
			-padx 1 -pady 1 -helptext [mc "Reaction Map"] -command "GUI::ventanaMapaReaccion $base"
		$boxcaja1 add -image $Icon::hidroicon -activebackground #a0a0a0 -takefocus 0 -relief link -borderwidth 1 \
			-padx 1 -pady 1 -helptext [mc "Add Hydrogens"] -command "GUI::anadirHidrogenos $base"
		$boxcaja1 add -image $Icon::nohidroicon -activebackground #a0a0a0 -takefocus 0 -relief link -borderwidth 1 \
			-padx 1 -pady 1 -helptext [mc "Remove Hydrogens" ] -command "GUI::quitarHidrogenos $base"
		#empaqueto
		pack $boxcaja1 -side left -anchor w

		pack $framec -side left -anchor w
		pack $frame -side left -anchor w
		
		#hasta aki la parte izquierda botones
		
		set sep [Separator $tb1.sep2 -orient vertical]
		pack $sep -side left -fill y -padx 8 -anchor w
		
		#creo un notebook, (como un tabStrip), para los modelos de Tinker y Mopac
		set notebook [NoteBook $tb1.nb]
		$notebook insert 0 tinker -text [mc "Tinker"]
		$notebook insert 1 mopac -text [mc "Mopac"]
	
		#Arecupero el 1º frame del notebook
		set tinker [$notebook getframe tinker]
		#inserto una caja de botones dentro
		set boxcaja1 [ButtonBox $tinker.bbox1 -spacing 0 -padx 1 -pady 1]
		#inserto botones
		$boxcaja1 add -image $Icon::metanoicon -activebackground #a0a0a0 -takefocus 0 -relief link -borderwidth 1 \
			-padx 1 -pady 1 -helptext [mc "Tinker Modelling"] -command "GUI::modelizarTinker $base $baseConf 0" 
			
		set gui(menuScan) [menu .popupMenuscan -tearoff 0]
			$gui(menuScan) add command -label [mc "Conformational Search (Newton)"] -command "GUI::modelizarTinker $base $baseConf 1"
			$gui(menuScan) add command -label [mc "Conformational Search (Optimize)"] -command "GUI::modelizarTinker $base $baseConf 2"
			
		set gui(scanMenu) [$boxcaja1 add -image $Icon::scanicon -activebackground #a0a0a0 -takefocus 0 -relief link -borderwidth 1 \
			-padx 1 -pady 1 -helptext [mc "Conformational Search"] ]
		set x GUI::${base}(menuScan)
		set y GUI::${base}(scanMenu)
		bind $gui(scanMenu) <ButtonRelease-1> "GUI::salta $x $y"
		
		$boxcaja1 add -image $Icon::tsicon -activebackground #a0a0a0 -takefocus 0 -relief link -borderwidth 1 \
			-padx 1 -pady 1 -helptext [mc "Transition State/Reaction Path"] -command "GUI::modelizarTinker $base $baseConf 5"
		$boxcaja1 add -image $Icon::iricon -activebackground #a0a0a0 -takefocus 0 -relief link -borderwidth 1 \
			-padx 1 -pady 1 -helptext [mc  "Calculate Molecular Vibrations"] -command "GUI::modelizarTinker $base $baseConf 3"
		$boxcaja1 add -image $Icon::chimeicon -activebackground #a0a0a0 -takefocus 0 -relief link -borderwidth 1 \
			-padx 1 -pady 1 -helptext [mc "View Vibrations"] -command "GUI::modelizarTinker $base $baseConf 4"
		$boxcaja1 add -image $Icon::logicon -activebackground #a0a0a0 -takefocus 0 -relief link -borderwidth 1 \
			-padx 1 -pady 1 -helptext [mc "Edit LOG"] -command "GUI::abrirFichLog $base"
		$boxcaja1 add -image $Icon::llaveicon -activebackground #a0a0a0 -takefocus 0 -relief link -borderwidth 1 \
			-padx 1 -pady 1 -helptext [mc "Edit KEY"] -command "GUI::editarTinker $base"
			
		#empaqueto
		pack $boxcaja1 -side left -anchor s
		
		
		#Recupero el segundo frame de la notebook
		set mopacnob [$notebook getframe mopac]
		#inserto una caja de botones dentro
		set boxcaja1 [ButtonBox $mopacnob.bbox1 -spacing 0 -padx 0 -pady 0]
		
		#set gui(menuMopac) [menu .popupMenumopac -tearoff 0]
		#	$gui(menuMopac) add command -label "Cálculo MOPAC Cartesianas" -command "set coorint 1\nventanamopac"
		#	$gui(menuMopac) add command -label "Cálculo MOPAC Internas" -command "set coorint 0\nventanamopac"
		#	$gui(menuMopac) add command -label "MOPAC Rápido" -command "mopacquick"
	
		
		set gui(mopacMenu) [$boxcaja1 add -image $Icon::mopacicon -activebackground #a0a0a0 -takefocus 0 -relief link -borderwidth 1 \
			-padx 1 -pady 1 -helptext [mc "Modelling with MOPAC"] -command "GUI::modelizarMopac $base $baseConf 0"]
		
		#set x GUI::${base}(menuMopac)
		#set y GUI::${base}(mopacMenu)
		
		
		$boxcaja1 add -image $Icon::orbicon -activebackground #a0a0a0 -takefocus 0 -relief link -borderwidth 1 \
			-padx 1 -pady 1 -helptext [mc "Show Molecular Orbitals"] -command "GUI::modelizarMopac $base $baseConf 3"
		$boxcaja1 add -image $Icon::cargaicon -activebackground #a0a0a0 -takefocus 0 -relief link -borderwidth 1 \
			-padx 1 -pady 1 -helptext [mc "Show Charge"] -command "GUI::modelizarMopac $base $baseConf 1"
		$boxcaja1 add -image $Icon::chimeicon -activebackground #a0a0a0 -takefocus 0 -relief link -borderwidth 1 \
			-padx 1 -pady 1 -helptext [mc "View Vibrations"] -command "GUI::modelizarMopac $base $baseConf 2"
		$boxcaja1 add -image $Icon::mnoicon -activebackground #a0a0a0 -takefocus 0 -relief link -borderwidth 1 \
			-padx 1 -pady 1 -helptext [mc "Edit MNO" ] -command "GUI::abrirFichMNO $base"
		#empaqueto
		pack $boxcaja1 -side left -anchor w
		
		pack $notebook -side left -anchor w -fill x -expand yes
		#fuerzo a que la que este activa sea la tinker
		$notebook raise tinker
		
	
		
		#creo una frame en el centro
		set framecent [$mainframe getframe]
		
		#la divido en 2 frames, una para el visor, y otra para pa botones
		set frameleft [frame $framecent.left -borderwidth 3 -bd 2 -relief groove]
		set sep [Separator $framecent.sep2 -orient vertical]
		set frameright [frame $framecent.right -borderwidth 3 -bd 2 -relief groove]
			
		set boxcaja1 [ButtonBox $frameleft.bbox1 -spacing 0 -padx 1 -pady 1 -orient vertical]  
		
		$boxcaja1 add -image $Icon::pegaricon -activebackground #a0a0a0 -takefocus 0 -relief link -borderwidth 1 \
			-padx 1 -pady 1 -helptext [mc "Paste"] -command "GUI::manejadorMenuIzq $base pegar"
		$boxcaja1 add -image $Icon::copiaricon -activebackground #a0a0a0 -takefocus 0 -relief link -borderwidth 1 \
			-padx 1 -pady 1 -helptext [mc "Copy"] -command "GUI::manejadorMenuIzq $base copiar"
		$boxcaja1 add -image $Icon::cortaricon -activebackground #a0a0a0 -takefocus 0 -relief link -borderwidth 1 \
			-padx 1 -pady 1 -helptext [mc "Cut"] -command "GUI::manejadorMenuIzq $base cortar"
		set gui(botonMover) [$boxcaja1 add -image $Icon::selecticon -activebackground #a0a0a0 -takefocus 0 -relief link -borderwidth 1 \
			-padx 1 -pady 1 -helptext [mc "Move"] -command "GUI::manejadorMenuIzq $base mover"]
		set gui(botonRotar) [$boxcaja1 add -image $Icon::rotaricon -activebackground #a0a0a0 -takefocus 0 -relief sunken -borderwidth 1 \
			-padx 1 -pady 1 -helptext [mc "Rotate"] -command "GUI::manejadorMenuIzq $base rotar"]
		set gui(botonDesplazar) [$boxcaja1 add -image $Icon::translateicon -activebackground #a0a0a0 -takefocus 0 -relief link -borderwidth 1 \
			-padx 1 -pady 1 -helptext [mc "Translate"] -command "GUI::manejadorMenuIzq $base desplazar"]
		$boxcaja1 add -image $Icon::fittoviewicon -activebackground #a0a0a0 -takefocus 0 -relief link -borderwidth 1 \
			-padx 1 -pady 1 -helptext [mc "Fit to Screen"] -command "GUI::manejadorMenuIzq $base centrar"
		set gui(botonAmpliar) [$boxcaja1 add -image $Icon::zoomicon -activebackground #a0a0a0 -takefocus 0 -relief link -borderwidth 1 \
			-padx 1 -pady 1 -helptext [mc "Zoom"] -command "GUI::manejadorMenuIzq $base ampliar"]
		$boxcaja1 add -image $Icon::lineicon -activebackground #a0a0a0 -takefocus 0 -relief link -borderwidth 1 \
			-padx 1 -pady 1 -helptext [mc "Display as Lines"] -command "GUI::manejadorMenuIzq $base lineas"
		$boxcaja1 add -image $Icon::stickicon -activebackground #a0a0a0 -takefocus 0 -relief link -borderwidth 1 \
			-padx 1 -pady 1 -helptext [mc "Display as Sticks"] -command "GUI::manejadorMenuIzq $base cilindros"
		$boxcaja1 add -image $Icon::bysicon  -activebackground #a0a0a0 -takefocus 0 -relief link -borderwidth 1 \
			-padx 1 -pady 1 -helptext [mc "Display as Ball & Sticks"] -command "GUI::manejadorMenuIzq $base cilYbolas"
		$boxcaja1 add -image $Icon::cpkicon  -activebackground #a0a0a0 -takefocus 0 -relief link -borderwidth 1 \
			-padx 1 -pady 1 -helptext [mc "Display as CPK"] -command "GUI::manejadorMenuIzq $base cpk"
		set gui(botonLabels) [$boxcaja1 add -image $Icon::idicon  -activebackground #a0a0a0 -takefocus 0 -relief link -borderwidth 1 \
			-padx 1 -pady 1 -helptext [mc "Show/Hide Labels"]]
		$gui(botonLabels) configure -command "GUI::menuEtiquetas $base $gui(botonLabels)"
		set gui(botonEjes) [$boxcaja1 add -image $Icon::ejesicon -activebackground #a0a0a0 -takefocus 0 -relief sunken -borderwidth 1 \
			-padx 1 -pady 1 -helptext [mc "Show/Hide Axis"] -command "GUI::manejadorMenuIzq $base ejes"]
		
			
		#enmpaqueto
		pack $boxcaja1 -side top -anchor w -padx 3
		pack $frameleft -side left -anchor w -fill y -expand no
		
		#ahora el frame de la derecha que esta asociado a un VisorVTK
	
		#creo un widget que contendra un renderer y se lo asocio al Widget de Tk
#		set vtkw [VisorVTK::devuelveRenderWindow $baseVisor]
#		set vtkWidg [vtkTkRenderWidget $frameright.visor -rw $vtkw]
#		puts $vtkWidg
		
		#le asocio los eventos
#		::vtk::bind_tk_render_widget $vtkWidg
		
		#actualizo la info del visor, para q sepa cual es su interactor y su picker
#		VisorVTK::actualizaInteractor $baseVisor $baseConf
		
		#color de fondo
#		VisorVTK::cambiarColorFondo $baseVisor $config(colorFondo)
#		VisorVTK::cambiarEscalaCPK $baseVisor $gui(escalaCPK)

#		pack $vtkWidg -in $frameright -expand  yes -fill both -side top
		
		wm deiconify .
		togl $frameright.visor -createproc "VisorGL::inicializarVisorGL $baseVisor"
		pack $frameright.visor -expand 1 -fill both
		
		
		pack $frameright -side bottom -anchor n -fill both -expand yes
		pack $framecent -side top -anchor n -fill both -expand yes
		set gui(etqSemaforo) [$mainframe addindicator -justify left -textvariable GUI::${base}(labelSemaforo) -fg blue -font {Arial 10 {bold roman}}]
		#set gui(labelFichActual) [$mainframe addindicator -justify left -textvariable VisorVTK::$gui(visor)(ficheroSeleccionado)]
		set gui(labelFichActual) [$mainframe addindicator -justify left -textvariable VisorGL::$gui(visor)(ficheroSeleccionado)]
		$mainframe addindicator -text [mc "BrandyMolVer"]
		pack $framecent -side top -anchor n -fill both -expand yes
		
		#empaqueto la ventana principal
		pack $mainframe -fill both -expand yes
		
		
		#manejadores
		
		#asocio el doble-click al proceso de seleccion de moleculas
#		bind $vtkWidg <Double-Button-1> "VisorVTK::manejadorDCE $gui(visor) $gui(conf)"
#		bind $vtkWidg <Shift-Double-Button-1> "VisorVTK::manejadorDCE $gui(visor) $gui(conf)"
#		bind $vtkWidg <Enter>  "VisorVTK::render $gui(visor)"
#		bind $vtkWidg <Leave>  "VisorVTK::render $gui(visor)"
#		bind $vtkWidg <FocusIn> "VisorVTK::render $gui(visor)"
#		bind $vtkWidg <FocusOut> "VisorVTK::render $gui(visor)"	
		
#		bind $frameleft <Destroy> "GUI::delGUI $base"
#		bind . <KeyPress> "VisorVTK::manejadorKPE $gui(visor) %K"
#		bind . <KeyRelease> "VisorVTK::manejadorKRE $gui(visor) %K"
#		bind . <MouseWheel>  "VisorVTK::manejadorScroll $gui(visor) %D"
#		bind . <KeyPress-Delete> "GUI::eliminaMoleculas $base"
		
		
		bind $frameright.visor <ButtonPress-1> "VisorGL::manejadorLBPE $gui(visor) %x %y"
                bind $frameright.visor <ButtonRelease-1> "VisorGL::manejadorLBRE $gui(visor) %x %y"
		
                bind $frameright.visor <ButtonPress-3> "VisorGL::manejadorRBPE $gui(visor) %x %y"
		bind $frameright.visor <ButtonRelease-3> "GUI::manejadorRBRE $base"
#                bind $frameright.visor <ButtonRelease-3> "VisorGL::manejadorRBRE $gui(visor) %x %y"
                bind $frameright.visor <B1-Motion> "VisorGL::manejadorMME $gui(visor) %x %y"
                bind $frameright.visor <B3-Motion> "VisorGL::manejadorMME $gui(visor) %x %y"
                bind . <MouseWheel>  "VisorGL::manejadorScroll $gui(visor) %D"
                bind $frameright.visor <2> "VisorGL::camaraReset $gui(visor) ; $frameright.visor postredisplay"
                bind . <KeyPress> "VisorGL::manejadorKPE $gui(visor) %K"
                bind . <KeyRelease> "VisorGL::manejadorKRE $gui(visor) %K"
                bind $frameright.visor <Double-Button-1> "VisorGL::manejadorDCE $gui(visor)"
		
		
		
		
		
		
		#maximizo la ventana y la muestro
		#wm state . zoomed
		#set gui(consola) 1
		console $config(estadoConsola)
		focus $frameright.visor
		update
		if {$config(estadoConsola) == "show"} {set gui(consola) 1}
		#focus .
		#update
		VisorGL::startPresentation $gui(visor)
	}; #finproc
	
	
	proc delGUI { base } {
		upvar #0 GUI::$base gui
		
		Tinker::delTinker t
		Mopac::delMopac m
		
		
		
		#VisorVTK::delVisorVTK $gui(visor)
		VisorGL::delVisorVTK $gui(visor)
		
		destroy .
		unset GUI::$base
	}; #finproc
	
	#activa o desactiva el semaforo de procesos, ademas establece como label etq, y asocia color segun el estado del semaforo
	proc activaDesactivaSemaforo { base onOff etq } {
		upvar #0 GUI::$base gui
		
		set gui(labelSemaforo) $etq
		if {$onOff == 0} {
			set gui(semaforoProceso) 0
			$gui(etqSemaforo) configure -fg blue
		} else {
			set gui(semaforoProceso) 1
			$gui(etqSemaforo) configure -fg red
		}
		
		
	}; #finproc
	
	#este proc crea variables q contienen ordenes, y son globales al namespace, por lo q solo puede tenerse abierta una sola instancia
	#de GUI en la misma shell de tcl ya q de haber varias, serian machacadas y no funcionaria el menu superior
	#esto es asi por la creacion del menu ya q usa los caracteres '{' y '}' en su formacion, y no permiten sustituciones en su interior.
	#seria mejor cambiar el formato del menu
	proc creaComandosMenu { base baseVisor baseConf } {
		upvar #0 GUI::$base gui
		
		set ::GUI::comCrearSuperficie "VisorVTK::generarSuperficie $baseVisor"
		set ::GUI::comBorrarSuperficies "VisorVTK::eliminarSuperficiesVisorVTK $baseVisor"
		set ::GUI::comTranspSuperficies "VisorVTK::transparenciaSuperficies $baseVisor"
	}; #finproc
	
	
	proc salta { menu val } {
		upvar #0 $menu men $val va
		set x [winfo rootx $va]
		set y [expr [winfo y $va] + [winfo rooty $va] + [winfo height $va]]
		tk_popup $men $x $y
	}; #finproc

	proc ventanaCteAcoplamiento { base } {
		upvar #0 GUI::$base gui
		
		#set ang [VisorVTK::devuelveTorsion $gui(visor)]
		#if { $ang == -1 || [cteAcoplamientoValida $base] == -1}
		set ang [cteAcoplamientoValida $base]
		if { $ang == -1} {
			tk_messageBox -type ok -title [mc "Atention"] -icon warning -title [mc "DihedralNotSelected"] -message [mc "DihedraMessageNotSelected"] 
		} else {
			set ang 
			set mainf ".cteacopl"
			if {[winfo exists $mainf]} { destroy $mainf }
			
			#creo la ventana
			toplevel $mainf
			wm title $mainf [mc "Coupling Constant"]
			wm resizable $mainf 0 0
			#la ventana constara de 3 frames, superior, central e inferior
			
			#frame superior
			set frameup [frame $mainf.frameup]
			set label [Label $frameup.label -activebackground #a0a0a0 -text [mc "BrandyMolVer"] -font {Arial 18 {bold roman}} -relief flat -anchor center]
			#pack $label -side right
			
			#frame central
			set framecent [frame $mainf.framecent -borderwidth 3 -bd 2 -relief groove]
			set label [Label $framecent.lab -activebackground #a0a0a0 -text "[mc "DihedralAngleText" ] $ang"  -font {Arial 10 {bold roman}} -relief flat -anchor w]
			set label2 [Label $framecent.lab2 -activebackground #a0a0a0 -text "[mc "Coupling Constant Window"] [cteAcoplamiento $ang]" -font {Arial 10 {bold roman}} -relief flat -anchor w]
			
			pack $label -anchor w
			pack $label2 -anchor w

			#frame inferior
			set framedown [frame $mainf.framedown -borderwidth 3 -bd 2 -relief raised]
			set buttonok [Button $framedown.cancel -activebackground #a0a0a0 -command "destroy $mainf" -helptext "Cancelar" -image $Icon::okicon]
			set buttonAyuda [Button $framedown.ayuda -activebackground #a0a0a0 -helptext [mc "Help"] -image $Icon::ayudicon -command "GUI::manejadorAyuda $base Acoplamiento"]
			pack $buttonok $buttonAyuda -side right
			
			#empaketo
			pack $frameup -side top -fill both 
			pack $framedown -side bottom -fill both 
			pack $framecent -side top -fill both -expand true -pady 6 -padx 6
			focus $buttonok
			
			VisorGL::render $gui(visor)
		}	
	}; #finproc
	
	#devuelve 1 o -1 si los atomos seleccionados forman una cte de acoplamiento valida.
	#4 atomos formaran una cte valida, si los 4 pertenecen a la misma molecula y si 2 de ellos son hidrogenos y los otros 2 no
	proc cteAcoplamientoValida { base } {
		upvar #0 GUI::$base gui
		
		#set selecc [VisorVTK::devuelveMolNumAtomoSelecc $gui(visor)]
		set selecc [VisorGL::listaMolAtomosSeleccionadosVisor $gui(visor)]
		
		
		if {[llength $selecc] != 4} {
			return -1
		} else {
			if {[string match [lindex [lindex $selecc 0] 0] [lindex [lindex $selecc 1] 0]] && \
				[string match [lindex [lindex $selecc 0] 0] [lindex [lindex $selecc 1] 0]] && \
				[string match [lindex [lindex $selecc 0] 0] [lindex [lindex $selecc 1] 0]] } {
				
				#todos los atomos pertenecen a la misma molecula
				upvar #0 Data::[lindex [lindex $selecc 0] 0] datos
				set atoms [list $datos(simbolo,[lindex [lindex $selecc 0] 1]) $datos(simbolo,[lindex [lindex $selecc 1] 1]) \
								$datos(simbolo,[lindex [lindex $selecc 2] 1]) $datos(simbolo,[lindex [lindex $selecc 3] 1])]
				if {[llength [lsearch -all $atoms "H"]] == 2} {
					#return 1
					#listaAtomosSeleccionadosMol
					set selecc [VisorGL::listaAtomosSeleccionadosVisor $gui(visor)]
					return [VisorGL::dibujarTorsionMol $gui(visor) [lindex $selecc 0] [lindex $selecc 1] [lindex $selecc 2] [lindex $selecc 3]]
				} else {
					return -1
				}
			} else {
				return -1
			}
		}
	}; #finproc
	
	#calcula la constante de acoplamiento del ang, estango agn en grados
	#valores de A=7.76; B=-1.1; C=1.4 obtenidos de "J.Chem.Ed.(2001),78,81"
	#valores de A=4.22; B=-0.5; C=4.5 obtenidos en "A dictionary of Concepts in RMN" (Solo para hidrocarburos)
	#uso los primeros
	proc cteAcoplamiento { ang } {
		set ang [expr $ang * $math::constants::degtorad]
		set a [expr 7.76 * cos($ang)*cos($ang)]
		set b [expr -1.1 * cos($ang)]
		set e [expr $a + $b + 1.4]
		return [format "%0.1f" $e]
	}; #finproc

	proc ventanaMapaReaccion { base } {
		upvar #0 GUI::$base gui
		
		set mainf $gui(mainfMR)
		if {[winfo exists $mainf]} { destroy $mainf }			
		#creo la ventana
		toplevel $mainf
		wm title $mainf [mc "Reaction Map"]
		#wm resizable $mainf 0 0
		#la ventana constara de 3 frames, superior, central e inferior
		
		#frame superior
		set frameup [frame $mainf.frameup]
		set label [Label $frameup.label -activebackground #a0a0a0 -text [mc "BrandyMolVer"] -font {Arial 18 {bold roman}} -relief flat -anchor center]
		#pack $label -side right
	
		#frame central
		set framecent [frame $mainf.framecent -borderwidth 3 -bd 2 -relief groove]
		
		#2 frames para los ficheros y otra para las listas y botones
		set framecent1 [frame $framecent.f1]
		set framecent2 [frame $framecent.f2]
		set framecent3 [frame $framecent.f3]
		
		#fichero base
		set le1 [ LabelEntry $framecent1.le1 -label [mc "First File"] -textvariable GUI::${base}(ficheroMR1) -side left -labelfont {Arial 10 {bold roman}}]
		set b1 [Button $framecent1.b1 -activebackground #a0a0a0 -command "GUI::manejadorBotonesCargarFicheroMR $base 1" -helptext [mc "Choose the First File"] -image $Icon::diricon -text "Ayuda"]
		pack $le1 -side left -fill x -expand 1
		pack $b1 -side left
		
		#fichero trabajo
		set le2 [ LabelEntry $framecent2.le2 -label [mc "Second File"] -textvariable GUI::${base}(ficheroMR2) -side left -labelfont {Arial 10 {bold roman}}]
		set b2 [Button $framecent2.b2 -activebackground #a0a0a0 -command "GUI::manejadorBotonesCargarFicheroMR $base 2" -helptext [mc "Choose the Second File"] -image $Icon::diricon -text "Ayuda"]
		pack $le2 -side left -fill x -expand 1
		pack $b2 -side left
		
		
		
		#resto elementos
		#4 frames dentro de framecent3
		set framecent3a [frame $framecent3.fa]
		set framecent3b [frame $framecent3.fb]
		set framecent3c [frame $framecent3.fc]
		set framecent3d [frame $framecent3.fd]
			
		#f1
		set l3a [Label $framecent3a.lea -activebackground #a0a0a0 -text [mc "Atom1"] -font {Arial 9 {bold roman}} -relief flat -anchor center]
		set frameflb3a [frame $framecent3a.flb3a]
		set lb3a [listbox $frameflb3a.lb3a -width 8 -exportselection false -yscrollcommand "$frameflb3a.scrollb set"]
		bind $lb3a <ButtonRelease-1> "GUI::seleccionListBoxMR $base 1"
		set gui(listBoxMR1) $lb3a
		set sba [scrollbar $frameflb3a.scrollb -command "$frameflb3a.lb3a yview"]
		pack $lb3a -side left -expand 1 -fill both
		pack $sba -fill y -side left
		
		pack $l3a -fill x
		pack $frameflb3a -fill both -expand 1
		
		
		pack $l3a $lb3a
		
		#f2
		set l3b [Label $framecent3b.leb -activebackground #a0a0a0 -text [mc "Atom2"] -font {Arial 9 {bold roman}} -relief flat -anchor center]
		set frameflb3b [frame $framecent3b.flb3b]
		set lb3b [listbox $frameflb3b.lb3b -width 8 -exportselection false -yscrollcommand "$frameflb3b.scrollb set"]
		bind $lb3b <ButtonRelease-1> "GUI::seleccionListBoxMR $base 2"
		set gui(listBoxMR2) $lb3b
		set sbb [scrollbar $frameflb3b.scrollb -command "$frameflb3b.lb3b yview"]
		pack $lb3b -side left -expand 1 -fill both
		pack $sbb -fill y -side left
		
		pack $l3b -fill x
		pack $frameflb3b -fill both -expand 1
		

		#f3
		set b1 [button $framecent3c.b1 -activebackground #a0a0a0 -command "GUI::botonAnadirMR $base" -text ">>>"]
		set b2 [button $framecent3c.b2 -activebackground #a0a0a0 -command "GUI::botonEliminarMR $base 0" -text "<<<"]
		set b3 [button $framecent3c.b3 -activebackground #a0a0a0 -command "GUI::botonEliminarMR $base 1" -text "<<<|"]
		pack $b1 $b2 $b3 -fill x -pady 3
		
		
		#f4
		set l3d [Label $framecent3d.led -activebackground #a0a0a0 -text [mc "Asociation"] -font {Arial 10 {bold roman}} -relief flat -anchor center]
		set frameflb3d [frame $framecent3d.flb3d]
		set lb3d [listbox $frameflb3d.lb3d -width 8 -yscrollcommand "$frameflb3d.scrollb set" -selectmode extended]
		bind $lb3d <ButtonRelease-1> "GUI::seleccionListBoxMRF $base" 
		set gui(listBoxMRF) $lb3d
		set sbd [scrollbar $frameflb3d.scrollb -command "$frameflb3d.lb3d yview"]
		pack $lb3d -side left -expand 1 -fill both
		pack $sbd -fill y -side left
		
		pack $l3d -fill x
		pack $frameflb3d -fill both -expand 1
		
		
		pack $framecent3a $framecent3b -side left -fill both -expand 1 -padx 5 -pady 5
		pack $framecent3c -side left -padx 5
		pack $framecent3d -side left -fill both -expand 1 -padx 5 -pady 5
		

		#empaketado de la frame central
		pack $framecent1 $framecent2 -padx 10 -pady 5 -fill x
		pack $framecent3 -padx 10 -expand 1 -pady 5 -fill both

		#frame inferior
		set framedown [frame $mainf.framedown -borderwidth 3 -bd 2 -relief raised]
		set buttonSave [Button $framedown.save -activebackground #a0a0a0 -command "GUI::manejadorEjecutarMR $base" -helptext [mc "Save"] -image $Icon::guardaricon]
		set buttonCancel [Button $framedown.cancel -activebackground #a0a0a0 -command "GUI::manejadorCancelarMR $base" -helptext [mc "Cancel"] -image $Icon::cancelicon]
		set buttonAyuda [Button $framedown.ayuda -activebackground #a0a0a0 -helptext [mc "Help"] -image $Icon::ayudicon -command "GUI::manejadorAyuda $base MapaReacc"]
		pack $buttonSave -side right
		pack $buttonCancel $buttonAyuda -side left
	
		#empaketo
		pack $frameup -side top -fill both 
		pack $framedown -side bottom -fill both 
		pack $framecent -side top -fill both -expand true -pady 6 -padx 6
		
		#reseteo valores
		set gui(ficheroMR1) ""
		set gui(ficheroMR2) ""	
		set gui(baseDataMR1) ""
		set gui(baseDataMR2) ""
		
		set gui(listaAsignadosMR1) [list]
		set gui(listaAsignadosMR2) [list]
		
		$gui(listBoxMR1) delete 0 end
		$gui(listBoxMR2) delete 0 end
		$gui(listBoxMRF) delete 0 end
		
		focus $mainf
	}; #finproc
	
	#carga un listBox con los atomos de la molecula baseData
	proc cargarLBMapaReaccionMol { listBox baseData } {
		upvar #0 Data::$baseData datos
		
		#borro lo q pudiera haber
		$listBox delete 0 end
		
		for {set x 0} {$x < $datos(numAtomos)} {incr x} {
			$listBox insert $x "$datos(simbolo,$x) [expr $x + 1]"
		}
	}; #finproc
	
	#carga el fichero para el mapa reaccion, ddistingue entre el fichero 1 o el fichero2f
	proc manejadorBotonesCargarFicheroMR { base f1of2 } {
		upvar #0 GUI::$base gui
		upvar #0 Conf::$gui(conf) config
		
		set types { {{Ficheros Mol} {.mol} } }
		set filename [tk_getOpenFile -filetypes $types -parent $gui(mainfMR) -initialdir $config(dirData) -title [mc "Open Mol File"]]

		if {$filename != ""} { 
			#set config(dirData) [file dirname $filename]
			
			if {$f1of2 == 1} {
				
				set gui(ficheroMR1) $filename
				#debo borrar la pantalla y cargar la molecula
				eliminaMoleculas $base
				set mol [cargarFicheroMol $base $filename]
				set gui(fichCargados) $mol
				set gui(baseDataMR1) $mol
				#set VisorVTK::$gui(visor)(ficheroSeleccionado) $filename
				VisorGL::estableceFicheroSeleccionado $gui(visor)
				
				cargarLBMapaReaccionMol $gui(listBoxMR1) $mol
				
				#reseteo los datos por lo q pudiera haber
				set gui(ficheroMR2) ""
				set gui(baseDataMR2) ""
				set gui(listaAsignadosMR1) [list]
				set gui(listaAsignadosMR2) [list]
				
				$gui(listBoxMR2) delete 0 end
				$gui(listBoxMRF) delete 0 end
				
				
				
			} elseif {$f1of2 == 2} {
				if {$gui(baseDataMR1) != ""} {
					#debo comprobar su formula Molecular, para ello cargo temporalmente e un data el fichero la obtengo y la compruebo
					set formula1 [Data::formulaMolecular $gui(baseDataMR1)]
					
					Data::newData tempMR
					set mol [Fich::leeFichMol $filename tempMR $gui(conf)]
					set formula2 [Data::formulaMolecular tempMR]
					Data::delData tempMR
		
					if {[string match $formula1 $formula2]} {
						
						#si ya existia una molecula definida, debo eliminarla
						if {$gui(baseDataMR2) != ""} {
							#VisorVTK::deseleccionarTodo $gui(visor) $gui(conf)
							#VisorVTK::seleccionarMol $gui(visor) $gui(baseDataMR2) $gui(conf)
							#VisorVTK::delDatosMolVisorVTKSelecc $gui(visor)
							VisorGL::deseleccionarTodo $gui(visor)
							VisorGL::seleccionarMol $gui(visor) $gui(baseDataMR2)
							VisorGL::delVisorMolSelecc$gui(visor)
							set index [lsearch -exact $gui(fichCargados) $gui(baseDataMR2)]
							set gui(fichCargados) [lreplace $gui(fichCargados) $index $index]
						}
						
						#cumple los requisitos para cargar la molecula 2
						set gui(ficheroMR2) $filename
						set mol [cargarFicheroMol $base $filename]
						lappend gui(fichCargados) $mol
						set gui(baseDataMR2) $mol
						#set VisorVTK::$gui(visor)(ficheroSeleccionado) [mc "FileNotDefined"]
						VisorGL::estableceFicheroSeleccionado $gui(visor)
					
						cargarLBMapaReaccionMol $gui(listBoxMR2) $mol
						
						#reseteo valores
						set gui(listaAsignadosMR1) [list]
						set gui(listaAsignadosMR2) [list]
						#selecciono el 1º de la listBox 1 y 2
						
						$gui(listBoxMR1) selection clear 0 end
						$gui(listBoxMR2) selection clear 0 end

						#limpio la listBox final
						$gui(listBoxMRF) delete 0 end
					} else {
						tk_messageBox -type ok -title [mc "Atention"] -icon warning -message " $filename , $gui(ficheroMR1) \n [mc "Molecular Formula For" ]" -parent $gui(mainfMR)
					}
				} else {


					tk_messageBox -type ok -title [mc "Atention"] -icon warning -message [mc "Define First File"] -parent $gui(mainfMR)
				}
			}
		}
		
	}; #finproc
	
	#controla la seleccion de elementos en las listBox1 y 2 de MR
	proc seleccionListBoxMR { base l1ol2 } {
		upvar #0 GUI::$base gui
		
		
		set x $l1ol2
		
		set index [$gui(listBoxMR$x) curselection]
		if {$index != ""} {
			
			$gui(listBoxMRF) selection clear 0 end
			
			set elem [$gui(listBoxMR$x) get $index $index]
			set i [lindex [lindex $elem 0] 1]
			
			#represento la molecula segun el estado del mapa de reaccion
			
			#VisorVTK::deseleccionarMol $gui(visor) $gui(baseDataMR$x) $gui(conf)
			#VisorVTK::seleccionarMol $gui(visor) $gui(baseDataMR$x) $gui(conf)
			#VisorVTK::representaEn $gui(visor) "CilindrosYBolas"
			#VisorVTK::deseleccionarMol $gui(visor) $gui(baseDataMR$x) $gui(conf)
			
			VisorGL::deseleccionaMolecula $gui(visor) $gui(baseDataMR$x)
			VisorGL::seleccionaMolecula $gui(visor) $gui(baseDataMR$x)
			VisorGL::cambiaRepresentacionVisor $gui(visor) CB
			VisorGL::deseleccionaMolecula $gui(visor) $gui(baseDataMR$x)
			
			foreach j $gui(listaAsignadosMR$x) {
				#VisorVTK::seleccionaAtomo $gui(visor) $gui(baseDataMR$x) $gui(conf) "$gui(baseDataMR$x)_actorAtomo_$j"
				VisorGL::seleccionaAtomo $gui(visor) $gui(baseDataMR$x) $j
			}
			#VisorVTK::seleccionaAtomo $gui(visor) $gui(baseDataMR$x) $gui(conf) "$gui(baseDataMR$x)_actorAtomo_[expr $i - 1]"
			#VisorVTK::representaEn $gui(visor) "Lineas"
			VisorGL::seleccionaAtomo $gui(visor) $gui(baseDataMR$x) [expr $i - 1]
			VisorGL::cambiaRepresentacionVisor $gui(visor) L
			
			#VisorVTK::deseleccionarMol $gui(visor) $gui(baseDataMR$x) $gui(conf)
			#VisorVTK::seleccionaAtomo $gui(visor) $gui(baseDataMR$x) $gui(conf) "$gui(baseDataMR$x)_actorAtomo_[expr $i - 1]"
			VisorGL::deseleccionaMolecula $gui(visor) $gui(baseDataMR$x)
			VisorGL::seleccionaAtomo $gui(visor) $gui(baseDataMR$x) [expr $i - 1]
			
			#VisorVTK::render $gui(visor)
			VisorGL::render $gui(visor)
		}
	}; #finproc
	
	proc seleccionListBoxMRF { base } {
		upvar #0 GUI::$base gui
		
		set index3 [$gui(listBoxMRF) curselection]
		if {$index3 != "" && [llength $index3] <= 1} {
		
			#deselecciono los otros listBox
			$gui(listBoxMR1) selection clear 0 end
			$gui(listBoxMR2) selection clear 0 end
			
			set e3 [$gui(listBoxMRF) get $index3 $index3]
			set e3 [lindex $e3 0]
			
			#los indices de cada lista
			set i [expr [lindex $e3 1] - 1]
			set j [expr [lindex $e3 4] - 1]
			
			foreach { x e } "1 $i 2 $j" {
				#VisorVTK::deseleccionarMol $gui(visor) $gui(baseDataMR$x) $gui(conf)
				#VisorVTK::seleccionarMol $gui(visor) $gui(baseDataMR$x) $gui(conf)
				#VisorVTK::representaEn $gui(visor) "CilindrosYBolas"
				#VisorVTK::deseleccionarMol $gui(visor) $gui(baseDataMR$x) $gui(conf)
				VisorGL::deseleccionaMolecula $gui(visor) $gui(baseDataMR$x)
        			VisorGL::seleccionaMolecula $gui(visor) $gui(baseDataMR$x)
        			VisorGL::cambiaRepresentacionVisor $gui(visor) CB
        			VisorGL::deseleccionaMolecula $gui(visor) $gui(baseDataMR$x)
				
				
				foreach k $gui(listaAsignadosMR$x) {
					#VisorVTK::seleccionaAtomo $gui(visor) $gui(baseDataMR$x) $gui(conf) "$gui(baseDataMR$x)_actorAtomo_$k"
					VisorGL::seleccionaAtomo $gui(visor) $gui(baseDataMR$x) $k
				}
				#VisorVTK::representaEn $gui(visor) "Lineas"
				VisorGL::cambiaRepresentacionVisor $gui(visor) L
				
				#VisorVTK::deseleccionarMol $gui(visor) $gui(baseDataMR$x) $gui(conf)
				#VisorVTK::seleccionaAtomo $gui(visor) $gui(baseDataMR$x) $gui(conf) "$gui(baseDataMR$x)_actorAtomo_$e"
				VisorGL::deseleccionaMolecula $gui(visor) $gui(baseDataMR$x)
				VisorGL::seleccionaAtomo $gui(visor) $gui(baseDataMR$x) $e
			}
			#VisorVTK::render $gui(visor)
			VisorGL::render $gui(visor)
		}
		
	}; #finproc
	
	proc botonAnadirMR { base } {
		upvar #0 GUI::$base gui	
		
		set index1 [$gui(listBoxMR1) curselection]
		set index2 [$gui(listBoxMR2) curselection]
		
		if {$index1 != "" && $index2 != ""} {
			
			set e1 [$gui(listBoxMR1) get $index1 $index1]
			set e2 [$gui(listBoxMR2) get $index2 $index2]
			set i [lindex [lindex $e1 0] 1]
			set j [lindex [lindex $e2 0] 1]
		
			lappend gui(listaAsignadosMR1) [expr $i - 1]
			lappend gui(listaAsignadosMR2) [expr $j - 1]
			
			$gui(listBoxMRF) insert end "[lindex $e1 0] >> [lindex $e2 0]"
			$gui(listBoxMRF) selection set end
			
			
			$gui(listBoxMR1) delete $index1 $index1
			$gui(listBoxMR2) delete $index2 $index2
		}
	}; #finproc 
	
	proc botonEliminarMR { base todo } {
		upvar #0 GUI::$base gui	
		
		if {$todo == 0} {
			set index3 [$gui(listBoxMRF) curselection]
		} else {
			$gui(listBoxMRF) selection set 0
			set index3 [$gui(listBoxMRF) curselection]
		}
		while {$index3 != ""} {
			
			set e3 [$gui(listBoxMRF) get $index3 $index3]
			set e3 [lindex $e3 0]
			
			#los indices de cada lista
			set i [lindex $e3 1]
			set j [lindex $e3 4]

			#los elimino de la lista de asignados
			set ind [lsearch -exact $gui(listaAsignadosMR1) [expr $i - 1]]
			set gui(listaAsignadosMR1) [lreplace $gui(listaAsignadosMR1) $ind $ind]
			set ind [lsearch -exact $gui(listaAsignadosMR2) [expr $j - 1]]
			set gui(listaAsignadosMR2) [lreplace $gui(listaAsignadosMR2) $ind $ind]
			
			
			#añado en las listBox1 y 2
			$gui(listBoxMR1) insert end "[lindex $e3 0] [lindex $e3 1]"
			$gui(listBoxMR2) insert end "[lindex $e3 3] [lindex $e3 4]"
			
			#elimino de la listBox3
			$gui(listBoxMRF) delete $index3 $index3	
			
			#actualizo la representacion
			#$gui(listBoxMR1) selection set end
			#$gui(listBoxMR2) selection set end

			if {$todo == 1} { $gui(listBoxMRF) selection set 0 }
			set index3 [$gui(listBoxMRF) curselection]
		}
		#actualizo el visor
		puts "actualizo : $gui(listaAsignadosMR1) , $gui(listaAsignadosMR2)"
		foreach x "1 2" {
			#VisorVTK::deseleccionarMol $gui(visor) $gui(baseDataMR$x) $gui(conf)
			#VisorVTK::seleccionarMol $gui(visor) $gui(baseDataMR$x) $gui(conf)
			#VisorVTK::representaEn $gui(visor) "CilindrosYBolas"
			#VisorVTK::deseleccionarMol $gui(visor) $gui(baseDataMR$x) $gui(conf)
			VisorGL::deseleccionaMolecula $gui(visor) $gui(baseDataMR$x)
			VisorGL::seleccionaMolecula $gui(visor) $gui(baseDataMR$x) 
			VisorGL::cambiaRepresentacionVisor $gui(visor) CB
			VisorGL::deseleccionaMolecula $gui(visor) $gui(baseDataMR$x)
			
			
			foreach k $gui(listaAsignadosMR$x) {
				#VisorVTK::seleccionaAtomo $gui(visor) $gui(baseDataMR$x) $gui(conf) "$gui(baseDataMR$x)_actorAtomo_$k"
				VisorGL::seleccionaAtomo $gui(visor) $gui(baseDataMR$x) $k
			}
			if {[llength $gui(listaAsignadosMR$x)] > 0} {
				#VisorVTK::representaEn $gui(visor) "Lineas"
				VisorGL::cambiaRepresentacionVisor $gui(visor) L
			}
			#VisorVTK::deseleccionarMol $gui(visor) $gui(baseDataMR$x) $gui(conf)
			VisorGL::deseleccionaMolecula $gui(visor) $gui(baseDataMR$x)
		}
		#VisorVTK::render $gui(visor)
		VisorGL::render $gui(visor)
		if {$todo == 1} {
			$gui(listBoxMR1) selection clear 0 end
			$gui(listBoxMR2) selection clear 0 end
		}
	}; #finproc

	proc manejadorEjecutarMR { base } {
		upvar #0 GUI::$base gui
		upvar #0 Conf::$gui(conf) config
		
		if { $gui(baseDataMR1) != "" && $gui(baseDataMR2) != ""} {
			upvar #0 Data::$gui(baseDataMR1) datos
			puts "[llength $gui(listaAsignadosMR1)] , $datos(numAtomos)"
			if {[llength $gui(listaAsignadosMR1)] != $datos(numAtomos)} {
				tk_messageBox -type ok -title [mc "Atention"] -icon warning -message [mc "Asignation Not Completed"]
			} else {
				#creo la lista de conversion
				set conv [list]
				for {set x 0} {$x < $datos(numAtomos)} {incr x} {
					set e3 [$gui(listBoxMRF) get $x $x]
					set e3 [lindex $e3 0]
					
					set i [expr [lindex $e3 1] - 1]
					set j [expr [lindex $e3 4] - 1]
					set datos(conv,$i) $j
				}
				#creo un data temporal y realizo en el la conversion
				Data::newData tempMR
				Data::reenumerar $gui(baseDataMR1) tempMR 
				
				#salvo a fichero
				set types { {{Ficheros Mol} {.mol} } }
				set filename [tk_getSaveFile -initialfile "[file rootname $gui(ficheroMR1)]-renum.mol" -parent $gui(mainfMR) -filetypes $types -defaultextension mol -initialdir $config(dirData) -title "Guardar el Mapa de Reacción"]
				if {$filename != ""} {
					Fich::escribeFichMol $filename tempMR $gui(conf)
					catch { file delete -force "[file rootname $filename]" }
					#elimino el temporal
					Data::delData tempMR
					
					#cargo el nuevo fichero
					eliminaMoleculas $base
					set mol [cargarFicheroMol $base $filename]
					set gui(fichCargados) $mol
					#set VisorVTK::$gui(visor)(ficheroSeleccionado) $filename
					VisorGL::estableceFicheroSeleccionado $gui(visor)
					destroy $gui(mainfMR)
				} else {
					focus $gui(mainfMR)
				}
			}
		} else {
			tk_messageBox -type ok -title [mc "Atention"] -icon warning -message [mc "Define Files and complete asignation"]
		}
	}; #finproc

	proc manejadorCancelarMR { base } {
		upvar #0 GUI::$base gui
		if {[tk_messageBox -type yesno -title [mc "Atention"] -icon warning -message [mc "Are you sure cancel RM"]]} {
			destroy $gui(mainfMR)
		}
	}
#----------------------------------------------------------------------------------------------
#									-	MANEJADORES	DE EVENTOS   -
#----------------------------------------------------------------------------------------------		
	#controla el 2º boton, si esta en modo rotar, saca un menu emergente, de lo contratrio cede en control al manejador implementado en VisorVTK
	proc manejadorRBRE { base } {
		upvar #0 GUI::$base gui
		
		set x [winfo pointerx .]
		set y [winfo pointery .]
		if {$gui(modoInteraccion) == "rotar"} {
			if {[winfo exists .menuContex]} {destroy .menuContex}
			set menu [menu .menuContex -tearoff 0]
			$menu add command -label [mc "Cut"] -command "GUI::cortar $base"
			$menu add command -label [mc "Copy"] -command "GUI::copiar $base"
			$menu add command -label [mc "Paste"] -command "GUI::pegar $base"
			$menu add separator
			$menu add check -label [mc Parallel/Oblique] -variable "GUI::${base}(proyeccion)" -command "GUI::manejadorProyeccion $base"
			$menu add cascade -label [mc "Resolution"] -menu $menu.res
				set res [menu $menu.res -tearoff 0]
				$res add radio -label [mc "Low"] -variable "GUI::${base}(resolucion)" -value "B" -command "GUI::cambiarResolucion $base"
				$res add radio -label [mc "Medium"] -variable "GUI::${base}(resolucion)" -value "M" -command "GUI::cambiarResolucion $base"
				$res add radio -label [mc "High"] -variable "GUI::${base}(resolucion)" -value "A" -command "GUI::cambiarResolucion $base"
				$res add radio -label [mc "Ultra"] -variable "GUI::${base}(resolucion)" -value "U" -command "GUI::cambiarResolucion $base"
			$menu add check -label [mc "Enable/Disable HUD"]  -variable "GUI::${base}(hud)" -command "GUI::manejadorHUD $base"
			$menu add command -label [mc "Options"] -command "GUI::ventanaConfiguracion $base"
			$menu add command -label [mc "Background Color"] -command "GUI::manejadorColorFondo $base"
			$menu add command -label [mc "Save as Image"] -command "GUI::manejadorGuardarImagenComo $base"	
			
			set listaP [generaListaPropiedades $base]
			puts $listaP
			if {$listaP != ""} {
				#hay disponibles propiedades para lo seleccionado				
				$menu add separator
				$menu add command -label [mc "Properties"] -command "GUI::ventanaPropiedades $base [list $listaP]"
			}
						
			
			tk_popup $menu $x $y
			
			#informo al Visor q she soltado el boton derecho, ya q he capturado el evento, el no puede enterarse por su cuenta
			#VisorVTK::manejadorRBRE $gui(visor)
			VisorGL::manejadorRBRE $gui(visor) $x $y
			
		} else {
			#cedo el control al manejador de VTK, el menu contextual solo sale en el modo rotacion
			#VisorVTK::manejadorRBRE $gui(visor)
			VisorGL::manejadorRBRE $gui(visor) $x $y
		}
	}; #finproc
	
	proc menuEtiquetas { base boton } {
		upvar #0 GUI::$base gui
		
		if {[winfo exists .menuEtq]} {destroy .menuEtq}
		set menu [menu .menuEtq -tearoff 0]
		$menu add check -label [mc "ID" ] -variable "GUI::${base}(etqId)" -command "GUI::manejadorEtiquetas $base ID"
		$menu add check -label [mc "BrandyMol Code"] -variable "GUI::${base}(etqCodB)" -command "GUI::manejadorEtiquetas $base CODB"
		$menu add check -label [mc "Charge"] -variable "GUI::${base}(etqCarga)" -command "GUI::manejadorEtiquetas $base CARGA"
		$menu add check -label [mc "Tinker Code"] -variable "GUI::${base}(etqCodTink)" -command "GUI::manejadorEtiquetas $base CODTINK"
		$menu add check -label [mc "Inchi Chirality"] -variable "GUI::${base}(etqQuira)" -command "GUI::manejadorEtiquetas $base QUIRA"
		
		tk_popup $menu [winfo rootx $boton] [winfo rooty $boton]
	}; 
	
	proc manejadorEtiquetas { base etq } {
		upvar #0 GUI::$base gui
		switch $etq {
			#ID { VisorVTK::establecerEtiquetasAMostrar $gui(visor) ID $gui(etqId) $gui(conf)}
			#CODB { VisorVTK::establecerEtiquetasAMostrar $gui(visor) CODB $gui(etqCodB) $gui(conf)}
			#CARGA { VisorVTK::establecerEtiquetasAMostrar $gui(visor) CARGA $gui(etqCarga) $gui(conf)}
			#CODTINK { VisorVTK::establecerEtiquetasAMostrar $gui(visor) CODTINK $gui(etqCodTink) $gui(conf)}
			#QUIRA { VisorVTK::establecerEtiquetasAMostrar $gui(visor) QUIRA $gui(etqQuira) $gui(conf)}
			ID { VisorGL::establecerEtiquetasAMostrar $gui(visor) ID $gui(etqId) }
			CODB { VisorGL::establecerEtiquetasAMostrar $gui(visor) CODB $gui(etqCodB) }
			CARGA { VisorGL::establecerEtiquetasAMostrar $gui(visor) CARGA $gui(etqCarga) }
			CODTINK { VisorGL::establecerEtiquetasAMostrar $gui(visor) CODTINK $gui(etqCodTink) }
			QUIRA { VisorGL::establecerEtiquetasAMostrar $gui(visor) QUIRA $gui(etqQuira) }
			
		}
		VisorGL::render $gui(visor)
	}; #finproc
	
	proc manejadorColorFondo { base } {
		upvar #0 GUI::$base gui
		
		set color [tk_chooseColor -parent .]
		if {$color != ""} { 
			#VisorVTK::cambiarColorFondo $gui(visor) $color
			VisorGL::cambiarColorFondo $gui(visor) $color
			VisorGL::render $gui(visor)
		}
	}; #finproc
	
	proc generaListaPropiedades { base } {
		upvar #0 GUI::$base gui
		
		set res [list]
		
		
		#set molec [VisorVTK::devuelveMolSeleccEntera $gui(visor)]
		#set lista [VisorVTK::devuelveMolNumAtomoSelecc $gui(visor)]
		set molec [VisorGL::listaMoleculasComplSelecc $gui(visor)]
		set lista [VisorGL::listaMolAtomosSeleccionadosVisor $gui(visor)]
		
		
		if {[llength $molec] == 1} {
			#esta seleccionada una molecula, devuelvo sus propiedades
			puts "esta seleccionada una molecula, devuelvo sus propiedades"
			set mol [lindex $molec 0]
			upvar #0 Data::$mol datos
			set form [Data::formulaMolecular $mol]
			
			lappend res [list [mc "ID"] $mol]
			lappend res [list [mc "Filename"] $datos(nombreFich)]
			lappend res [list [mc "Molecular Formula"] "[join [join $form]]"]
			lappend res [list [mc "Atoms"] $datos(numAtomos)]
			lappend res [list [mc "Molecular Weight"] "[Data::pesoMolecular $form] g/mol"]
			lappend res [list [mc "Inchi Code" ] $datos(inchi)]
			#lappend res [list "Quiralidad" $datos(quiralidad)]
		} elseif { [llength $molec] == 0 && [llength $lista] > 0 && [llength $lista] <= 4 } {
			#no hay ninguna molecula completamente seleccionada
			#set lista [VisorVTK::devuelveMolNumAtomoSelecc $gui(visor)]
			set lista [VisorGL::listaMolAtomosSeleccionadosVisor $gui(visor)]
			if {[llength $lista] == 1} {
				#seleccionado un solo atomo
				set elem [lindex $lista 0]
				set mol [lindex $elem 0]
				set id [lindex $elem 1]
				
				upvar #0 Data::$mol datos
				
				lappend res [list [mc "ID"] "$mol [expr $id + 1]"]
				lappend res [list [mc "BrandyMol Code"] [Data::codBrandy $mol $id]]
				lappend res [list [mc "Symbol"] $datos(simbolo,$id)]
				lappend res [list [mc "Coordinates" ] "$datos(coordX,$id) $datos(coordY,$id) $datos(coordZ,$id)"]
				lappend res [list [mc "Charge"] "$datos(carga,$id)"]
				#añadir color
				puts "#seleccionado un solo atomo"
			} elseif {[llength $lista] == 2} {
				#seleccionado 2 atomos
				
				set elem1 [lindex $lista 0]
				set elem2 [lindex $lista 1]
				
				set mol1 [lindex $elem1 0]
				set id1 [lindex $elem1 1]
				set mol2 [lindex $elem2 0]
				set id2 [lindex $elem2 1]
				
				upvar #0 Data::$mol1 datos1
				upvar #0 Data::$mol2 datos2
				
				
				lappend res [list [mc "ID"] "($mol1 [expr $id1 + 1]) , ($mol2 [expr $id2 + 1])"]
				lappend res [list [mc "BrandyMol Code"] "[Data::codBrandy $mol1 $id1] , [Data::codBrandy $mol2 $id2]"]
				lappend res [list [mc "Symbol"] "$datos1(simbolo,$id1), $datos2(simbolo,$id2)"]
				#lappend res [list "Coordenadas" "$datos(coordX,$id) $datos(coordY,$id) $datos(coordZ,$id)"]
				#lappend res [list "Carga" "$datos(carga,$id)"]
				#lappend res [list [mc "Length"] "[VisorVTK::insertarDistancia $gui(visor) 	[list $datos1(coordX,$id1) $datos1(coordY,$id1) $datos1(coordZ,$id1)] \
														[list $datos2(coordX,$id2) $datos2(coordY,$id2) $datos2(coordZ,$id2)] 0]A"]
				lappend res [list [mc "Length"] "[VisorGL::dibujarDistancia $gui(visor) 	[list $datos1(coordX,$id1) $datos1(coordY,$id1) $datos1(coordZ,$id1)] \
														[list $datos2(coordX,$id2) $datos2(coordY,$id2) $datos2(coordZ,$id2)]] A"]
				puts "#seleccionado 2 atomos"
			} elseif {[llength $lista] == 3} {
				#seleccionado 3 atomos
				
				set elem1 [lindex $lista 0]
				set elem2 [lindex $lista 1]
				set elem3 [lindex $lista 2]
				
				
				set mol1 [lindex $elem1 0]
				set id1 [lindex $elem1 1]
				set mol2 [lindex $elem2 0]
				set id2 [lindex $elem2 1]
				set mol3 [lindex $elem3 0]
				set id3 [lindex $elem3 1]
				
				upvar #0 Data::$mol1 datos1
				upvar #0 Data::$mol2 datos2
				upvar #0 Data::$mol3 datos3
				
				lappend res [list [mc "ID"] "($mol1 [expr $id1 + 1]) , ($mol2 [expr $id2 + 1]) , ($mol3 [expr $id3 + 1])"]
				lappend res [list [mc "BrandyMol Code"] "[Data::codBrandy $mol1 $id1] , [Data::codBrandy $mol2 $id2] , [Data::codBrandy $mol3 $id3]"]
				lappend res [list [mc "Symbol"] "$datos1(simbolo,$id1), $datos2(simbolo,$id2), $datos3(simbolo,$id3)"]
				#lappend res [list "Coordenadas" "$datos(coordX,$id) $datos(coordY,$id) $datos(coordZ,$id)"]
				#lappend res [list "Carga" "$datos(carga,$id)"]
				#lappend res [list [mc "Angle"] "[VisorVTK::insertarAngulo $gui(visor) [list $datos1(coordX,$id1) $datos1(coordY,$id1) $datos1(coordZ,$id1)] \
																				  [list $datos2(coordX,$id2) $datos2(coordY,$id2) $datos2(coordZ,$id2)] \
																				  [list $datos3(coordX,$id3) $datos3(coordY,$id3) $datos3(coordZ,$id3)] 0]º"]
				lappend res [list [mc "Angle"] "[VisorGL::dibujarAngulo $gui(visor) 	[list $datos1(coordX,$id1) $datos1(coordY,$id1) $datos1(coordZ,$id1)] \
													[list $datos2(coordX,$id2) $datos2(coordY,$id2) $datos2(coordZ,$id2)] \
													[list $datos3(coordX,$id3) $datos3(coordY,$id3) $datos3(coordZ,$id3)]] º"]

				puts "#seleccionado 3 atomos"
			} elseif {[llength $lista] == 4} {
				#seleccionado 4 atomos
				
				set elem1 [lindex $lista 0]
				set elem2 [lindex $lista 1]
				set elem3 [lindex $lista 2]
				set elem4 [lindex $lista 3]
				
				
				set mol1 [lindex $elem1 0]
				set id1 [lindex $elem1 1]
				set mol2 [lindex $elem2 0]
				set id2 [lindex $elem2 1]
				set mol3 [lindex $elem3 0]
				set id3 [lindex $elem3 1]
				set mol4 [lindex $elem4 0]
				set id4 [lindex $elem4 1]
				
				upvar #0 Data::$mol1 datos1
				upvar #0 Data::$mol2 datos2
				upvar #0 Data::$mol3 datos3
				upvar #0 Data::$mol4 datos4
				
				lappend res [list [mc "ID"] "($mol1 [expr $id1 + 1]) , ($mol2 [expr $id2 + 1]) , ($mol3 [expr $id3 + 1]), ($mol4 [expr $id4 + 1])"]
				lappend res [list [mc "BrandyMol Code"] "[Data::codBrandy $mol1 $id1] , [Data::codBrandy $mol2 $id2] , [Data::codBrandy $mol3 $id3], [Data::codBrandy $mol4 $id4]"]
				lappend res [list [mc "Symbol"] "$datos1(simbolo,$id1), $datos2(simbolo,$id2), $datos3(simbolo,$id3), $datos4(simbolo,$id4)"]
				#lappend res [list "Coordenadas" "$datos(coordX,$id) $datos(coordY,$id) $datos(coordZ,$id)"]
				#lappend res [list "Carga" "$datos(carga,$id)"]
				#lappend res [list [mc "DihedralAngle"] "[VisorVTK::insertarTorsion $gui(visor) [list $datos1(coordX,$id1) $datos1(coordY,$id1) $datos1(coordZ,$id1)] \
																				  [list $datos2(coordX,$id2) $datos2(coordY,$id2) $datos2(coordZ,$id2)] \
																				  [list $datos3(coordX,$id3) $datos3(coordY,$id3) $datos3(coordZ,$id3)] \
																				  [list $datos4(coordX,$id4) $datos4(coordY,$id4) $datos4(coordZ,$id4)] 0]º"]
				lappend res [list [mc "DihedralAngle"] "[VisorGL::dibujarTorsion $gui(visor) 	[list $datos1(coordX,$id1) $datos1(coordY,$id1) $datos1(coordZ,$id1)] \
														[list $datos2(coordX,$id2) $datos2(coordY,$id2) $datos2(coordZ,$id2)] \
														[list $datos3(coordX,$id3) $datos3(coordY,$id3) $datos3(coordZ,$id3)] \
														[list $datos4(coordX,$id4) $datos4(coordY,$id4) $datos4(coordZ,$id4)]] º"]
				puts "#seleccionado 4 atomos"
			}
		} else {
			#compruebo si hay solo 1 enlace seleccionado
			#set lista [VisorVTK::devuelveMolNumEnlacesSelecc $gui(visor)]
			set lista [VisorGL::listaMolEnlacesSeleccionadosVisor $gui(visor)]
			
			#set lista [list]
			
			if {[llength $lista] == 1} {
				set elem1 [lindex $lista 0]
				
				set mol1 [lindex $elem1 0]
				set id1 [lindex $elem1 1]
				set id2 [lindex $elem1 2]
				
				upvar #0 Data::$mol1 datos1
				
				lappend res [list [mc "ID"] "($mol1 $id1) , ($mol1 $id2)"]
				lappend res [list [mc "BrandyMol Code"] "[Data::codBrandy $mol1 $id1] , [Data::codBrandy $mol1 $id2]"]
				lappend res [list [mc "Symbol"]  "$datos1(simbolo,$id1), $datos1(simbolo,$id2)"]
				#lappend res [list "Coordenadas" "$datos(coordX,$id) $datos(coordY,$id) $datos(coordZ,$id)"]
				#lappend res [list "Carga" "$datos(carga,$id)"]
				#lappend res [list [mc "Length"] "[VisorVTK::insertarDistancia $gui(visor) [list $datos1(coordX,$id1) $datos1(coordY,$id1) $datos1(coordZ,$id1)] \
																						[list $datos1(coordX,$id2) $datos1(coordY,$id2) $datos1(coordZ,$id2)] 0]A"]
				lappend res [list [mc "Length"] "[VisorGL::dibujarDistancia $gui(visor) [list $datos1(coordX,$id1) $datos1(coordY,$id1) $datos1(coordZ,$id1)] \
													[list $datos1(coordX,$id2) $datos1(coordY,$id2) $datos1(coordZ,$id2)]] A"]
				
			}
		}
		VisorGL::render $gui(visor)
		return $res
	}; #finproc
	
	proc ventanaPropiedades { base listaP } {
		upvar #0 GUI::$base gui
		set mainf $gui(mainfMR)
		if {[winfo exists $mainf]} {destroy $mainf}
		
		toplevel $mainf
		wm title $mainf [mc "Properties"]
		wm resizable $mainf 0 0
		
		#frame superior
		set frameup [frame $mainf.frameup]
		set label [Label $frameup.label -activebackground #a0a0a0 -text [mc "BrandyMolVer"] -font {Arial 18 {bold roman}} -relief flat -anchor center]
		#pack $label -side right
		
		
		#frame central
		set framecent [frame $mainf.framecent -borderwidth 3 -bd 2 -relief groove]
		
		#frame titulo
		set frametit [frame $framecent.frametit]
		set lab1 [Label $frametit.l1 -activebackground #a0a0a0 -text [mc "Property"] -font {Arial 13 {bold roman}} -relief flat -anchor center]
		set lab2 [Label $frametit.l2 -activebackground #a0a0a0 -text [mc "Value"] -font {Arial 13 {bold roman}} -relief flat -anchor center]
		
		pack $lab1 -side left
		pack $lab2 -side right -padx 90
		pack $frametit -fill x -padx 5 -pady 5
		
		
		set x 0
		foreach prop $listaP {
			set frameP [frame $framecent.frameP${x} -borderwidth 3 -bd 2 -relief groove]
			set lab1 [Label $frameP.l1${x} -activebackground #a0a0a0 -text [lindex $prop 0] -font {Arial 8 {bold roman}} -relief flat -anchor center]
			set	lab2 [Entry $frameP.l2${x} -background white -text [lindex $prop 1] -font {Arial 8 {bold roman}} -relief flat -justify right -width 40]
			incr x
			pack $lab1 -anchor w -side left
			pack $lab2 -anchor e -side right
			pack $frameP -fill x -expand 1 -padx 3
		}
		
		#frame inferior
		set framedown [frame $mainf.framedown -borderwidth 3 -bd 2 -relief raised]
		set butonayu [Button $framedown.ayuda -activebackground #a0a0a0 -helptext [mc "Help"] -command "GUI::manejadorAyuda $base Visualizador" -image $Icon::ayudicon -text [mc "Help"]]
		set butonejec [Button $framedown.ok -activebackground #a0a0a0 -command "destroy $mainf" -helptext [mc "Close"] -image $Icon::okicon]
		
		pack $butonejec $butonayu -side right -fill x 
		#empaqueto las frames ppales
		pack $frameup -fill x 
		pack $framecent -fill both -expand 1 -padx 4 -pady 4 
		pack $framedown -fill x
		focus $butonejec
		
		#cerrar si se pulsa intro
		bind $mainf <KeyPress-Return> "destroy $mainf"
	}; #finproc
	
	proc cambiarResolucion { base } {
		upvar #0 GUI::$base gui
		
		switch $gui(resolucion) {
			#B {VisorVTK::cambiarResolucionVisorVTK $gui(visor) 6; VisorVTK::cambiarAntiAliasingVisorVTK $gui(visor) 0}
			#M {VisorVTK::cambiarResolucionVisorVTK $gui(visor) 18; VisorVTK::cambiarAntiAliasingVisorVTK $gui(visor) 0}
			#A {VisorVTK::cambiarResolucionVisorVTK $gui(visor) 50; VisorVTK::cambiarAntiAliasingVisorVTK $gui(visor) 0}
			#U {VisorVTK::cambiarResolucionVisorVTK $gui(visor) 100; VisorVTK::cambiarAntiAliasingVisorVTK $gui(visor) 5}
			B {VisorGL::cambiarResolucionVisor $gui(visor) 6
				#VisorVTK::cambiarAntiAliasingVisorVTK $gui(visor) 0
				
			}
			M {VisorGL::cambiarResolucionVisor $gui(visor) 18
				#VisorVTK::cambiarAntiAliasingVisorVTK $gui(visor) 0
				
			}
			A {VisorGL::cambiarResolucionVisor $gui(visor) 50
				 #VisorVTK::cambiarAntiAliasingVisorVTK $gui(visor) 0
				
			}
			U {VisorGL::cambiarResolucionVisor $gui(visor) 100
				#VisorVTK::cambiarAntiAliasingVisorVTK $gui(visor) 5
				
			}
		}
		VisorGL::render $gui(visor)
	}; #finproc
	
	proc manejadorProyeccion { base } {
		upvar #0 GUI::$base gui
		if {$gui(proyeccion) == 0} {
			#VisorVTK::cambiarProyeccionCamara $gui(visor) 0
			VisorGL::cambiarProyeccion $gui(visor) 0
			
		} else {
			#VisorVTK::cambiarProyeccionCamara $gui(visor) 1
			VisorGL::cambiarProyeccion $gui(visor) 1
		}
		VisorGL::render $gui(visor)
	}; #finproc
	
	proc manejadorGuardarImagenComo { base } {
		upvar #0 GUI::$base gui
		upvar #0 Conf::$gui(conf) config
		set types {
			{{JPEG} {.jpg} }
			{{Mapa de bits} {.bmp} }
			{{TIFF} {.tif} }
			{{PNG} {.png} }
		}
		set filename [tk_getSaveFile -parent . -filetypes $types -defaultextension jpg -initialdir $config(dirData) -title [mc "Save Image as"]]
		if {$filename != ""} {
			#set config(dirData) [file dirname $filename]
			set ext [file extension $filename]
			switch $ext {
				".jpg" {
					#VisorVTK::salvarPantallaComoImagen $gui(visor) JPEG $filename
					VisorGL::salvarImagenVisor $gui(visor) $filename JPEG
				}
				".bmp" {
					#VisorVTK::salvarPantallaComoImagen $gui(visor) BMP $filename
					VisorGL::salvarImagenVisor $gui(visor) $filename BMP
				}
				".tif" {
					#VisorVTK::salvarPantallaComoImagen $gui(visor) TIFF $filename
					VisorGL::salvarImagenVisor $gui(visor) $filename TIFF
				}
				".png" {
					#VisorVTK::salvarPantallaComoImagen $gui(visor) PNG $filename
					VisorGL::salvarImagenVisor $gui(visor) $filename PNG
				}
				default {}
			}
		}
	}; #finproc
	
	proc crearSuperficie { base } {
		upvar #0 GUI::$base gui
		
		VisorVTK::generarSuperficie $gui(visor) $gui(conf)
		set gui(repreSuperficie) "Surface"
	}; #finproc
	
	proc cambiarRepresentacionSuperficie { base } {
		upvar #0 GUI::$base gui
		VisorVTK::modificarRepresentacionSuperficie $gui(visor) $gui(repreSuperficie)
	}; #finproc
	
	#controlara los botones pulsados en el menu lateral Izquierdo
	proc manejadorMenuIzq { base boton } {
		upvar #0 GUI::$base gui
		
		
		
		switch $boton {
			pegar {
				pegar $base
			}
			copiar {
				copiar $base
			}
			cortar {
				cortar $base
			}
			mover {
				set gui(modoInteraccion) "mover"
				#VisorVTK::manejadorEstado $gui(visor) "mover"
				VisorGL::cambiaModoActivoVisor $gui(visor) "mover"
				#if {[VisorVTK::devolverEstadoEjes $gui(visor)] == 1} {VisorVTK::ejesInteractivos $gui(visor) 1 } 
			}
			rotar {
				set gui(modoInteraccion) "rotar"
				#VisorVTK::manejadorEstado $gui(visor) "rotar"
				VisorGL::cambiaModoActivoVisor $gui(visor) "rotar"
				#if {[VisorVTK::devolverEstadoEjes $gui(visor)] == 1} {VisorVTK::ejesInteractivos $gui(visor) 0} 
			}
			desplazar {
				set gui(modoInteraccion) "desplazar"
				#VisorVTK::manejadorEstado $gui(visor) "desplazar"
				VisorGL::cambiaModoActivoVisor $gui(visor) "desplazar"
				#if {[VisorVTK::devolverEstadoEjes $gui(visor)] == 1} {VisorVTK::ejesInteractivos $gui(visor) 0 } 
			}
			centrar {
				#VisorVTK::manejadorEstado $gui(visor) "centrar"
				VisorGL::camaraReset $gui(visor)
			}
			ampliar {
				set gui(modoInteraccion) "ampliar"
				#VisorVTK::manejadorEstado $gui(visor) "ampliar"
				VisorGL::cambiaModoActivoVisor $gui(visor) "zoom"
				#if {[VisorVTK::devolverEstadoEjes $gui(visor)] == 1} {VisorVTK::ejesInteractivos $gui(visor) 0 } 
			}
			lineas {
				#VisorVTK::representaEn $gui(visor) "Lineas"
				#VisorVTK::render $gui(visor)
				VisorGL::cambiaRepresentacionVisor $gui(visor) L
				VisorGL::render $gui(visor)
			}
			cilindros {
				#VisorVTK::representaEn $gui(visor) "Cilindros"
				#VisorVTK::render $gui(visor)
				VisorGL::cambiaRepresentacionVisor $gui(visor) C
				VisorGL::render $gui(visor)
			}
			cilYbolas {
				#VisorVTK::representaEn $gui(visor) "CilindrosYBolas"
				#VisorVTK::render $gui(visor)
				VisorGL::cambiaRepresentacionVisor $gui(visor) CB
				VisorGL::render $gui(visor)
			}
			cpk {
				#VisorVTK::representaEn $gui(visor) "CPK"
				#VisorVTK::render $gui(visor)
				VisorGL::cambiaRepresentacionVisor $gui(visor) CPK
				VisorGL::render $gui(visor)
			}
			labels {
				
			}
			ejes {
				if {$gui(ejes) == 0} {
					set gui(ejes) 1
					#VisorVTK::mostrarOcultarEjes $gui(visor) 1
					VisorGL::cambiaModoEjes $gui(visor) 1
					#if {$gui(modoInteraccion) == "mover"} {
						#if {[VisorVTK::devolverEstadoEjes $gui(visor)] == 1} {VisorVTK::ejesInteractivos $gui(visor) 1 } 
					#} else {
						#if {[VisorVTK::devolverEstadoEjes $gui(visor)] == 1} {VisorVTK::ejesInteractivos $gui(visor) 0 } 
					#}
				} else {
					set gui(ejes) 0
					#VisorVTK::mostrarOcultarEjes $gui(visor) 0
					VisorGL::cambiaModoEjes $gui(visor) 0
				}
			}
		}
		controlPulsado $base $boton
	}; #finproc
	
	proc controlPulsado { base boton } {
		upvar #0 GUI::$base gui
		
		if {$boton == "mover" || $boton == "rotar" || $boton == "desplazar"  || $boton == "ampliar" } {
			$gui(botonMover) configure -relief link
			$gui(botonRotar) configure -relief link
			$gui(botonDesplazar) configure -relief link
			$gui(botonAmpliar) configure -relief link
			
			switch $boton {
				mover {
					$gui(botonMover) configure -relief sunken
				}
				rotar {
					$gui(botonRotar) configure -relief sunken
				}
				desplazar {
					$gui(botonDesplazar) configure -relief sunken
				}
				ampliar {
					$gui(botonAmpliar) configure -relief sunken
				}
			}
		}
		if {$gui(ejes) == 0} {
			$gui(botonEjes)  configure -relief link
		} else {
			$gui(botonEjes)  configure -relief sunken
		}
		
	}; #finproc
	
	proc ocultarMostrarConsola { base } {
		upvar #0 GUI::$base gui
		if {$gui(consola) == 0} { console hide } else { console show }
	}; #finproc
	
	#buscar el pid del proceso proc en la lista de pares <pid> <nombre Proceso> listaProc
	proc buscaPID { listaProc nombreProc } {
		set enc -1
		set res -1
		set x 0
		while {$enc != 1 && $x < [llength $listaProc]} {
			set proceso [lindex $listaProc $x]
			if {[string match $nombreProc [lindex $proceso 1]]} {
				set enc 1
				set res [lindex $proceso 0]
			} else {
				incr x
			}
		}
		return $res
	}; #finproc
	
	proc manejadorCajaBot1 { base boton } {
		upvar #0 GUI::$base gui
		upvar #0 Conf::$gui(conf) config
		
		switch $boton {
			abreISIS {	
				#si el proceso existe lo pongo delante, si no lo lanzo
				set pids [twapi:::get_process_ids -name "IDraw32.exe"]
				if {$pids != ""} {
					foreach pid $pids {
						foreach handle [twapi::find_windows -pids $pid -toplevel 1] {
							if {[string match "*ISIS*" [twapi::get_window_text $handle]]} {
								#ya estoy en el handle de la ventana de isis
								twapi::restore_window $handle
								twapi::set_focus $handle
							}
						}
					}
				} else {
					exec [string map {"\\" "/"} $config(idraw)] &
				}
			}
			guardar {
				guardar $base
			}
			abrir {
				abrirFicheroMol $base
			}
			importar {
				importarFicheroMol $base
			}
			editor {
				#si el editor esta abierto lo pongo delante, si no lo lanzo
				set pids [twapi:::get_process_ids -name "Sc172.exe"]
				if {$pids != ""} {
					foreach pid $pids {
						foreach handle [twapi::find_windows -pids $pid -toplevel 1] {
							if {[string match "*Sc1*" [twapi::get_window_text $handle]]} {
								#ya estoy en el handle de la ventana de isis
								twapi::restore_window $handle
								twapi::set_focus $handle
							}
						}
					}
				} else {
					exec "$config(dirBin)Sc172.exe" &
				}
			}
			ayuda {
				tk_messageBox -type ok -message "Ayuda aun no disponible"
			}
			
		}
	}; #finproc
	
#----------------------------------------------------------------------------------------------
#									-	CREACION DE AYUDAS   -
#----------------------------------------------------------------------------------------------
	proc manejadorAyuda { base address } {
        upvar #0 GUI::$base gui
        upvar #0 Conf::$gui(conf) config
		#el manejador de ayuda arranca la ventana hh.exe en entorno de comandos
	    #si esta ventana esta lanzada la mato y la rearranco ya que no se puede 
	    #cambiar la pagina activa relativa de una ayuda externa desde linea de comandos
	    #miro si hh ha sido lanzado y si ocurre lo matoen caso contrario arranco la ayuda
	    #a la direccion que me envian (address)
		set pids [twapi:::get_process_ids -name "hh.exe"]
		if {$pids != ""} {
			foreach pidelem $pids {
				matoproc $pidelem
			}
			puts "$config(dirCHM) $address"
			exec hh.exe "mk:@MSITStore:[string map {"/" "\\"} $config(dirCHM)]brandymol.chm::/C/VTKBANBRANDY/chmmaker/HTML/$address.html" &
			} else {
			puts "$config(dirCHM) $address"
			exec hh.exe "mk:@MSITStore:[string map {"/" "\\"} $config(dirCHM)]brandymol.chm::/C/VTKBANBRANDY/chmmaker/HTML/$address.html" &
		} 
    }; #finproc
#----------------------------------------------------------------------------------------------
#									-FIN DE CREACION DE AYUDAS   -
#----------------------------------------------------------------------------------------------

	proc cargarFicheroMol { base filename } {
		upvar #0 GUI::$base gui
		incr gui(semillaFichCargados) 1	
		set baseData mol${gui(semillaFichCargados)}

		Data::newData $baseData
		catch {
			Fich::leeFichMol $filename $baseData $gui(conf)
		} res
		
		if { $res == 1 } {
			#VisorVTK::cargaVisorMolData $gui(visor) $baseData $gui(conf) 
			VisorGL::cargaVisorMolData $gui(visor) $baseData $gui(conf)
			VisorGL::camaraReset $gui(visor)
	
			#if {$gui(etqId) == 1 || $gui(etqCodB) == 1 || $gui(etqCarga) == 1 || $gui(etqCodTink) == 1 || $gui(etqQuira) == 1} { VisorVTK::crearEtiquetas $gui(visor) $gui(conf)}
			#VisorVTK::crearPuentesH $gui(visor)
			#VisorVTK::render $gui(visor)
			VisorGL::render $gui(visor)
			return $baseData
		} else {
			tk_messageBox -type ok -icon warning -title [mc "Atention"] -message "$filename, \n [mc "Error On reading"]"
			return "ERROR"
		}
	}; #finproc
	
	proc abrirFicheroMol { base } {
		upvar #0 GUI::$base gui
		upvar #0 Conf::$gui(conf) config
				
		set types {
			{{Ficheros Mol} {.mol} }
		}
		set filename [tk_getOpenFile -filetypes $types -initialdir $config(dirData) -title [mc "Open Mol File"]]
		if {$filename != ""} {
			#set config(dirData) [file dirname $filename]
			eliminaMoleculas $base
			#VisorVTK::eliminarSuperficiesVisorVTK $gui(visor)
			set mol [cargarFicheroMol $base $filename]
			if {$mol != "ERROR"} {
				set gui(fichCargados) $mol
				$gui(labelFichActual) configure -text $filename
				#set VisorVTK::$gui(visor)(ficheroSeleccionado) $filename
				#set VisorGL::$gui(visor)(ficheroSeleccionado) $filename
				VisorGL::estableceFicheroSeleccionado $gui(visor)
			}
		}
	}; #finproc
	
	proc importarFicheroMol { base } {
		upvar #0 GUI::$base gui
		upvar #0 Conf::$gui(conf) config
				
		set types {
			{{Ficheros Mol} {.mol} }
		}
		set filename [tk_getOpenFile -filetypes $types -multiple 1 -initialdir $config(dirData) -title [mc "Import a Molecule"]]
		
		if {[llength $filename] != 0} {
			#set config(dirData) [file dirname [lindex $filename 0]]
			foreach file $filename {
				set existe [devuelveDataFichData $base $filename]
				set mol [cargarFicheroMol $base $file]
				if {$mol != "ERROR"} {
				#controlo el nombre del fichero asociado al data, debe ser unico
					if {$existe != ""} {
						upvar #0 Data::$mol datos
						set datos(nombreFich) [mc "FileNotDefined"]
					}
					lappend gui(fichCargados) $mol
				}
			}
			if {[llength $gui(fichCargados)] == 1 } { 
				#set VisorVTK::$gui(visor)(ficheroSeleccionado) [lindex $filename 0] 
				#set VisorGL::$gui(visor)(ficheroSeleccionado) [lindex $filename 0]
				VisorGL::estableceFicheroSeleccionado $gui(visor)
				
			} else { 
				#set VisorVTK::$gui(visor)(ficheroSeleccionado) [mc "FileNotDefined"] 
				#set VisorGL::$gui(visor)(ficheroSeleccionado) [mc "FileNotDefined"]
				VisorGL::estableceFicheroSeleccionado $gui(visor)
				
			}
		}
	}; #finproc
		
	#si file el vacio, preguntara el nombre, de lo contrario usara el suministrado
	proc guardarComo { base file } {
		upvar #0 GUI::$base gui
		upvar #0 Conf::$gui(conf) config
		
		set types {
			{{Ficheros Mol} {.mol} }
		}
		
		#set listaM [VisorVTK::devuelveMolSeleccEntera $gui(visor)]
		set listaM [VisorGL::listaMoleculasComplSelecc $gui(visor)]
	
		#creo una lista con las moleculas parcialmente seleccionadas
		#set listaP [VisorVTK::devuelveMolSelecc $gui(visor)]
		set listaP [VisorGL::listaMoleculasParcSelecc $gui(visor)]
		#puts "Parciales : $listaP"
		foreach mol $listaM {
			set index [lsearch $listaP $mol]
			if {$index != -1} {
				set listaP [lreplace $listaP $index $index]
			}
		}
		#creo Datas temporales para almacenar partes de moleculas
		set temp [list]
		foreach mol $listaP {
			incr gui(semillaFichCargados)
			#lappend temp [Data::newSubData mol${gui(semillaFichCargados)} $mol [VisorVTK::devuelveNumAtomosSeleccMol $gui(visor) $mol]]
			lappend temp [Data::newSubData mol${gui(semillaFichCargados)} $mol [VisorGL::listaAtomosSeleccionadosMol $gui(visor) $mol]]
			
		}
		lappend listaM $temp
		set listaM [join $listaM " "]
		
		if {$listaM == ""} {
			set listaM $gui(fichCargados)
		}
		
		
		set filename ""
		if {[llength $listaM] == 1} {
			#solo hay marcada 1 molecula, la guardo en 1 fichero
			if {$file == 0} {
				set filename [tk_getSaveFile -filetypes $types -defaultextension mol -initialdir $config(dirData) -title [mc "Save the Molecule"]]
			} else { set filename $file }
			if {$filename != ""} {
				set f1 [string map {".mol" ""} [file tail $filename]]
				#borro los posibles datos q pudieran exitir
				catch { file delete -force "[file dirname $filename]/Almacen/$f1" }
				
				Fich::escribeFichMol $filename $listaM $gui(conf)
				
				#cuando se le suministra el nombre del fichero externamente, se hace a ocultas del visor, se usa ppalmente para copiar
				#al portapapeles
				if {$file == 0} {
					#solo hay una molecula marcada, por lo tanto, le asocio un nombre a la molecula, y actualizo a mano la label
					#set VisorVTK::$gui(visor)(ficheroSeleccionado) $filename
					
					Data::asociaFichData [lindex $listaM 0] $filename
					Fich::actualizaInchi $filename [lindex $listaM 0] $gui(conf)
					VisorGL::estableceFicheroSeleccionado $gui(visor)
				}
			}
		} elseif {[llength $listaM] >= 2} {
			#tengo q guardar varias moleculas
			#puedo querer guardarlas todas en un mismo fichero o en ficheros distintos
			if {$file == 0} {

				set op [tk_messageBox -title [mc "Information"] -message [mc "Doyouwishtojoin"] -type yesnocancel -icon question]
			} else { set op "yes"}
			if {$op == "yes"} {
				if {$file == 0} {
					set filename [tk_getSaveFile -filetypes $types -defaultextension mol -initialdir $config(dirData) -title [mc "Save the Molecule"]]
				} else { set filename $file }
				if {$filename != ""} {
					set f1 [string map {".mol" ""} [file tail $filename]]
					#borro los posibles datos q pudieran exitir
					catch { file delete -force "[file dirname $filename]/Almacen/$f1" }
					Fich::escribeFichMol $filename $listaM $gui(conf)
				}
			} elseif {$op == "no"} {
				foreach mol $listaM {
					#la selecciono para q se vea cual se va a guardar
					#VisorVTK::seleccionarMol $gui(visor) $mol $gui(conf)
					#VisorVTK::render $gui(visor)
					
					VisorGL::seleccionaMolecula $gui(visor) $mol
					VisorGL::render $gui(visor)
					if {$file == 0} {
						set filename [tk_getSaveFile -filetypes $types -defaultextension mol -initialdir $config(dirData) -title [mc "Save the Molecule"]]
					} else { set filename $file }	
					if {$filename != ""} {
						set f1 [string map {".mol" ""} [file tail $filename]]
						#borro los posibles datos q pudieran exitir
						catch { file delete -force "[file dirname $filename]/Almacen/$f1" }
						Fich::escribeFichMol $filename [list $mol] $gui(conf)
					}
					#VisorVTK::deseleccionarMol $gui(visor) $mol $gui(conf)
					VisorGL::deseleccionarMolecula $gui(visor) $mol
				}
			}	
		}	
		
		#elimino los temporales
		foreach mol $temp {
			Data::delData $mol
		}
		return $filename
	}; #finproc
	
	proc guardar { base } {
		upvar #0 GUI::$base gui
		
		#set listaM [VisorVTK::devuelveMolSeleccEntera $gui(visor)]
		#set listaM [VisorGL::listaMoleculasComplSelecc $gui(visor)]
		if {[llength $gui(fichCargados)] == 1} {
			#solo hay una molecula en el visor
			upvar #0 Data::[lindex $gui(fichCargados) 0] datos
			if {$datos(nombreFich) != [mc "FileNotDefined"]} {
				Fich::escribeFichMol $datos(nombreFich) [lindex $gui(fichCargados) 0] $gui(conf)
			} else {
				guardarComo $base 0
			}
		} elseif {[llength $gui(fichCargados)] > 1} {
			#hay mas de una, compruebo si hay seleccionada alguna en particular
			#set listaM [VisorVTK::devuelveMolSeleccEntera $gui(visor)]
			set listaM [VisorGL::listaMoleculasComplSelecc $gui(visor)]
			if {[llength $listaM] == 1} {
				upvar #0 Data::[lindex $listaM 0] datos
				if {$datos(nombreFich) != [mc "FileNotDefined"]} {
					Fich::escribeFichMol $datos(nombreFich) [lindex $listaM 0] $gui(conf)
				} else {
					guardarComo $base 0
				}
			} else {
				guardarComo $base 0
			}
		}
	}; #finproc
	
	proc copiar { base } {
		upvar #0 GUI::$base gui
		upvar #0 Conf::$gui(conf) config
		
		set fich "$config(dirTemp)copyclip.temp"
		file mkdir $config(dirTemp)
		set fileclip [guardarComo $base $fich]
		puts $fileclip
		if { $fileclip != ""} {Fich::escribeClipboard $fich $gui(conf) }
		
	}; #finproc
	
	proc cortar { base } {
		upvar #0 GUI::$base gui
		copiar $base
		#set listaM [VisorVTK::devuelveMolSeleccEntera $gui(visor)]
		set listaM [VisorGL::listaMoleculasComplSelecc $gui(visor)]
		puts $listaM
		if {$listaM == ""} {set listaM $gui(fichCargados)}
		
		foreach mol $listaM {
			#VisorVTK::deseleccionarTodo $gui(visor) $gui(conf)
			#VisorVTK::seleccionarMol $gui(visor) $mol $gui(conf)
			
			VisorGL::deseleccionarTodo $gui(visor)
			VisorGL::seleccionaMolecula $gui(visor) $mol
			eliminaMoleculas $base
		}
		
	}; #finproc
	
	proc pegar { base } {
		upvar #0 GUI::$base gui
		upvar #0 Conf::$gui(conf) config
		
		set file [Fich::leeClipboard $gui(conf)]
		if {$file != ""} {
			set mol [cargarFicheroMol $base $file]
			if {$mol != "ERROR"} {
				#al ser file un fichero virtual, no le asocio su nombre al Data
				Data::asociaFichData $mol [mc "FileNotDefined"]
				lappend gui(fichCargados) $mol
				#set VisorVTK::$gui(visor)(ficheroSeleccionado) [mc "FileNotDefined"]
				VisorGL::estableceFicheroSeleccionado $gui(visor)
				
				#calculo la informacion inchi, para ello debo guardar el data, ya q el formato del archivo generado del
				#del portapapeles no lo acepta el inchi
				Fich::escribeFichMol "$config(dirTemp)tempinchi.mol" $mol $gui(conf)
				Fich::actualizaInchi "$config(dirTemp)tempinchi.mol" $mol $gui(conf)
			}
		}
	}; #finproc	
	
	proc eliminaMoleculas { base } {
		upvar #0 GUI::$base gui
		
		#VisorVTK::eliminarMedidas $gui(visor)
		#VisorVTK::eliminaListaMedidas $gui(visor)
		#VisorVTK::eliminarSuperficiesVisorVTK $gui(visor)
		#set listElim [VisorVTK::delDatosMolVisorVTKSelecc $gui(visor)]
		set listElim [VisorGL::delVisorMolSelecc $gui(visor)]
		foreach mol $listElim {
			Data::delData $mol
			set index [lsearch -exact $gui(fichCargados) $mol]
			set gui(fichCargados) [lreplace $gui(fichCargados) $index $index]
		}
		
		#VisorVTK::calcularMedidas $gui(visor)
		#if {$gui(etqId) == 1 || $gui(etqCodB) == 1 || $gui(etqCarga) == 1 || $gui(etqCodTink) == 1 || $gui(etqQuira) == 1} {
		#	VisorVTK::crearEtiquetas $gui(visor) $gui(conf)
		#} else {
		#	VisorVTK::eliminarEtiquetas $gui(visor)
		#}
		#VisorVTK::crearPuentesH $gui(visor)
		#VisorVTK::render $gui(visor)
		VisorGL::render $gui(visor)
	}; #finproc
	
	proc manejadorMedidas { base quitar } {
		upvar #0 GUI::$base gui
		
		if {$quitar == 1} {
			#VisorVTK::eliminarMedidas $gui(visor)
			VisorGL::eliminarMedidas $gui(visor)
		} else {
			#VisorVTK::insertarMedida $gui(visor)
			#VisorVTK::calcularMedidas $gui(visor)
			VisorGL::insertarMedida $gui(visor)
		}
		#VisorVTK::render $gui(visor)
		VisorGL::render $gui(visor)
	}; #finproc
	
	proc anadirHidrogenos { base } {
		upvar #0 GUI::$base gui
		#set listaMol [VisorVTK::devuelveMolSelecc $gui(visor)]
		set listaMol [VisorGL::listaMoleculasParcSelecc $gui(visor)]
		puts $listaMol
		if {[llength $listaMol] == 0} {
			#no hay nada seleccionado, por lo que añado hidrogenos a todo lo que haya en el visor
			foreach mol $gui(fichCargados) {
				if {[Data::modificada $mol] == 0} {
					#no ha sido modificada, no es necesario recalcular, solo muestro los hidrogenos ocultados
					#en el visor
					#VisorVTK::ocultarMostrarHidrogenosMol $gui(visor) $mol 1
					VisorGL::ocultarMostrarHidrogenosMol $gui(visor) $mol 1
				} else {
					#la molecula ha sufrido cambios que han podio alterar el numero de sus atomos
					#es necesario recalcular los hidrogenos					
					puts recalcula
					VisorGL::delVisorMolData $gui(visor) $mol
					Data::addHidrogenos $mol $gui(conf)
					#VisorVTK::delDatosMolVisorVTK $gui(visor) $mol
					#VisorVTK::cargaVisorMolData $gui(visor) $mol $gui(conf)
					
					
					VisorGL::cargaVisorMolData $gui(visor) $mol $gui(conf)
					VisorGL::camaraReset $gui(visor)
				}
				#actualizo los anillos de la mol, aunq no se vayan a formar ciclos, se haace por sonsistencia y q existan las variables data(anillo,x,y)
				Data::calculaAnillos $mol
			}
		} else {
			#solo añado a lo que este seleccionado
			#set listaSelecc [VisorVTK::devuelveMolNumAtomoSelecc $gui(visor)]
			set listaSelecc [VisorGL::listaMolAtomosSeleccionadosVisor $gui(visor)]
			puts $listaSelecc
			#pero dependiendo de si ha sido la molecula o no, mostrare los ocultos
			#o recalculare los hidrogenos de los atomos en cuestion
			set listaMolRepintar [list]
			set listaHVisiblesMol [list]
			foreach x $listaSelecc {
				set listaH([lindex $x 0]) [list]
			}
			 
			foreach x $listaSelecc {
				if {[Data::modificada [lindex $x 0]] == 0} {
					#no ha sido modificada, solo muestro los hidrogenos ocultados del atomo
					lappend listaH([lindex $x 0]) [Data::devolverHidrogenosDelAtomo  [lindex $x 0] [lindex	$x 1]]
				} else {
					#recalculo los hidrogenos del atomo, y los muestro si estaban ocultos
					if {[lsearch -exact $listaMolRepintar [lindex $x 0]] == -1} {
						lappend listaMolRepintar [lindex $x 0]
					}
					Data::addHAtomo [lindex $x 0] [lindex $x 1]
					lappend listaH([lindex $x 0])  [Data::devolverHidrogenosDelAtomo [lindex $x 0] [lindex $x 1]]
				}
			}

			foreach mol $listaMolRepintar {
				#actualizo los anillos de la mol, aunq no se vayan a formar ciclos, se hace por consistencia y q existan las variables data(anillo,x,y)
				Data::calculaAnillos $mol
				#VisorVTK::delDatosMolVisorVTK $gui(visor) $mol
				VisorGL::delVisorMolData $gui(visor) $mol
				Data::addHidrogenos $mol $gui(conf)
				#VisorVTK::cargaVisorMolData $gui(visor) $mol $gui(conf)
				
				
				VisorGL::cargaVisorMolData $gui(visor) $mol $gui(conf)
				VisorGL::camaraReset $gui(visor)
			}
			
			foreach mol $listaSelecc {
				set mol [lindex $mol 0]
				set index [lsearch $mol $listaMolRepintar]
				if {$index == -1} {
					set listaH($mol) [join $listaH($mol) " "]	
					foreach h $listaH($mol) {
						#VisorVTK::ocultarMostrarAtomo $gui(visor) [lindex $x 0] $h 1
						VisorGL::ocultarMostrarAtomosMol $gui(visor) [lindex $x 0] $h 1
					}
				}
			}
		}
		#if {[llength $gui(fichCargados)] == 1 } { set VisorVTK::$gui(visor)(ficheroSeleccionado) [Data::devuelveFichData [lindex $gui(fichCargados) 0]]
		#} else { set VisorVTK::$gui(visor)(ficheroSeleccionado) [mc "FileNotDefined"] }
		#if {$gui(etqId) == 1 || $gui(etqCodB) == 1 || $gui(etqCarga) == 1 || $gui(etqCodTink) == 1 || $gui(etqQuira) == 1} { VisorVTK::crearEtiquetas $gui(visor) $gui(conf) }
		#VisorVTK::calcularMedidas $gui(visor)
		#VisorVTK::crearPuentesH $gui(visor)
		#VisorVTK::render $gui(visor)
		VisorGL::estableceFicheroSeleccionado $gui(visor)
		#VisorGL::camaraReset $gui(visor)
		VisorGL::render $gui(visor)
		
	}; #finproc
	
	proc quitarHidrogenos { base } {
		upvar #0 GUI::$base gui
		#set listaMol [VisorVTK::devuelveMolSelecc $gui(visor)]
		set listaMol [VisorGL::listaMoleculasParcSelecc $gui(visor)]
		
		
		if {[llength $listaMol] == 0} {
			#no hay nada seleccionado, por lo que añado hidrogenos a todo lo que haya en el visor
			foreach mol $gui(fichCargados) {
				#oculto todos los hidrogenos de la molecula
				#VisorVTK::ocultarMostrarHidrogenosMol $gui(visor) $mol 0
				VisorGL::ocultarMostrarHidrogenosMol $gui(visor) $mol 0
			}
		} else {
			#solo quito a lo que este seleccionado
			#set listaSelecc [VisorVTK::devuelveMolNumAtomoSelecc $gui(visor)]
			set listaSelecc [VisorGL::listaMolAtomosSeleccionadosVisor $gui(visor)]
			
			foreach x $listaSelecc {
				set hidrogenos [Data::devolverHidrogenosDelAtomo  [lindex $x 0] [lindex	$x 1]]
				foreach h $hidrogenos {
					#VisorVTK::ocultarMostrarAtomo $gui(visor) [lindex $x 0] $h 0
					VisorGL::ocultarMostrarAtomosMol $gui(visor) [lindex $x 0] $h 0
				}
			}
		}
		#if {$gui(etqId) == 1 || $gui(etqCodB) == 1 || $gui(etqCarga) == 1 || $gui(etqCodTink) == 1 || $gui(etqQuira) == 1} { VisorVTK::crearEtiquetas $gui(visor) $gui(conf)}
		#VisorVTK::calcularMedidas $gui(visor)
		#VisorVTK::crearPuentesH $gui(visor)
		#VisorVTK::render $gui(visor)
		VisorGL::render $gui(visor)
	}; #finproc
	
	#calc
	proc imagenEspecular { base } {
		upvar #0 GUI::$base gui
		
		#set listaMol [VisorVTK::devuelveMolSelecc $gui(visor)]
		set listaMol [VisorGL::listaMoleculasParcSelecc $gui(visor)]
		set todo 0
		if {$listaMol == ""} {
			set listaMol $gui(fichCargados)
			set todo 1
		} 
		
		foreach mol $listaMol {	
			
			#if {[VisorVTK::estaSeleccEnteraMol $gui(visor) $mol] == 1 || $todo == 1} 
			if {[VisorGL::estaSeleccEnteraMolecula $gui(visor) $mol] == 1 || $todo == 1} {
				Data::imagenEspecularMol $mol Z
				#VisorVTK::actualizaVisorMolData $gui(visor) $mol
				#VisorVTK::render $gui(visor)
				VisorGL::actualizaVisorMol $gui(visor)
				#VisorGL::render $gui(visor)
			} else {
				puts $mol
				#caso especial, esta seleccionado 1 solo atomo de 1 molecula
				#set x [VisorVTK::devuelveAtomosSeleccMol $gui(visor) $mol]
				set x [VisorGL::listaAtomosSeleccionadosMol $gui(visor) $mol]
				
				puts $x
				if {[llength $x] == 1} {
					#hay un atomo de 1 molecula marcada
					#scan [lindex $x 0] {%[a-zA-Z0-9]_%[a-zA-Z0-9]_%[0-9]} b n numAtom
					Data::imagenEspecularCasoEsp $mol [lindex $x 0]
					#VisorVTK::actualizaVisorMolData $gui(visor) $mol
					#VisorVTK::render $gui(visor)
					VisorGL::actualizaVisorMol $gui(visor)
					VisorGL::render $gui(visor)
				}
			}
			#la molecula pasa a ser un fichero no definido
			Data::asociaFichData $mol [mc "FileNotDefined"]
		}
		#set VisorVTK::$gui(visor)(ficheroSeleccionado) [mc "FileNotDefined"]
		VisorGL::estableceFicheroSeleccionado $gui(visor)
		#if {$gui(etqId) == 1 || $gui(etqCodB) == 1 || $gui(etqCarga) == 1 || $gui(etqCodTink) == 1 || $gui(etqQuira) == 1} {VisorVTK::crearEtiquetas $gui(visor) $gui(conf)}		
		#VisorVTK::calcularMedidas $gui(visor)
		#VisorVTK::crearPuentesH $gui(visor)
		#VisorVTK::render $gui(visor)
		VisorGL::render $gui(visor)
	}; #finproc
	
	proc editarTinker { base } {
		upvar #0 GUI::$base gui
		upvar #0 Conf::$gui(conf) config

		#para la edicion de tinker no usare una ventana de log, ya q deseo un menu especial	
		set fkey "$config(dirCHM)TINKER.key"
		if {[file exists $fkey]} {
			set mainf $gui(mainfEdTink)
			if {[winfo exists $mainf]} {destroy $mainf}
			if {[winfo exists ${mainf}_menuppal]} {destroy ${mainf}_menuppal}

			toplevel $mainf -menu ${mainf}_menuppal
			wm title $mainf [mc "Key" ]
			wm geometry $mainf 400x300
			set menuppal [menu ${mainf}_menuppal -tearoff 0]
			
			set frameup [frame ${mainf}.fup -borderwidth 3 -bd 2 -relief groove]
			set texto [text $frameup.text -borderwidth 2 -font {Terminal 9 } -relief raised -yscrollcommand "$frameup.text.textscroll set"]
			puts $texto
			#set ${base}(texto) $texto
			set scroll [scrollbar $frameup.text.textscroll -command "$texto yview"]
			pack $scroll -fill y -side right -expand no
			pack $texto -fill both -expand yes
			pack $frameup -side top -fill both -expand yes -padx 5 -pady 5
			
			set framedown [frame ${mainf}.down -bd 1 -relief raised]
			set butCerrar [Button $framedown.ok -activebackground #a0a0a0 -command "destroy $mainf ; destroy $menuppal" -helptext [mc "Close"] -image $Icon::cancelicon]		
			set butGuardar [Button $framedown.grd -activebackground #a0a0a0 -command "GUI::guardarKey $base $texto" -helptext [mc "Save TINKER.key File"] -image $Icon::guardaricon]
			
			pack $butCerrar $butGuardar -side left
			pack $framedown -fill x
			
			#creo el menu
			$menuppal add cascade -label [mc "File"] -menu ${mainf}_menuppal.key
				set menukey [menu ${mainf}_menuppal.key -tearoff 0]
				$menukey add command -label [mc "Exit"] -command "destroy $mainf ; destroy $menuppal"
			$menuppal add cascade -label [mc "Insert"] -menu ${mainf}_menuppal.tink	
				set menutink [menu ${mainf}_menuppal.tink -tearoff 0]
				#$menutink add cascade  -label "Fichero" -menu $filelog -state active -underline 0
				$menutink add command  -command "GUI::modificaPRMFichKey $base $texto" -label [mc "Parameters"]
				$menutink add separator 
				$menutink add command  -command "$texto insert end [mc "Pi System Command"]" -label [mc "Pi System"]
				$menutink add separator 
				$menutink add command  -command "$texto insert end [mc "Restrain Distance Command"]" -label [mc "Restrain Distance"]
				$menutink add command  -command "$texto insert end [mc "Restrain Angle Command"]" -label  [mc "Restrain Angle"]
				$menutink add command  -command "$texto insert end [mc "Restrain Torsion Command"]" -label [mc "Restrain Torsion" ]
				$menutink add separator 
				$menutink add command  -command "$texto insert end [mc "Dielectric Constant Command"]" -label [mc "Dielectric Constant"]
				$menutink add command  -command "$texto insert end [mc "Maximum Iteration Command"]" -label [mc "Maximum Iteration"]
				$menutink add separator 
				$menutink add command  -command "$texto insert end [mc "Saddlepoint Command"]" -label [mc "Saddlepoint"]
				$menutink add command  -command "$texto insert end [mc "Reduce Command"]" -label [mc "Reduce"]
				$menutink add command  -command "$texto insert end [mc "Enforce Chirality Command"]" -label [mc "Enforce Chirality"]					
			#cargo el fichero key
			set fichero [open $fkey r]
			set text [read $fichero]
			close $fichero
			#$textWidget configure -state normal
			$texto delete 0.0 end
			$texto insert end $text
			focus $mainf
		} else {
			tk_messageBox -type ok -title [mc "Critical Error"] -icon error -message [mc "Tinker.key Missing" ] 
		}	
	}; #finproc 
	
	proc guardarKey { base textW } {
		upvar #0 GUI::$base gui
		upvar #0 Conf::$gui(conf) config
		
		set fichero [open "$config(dirCHM)TINKER.key" w+]
		set texto [string trim [$textW get 0.0 end]]
		puts $fichero $texto
		close $fichero
		
		Fich::modificaPRM $gui(conf)

		tk_messageBox -message [mc "Tinker.Key Saved"] -parent $gui(mainfEdTink)
	}; #finproc

	 proc modificaPRMFichKey { base textoW } {
		upvar #0 GUI::$base gui
		upvar #0 Conf::$gui(conf) config

		set types { { {Parametros} {.prm} } }
		set filename [tk_getOpenFile -defaultextension "prm" -initialdir $config(dirCHM) -filetypes $types -parent $gui(mainfEdTink)]
		if { $filename != "" } {
			#set config(dirData) [file dirname $filename]
			$textoW delete 0.0 1.end
			$textoW insert 0.0 "PARAMETERS $filename"
		}
	}; #finproc
#ESTE MENUINSERTARTINKER NO SIRVE PARA NADA	
	proc menuInsertarTinker { textokey } {
		#upvar #0 GUI::$base gui
		#set base euiei
		set textokey sdfsd
		
		if {[winfo exists .menuContexTink]} {destroy .menuContexTink}
			
		set menuinsert [menu .menuContexTink -tearoff 0]
		#$menuinsert add command  -command "$textokey insert 0.0 {PARAMETERS $chmdir/MM3BRANDYMOL.PRM \n}" -label "Parámetros" -underline 0
		#$menuinsert add command  -command "Tinker::modificaPRMFichKey $base $textokey $texto" -label "Parámetros" -underline 0
		$menuinsert add separator 
		$menuinsert add command  -command "$textokey insert end {PISYSTEM   Escriba la lista de átomos PI \n}" -label "Sistema Pi" -underline 0
		$menuinsert add separator 
		$menuinsert add command  -command "$textokey insert end {RESTRAIN-DISTANCE  Escriba la lista de átomos \n}" -label "Fijar Distancia" -underline 0
		$menuinsert add command  -command "$textokey insert end {RESTRAIN-ANGLE  Escriba la lista de átomos \n}" -label "Fijar Ángulo" -underline 0
		$menuinsert add command  -command "$textokey insert end {RESTRAIN-TORSION  Escriba la lista de átomos \n}" -label "Fijar Torsión" -underline 0
		$menuinsert add separator 
		$menuinsert add command  -command "$textokey insert end {DIELECTRIC Escriba la constante dieléctrica (0.1 a 79)\n}" -label "Constante Dieléctrica" -underline 0
		$menuinsert add command  -command "$textokey insert end {MAXITER Escriba el máximo número de iteraciones \n}" -label "Iteraciones Máximas" -underline 0
		$menuinsert add separator 
		$menuinsert add command  -command "$textokey insert end {SADDLEPOINT \n}" -label "Estado de Transición" -underline 0
		$menuinsert add command  -command "$textokey insert end {REDUCE Escriba un valor entre 0 y 1 (aprox. 0.3) \n}" -label "Reduce" -underline 0
		$menuinsert add command  -command "$textokey insert end {ENFORCE-CHIRALITY \n}" -label "Forzar Quiralidad" -underline 0
		
		set x [winfo pointerx .]
		set y [winfo pointery .]
		tk_popup $menuinsert $x $y
		
	}; #finproc
		
	proc abrirFichLog { base } {
		upvar #0 GUI::$base gui
		incr gui(semillaLogs)
		Log::newLog log_$gui(semillaLogs) [list] $gui(conf) "log" 1
		set res [Log::abrirLog log_$gui(semillaLogs)]
		
		if {$res == -1} {
			Log::delLog log_$gui(semillaLogs)
		} else {
			#añado el boton de ordenar usado para los logs de scan
			upvar #0 Log::log_$gui(semillaLogs) log
			set cmd "Log::cargarTexto log_$gui(semillaLogs) [list [Tinker::ordenaLogBC $log(file)]]"
			Log::anadirBotonLog log_$gui(semillaLogs) "texto" "$Icon::ordenicon" $cmd
		}
	}; #finproc
	
	proc abrirFichMNO { base } {
		upvar #0 GUI::$base gui
		incr gui(semillaLogs)
		Log::newLog log_$gui(semillaLogs) "" $gui(conf) "mno" 1
		set res [Log::abrirLog log_$gui(semillaLogs)]
		if {$res == -1} {Log::delLog log_$gui(semillaLogs)}
	}; #finproc
	
	
	#tipo identifica kien llama a tinker
	#		tipo 0 --> Modelizacion Tinker
	#		tipo 1 --> Busqueda Conformacional TNCG
	#		tipo 2 --> Busqueda Conformacional OCVM	
	#		tipo 3 --> Calcula Vibraciones
	#		tipo 4 --> Mostrar Vibraciones
	#		tipo 5 --> Estado Transicion y Trayectoria de transicion
	#		tipo 6 --> Superponer
	#
	proc modelizarTinker { base baseConfig tipo } {
		upvar #0 GUI::$base gui
		upvar #0 Conf::$gui(conf) config
		
		#identifico el tipo
		puts "el fichero es [$gui(labelFichActual) cget -text]"
		if {$gui(semaforoProceso) == 0} {
			#set gui(semaforoProceso) 1
			activaDesactivaSemaforo $base 1 [mc "Tinker Running"]
			if {[string match [$gui(labelFichActual) cget -text] [mc "FileNotDefined"]] && $tipo != 4 && $tipo != 5 && $tipo != 6 } {
				#no hay fichero definido, 1º hay q guardar lo seleccionado en un nuevo fichero, y despues modelizaremos
				
				#set listaM [VisorVTK::devuelveMolSeleccEntera $gui(visor)]
				set listaM [VisorGL::listaMoleculasComplSelecc $gui(visor)]
				
				if {[llength $listaM] == 0} {
					set listaM $gui(fichCargados)
				}
				
				set filename ""
				
				if {[llength $gui(fichCargados)] > 0} {
					set types { {{Ficheros Mol} {.mol} } }
					set filename [tk_getSaveFile -filetypes $types -defaultextension mol -initialdir $config(dirData) -title [mc "Save the Molecule"]]
					puts "filename : $filename"
					if {$filename != ""} {
						Fich::escribeFichMol $filename $listaM $gui(conf)
						#borro la carpeta de info si la tubiera
						catch { file delete -force "[file rootname $filename]" }
						
						#cargo en el visor el nuevo fichero
						eliminaMoleculas $base
						set gui(fichCargados) [cargarFicheroMol $base $filename]
						#set VisorVTK::$gui(visor)(ficheroSeleccionado) $filename
						VisorGL::estableceFicheroSeleccionado $gui(visor)
						
						Tinker::newTinker t $gui(fichCargados) $gui(conf) $filename $base $tipo
						#debo borrar tempData cuando termine Data::delData tempData
					} else {activaDesactivaSemaforo $base 0 [mc "Ready"]}
				} else {
					#aunk no haya nada cargado en el visor, dejare ver la ventana de Tinker
					Tinker::newTinker t "" $gui(conf) [mc "FileNotDefined"] $base $tipo
				}
			} elseif { $tipo == 5 || $tipo == 6 } {
				Tinker::newTinker t "" $gui(conf) [mc "FileNotDefined"] $base $tipo
			} else {
				#queremos modelizar un fichero definido.
				set filename [$gui(labelFichActual) cget -text]
				puts [devuelveDataFichData $base $filename]
				Tinker::newTinker t [devuelveDataFichData $base $filename] $gui(conf) $filename $base $tipo
			}
			
		} else {
			tk_messageBox -title [mc "Information"] -message [mc "Calc Progress"]
		}
	}; #finproc
	
	proc finProcesoTink { base } {
		upvar #0 GUI::$base gui
		
		#una vez que ha terminado tinker, si existe la variable tempData debo borrarla
		#Data::delData tempData
		puts "---->$gui(resultadoTink)"
		activaDesactivaSemaforo $base 1 [mc "Tinker Running"]
		if {$gui(resultadoTink) != "ERROR" && $gui(resultadoTink) != "NOGENFICH"} {
			#se ha producido una nueva molecula como resultado del calculo
			#borro todo el sistema
			#VisorVTK::delDatk_messageBoxtosVisorVTK $gui(visor)
			#VisorVTK::eliminarMedidas $gui(visor)
			VisorGL::delVisorMol $gui(visor)
			
			foreach data $gui(fichCargados) {
				Data::delData $data
			}
			set gui(fichCargados) [list]
			
			foreach molec $gui(resultadoTink) {
				if {[file exists $molec]} {
					lappend gui(fichCargados) [cargarFicheroMol $base $molec]
					VisorGL::render $gui(visor)
				}
			}
			
			if {[llength $gui(resultadoTink)] == 1} {
				#set VisorVTK::$gui(visor)(ficheroSeleccionado) [join $gui(resultadoTink)]
				VisorGL::estableceFicheroSeleccionado $gui(visor)
			}
			
			#cargo la molecula resultante
			#set gui(fichCargados) [list [cargarFicheroMol $base $gui(resultadoTink)]]
			#como he eliminado las demas, actualizo la label
			#set VisorVTK::$gui(visor)(ficheroSeleccionado) $gui(resultadoTink)
		}
		activaDesactivaSemaforo $base 0 [mc "Ready"]
	}; #finproc
	
	#tipo identifica kien llama a tinker
	#		tipo 0 --> Modelizacion Mopac
	#		tipo 1 --> Mostrar Cargas
	#		tipo 2 --> Mostrar Vibraciones
	#		tipo 3 --> Mostrar Orbitales
	proc modelizarMopac { base baseConfig tipo } {
		upvar #0 GUI::$base gui
		upvar #0 Conf::$baseConfig config
		
		#Mopac::newMopac m $baseConfig $base ""
		
		
		
		if {$gui(semaforoProceso) == 0} {
			activaDesactivaSemaforo $base 1 [mc "Mopac Running"]
			
			if {[string match [$gui(labelFichActual) cget -text] [mc "FileNotDefined"]] && $tipo != 1} {
				#no hay fichero definido, 1º hay q guardar lo seleccionado en un nuevo fichero, y despues modelizaremos	
				#set listaM [VisorVTK::devuelveMolSeleccEntera $gui(visor)]
				set listaM [VisorGL::listaMoleculasComplSelecc $gui(visor)]
				if {[llength $listaM] == 0} {
					set listaM $gui(fichCargados)
				}
				
				set filename ""
				
				if {[llength $gui(fichCargados)] > 0} {
					set types { {{Ficheros Mol} {.mol} } }
					set filename [tk_getSaveFile -filetypes $types -defaultextension mol -initialdir $config(dirData) -title [mc "Save the Molecule"]]
					puts "filename : $filename"
					if {$filename != ""} {
						Fich::escribeFichMol $filename $listaM $gui(conf)
						#cargo en el visor el nuevo fichero
						eliminaMoleculas $base
						set gui(fichCargados) [cargarFicheroMol $base $filename]
						#set VisorVTK::$gui(visor)(ficheroSeleccionado) $filename
						VisorGL::estableceFicheroSeleccionado $gui(visor)
						Mopac::newMopac m $gui(fichCargados) $gui(conf) $base $filename $tipo
					} else {activaDesactivaSemaforo $base 0 [mc "Ready"]}
				} else {
					#aunk no haya nada cargado en el visor, dejare ver la ventana de Tinker
					Mopac::newMopac m d $gui(conf) $base [mc "FileNotDefined"] $tipo
				}
			} elseif {[string match [$gui(labelFichActual) cget -text] [mc "FileNotDefined"]] && $tipo == 1} {
				Mopac::newMopac m "" $gui(conf) $base "" $tipo
			} else {
				#queremos modelizar un fichero definido.
				set filename [$gui(labelFichActual) cget -text]
				puts [devuelveDataFichData $base $filename]
				Mopac::newMopac m [devuelveDataFichData $base $filename] $gui(conf) $base $filename $tipo
			}
			
		} else {
			tk_messageBox -title [mc "Information"] -message [mc "Calc Progress"]
		}
		
	}; #finproc
	
	proc finProcesoMopac { base } {
		upvar #0 GUI::$base gui
		
		puts "recibo : $gui(resultadoMopac)"
		
		activaDesactivaSemaforo $base 1 [mc "Mopac Running"]
		if {$gui(resultadoMopac) != "ERROR" && $gui(resultadoMopac) != "NOGENFICH"} {
			
			#se ha producido una nueva molecula como resultado del calculo
			#borro todo el sistema
			#VisorVTK::delDatosVisorVTK $gui(visor)
			#VisorVTK::eliminarMedidas $gui(visor)
			VisorGL::delVisorMol $gui(visor)
			foreach data $gui(fichCargados) {
				Data::delData $data
			}
			set gui(fichCargados) [list]
			
			foreach molec $gui(resultadoMopac) {
				if [file exists $molec] {
					lappend gui(fichCargados) [cargarFicheroMol $base $molec]
				}
			}
			
			if {[llength $gui(resultadoMopac)] == 1} {
				#set VisorVTK::$gui(visor)(ficheroSeleccionado) [join $gui(resultadoMopac)]
				VisorGL::estableceFicheroSeleccionado $gui(visor)
				activaDesactivaSemaforo $base 0 [mc "Ready"]
				return $gui(fichCargados)
			}
		}
		activaDesactivaSemaforo $base 0 [mc "Ready"]
		return -1
	}; #finproc
	
	#devuelve si existe el nombre del data q tiene asociado el fichero de nombre file
	proc devuelveDataFichData { base file } {
		upvar #0 GUI::$base gui
		
		set enc 0
		set x 0
		set mol ""
		while {$x < [llength $gui(fichCargados)] && $enc == 0} {
			upvar #0 Data::[lindex $gui(fichCargados) $x] datos
			
			
			if {[string match $file $datos(nombreFich)]} {
				set enc 1
				set mol [lindex $gui(fichCargados) $x]
			} else {
				incr x
			}
		}
		return $mol
	
	}; #finproc
	
#----------------------------------------------------------------------------------------------
#									-	PUENTES DE HIDROGENO   -
#----------------------------------------------------------------------------------------------			
#AQUIIIIIIIIIIIIIIIIIIIIIIIIIIII	
	proc ventanaPuentesHidrogeno { base } {
		upvar #0 GUI::$base gui
		
		set mainf $gui(mainPH)
		if {[winfo exists $mainf]} {destroy $mainf}
		
		toplevel $mainf
		wm title $mainf [mc "Hydrogens Bonds"]
		
		#frame superior
		set frameup [frame $mainf.frameup]
		set label [Label $frameup.label -activebackground #a0a0a0 -text [mc "BrandyMolVer"] -font {Arial 18 {bold roman}} -relief flat -anchor center]
		#pack $label -side right
		
			
		#frame central
		set framecent [frame $mainf.framecent -borderwidth 3 -bd 2 -relief flat]
		
		set fa [frame $framecent.fa -borderwidth 3 -bd 2 -relief groove]
		set label [Label $framecent.l1 -activebackground #a0a0a0 -text [mc "Hydrogens Bonds with"] -font {Arial 11 {bold roman}} -relief flat -anchor center]
		
		set oxig [checkbutton $fa.oxig -offvalue N -onvalue Y -text [mc "Oxygen"] -font {Arial 9 {bold roman}} -variable "GUI::${base}(phO)"]
		set nitro [checkbutton $fa.nitor -offvalue N -onvalue Y -text [mc "Nitrogen"] -font {Arial 9 {bold roman}} -variable "GUI::${base}(phN)"]
		set azuf [checkbutton $fa.azuf -offvalue N -onvalue Y -text [mc "Sulfur"] -font {Arial 9 {bold roman}} -variable "GUI::${base}(phS)"]
		set flu [checkbutton $fa.flu -offvalue N -onvalue Y -text [mc "Fluorine"] -font {Arial 9 {bold roman}} -variable "GUI::${base}(phF)"]
		
		pack $label -padx 5 -pady 10 
		pack $oxig $nitro $azuf $flu -anchor w -padx 5
		
		#set fb [frame $framecent.fb -borderwidth 3 -bd 2 -relief groove]
		set label [Label $fa.l2 -activebackground #a0a0a0 -text [mc "Hydrogen Bond Length"] -font {Arial 11 {bold roman}} -relief flat -anchor center]
		pack $label -padx 5 -pady 3
		
		set fam [frame $fa.dist -borderwidth 3 -bd 2 -relief flat]
		set label [Label $fam.l3 -activebackground #a0a0a0 -text "<=" -font {Arial 11 {bold roman}} -relief flat]
		set dist [ LabelEntry $fam.dist -label [mc "Amstrongs"] -side right -justify right -width 15 -textvariable "GUI::${base}(phDist)"]
		
		pack $label $dist -side left -padx 15 -pady 5
		
		pack $fa -side left -fill both -expand 1
		pack $fam -side left -fill both -expand 1
		
		
		#frame inferior
		set framedown [frame $mainf.framedown -borderwidth 3 -bd 2 -relief raised]
		set butonayu [Button $framedown.ayuda -activebackground #a0a0a0 -helptext [mc "Help"] -image $Icon::ayudicon -text [mc "Help"]]
		set butonejec [Button $framedown.ok -activebackground #a0a0a0 -command "destroy $mainf" -helptext [mc "Run"] -image $Icon::okicon]
		
		pack $butonejec $butonayu -side right -fill x 
		#empaqueto las frames ppales
		pack $frameup -fill x
		pack $framecent -fill both -expand 1 -padx 4 -pady 4 
		pack $framedown -fill x
		focus $butonejec
		bind $mainf <KeyPress-Return> "destroy $mainf"
		bind $butonejec <Destroy> "GUI::manejadorPuentesHidrogeno $base"
		
		
		#parent .
		grab $mainf
		focus $mainf
		tkwait window $mainf
		grab release .
		focus .
		destroy $mainf
	}; #finproc
	
	proc manejadorPuentesHidrogeno { base } {
		upvar #0 GUI::$base gui
		
		set listaE [list]
		foreach {check elem} "$gui(phO) O $gui(phN) N $gui(phS) S $gui(phF) F" {
			puts $check
			if {$check == "Y"} {lappend listaE $elem}
		}
		
		#puts "VisorVTK::definirElemsFormanPH $gui(visor) $listaE $gui(phDist)"
		#VisorVTK::definirElemsFormanPH $gui(visor) $listaE $gui(phDist)
		VisorGL::cambiaModoPH $gui(visor) 1 $listaE $gui(phDist)
		if {[winfo exists $gui(mainPH)]} {destroy $gui(mainPH)}
		
	}; #finproc
	
#----------------------------------------------------------------------------------------------
#									-	CONFIGURACION   -
#----------------------------------------------------------------------------------------------		

	proc ventanaConfiguracion { base } {
		upvar #0 GUI::$base gui
		upvar #0 Conf::$gui(conf) config
		set mainf $gui(mainConfig)
		if {[winfo exists $mainf]} {destroy $mainf}
		
		toplevel $mainf
		wm title $mainf [mc "Properties"]
		#wm resizable $mainf 0 0
		
		#frame superior
		set frameup [frame $mainf.frameup]
		set label [Label $frameup.label -activebackground #a0a0a0 -text [mc "BrandyMolVer"] -font {Arial 18 {bold roman}} -relief flat -anchor center]
		#pack $label -side right
		
			
		#frame central
		set framecent [frame $mainf.framecent -borderwidth 3 -bd 2 -relief flat]
		
		
		#la frame central contendra un notebook de 2 pestañas
		set notebook [NoteBook $framecent.nb] 
		$notebook insert 0 directorios -text [mc "Folder"]
		$notebook insert 1 colores -text [mc "Color"]
		$notebook insert 2 preferencias -text [mc "Preferences"]
		$notebook insert 3 actualizar -text [mc "Update"]		
		
		#pestaña de directorios
		set dir [$notebook getframe directorios]
		
		
		#set f1 [frame $dir.f1 -borderwidth 3 -bd 2 -relief groove]
		set label1 [Label $dir.l1 -activebackground #a0a0a0 -text [mc "Folder"] -font {Arial 13 {bold roman}} -relief flat -anchor center]
		pack $label1 -padx 10 -pady 10
		
		
		#directorios
		#directorio de datos
		set d1 [frame $dir.d1 -borderwidth 3 -bd 2 -relief groove]
		set ldata [Label $d1.l1 -activebackground #a0a0a0 -text [mc "Folder Data"] -font {Arial 10 {bold roman}} -relief flat -anchor center]
		set gui(dirData) $config(dirData)
		set ldirdata [Label $d1.l2 -activebackground #a0a0a0 -textvariable "GUI::${base}(dirData)" -font {Arial 8 {bold roman}} -relief flat -anchor center]
		
		
		set b1 [Button $d1.b1 -activebackground #a0a0a0 -command "GUI::manejadorCambiarDirData $base $ldirdata" -helptext [mc "Folder Data Choose"] -image $Icon::diricon]
		pack $ldata -side left
		pack $b1 -side right
		pack $ldirdata -side right
		
		
		#directorio de ejecutables
		set d2 [frame $dir.d2 -borderwidth 3 -bd 2 -relief groove]
		set lbin [Label $d2.l1 -activebackground #a0a0a0 -text [mc "Folder Exec"] -font {Arial 10 {bold roman}} -relief flat -anchor center]
		set ldirbin [Label $d2.l2 -activebackground #a0a0a0 -text $config(dirBin) -font {Arial 8 {bold roman}} -relief flat -anchor center]
		pack $lbin -side left
		pack $ldirbin -side right
		
		#directorio chm
		set d3 [frame $dir.d3 -borderwidth 3 -bd 2 -relief groove]
		set lchm [Label $d3.l1 -activebackground #a0a0a0 -text [mc "Folder CHM"] -font {Arial 10 {bold roman}} -relief flat -anchor center]
		set ldirchm [Label $d3.l2 -activebackground #a0a0a0 -text $config(dirCHM) -font {Arial 8 {bold roman}} -relief flat -anchor center]
		pack $lchm -side left
		pack $ldirchm -side right
		
		#directorio temp
		set d4 [frame $dir.d4 -borderwidth 3 -bd 2 -relief groove]
		set ltemp [Label $d4.l1 -activebackground #a0a0a0 -text [mc "Folder Temp"] -font {Arial 10 {bold roman}} -relief flat -anchor center]
		set ldirtemp [Label $d4.l2 -activebackground #a0a0a0 -text $config(dirTemp) -font {Arial 8 {bold roman}} -relief flat -anchor center]
		pack $ltemp -side left
		pack $ldirtemp -side right
		

		pack $d1 $d2 $d3 $d4 -fill x -expand 1
		
		
		
		#pestaña de colores
		set col [$notebook getframe colores]
		
		set label2 [Label $col.l2 -activebackground #a0a0a0 -text [mc "Color"] -font {Arial 13 {bold roman}} -relief flat -anchor center]
		pack $label2 -padx 10 -pady 10
		
		set framecol [frame $col.framecol -borderwidth 3 -bd 2 -relief groove]
		set fcol [frame $framecol.fcol -borderwidth 3 -bd 2 -relief flat]
		set lbcolors [listbox $fcol.lbcol -width 12	-yscrollcommand "$fcol.scrollb set"]
		set gui(listBoxColors) $lbcolors
		#bind $lb3d <ButtonRelease-1> "GUI::seleccionListBoxMRF $base" 
		set sbc [scrollbar $fcol.scrollb -command "$fcol.lbcol yview"]
		pack $lbcolors $sbc -side left -fill y -pady 5
		
		#set color [Label $fcol.lab -bg white -bd white -disabledforeground white -fg white -highlightbackground white -highlightcolor white -borderwidth 3 -bd 2 -relief groove]
		set color [Label $fcol.lab -bg white -borderwidth 3 -bd 2 -relief groove]
		set gui(labelColor) $color
		pack $color -side left -fill both -expand 1 -padx 25 -pady 25
		
		
		#inicializo la listbox
		set gui(elementos) 	"Ce B Pr C Yb Ir Ra Rb Br Pt F Re Cl H I Co Rh K La Sb Cr Cs N Sc O Rn P Cu Se S Si U Ta\
					  Li Kr Tb V W Tc Ru Sm Zn Te Sn Y Fe Mg Zr Th Sr Ti Dy Na Er Nb Ga Tl Tm Lu Nd Eu Mn Ne\
					  Gd Mo Ge Ni Fr Ac He Hf Hg Ag Pa Pb Ba Pd Al Be Ho Os Ar Bi As Ca Xe Pm At Au Cd In Po"
		set gui(elementos) [lsort $gui(elementos)]
		set gui(colores) [list]
		foreach e $gui(elementos) {$lbcolors insert end $e; lappend gui(colores) $config(colorSimb,$e)}
		bind $lbcolors <ButtonRelease-1> "GUI::seleccionListBoxColors $base"
		bind $color <ButtonRelease-1> "GUI::cambiarColorConfig $base"
		
		$gui(listBoxColors) selection set 0
		$gui(labelColor) configure -bg [lindex $gui(colores) 0]
		
		
		pack $fcol -fill both -expand 1 -ipadx 5 -ipady 5
		
		#color etiquetas
		set fetq [frame $framecol.fetq -borderwidth 3 -bd 2 -relief flat]
		set label4 [Label $fetq.l4 -activebackground #a0a0a0 -text [mc "Color Label"] -font {Arial 10 {bold roman}} -relief flat -anchor center]
		set gui(colorEtq) $config(colorEtq)
		set coloretq [Label $fetq.lab -bg $config(colorEtq) -borderwidth 3 -bd 2 -relief groove]
		set gui(labelColorEtq) $coloretq
		bind $coloretq <ButtonRelease-1> "GUI::cambiarColorEtq $base"
		pack $label4 -side left
		pack $coloretq -side right -fill x -expand 1 -padx 23
		pack $fetq -side bottom -fill x -pady 5
		
		#color Fonfo
		set fbg [frame $framecol.fbg -borderwidth 3 -bd 2 -relief flat]
		set label4 [Label $fbg.l4 -activebackground #a0a0a0 -text [mc "Color Background"] -font {Arial 10 {bold roman}} -relief flat -anchor center]
		set gui(colorFondo) $config(colorFondo)
		set colorFondo [Label $fbg.lab -bg $config(colorFondo) -borderwidth 3 -bd 2 -relief groove]
		set gui(labelColorFondo) $colorFondo
		bind $colorFondo <ButtonRelease-1> "GUI::cambiarColorFondo $base"
		pack $label4 -side left
		pack $colorFondo -side right -fill x -expand 1 -padx 23
		pack $fbg -side bottom -fill x -pady 5
		
		
		
		
		pack $framecol -fill both -expand 1 -padx 5 -pady 5		
		
		
		#pestaña de preferencias
		set pref [$notebook getframe preferencias]
		
		#escala de la representacion en cpk
		set fcpk [frame $pref.cpk -borderwidth 3 -bd 2 -relief groove]
		set label5 [Label $fcpk.l1 -activebackground #a0a0a0 -text [mc "CPK Scale"] -font {Arial 10 {bold roman}} -relief flat -anchor center]
		set gui(scaleWCPK) [scale $fcpk.scale -orient horizontal -from 1 -to 50 -width 10 -resolution 0.1 -showvalue 1]
		$gui(scaleWCPK) set $gui(escalaCPK)
		pack $label5 -side left
		pack $gui(scaleWCPK) -fill x -expand 1 -side left
		pack $fcpk -fill both -pady 10
		
             
		#consola al inicio
		set fcon [frame $pref.con -borderwidth 3 -bd 2 -relief groove]
		set con [checkbutton $fcon.conchk -offvalue "hide" -onvalue "show" -text [mc "Show Console on Start"] -font {Arial 9 {bold roman}} -variable Conf::$gui(conf)(estadoConsola)]
		pack $con -side left
		pack $fcon -fill both -pady 10
		
		#idiomas
		set fichidiomas [glob -nocomplain "$config(dirCHM)*.msg"]
		foreach lan $fichidiomas {lappend idiomas [string toupper [file rootname [file tail $lan]]]}
		
		set flan [frame $pref.lan -borderwidth 3 -bd 2 -relief groove]
		set label6 [Label $flan.l1 -activebackground #a0a0a0 -text [mc "Language"] -font {Arial 10 {bold roman}} -relief flat -anchor center]
		set combolan [ComboBox $flan.combolan -textvariable Conf::$gui(conf)(idioma) -values $idiomas -width 15 -hottrack 1]
		#set con [checkbutton $fcon.conchk -offvalue "hide" -onvalue "show" -text "Mostrar la Consola al Iniciar" -font {Arial 9 {bold roman}} -variable Conf::$gui(conf)(estadoConsola)]
		pack $label6 -side left
		pack $combolan -fill x -expand 1 -side left
		pack $flan -fill both -pady 10
		
                #pestaña de actualizacion
		set act [$notebook getframe actualizar]
		set fact [frame $act.act -borderwidth 3 -bd 2 -relief groove]
		set label6 [Label $act.l6 -activebackground #a0a0a0 -text [mc "Update"] -font {Arial 13 {bold roman}} -relief flat -anchor center]
                set butonactual [Button $fact.actual -activebackground #a0a0a0 -command "GUI::descargarPRM $base" -helptext [mc "Update"] -text [mc "Update"]]
		set label7 [Label $fact.l7 -activebackground #a0a0a0 -text [mc "Update Text"] -relief flat -anchor center]	
                pack $label6 -padx 10 -pady 10
                pack $label7 $butonactual -side left -fill x 
		pack $fact -fill both -pady 10
		pack $notebook -fill both -expand 1
		$notebook raise directorios
                
                
                
		#frame inferior
		set framedown [frame $mainf.framedown -borderwidth 3 -bd 2 -relief raised]
		set butonayu [Button $framedown.ayuda -activebackground #a0a0a0 -helptext [mc "Help"] -image $Icon::ayudicon -text [mc "Help"]]
		set butonejec [Button $framedown.ok -activebackground #a0a0a0 -command "GUI::guardarPropiedades $base" -helptext [mc "Run"] -image $Icon::okicon]
		set butoncanc [Button $framedown.cancel -activebackground #a0a0a0 -command "destroy $mainf" -helptext [mc "Cancel"] -image $Icon::cancelicon -anchor center]
		
		pack $butonejec $butonayu $butoncanc -side right -fill x 
		#empaqueto las frames ppales
		pack $frameup -fill x
		pack $framecent -fill both -expand 1 -padx 4 -pady 4 
		pack $framedown -fill x
		focus $mainf

	}; #finproc

	proc manejadorCambiarDirData { base etq } {
		upvar #0 GUI::$base gui
		upvar #0 Conf::$gui(conf) config
		
		set filename [tk_chooseDirectory -parent $gui(mainConfig) -initialdir $config(dirDataOrig) -title [mc "Folder Data Choose"]]
		if {$filename != ""} {
			set gui(dirData) $filename
		}
	}; #finproc
	
	proc seleccionListBoxColors { base } {
		upvar #0 GUI::$base gui
		
		set index [$gui(listBoxColors) curselection]
		$gui(labelColor) configure -bg [lindex $gui(colores) $index]
	}; #finproc
	
	proc cambiarColorConfig { base } {
		upvar #0 GUI::$base gui
		
		set index [$gui(listBoxColors) curselection]
		set color [tk_chooseColor -parent $gui(mainConfig) -initialcolor [lindex $gui(colores) $index]]
		if {$color != ""} {
			set gui(colores) [lreplace $gui(colores) $index $index $color]
			$gui(labelColor) configure -bg $color
		}
	}; #finproc
	
	proc cambiarColorEtq { base } {
		upvar #0 GUI::$base gui
		
		set color [tk_chooseColor -parent $gui(mainConfig) -initialcolor $gui(colorEtq)]
		if {$color != ""} {
			set gui(colorEtq) $color
			$gui(labelColorEtq) configure -bg $color
		}
		
	}; #finproc
	
	proc cambiarColorFondo { base } {
		upvar #0 GUI::$base gui
		
		set color [tk_chooseColor -parent $gui(mainConfig) -initialcolor $gui(colorFondo)]
		if {$color != ""} {
			set gui(colorFondo) $color
			$gui(labelColorFondo) configure -bg $color
		}
		
	}; #finproc
	
	proc guardarPropiedades { base } {
		upvar #0 GUI::$base gui
		upvar #0 Conf::$gui(conf) config
		
		#asigno la escala cpk
		set gui(escalaCPK) [$gui(scaleWCPK) get]
		#VisorVTK::cambiarEscalaCPK $gui(visor) $gui(escalaCPK)
		VisorGL::cambiarEscalaCPK $gui(visor) $gui(escalaCPK)
		
		set dirData $gui(dirData)
		if {[string range $gui(dirData) end end ] != "/"} { append dirData / }
		
		VisorGL::cambiarColorFondo $gui(visor) $gui(colorFondo)
		
		Conf::crearFichConf $gui(conf) "$config(dirBin)conf.ini" "$config(dirBin)colors.ini" $dirData $gui(colorFondo) $gui(colorEtq) $gui(elementos) $gui(colores) $gui(escalaCPK) $config(estadoConsola) $config(idioma)
		destroy	$gui(mainConfig)
		tk_messageBox -type ok -title [mc "Information"] -message [mc "Changes the Next"]
		
	}; #finproc
        
	
        proc descargarPRM { base } {
		upvar #0 GUI::$base gui
		upvar #0 Conf::$gui(conf) config
                #descargo los ficheros PRM

                #PRIMERO LEO LOS FICHEROS DISPONIBLES EN EL SERVIDOR
                set sal [::http::geturl "http://personales.ya.com/gretor/descarga/actualiza/lista.txt" ]
                set textolist [::http::data $sal]
                #tk_messageBox -type ok -title "Información" -message "$textolist"
                #creo una lista con el fichero lista.txt
                set textolist [split $textolist "\n"]
                #para cada fichero lo copio en su sitio
                foreach ficha $textolist {
                  if { ![string match ".tcl" [file extension $ficha]] } {
                        #no es tcl lo copio a CHM son parametros
                        set dir $config(dirCHM)
                      } else {
                        #es tcl la extension debe ir a BIN
                        set dir $config(dirBin)
                      }
                
                  set valorfinal [open $dir$ficha w]
                  set sali [::http::geturl "http://personales.ya.com/gretor/descarga/actualiza/$ficha" -channel $valorfinal]
                tk_messageBox -type ok -title "Información" -message "Copiando $ficha"
                close $valorfinal
                }
        
        
        }; #finproc
#----------------------------------------------------------------------------------------------
#									-	ACERCA DE   -
#----------------------------------------------------------------------------------------------		
	
	proc acercaDe { base } {
		upvar #0 GUI::$base gui
		
		set mainf $gui(mainAcercaDe)
		if {[winfo exists $mainf]} {destroy $mainf}
		
		toplevel $mainf
		wm title $mainf [mc "Properties"]
		wm resizable $mainf 0 0
		wm overrideredirect $mainf 1
			
		#frame ppal
		set frameup [frame $mainf.frameup -borderwidth 3 -bd 2 -relief sunken]
		#imagen ppal
		set image [image create photo img_phantom -file "acercaDe.jpg"] 
		set limage [label $frameup.lb1 -image img_phantom -bg white]
		pack $limage
		
		
		#textos
		set framein1 [frame $limage.f1]
		set texto1 "         [mc "BrandyMolVer"] "
		set label1 [label $framein1.lab1 -text $texto1 \
	    -activebackground white -background white -relief flat -font {Arial 16 {bold italic}} -justify left]
		place $framein1 -x 10 -y 20
		pack $label1
		
		set framein2 [frame $limage.f2]
		set texto2 [mc "Authors"]
		set label2 [label $framein2.lab2 -text $texto2 \
	    -activebackground white -background white -relief flat -font {Arial 12 {bold italic}} -justify left]
		place $framein2 -x 10 -y 80
		pack $label2
		
		set framein3 [frame $limage.f3]
		set texto3 [mc "Authors2"]
		set label3 [label $framein3.lab2 -text $texto3 \
	    -activebackground white -background white -relief flat -font {Arial 7 {bold italic}} -justify left]
		place $framein3 -x 10 -y 200
		pack $label3
		
		set framein4 [frame $limage.f4]
		set texto4 [mc "Authors3"]
		set label4 [label $framein4.lab2 -text $texto4 \
	    -activebackground white -background white -relief flat -font {Arial 7 {bold italic}} -justify left]
		place $framein4 -x 10 -y 280
		pack $label4
		
		set framein5 [frame $limage.f5]
		set texto5 "Copyright(c) 2010"
		set label5 [label $framein5.lab2 -text $texto5 \
	    -activebackground white -background white -relief flat -font {Arial 9 {bold italic}} -justify left]
		place $framein5 -x 120 -y 360
		pack $label5
		

		pack $limage -side top
		

		set butAceptar [Button $mainf.ok -activebackground #a0a0a0 -command "destroy $mainf" -text [mc "Ok"] -relief flat]
		pack $butAceptar -side bottom -fill x
		
		pack $frameup
		
		#cerrar si se pulsa intro
		bind $mainf <KeyPress-Return> "destroy $mainf"
		
		BWidget::place $mainf 0 0 center
		grab $mainf
		focus $mainf
		tkwait window $mainf
		grab release .
		focus .
		destroy $mainf
		
	}; #finproc	
	
	proc manejadorHUD { base } {
		upvar #0 GUI::$base gui
		#if {$gui(hud) == 0 } {
		#	set gui(hud) 1
		#	VisorGL::cambiarModoHUD $gui(visor) 1
		#} else {
		#	set gui(hud) 0
			VisorGL::cambiarModoHUD $gui(visor) $gui(hud)
		#}
		VisorGL::render $gui(visor)
		
	}
	
}; #finnamespace
