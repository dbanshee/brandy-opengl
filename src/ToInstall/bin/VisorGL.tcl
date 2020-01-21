#######################################################################################################
#
#	AUTOR : OSCAR NOEL AMAYA GARCIA - 2008
#
#								- MODULO PARA EL MANEJO DE VISORES OpenGL -
#									 	  --------------------
# Cada visor sera manejado por una estructura que tomara un nombre base unico definido por el usuario
# 
#
#	Definido dentro del
#			namespace eval VisorGL
#
#	base(): array que representara la instancia del visor
#######################################################################################################


package require tcl3d


namespace eval VisorGL {
	
	proc newVisorGL { base baseConf } {
		if {[info exists VisorGL::$base]==0} {
			variable $base
			
			upvar #0 Conf::$baseConf config
			
			set ${base}(baseConf) $baseConf
			
			#GENERAL
			set ${base}(backColor) "0.1 0.2 0.4"
			
			#CAMARA
			set ${base}(camaraPos)		"0.0 0.0 5.0"
			set ${base}(camaraFocal) 	"0.0 0.0 0.0"
			set ${base}(camaraUp) 		"0.0 1.0 0.0"
			set ${base}(viewAngle) 		60.0
			set ${base}(zoomPersp)		1.0
			set ${base}(zoomParal)		1.0
			set ${base}(viewport) 		"650 500"
		#	set ${base}(BBActual)		"-1.0 1.0 -1.0 1.0 -1.0 1.0"
		#	set ${base}(radioFrustum)	1.0
			
			set ${base}(proyeccion)		0
			
			
			#RATON
			set ${base}(ratonPosAnt) 	"0 0"
			set ${base}(ratonPos) 		"0 0"
			
			#DATOS
			set ${base}(moleculas) 		[list]
			set ${base}(moleculasMostrar)	1
			
			
			#tcl3d
			set ${base}(vec3i) "0 0 0"
			set ${base}(vec4i) "0 0 0 0"
			set ${base}(vec3f) "0.0 0.0 0.0"
			set ${base}(vec4f) "0.0 0.0 0.0 1.0"
			set ${base}(vec4d) "0.0 0.0 0.0 1.0"
			
			set ${base}(mat16) "1.0 0.0 0.0 0.0 \
        					 0.0 1.0 0.0 0.0 \
        					 0.0 0.0 1.0 0.0 \
        					 0.0 0.0 0.0 1.0"
			set ${base}(mat16v) [list 	[list 1.0 0.0 0.0 0.0] \
					 		[list 0.0 1.0 0.0 0.0] \
					 		[list 0.0 0.0 1.0 0.0] \
					 		[list 0.0 0.0 0.0 1.0]]
			
			
			#INTERACCION
			set ${base}(modoAct) 				"rotar"
			set ${base}(SHIFT) 				0
			set ${base}(CTRL) 				0
			set ${base}(ratonIzqPuls) 			0
			set ${base}(ratonDchoPuls) 			0
			set ${base}(dobleClick) 			0
			set ${base}(ratonMov) 				0
			set ${base}(agregaSeleccion) 			0
			set ${base}(actorOpcMover) 			[list]
			set ${base}(ficheroSeleccionado)		[list]
			
			
			#ANIMACION
			set ${base}(idleId) 		0
			set ${base}(idleTick) 		20
			set ${base}(idleClockFrame1)	[clock microseconds ]
			set ${base}(idleClockFrame2)	[expr [clock microseconds ] +1]
			set ${base}(fpsMostrar)		0
			
			#OpenGL Display Lists
			set ${base}(useDisplayList)	 0
			set ${base}(molList) 		-1
			set ${base}(molListSelect) 	-1
			set ${base}(hudList) 		-1
			set ${base}(medidasList) 	-1
			set ${base}(etqList) 		-1
			set ${base}(phList) 		-1
			set ${base}(ejesList) 		-1
			set ${base}(orbitalList)	-1
			set ${base}(cuboList)		-1
			set ${base}(seleccionList)	-1
			set ${base}(rotacionList)	-1
			set ${base}(displaysOrbitales) [list]
			
			
	
			#CAMBIOS
			set ${base}(molModificadas) 		0
			set ${base}(molModificadasSelect) 	0
			set ${base}(hudModificada)		0
			set ${base}(medidasModificadas) 	0
			set ${base}(etqModificadas) 		0
			set ${base}(phModificados) 		0
			set ${base}(seleccionModificadas)	0
			set ${base}(rotacionModificadas)	0
			
			#SELECCION
			set ${base}(colorSeleccion) 		"1.0 0.92 0.0"
			set ${base}(rectanguloSeleccion) 	0
			set ${base}(posInicioSeleccion) 	"0 0"
			set ${base}(posFinSeleccion) 		"0 0"
			
			#MOVIMIENTO MOLECULAS
			set ${base}(posInicioMovimiento) 	"0 0"
			set ${base}(posFinMovimiento) 		"0 0"
			set ${base}(moverSeleccion)		"0.0 0.0 0.0"
			
			#ROTACION MOLECULAS
			set ${base}(listaMolRotar)		[list]
			set ${base}(matrizRotar)		[list 	[list 1.0 0.0 0.0 0.0] \
					 				[list 0.0 1.0 0.0 0.0] \
					 				[list 0.0 0.0 1.0 0.0] \
					 				[list 0.0 0.0 0.0 1.0]]
			
			
			
			#REPRESENTACION
			set ${base}(radioAtC) 		0.071
			set ${base}(radioAtCB) 		0.2
			#set ${base}(radioAtCPK) 	1.5		
			set ${base}(wireframe) 		0
			set ${base}(resolucion) 	10
			set ${base}(escalaCPK) 		$config(escalaCPK)
			
			#MEDIDAS
			set ${base}(atomosMedidas) 	[list]
			set ${base}(distancias) 	[list]
			set ${base}(angulos) 		[list]
			set ${base}(torsiones) 		[list]

			
			#EDICION
			set ${base}(moverAtomos) 	0
			set ${base}(listaMoverAtomos) 	[list]
			
			#ETIQUETAS
			set ${base}(etqId) 		0
			set ${base}(etqCodB) 		0
			set ${base}(etqCarga) 		0
			set ${base}(etqCodTink) 	0
			set ${base}(etqQuira) 		0
			

			
			#PUENTES DE HIDROGENO
			set ${base}(listaPuentesH) 	[list]
			set ${base}(elemsPuentesH) 	[list O H]
			set ${base}(distPuentesH) 	3
			set ${base}(phMostrar) 		0
			
			#orbitales
			set ${base}(orbitalMostrado)	-1
			#set ${base}(modoRepOrbital)	GL_
			set ${base}(modoTranspOrbital)	0
			set ${base}(modoRepOrbital)	2
			
			
			#HUD
			set ${base}(hudMostrar)		1
			
			
			#Ejes
			set ${base}(ejesMostrar)	1
			
			
			#ANIMACION PRESENTACION
			set ${base}(presentacion)	0
			set ${base}(speedPres)		0.0
			set ${base}(progressPres)	1.0
			
			
			return 0
		} else {
			return -1
		}
	}; #finproc
	
	proc delVisorGL { base } {
		upvar #0 VisorGL::$base visor
		
		if {[array exists visor]} {
			#borrar todas las reservas de memoria
			
			unset visor
		}
	}; #finproc
	
	proc inicializarVisorGL { base w } {
		upvar #0 VisorGL::$base visor
		
		set visor(togl) $w
		
		if {$visor(presentacion) == 0 } {
			$visor(togl) configure 	-width [lindex $visor(viewport) 0] -height [lindex $visor(viewport) 1] \
						-displayproc "VisorGL::displayVisorGL $base"  \
						-reshapeproc "VisorGL::reshapeVisorGL $base"  \
						-double true \
						-depth true
			#inicializo fuentes
        		set visor(fontText3D) [$w loadbitmapfont [format "-*-%s-%s-%s-*-*-%d-*-*-*-*-*-*-*" "Verdana" "ibold" "r" 10]]
        		set visor(fontText2D) [$w loadbitmapfont [format "-*-%s-%s-%s-*-*-%d-*-*-*-*-*-*-*" "HandelGotDLig" "bold" "r" 15]]
        		
        		glClearColor [lindex $visor(backColor) 0] [lindex $visor(backColor) 1] [lindex $visor(backColor) 2] 0
        		glEnable GL_DEPTH_TEST
			
			glEnable GL_COLOR_MATERIAL
			
			glBlendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
			establecerLuces $base
			reshapeVisorGL $base $visor(togl) [lindex $visor(viewport) 0] [lindex $visor(viewport) 1]
			
			
			#cargarOrbital v "BORB.VTK"
			#cambiarModoTransparenciaOrbital 1
			
		} else {
			$visor(togl) configure 	-width [lindex $visor(viewport) 0] -height [lindex $visor(viewport) 1] \
						-displayproc "VisorGL::displayVisorGLPres $base" \
						-reshapeproc "VisorGL::reshapeVisorGLPres $base" \
						-double true \
						-depth true
			
			set lightpos { 1.0 1.0 1.0 0.0 }
			set lightamb { 0.3 0.3 0.9 1.0 }
			set lightdif { 0.9 0.9 0.8 1.0 }
			
			glShadeModel GL_SMOOTH
			glEnable GL_DEPTH_TEST
			glLightfv GL_LIGHT0 GL_POSITION $lightpos
			glLightfv GL_LIGHT0 GL_AMBIENT $lightamb
			glLightfv GL_LIGHT0 GL_DIFFUSE $lightdif
		
			
			glEnable GL_LIGHTING
			glEnable GL_LIGHT0
			glColor3f 1.0 1.0 1.0
			glClearColor 0.0 0.0 0.0 1.0
			glPolygonMode GL_FRONT_AND_BACK GL_FILL
			glEnable GL_NORMALIZE
			tcl3dOglLogoDefine
			glCullFace GL_BACK
			glEnable GL_CULL_FACE
			
			tcl3dOglLogoRandomize
		}
		
	}
	
	
	
	proc establecerLuces { base } {
		upvar #0 VisorGL::$base visor
		
		
		set ambient 		{ 0.0 0.0 0.0 1.0 }
		set diffuse 		{ 1.0 1.0 1.0 1.0 }
		set specular 		{ 1.0 1.0 1.0 1.0 }
		set lmodel_ambient 	{ 0.4 0.4 0.4 1.0 }
		set local_view 		{ 1.0 }
		
		#set position { 0.0 3.0 2.0 0.0 }
		#set position2 { 0.0 -3.0 -2.0 0.0 }
		
		
		set position 	{ 0.0 0.0 100.0 0.0 }
		set position2 	{ 0.0 0.0 -100.0 0.0 }
		set position3 	{ 0.0 -3.0 -2.0 0.0 }
		set position4 	{ 0.0 -3.0 -2.0 0.0 }
		
		
		glLightfv GL_LIGHT0 GL_AMBIENT $ambient
		glLightfv GL_LIGHT0 GL_DIFFUSE $diffuse
		glLightfv GL_LIGHT0 GL_POSITION $position
		
		
		glLightfv GL_LIGHT1 GL_AMBIENT $ambient
		glLightfv GL_LIGHT1 GL_DIFFUSE $diffuse
		glLightfv GL_LIGHT1 GL_POSITION $position2

		glLightModelfv GL_LIGHT_MODEL_AMBIENT $lmodel_ambient
		glLightModelfv GL_LIGHT_MODEL_LOCAL_VIEWER $local_view
	 
		glEnable GL_LIGHTING
		glEnable GL_LIGHT0
		glEnable GL_LIGHT1
		
	}
	
	proc cambiarModoLuz { base luz modo } {
		
		if { $modo == 0 } {
			glEnable "GL_LIGHT$luz"
		} else {
			glDisable "GL_LIGHT$luz"
		}
	}
	
	
	proc establecerMateriales { base } {
		
		set color_difuso_ambiente { 0.1 0.0 0.8 1.0 }
		set color_especular {0.5 0.5 0.5 0.5}
		set brillo_specular_suave {5.0} 
		
		glMaterialfv GL_FRONT GL_AMBIENT_AND_DIFFUSE $color_difuso_ambiente
		glMaterialfv GL_FRONT GL_SPECULAR $color_especular
		glMaterialfv GL_FRONT GL_SHININESS $brillo_specular_suave
	}
	
	proc displayVisorGL { base w } {
		upvar #0 VisorGL::$base visor 
		
		#set visor(camaraFocal) 	"-4.79173374 -4.81841993 -4.11713028"
		glMatrixMode GL_PROJECTION
		glLoadIdentity
		
		
		#proyeccion perspectiva
		if { $visor(proyeccion) == 0 } {
			gluPerspective [expr $visor(viewAngle)*$visor(zoomPersp)] [expr double([lindex $visor(viewport) 0])/double([lindex $visor(viewport) 1])] 0.2 100.0			
		} else {		
			set rel double([lindex $visor(viewport) 1])/double([lindex $visor(viewport) 0])
			glOrtho [expr -4.0*$visor(zoomParal)] \
				[expr 4.0*$visor(zoomParal)] \
				[expr -4.0*$visor(zoomParal)*$rel] \
				[expr 4.0*$visor(zoomParal)*$rel] \
				0.1 100.0					
		}
		
		
		gluLookAt 	[lindex $visor(camaraPos) 0] 	[lindex $visor(camaraPos) 1] 	[lindex $visor(camaraPos) 2] \
				[lindex $visor(camaraFocal) 0] 	[lindex $visor(camaraFocal) 1] 	[lindex $visor(camaraFocal) 2] \
				[lindex $visor(camaraUp) 0] 	[lindex $visor(camaraUp) 1] 	[lindex $visor(camaraUp) 2]
		
		glMatrixMode GL_MODELVIEW
		glLoadIdentity
		#glClearColor 0.1 0.2 0.4 0
		glClearColor [lindex $visor(backColor) 0] [lindex $visor(backColor) 1] [lindex $visor(backColor) 2] 0
		glClear [expr $::GL_COLOR_BUFFER_BIT | $::GL_DEPTH_BUFFER_BIT]
		
		establecerMateriales $base
		
		
		#Moleculas
		if { $visor(molModificadas) == 1 || $visor(molList) == -1 } {
			crearDisplayListMol $base
			set visor(molModificadas) 0
		}
		if {$visor(moleculasMostrar) == 1 } {
			glCallList $visor(molList)
		}
		
		#Selecciones Multiples para traslaciones
		if { $visor(seleccionModificadas) == 1 } {
			set visor(seleccionModificadas) 0
			crearDisplayListSeleccion $base
		}
		
		
		if { $visor(listaMoverAtomos) != [list] && $visor(ratonIzqPuls) == 1 } {	
			glPushMatrix
			glTranslatef [lindex $visor(moverSeleccion) 0] [lindex $visor(moverSeleccion) 1] [lindex $visor(moverSeleccion) 2] 
			glCallList $visor(seleccionList)
			glPopMatrix
		}
		
		
		#Selecciones moleculares para rotaciones
		if { $visor(rotacionModificadas) == 1 } {
			set visor(rotacionModificadas) 0
			crearDisplayListRotacion $base
		}
		if {$visor(listaMolRotar) != [list]} {
			glPushMatrix
			glMultTransposeMatrixd [join $visor(matrizRotar)]
			glCallList $visor(rotacionList)
			glPopMatrix
		}
		
		#Orbitales
		#if { $visor(orbitalList) == -1 } {
		#	set visor(orbitalList) [glGenLists 1]
		#	glNewList $visor(orbitalList) GL_COMPILE
			#dibujarMoleculasSelect $base $visor(baseConf)
		#	leerFichMaya "salida"
		#	pintaNormalesFicheroMaya "salida"
			
			#leerFichMaya "esferanormales"
			#pintaNormalesFicheroMaya "esferanormales"
			
		#	glEndList
			
		#}
		#glCallList $visor(orbitalList)
		
		if {$visor(orbitalMostrado) != -1} {
			set dl [lindex $visor(displaysOrbitales) $visor(orbitalMostrado)]
			glPolygonMode GL_FRONT_AND_BACK $visor(modoRepOrbital)
			glCallList $dl
			glPolygonMode GL_FRONT_AND_BACK GL_FILL
		}


		#Medidas
		if { $visor(medidasModificadas) == 1 || $visor(medidasList) == -1 } {
			crearDisplayListMedidas $base
			set visor(medidasModificadas) 0
		}
		glCallList $visor(medidasList)
	   
		#Hud
		if { $visor(hudModificada) == 1 || $visor(hudList) == -1 } {
			crearDisplayListHud $base
			set visor(hudModificada) 0
		}
		if { $visor(hudMostrar) == 1 } {
			glCallList $visor(hudList)
		}
		
		#Etiquetas
		if { $visor(etqModificadas) == 1 || $visor(etqList) == -1 } {
			crearDisplayListEtiquetas $base
			set visor(etqModificadas) 0
		}
		glCallList $visor(etqList)
		
		
		#Puentes de hidrogeno
		if {$visor(phMostrar)} {
			if {$visor(phModificados) || $visor(phList) == -1} {
				crearDisplayListPH $base
				set visor(phModificados) 0
			}
			glCallList $visor(phList)
		} 
		
		
		if { $visor(cuboList) == -1 } {
			set visor(cuboList) [glGenLists 1]
			glNewList $visor(cuboList) GL_COMPILE
			#dibujarMoleculasSelect $base $visor(baseConf)
			pintaCubo2 $base
			glEndList
			
		}
		#glCallList $visor(cuboList)
		
		
		if {$visor(ejesMostrar)} {
			dibujarEjesComplejosPosicion $base 0 [lindex $visor(viewport) 1]
		}
		

	  
		if { $visor(rectanguloSeleccion) == 1 } {
			dibujarRectanguloSeleccion $base $visor(posInicioSeleccion) $visor(posFinSeleccion)
		}

		#pintarEjes $base
		#pintarEjesComplejos $base
		#escribirCad3D $base "0.0 0.0 0.0" "0.0 1.0 0.0" "Origen"
		#escribirCad3D $base "[lindex $visor(camaraFocal) 0] [lindex $visor(camaraFocal) 1] [lindex $visor(camaraFocal) 2]" "0.0 1.0 0.0" "Focal"
		
		if { $visor(fpsMostrar) == 1 } {
			escribirCad2D $base "10 70" "0.0 1.0 0.0" "   FPS : [expr 1000000 / ($visor(idleClockFrame2) - $visor(idleClockFrame1))]"
		}
		#
		
		#pintaCubo2 $base
		#pintarSuperficieIsovalor 4
		
		$w swapbuffers
		glFinish
	}
	
	proc displayVisorGLPres { base w } {
		upvar #0 VisorGL::$base visor
		
		#glClearColor [lindex $visor(backColor) 0] [lindex $visor(backColor) 1] [lindex $visor(backColor) 2] 0
		#glClearColor 1.0 1.0 1.0 0.0
		glClear [expr $::GL_COLOR_BUFFER_BIT | $::GL_DEPTH_BUFFER_BIT]
		glViewport 0 0 [lindex $visor(viewport) 0] [lindex $visor(viewport) 1]

		setCameraPres $base
		#tcl3dOglLogoDraw [expr max(0, $visor(progressPres))]
		tcl3dOglLogoDraw $visor(progressPres)
		glFlush
		
		$w swapbuffers
	}
	
	
	proc render { base } {
		upvar #0 VisorGL::$base visor
		 $visor(togl) postredisplay
	}
	
	#------------------------------------ DISPLAY LISTS ---------------------------------------
	
	proc crearDisplayListMol { base } {
		upvar #0 VisorGL::$base visor
		if { $visor(molList) != -1 } {
			glDeleteLists $visor(molList) 1
		}
		set visor(molList) [glGenLists 1]
		glNewList $visor(molList) GL_COMPILE
		dibujarMoleculas $base $visor(baseConf)
		glEndList
	}
	
	proc delDisplayListMol { base } {
		upvar #0 VisorGL::$base visor
		glDeleteLists $visor(molList) 1
		set visor(molList) -1
	}
	
	proc crearDisplayListSeleccion { base } {
		upvar #0 VisorGL::$base visor
		if { $visor(seleccionList) != -1 } {
			glDeleteLists $visor(seleccionList) 1
		}
		set visor(seleccionList) [glGenLists 1]
		glNewList $visor(seleccionList) GL_COMPILE
		dibujarSeleccion $base
		glEndList
		
	}
	
	proc delDisplayListSeleccion { base } {
		upvar #0 VisorGL::$base visor
		glDeleteLists $visor(seleccionList) 1
		set visor(seleccionList) -1
	}
	
	proc crearDisplayListRotacion { base } {
		upvar #0 VisorGL::$base visor
		if { $visor(rotacionList) != -1 } {
			glDeleteLists $visor(rotacionList) 1
		}
		if { $visor(listaMolRotar) != [list]} {
        		set visor(rotacionList) [glGenLists 1]
        		glNewList $visor(rotacionList) GL_COMPILE
			glEnable GL_BLEND
        		foreach mol $visor(listaMolRotar) {
				dibujarMolecula $base $mol $visor(baseConf)
        		}
			glDisable GL_BLEND
        		#dibujarSeleccion $base
        		glEndList
		}
	}
	
	proc delDisplayListRotacion { base } {
		upvar #0 VisorGL::$base visor
		glDeleteLists $visor(rotacionList) 1
		set visor(rotacionList) -1
	}
	
	proc crearDisplayListMolSelect { base } {
		upvar #0 VisorGL::$base visor
		if { $visor(molListSelect) != -1 } {
			glDeleteLists $visor(molListSelect) 1
		}
		set visor(molListSelect) [glGenLists 1]
		glNewList $visor(molListSelect) GL_COMPILE
		dibujarMoleculasSelect $base $visor(baseConf)
		glEndList
	}
	
	proc delDisplayListMolSelect { base } {
		upvar #0 VisorGL::$base visor
		glDeleteLists $visor(molListSelect) 1
		set visor(molListSelect) -1
	}
	
	proc crearDisplayListHud { base } {
		upvar #0 VisorGL::$base visor
		if { $visor(hudList) != -1 } {
			glDeleteLists $visor(hudList) 1
		}
		set visor(hudList) [glGenLists 1]
		glNewList $visor(hudList) GL_COMPILE
		dibujarHud $base
		glEndList
	}
	
	proc delDisplayListHud { base } {
		upvar #0 VisorGL::$base visor
		glDeleteLists $visor(hudList) 1
		set visor(hudList) -1
	}
	
	proc crearDisplayListMedidas { base } {
		upvar #0 VisorGL::$base visor
		if { $visor(medidasList) != -1 } {
			glDeleteLists $visor(medidasList) 1
		}
		set visor(medidasList) [glGenLists 1]
		glNewList $visor(medidasList) GL_COMPILE
		dibujarMedidas $base
		glEndList
	}
	
	proc delDisplayListMedidas { base } {
		upvar #0 VisorGL::$base visor
		glDeleteLists $visor(medidasList) 1
		set visor(medidasList) -1
	}
	
	proc crearDisplayListEtiquetas { base } {
		upvar #0 VisorGL::$base visor
		if { $visor(etqList) != -1 } {
			glDeleteLists $visor(etqList) 1
		}
		set visor(etqList) [glGenLists 1]
		glNewList $visor(etqList) GL_COMPILE
		dibujarEtiquetas $base
		glEndList
	}
		
	proc delDisplayListEtiquetas { base } {
		upvar #0 VisorGL::$base visor
		glDeleteLists $visor(etqList) 1
		set visor(etqList) -1
	}

	proc crearDisplayListPH { base } {
		upvar #0 VisorGL::$base visor
		if { $visor(phList) != -1 } {
			glDeleteLists $visor(phList) 1
		}
		set visor(phList) [glGenLists 1]
		glNewList $visor(phList) GL_COMPILE
		crearPuentesH $base
		dibujarPuentesH $base
		glEndList
	}
		
	proc delDisplayListPH { base } {
		upvar #0 VisorGL::$base visor
		glDeleteLists $visor(phList) 1
		set visor(phList) -1
	}
	
	#Estos displayList no necesitan ser modificados
	proc crearDisplayListEjes { base } {
		upvar #0 VisorGL::$base visor
		if { $visor(ejesList) != -1 } {
			glDeleteLists $visor(ejesList) 1
		}
		set visor(ejesList) [glGenLists 1]
		glNewList $visor(ejesList) GL_COMPILE
		dibujarEjesComplejos $base
		glEndList
	}
	
	proc delDisplayListEjes { base } {
		upvar #0 VisorGL::$base visor
		glDeleteLists $visor(ejesList) 1
		set visor(ejesList) -1
	}
	
	
	
	proc cargarOrbital { base filename } {
		upvar #0 VisorGL::$base visor
		
		#esta funcion es de Dll, no un procedimiento Tcl
		cargarFicheroOrbital $filename
		
		
		cargarDisplaysListsOrbital $base
		
		set visor(orbitalMostrado) 5 
		
	}
	
	proc cargarDisplaysListsOrbital { base } {
		upvar #0 VisorGL::$base visor
		
		#elimino los displayLists anteriores
		foreach dl $visor(displaysOrbitales) {
			if {$dl != -1 } {
				glDeleteLists $dl 1
			}
		}
		set visor(displaysOrbitales) [list]
		
		#creo los display Lists
		for {set x 0} {$x <= 254} {incr x} {
			#set fn [list $filenameBase]_$x
			
			#display
			set dl [glGenLists 1]
			lappend visor(displaysOrbitales) $dl
			glNewList $dl GL_COMPILE
			#leerFichMaya $fn
			pintarSuperficieIsovalorOrbital $x
			glEndList
			
			#end display
		}
		
	}
	
	proc cambiarRepresentacionOrbital { base modo } {
		upvar #0 VisorGL::$base visor
		
		cambiarModoRepresentacionOrbital $modo
		cargarDisplaysListsOrbital $base
		set visor(modoRepOrbital) $modo
	}
	
	proc cambiarTransparenciaOrbital { base modo } {
		upvar #0 VisorGL::$base visor
		
		cambiarModoTransparenciaOrbital $modo
		cargarDisplaysListsOrbital $base
		set visor(modoTranspOrbital) $modo
	}
	
	proc devuelveTransparenciaOrbital { base } {
		upvar #0 VisorGL::$base visor
		return $visor(modoTranspOrbital)
	}
		
	proc cambiarOrbitalMostrado { base orbital } {
		upvar #0 VisorGL::$base visor
		if {$orbital >= 0 && $orbital < [llength $visor(displaysOrbitales)]} {
			set visor(orbitalMostrado) $orbital
			render $base
		}
		
	}	
	
	
	
	
	#-----------------------------------------------------------------------------
	
	proc reshapeVisorGL { base toglwin w h } {
		upvar #0 VisorGL::$base visor
		
		set visor(viewport) "$w $h"
		glViewport 0 0 $w $h
		set visor(hudModificada) 1
		$toglwin postredisplay
	}
	
	proc reshapeVisorGLPres { base toglwin w h } {
		glMatrixMode GL_MODELVIEW
		glViewport 0 0 $w $h
		glLoadIdentity
		setCameraPres $base
		$toglwin postredisplay
        
            #set ::g_WinWidth  $w
            #set ::g_WinHeight $h
	}
	
	proc idle { base } {
		upvar #0 VisorGL::$base visor
		camaraAzimuth $base 3
		$visor(togl) postredisplay
		set visor(idleClockFrame1) $visor(idleClockFrame2)
		set visor(idleClockFrame2) [clock microseconds]
		#set visor(idleId) [after $visor(idleTick) "VisorGL::idle $base"]
		set visor(idleId) [after idle "VisorGL::idle $base"]
	}
	
	proc startIdle { base } {
		upvar #0 VisorGL::$base visor
		set visor(fpsMostrar) 1
		idle $base
	}
	
	proc stopIdle { base } {
		upvar #0 VisorGL::$base visor
		after cancel $visor(idleId)
		set visor(idleId) 0
		set visor(fpsMostrar) 0

	}
	
	proc enablePresentation { base } {
		upvar #0 VisorGL::$base visor
		set visor(presentacion) 1
	}
	
	proc startPresentation { base } {
		upvar #0 VisorGL::$base visor
		

		set visor(presentacion) 1

		
		set visor(speedPres) [expr -0.995 * $visor(speedPres) + $visor(progressPres) * 0.005]
                if { $visor(progressPres) > 0.0 && $visor(speedPres) < 0.000005 } {
                    set visor(speedPres) 0.000005
                }
                if { $visor(speedPres) > 0.0005 } {
                    set visor(speedPres) 0.0005
                }
		
		#set visor(speedPres) [expr -0.95 * $visor(speedPres) + $visor(progressPres) * 0.05]
                #if { $visor(progressPres) > 0.0 && $visor(speedPres) < 0.0003 } {
                #    set visor(speedPres) 0.003
                #}
                #if { $visor(speedPres) > 0.01 } {
                #    set visor(speedPres) 0.01
                #}
		
		
                set visor(progressPres) [expr $visor(progressPres) - $visor(speedPres)]
                
		#set visor(progressPres) [expr $visor(progressPres) - 0.0007]
		
		if { $visor(progressPres) < 0.0 } {
			#set visor(progressPres) 0.0
			set visor(speedPres) 0.1
			
			set visor(speedPres) 0.0
			set visor(presentacion) 0
                }
		#after 5
		
		#puts "Progress : $visor(progressPres)"
		#puts "Speed : $visor(speedPres)"
		#puts "Presentacion : $visor(presentacion)"
		#puts ""
		
		
                $visor(togl) postredisplay
		if { $visor(presentacion) == 1 } {
                	after idle "VisorGL::startPresentation $base"
		} else { 
			inicializarVisorGL $base $visor(togl)
		}
   	}
	
	
	#pinta unos ejes de coordenadas
	proc pintarEjes { base } {
		upvar #0 VisorGL::v visor
		glPushMatrix
		glLoadIdentity
	
		glDisable GL_LIGHTING	
		set quadObj [gluNewQuadric]
		
		#eje Z
		glColor3f 0.0 0.0 1.0 
		#gluCylinder $quadObj 0.07 0.07 1 15 1
		
		#eje X
		glRotated 90 0.0 1.0 0.0
		glColor3f 1.0 0.0 0.0 
		#gluCylinder $quadObj 0.07 0.07 1 15 1
		
		#eje Y 
		glLoadIdentity
		glRotated -90 1.0 0.0 0.0
		#glRotated 90 0.0 0.0 1.0
		glColor3f 0.0 1.0 0.0 
		#gluCylinder $quadObj 0.07 0.07 1 15 1
		
		gluDeleteQuadric $quadObj
		
		
		#conos para las puntas de las flechas
		
		glLoadIdentity
		
		#ejeZ
		glTranslatef 0.0 0.0 1.0
		#glutSolidCone 0.1 3.0 40 40

		#ejeX
		glTranslatef 1.0 0.0 -1.0
		#glRotatef 
		#glutSolidCone 0.1 3.0 40 40
		
		
		#ejes verdaderos
		glLoadIdentity
		glBegin GL_LINES
			glColor3f 1.0 0.0 0.0
			glVertex3f 0.0 0.0 0.0
			glVertex3f 1.0 0.0 0.0
		
			glColor3f 0.0 1.0 0.0
			glVertex3f 0.0 0.0 0.0
			glVertex3f 0.0 1.0 0.0
			
			glColor3f 0.0 0.0 1.0
			glVertex3f 0.0 0.0 0.0
			glVertex3f 0.0 0.0 1.0
		
		glEnd
		
		
		#ejes en el focal
		glLoadIdentity
		glBegin GL_LINES
			glColor3f 1.0 0.0 0.0
			glVertex3f [lindex $visor(camaraFocal) 0] [lindex $visor(camaraFocal) 1] [lindex $visor(camaraFocal) 2]
			glVertex3f [expr 1 + [lindex $visor(camaraFocal) 0]] [lindex $visor(camaraFocal) 1] [lindex $visor(camaraFocal) 2]
		
			glColor3f 0.0 1.0 0.0
			glVertex3f [lindex $visor(camaraFocal) 0] [lindex $visor(camaraFocal) 1] [lindex $visor(camaraFocal) 2]
			glVertex3f [lindex $visor(camaraFocal) 0] [expr 1 + [lindex $visor(camaraFocal) 1]] [lindex $visor(camaraFocal) 2]
			
			glColor3f 0.0 0.0 1.0
			glVertex3f [lindex $visor(camaraFocal) 0] [lindex $visor(camaraFocal) 1] [lindex $visor(camaraFocal) 2]
			glVertex3f [lindex $visor(camaraFocal) 0] [lindex $visor(camaraFocal) 1] [expr 1 + [lindex $visor(camaraFocal) 2]]
		
		glEnd
		
		
		glPopMatrix
		
		glEnable GL_LIGHTING
	}
	
	
	proc dibujarEjesComplejos { base } {
		upvar #0 VisorGL::$base visor
		
		escribirCad3D $base "1.4 0.0 0.0" "1.0 1.0 1.0" "X"
		escribirCad3D $base "0.0 1.4 0.0" "1.0 1.0 1.0" "Y"
		escribirCad3D $base "0.0 0.0 1.4" "1.0 1.0 1.0" "Z"
	
		set color_difuso_ambiente { 0.1 0.0 0.8 1.0 }
		set color_especular {0.5 0.5 0.5 0.5}
		set brillo_specular_suave {0.0} 
		glMaterialfv GL_FRONT GL_AMBIENT_AND_DIFFUSE $color_difuso_ambiente
		glMaterialfv GL_FRONT GL_SPECULAR $color_especular
		glMaterialfv GL_FRONT GL_SHININESS $brillo_specular_suave
		
		
		set quadObj [gluNewQuadric]
		glColor3f 1.0 1.0 1.0
		#gluSphere $quadObj 0.12 10 10
		glutSolidCube 0.2
		
		#ejeZ
		glColor3f 0.0 0.0 1.0
		gluCylinder $quadObj 0.07 0.07 1 15 1
		glTranslatef 0.0 0.0 1.0
		glutSolidCone 0.15 0.25 10 10
		glTranslatef 0.0 0.0 -1.0
		
		#ejeY
		glColor3f 0.0 1.0 0.0
		glRotatef -90 1.0 0.0 0.0
		gluCylinder $quadObj 0.07 0.07 1 15 1
		glTranslatef 0.0 0.0 1.0
		glutSolidCone 0.15 0.25 10 10
		glTranslatef 0.0 0.0 -1.0
		
		#ejeX
		glColor3f 1.0 0.0 0.0
		glRotated 90 0.0 1.0 0.0
		gluCylinder $quadObj 0.07 0.07 1 15 1
		glTranslatef 0.0 0.0 1.0
		glutSolidCone 0.15 0.25 10 10
		glTranslatef 0.0 0.0 -1.0
		
		
		glRotated -90 0.0 1.0 0.0
		glutSolidCone 0.10 0.25 4 4
		
		gluDeleteQuadric $quadObj
		
		
	} 
	
	
	proc dibujarEjesComplejosPosicion { base x y } {
		upvar #0 VisorGL::$base visor
		if {$visor(ejesList) == -1 } {
			crearDisplayListEjes $base
		}
		
		glMatrixMode GL_PROJECTION
		glPushMatrix
		glLoadIdentity
		
		gluPerspective [expr $visor(viewAngle)] [expr double([lindex $visor(viewport) 0])/double([lindex $visor(viewport) 1])] 0.2 100.0
		gluLookAt 	[lindex $visor(camaraPos) 0] 	[lindex $visor(camaraPos) 1] 	[lindex $visor(camaraPos) 2] \
					[lindex $visor(camaraFocal) 0] 	[lindex $visor(camaraFocal) 1] 	[lindex $visor(camaraFocal) 2] \
					[lindex $visor(camaraUp) 0] 	[lindex $visor(camaraUp) 1] 	[lindex $visor(camaraUp) 2]
		
		
		set vfc [math::linearalgebra::sub $visor(camaraFocal) $visor(camaraPos)]
		set vfc [math::linearalgebra::unitLengthVector $vfc]
		set vfc [math::linearalgebra::scale 0.05 $vfc]
		
		#calculo las coordenadas del mundo de la esquina inferior izquierda
		#q es donde quiero situar los ejes
		set p [displayToWorld $base $x $y]
		set p "[lindex $p 1] [lindex $p 2] [lindex $p 3]"
		#sumo a esta posicion un factor en la direccion de la camara y el focal, para que los ejes
		#no esten pegados a la pantalla (conceptualmente alejar en Z)
		set p [math::linearalgebra::add $p $vfc]
		
		glMatrixMode GL_MODELVIEW
		glPushMatrix
		glLoadIdentity
		
		glTranslatef [lindex $p 0] [lindex $p 1] [lindex $p 2] 
		glScalef 0.015 0.015 0.015
		
		glCallList $visor(ejesList)
		glPopMatrix
		glMatrixMode GL_PROJECTION
		glPopMatrix
		
		glMatrixMode GL_MODELVIEW
	}
	
	# -------------------------------------- MANEJADORES DE EVENTOS ------------------------------------
	
	proc manejadorLBPE { base x y } {
		upvar #0 VisorGL::$base visor
		set visor(ratonPosAnt) $visor(ratonPos)
		set visor(ratonPos) "$x $y"
		
		#puts "[displaytoWorld $x $y]"
		
		
		if { $visor(modoAct) == "mover" } {
			#realizo un picado simple
			set obj [pica $base 0]
			set listaSelecc [listaAtomosSeleccionadosVisor $base]
			set visor(listaMoverAtomos) $listaSelecc
			
			if {$obj == [list] || [lsearch -exact $listaSelecc [lindex $obj 0]] == -1} {
				#no ha picado nada, o se ha picado sobre algo que no estaba seleccionado 
				#inicio el lazo de seleccion
				set visor(posInicioSeleccion) "$x $y" 
				set visor(posFinSeleccion) "$x $y"
				set visor(rectanguloSeleccion) 1
			} else {
				set visor(moverAtomos) 1
				#la lista de atomos a mover, sera la original, ademas de todos los hidrogenos que esten
				#unidos a algun atomo de esta lista
				foreach par $listaSelecc {
					set hidrog [Data::devolverHidrogenosDelAtomo [lindex $visor(moleculas) [lindex $par 0]] [lindex $par 1]]
					foreach h $hidrog {
						if {[lsearch $listaSelecc [list [lindex $par 0] $h]] == -1} {
							lappend listaSelecc [list [lindex $par 0] $h]
						}
					}
				}
				set visor(listaMoverAtomos) $listaSelecc
				set visor(seleccionModificadas) 1
				
				#set visor(posInicioSeleccion) "$x $y"
				set visor(moverSeleccion) "0.0 0.0 0.0"
				
			}
		}
		set visor(ratonIzqPuls) 1
	}
	
	proc manejadorLBRE { base x y } {
		upvar #0 VisorGL::$base visor
		
		#set visor(ratonPosAnt) $visor(ratonPos)
		#set visor(ratonPos) "$x $y"		
		if {$visor(modoAct) == "rotar"} {
			if {$visor(ratonMov) == 0 && $visor(dobleClick) == 0} {
				seleccion $base 0
				#$visor(togl) postredisplay
			} elseif { ( $visor(CTRL) == 1 || $visor(SHIFT) == 1 ) && $visor(listaMolRotar) != [list]} {
				#aplico las rotaciones a las moleculas
				rotarMolsMatriz $base $visor(matrizRotar)
				set visor(matrizRotar) $visor(mat16v)
				set visor(rotacionModificadas) 1
				
			}
		} elseif {$visor(modoAct) == "mover"} {			
			if {$visor(ratonMov) == 0 && $visor(dobleClick) == 0} {
				seleccion $base 0
			} else {
				if { $visor(rectanguloSeleccion) == 1 } {
					#seleccion multiple
					seleccion $base 1
				} else {
					#set visor(posFinSeleccion) "$x $y"
					#desplazar realmente las moleculas
					moverAtomos $base $visor(listaMoverAtomos) $visor(moverSeleccion)					
					set visor(moverAtomos) 0
				}
			}
			set visor(rectanguloSeleccion) 0
			set visor(listaMoverAtomos) [list]
			
			#$visor(togl) postredisplay
		}
		#set visor(listaMoverAtomos) [listaAtomosSeleccionadosVisor $base]
		set visor(seleccionModificadas) 1
		set visor(ratonIzqPuls) 0
		set visor(ratonMov) 0
		set visor(dobleClick) 0
		$visor(togl) postredisplay
	}
	
	proc manejadorRBPE { base x y } {
		upvar #0 VisorGL::$base visor

		set visor(ratonPosAnt) $visor(ratonPos)
		set visor(ratonPos) "$x $y"
				
		set visor(ratonDchoPuls) 1
	}
	
	proc manejadorRBRE { base x y } {
		upvar #0 VisorGL::$base visor
		set visor(ratonDchoPuls) 0
	}
	
	proc manejadorMME { base x y } {
		upvar #0 VisorGL::$base visor
		
		set visor(ratonMov) 1
		set visor(ratonPosAnt) $visor(ratonPos)
		set visor(ratonPos) "$x $y"
		
		#rotar camara
		if {$visor(modoAct) == "rotar"} {
			if {$visor(ratonIzqPuls) == 1} {
				set difX [expr [lindex $visor(ratonPosAnt) 0] - $x]
				set difY [expr [lindex $visor(ratonPosAnt) 1] - $y]
				
				if {$visor(CTRL) == 0 && $visor(SHIFT) == 0} {
					#roto la camara
					camaraAzimuth $base [expr $difX / 2.0]
					camaraElevation $base [expr $difY / 2.0]
				} elseif {$visor(CTRL) == 1 && $visor(SHIFT) == 0} {
					#rotacion en X e Y de lo seleccionado
					set mX [calculaRotacionEjeAng $base "X" [expr -$difY / 2.0]]
					set mY [calculaRotacionEjeAng $base "Y" [expr -$difX / 2.0]]
					set mRXY [math::linearalgebra::matmul $mY $mX]
					set visor(matrizRotar) [math::linearalgebra::matmul $mRXY $visor(matrizRotar)]
					
				} elseif {$visor(CTRL) == 0 && $visor(SHIFT) == 1} { 
					#rotacion en Z de todo el visor
					set mZ [calculaRotacionEjeAng $base "Z" [expr -$difY / 2.0]]
					set visor(matrizRotar) [math::linearalgebra::matmul $mZ $visor(matrizRotar)]
				} elseif {$visor(CTRL) == 1 && $visor(SHIFT) == 1} {
					#rotacion en Z de lo seleccionado
					set mZ [calculaRotacionEjeAng $base "Z" [expr -$difY / 2.0]]
					set visor(matrizRotar) [math::linearalgebra::matmul $mZ $visor(matrizRotar)]
				}
			}
			
			if {$visor(ratonDchoPuls) == 1} {
				camaraPan $base [vectorDifPosRaton $base $visor(ratonPosAnt) $visor(ratonPos)] 
			}
		} elseif {$visor(modoAct) == "mover"} {
			if {$visor(ratonIzqPuls) == 1} { 
				if { $visor(rectanguloSeleccion) == 1} {
					set visor(posFinSeleccion) $visor(ratonPos)
				} else {  
#					moverAtomos $base $visor(listaMoverAtomos) [math::linearalgebra::scale -2 [vectorDifPosRaton $base $visor(ratonPosAnt) $visor(ratonPos)]]
					set visor(moverSeleccion) [math::linearalgebra::add $visor(moverSeleccion) [math::linearalgebra::scale -2 [vectorDifPosRaton $base $visor(ratonPosAnt) $visor(ratonPos)]]]
				}
			}
			if {$visor(ratonDchoPuls) == 1} {
				set difX [expr [lindex $visor(ratonPosAnt) 0] - $x]
				set difY [expr [lindex $visor(ratonPosAnt) 1] - $y]
				camaraAzimuth $base [expr $difX / 2.0]
				camaraElevation $base [expr $difY / 2.0]
			}
		} elseif {$visor(modoAct) == "zoom"} {
			if {$visor(ratonIzqPuls) == 1} { 
				set difY [expr [lindex $visor(ratonPosAnt) 1] - $y]
				manejadorScroll $base $difY
			}
			if {$visor(ratonDchoPuls) == 1} {
				set difX [expr [lindex $visor(ratonPosAnt) 0] - $x]
				set difY [expr [lindex $visor(ratonPosAnt) 1] - $y]
				camaraAzimuth $base [expr $difX / 2.0]
				camaraElevation $base [expr $difY / 2.0]
			}
		} elseif {$visor(modoAct) == "desplazar"} {
			if {$visor(ratonIzqPuls) == 1} { 
				camaraPan $base [vectorDifPosRaton $base $visor(ratonPosAnt) $visor(ratonPos)] 
			}
			if {$visor(ratonDchoPuls) == 1} {
				set difX [expr [lindex $visor(ratonPosAnt) 0] - $x]
				set difY [expr [lindex $visor(ratonPosAnt) 1] - $y]
				camaraAzimuth $base [expr $difX / 2.0]
				camaraElevation $base [expr $difY / 2.0]
			}
		}
		#set visor(listaMoverAtomos) [listaAtomosSeleccionadosVisor $base]
		$visor(togl) postredisplay
	}
	
	proc manejadorDCE { base } {
		upvar #0 VisorGL::$base visor
		set visor(dobleClick) 1
		set obj [pica $base 0]
		if {$obj != [list]} {
			seleccionaMolecula $base [lindex $visor(moleculas) [lindex [lindex $obj 0] 0]]
			upvar #0 Data::[lindex $visor(moleculas) [lindex [lindex $obj 0] 0]] datos
			set visor(ficheroSeleccionado) $datos(nombreFich)
			
			$visor(togl) postredisplay
		}
	}
	
	proc manejadorScroll { base sentido } {
		upvar #0 VisorGL::$base visor
		if {$visor(proyeccion) == 0} {
			if {$sentido < 0} { set zoom [expr $visor(zoomPersp) + 0.1] 
			} else { set zoom [expr $visor(zoomPersp) - 0.1] }
			if {$zoom >= 0.0 && $zoom <= 3.0} {
				set visor(zoomPersp) $zoom
				$visor(togl) postredisplay
			}
		} else {
			if {$sentido < 0} { set zoom [expr $visor(zoomParal) + 0.2] 
			} else { set zoom [expr $visor(zoomParal) - 0.2] }
			if {$zoom >= 0.0} {
				set visor(zoomParal) $zoom
				$visor(togl) postredisplay
			}
		}
	}
	
	proc manejadorKPE { base key } {
		upvar #0 VisorGL::$base visor

		switch $key {
			space {
				if {$visor(idleId) == 0} {
					startIdle $base
				} else {
					stopIdle $base
				}
			}
			r - R {
				camaraReset $base
				$visor(togl) postredisplay
			}
			m - M {
				insertarMedida $base
				$visor(togl) postredisplay
			}
			d - D {
				eliminarMedidas $base
				$visor(togl) postredisplay
			}
			s - S {
				if {$visor(wireframe)} {
					set visor(wireframe) 0
					set visor(molModificadas) 1
					$visor(togl) postredisplay
				}
			}
			w - W {
				if {!$visor(wireframe)} {
					set visor(wireframe) 1
					set visor(molModificadas) 1
					$visor(togl) postredisplay
				}
			}
			Control_L - Control_R {
				if {$visor(modoAct) == "rotar"} {
					#calculo el centro para una posible rotacion individual
					if {$visor(SHIFT)} {
						#todo el visor
						set lMol $visor(moleculas)
					} else {
						set lMol [listaMoleculasComplSelecc $base]
						if {$lMol == ""} {
							set lMol $visor(moleculas)
						}
					}
					if { $visor(listaMolRotar) != $lMol } {
						set visor(rotacionModificadas) 1
						set visor(centroEjes) [calculaEjesCameraBB $base $lMol]
						set visor(matrizRotar) $visor(mat16v)
					} 
					set visor(listaMolRotar) $lMol
					
				}
				set visor(CTRL) 1
			}
			Shift_L - Shift_R {
				if {$visor(modoAct) == "rotar" && $visor(CTRL) == 0} {
					if { $visor(listaMolRotar) != $visor(moleculas) } {
						set visor(rotacionModificadas) 1
					} 
					set visor(listaMolRotar) $visor(moleculas)
					set visor(centroEjes) [calculaEjesCameraBB $base $visor(listaMolRotar)]
				}
				set visor(SHIFT) 1
			}
			1 {
				cambiaRepresentacionVisor $base L
				$visor(togl) postredisplay
			}
			2 {
				cambiaRepresentacionVisor $base C
				$visor(togl) postredisplay
			}
			3 {
				cambiaRepresentacionVisor $base CB
				$visor(togl) postredisplay
			}
			4 {
				cambiaRepresentacionVisor $base CPK
				$visor(togl) postredisplay
			}
			7 {
				set visor(modoAct) "rotar"
				set visor(hudModificada) 1
				$visor(togl) postredisplay
			} 
			8 {
				set visor(modoAct) "mover"
				set visor(hudModificada) 1
				$visor(togl) postredisplay
			}
			9 {
				set visor(modoAct) "zoom"
				set visor(hudModificada) 1
				$visor(togl) postredisplay
			}
			0 {
				set visor(modoAct) "desplazar"
				set visor(hudModificada) 1
				$visor(togl) postredisplay
			}
			
			b - B {
				#set centroEjes [calculaEjesCameraBB $base [list molec1 molec0]]
				#puts $centroEjes 
				#rotarMolsEje $base [list molec1 molec0] [lindex $centroEjes 0] [lindex $centroEjes 1] 3
				#rotacionMoleculas $base Z 3
				$visor(togl) postredisplay
			}
			p - P {
				set visor(proyeccion) 0
				$visor(togl) postredisplay
			}
			o - O {
				set visor(proyeccion) 1
				$visor(togl) postredisplay
			}
		}
	}
	
	proc manejadorKRE { base key } {
		upvar #0 VisorGL::$base visor
		switch $key {
			q - Q {
				exit
			}
			Control_L - Control_R {
				set visor(listaMolRotar) [list]
				set visor(CTRL) 0
				set visor(rotacionModificadas) 1
				
				$visor(togl) postredisplay
			}
			Shift_L - Shift_R {
				set visor(listaMolRotar) [list]
				set visor(SHIFT) 0
				set visor(rotacionModificadas) 1
				
				$visor(togl) postredisplay
				
			}
		}
	}
	
	proc calculaRotacionEjeAng { base eje ang } {
		upvar #0 VisorGL::$base visor
		
		#set lMol $visor(listaMolRotar)
		#if {$lMol != ""} {
			#set centroEjes $visor(centroEjes)
			
		if {$eje == "X" } {
			#rotarMolsEje $base $lMol [lindex $centroEjes 0] [lindex $centroEjes 1] $ang
			set ejeA [lindex $visor(centroEjes) 0]
			set ejeB [lindex $visor(centroEjes) 1]
		} elseif {$eje == "Y"} {
			#rotarMolsEje $base $lMol [lindex $centroEjes 0] [lindex $centroEjes 2] $ang
			set ejeA [lindex $visor(centroEjes) 0]
			set ejeB [lindex $visor(centroEjes) 2]
		} elseif {$eje == "Z"} {
			#rotarMolsEje $base $lMol [lindex $centroEjes 0] [lindex $centroEjes 3] $ang
			set ejeA [lindex $visor(centroEjes) 0]
			set ejeB [lindex $visor(centroEjes) 3]
		}
		#}
		
		
		set eje [math::linearalgebra::sub $ejeB $ejeA]

		set T [matfTranslate [math::linearalgebra::scale -1 $ejeA]]
		set iT [matfTranslate $ejeA]
		set mRot [matfRotate $ang $eje]
		
		
		set Res [math::linearalgebra::matmul $iT $mRot]
		set Res [math::linearalgebra::matmul $Res $T]
		
		return $Res
		
	}
	
	
	# -------------------------------------- FIN MANEJADORES DE EVENTOS ------------------------------------
	
	# -------------------------------------- FUNCIONES DE LA CAMARA ------------------------------------
	
	#cogido de VTK
	proc camaraAzimuth2 { base angle } {
		upvar #0 VisorGL::$base visor
		
		set pos [tcl3dVectorFromList GLfloat "$visor(camaraPos) 1.0"]
		set axis [tcl3dVectorFromList GLfloat $visor(camaraUp)]
		set m [tcl3dVector GLfloat 16]
		
		#tcl3dMatfIdentity $m
		tcl3dMatfTranslate [expr - [lindex $visor(camaraFocal) 0]]  [expr - [lindex $visor(camaraFocal) 1]] [expr - [lindex $visor(camaraFocal) 2]] $m
		tcl3dMatfTransformPoint $pos $m $pos
		tcl3dMatfRotate $angle $axis $m
		tcl3dMatfTransformPoint $pos $m $pos
		tcl3dMatfTranslate [lindex $visor(camaraFocal) 0]  [lindex $visor(camaraFocal) 1] [lindex $visor(camaraFocal) 2] $m
		tcl3dMatfTransformPoint $pos $m $pos
		
		
		
		set visor(camaraPos) [tcl3dVectorToList $pos 3]
		#puts "RadioA : [math::linearalgebra::norm [math::linearalgebra::sub $visor(camaraFocal) $visor(camaraPos)]]"

		$m Delete
		$pos Delete
		$axis Delete	
	}
	
	#cogido de VTK
	proc camaraAzimuth { base angle } {
		upvar #0 VisorGL::$base visor
	
		set pos "$visor(camaraPos) 1.0"
		
		set mT  [matfTranslate [math::linearalgebra::scale -1 $visor(camaraFocal)]]
		set mR  [matfRotate $angle $visor(camaraUp)]
		set miT [matfTranslate $visor(camaraFocal)]

		
		set mRes [math::linearalgebra::matmul $miT $mR]
		set mRes [math::linearalgebra::matmul $mRes $mT]
		set pos [math::linearalgebra::matmul $mRes "$visor(camaraPos) 1.0"]
		
		set visor(camaraPos) "[lindex $pos 0] [lindex $pos 1] [lindex $pos 2]" 
		
		#puts "RadioA : [math::linearalgebra::norm [math::linearalgebra::sub $visor(camaraFocal) $visor(camaraPos)]]"	
	}
	
	#cogido de VTK
	proc camaraElevation2 { base angle } {
		upvar #0 VisorGL::$base visor
		
		set pos [tcl3dVectorFromList GLfloat "$visor(camaraPos) 1.0"]
		set m [tcl3dVector GLfloat 16]
		
		set viewTransform [camaraSetup $base $visor(camaraPos) $visor(camaraFocal) $visor(camaraUp)]
		set axis [tcl3dVectorFromList GLfloat [lindex $viewTransform 0]]
		
		
		#tcl3dMatfIdentity $m
		tcl3dMatfTranslate [expr - [lindex $visor(camaraFocal) 0]] [expr - [lindex $visor(camaraFocal) 1]] [expr - [lindex $visor(camaraFocal) 2]] $m
		tcl3dMatfTransformPoint $pos $m $pos
		tcl3dMatfRotate $angle $axis $m
		tcl3dMatfTransformPoint $pos $m $pos
		tcl3dMatfTranslate [lindex $visor(camaraFocal) 0] [lindex $visor(camaraFocal) 1] [lindex $visor(camaraFocal) 2] $m
		tcl3dMatfTransformPoint $pos $m $pos
		
		set visor(camaraPos) [tcl3dVectorToList $pos 3]
		
		#ortogonalizo View UP	
		set vUp [lindex $viewTransform 1]
		set visor(camaraUp) "[lindex $vUp 0] [lindex $vUp 1] [lindex $vUp 2]"
		
		puts "RadioE : [math::linearalgebra::norm [math::linearalgebra::sub $visor(camaraFocal) $visor(camaraPos)]]"

		$m Delete
		$pos Delete
		$axis Delete	
	}
	
	proc camaraElevation { base angle } {
		upvar #0 VisorGL::$base visor
		
		set pos "$visor(camaraPos) 1.0"
		
		set viewTransform [camaraSetup $base $visor(camaraPos) $visor(camaraFocal) $visor(camaraUp)]
		set axis [lindex $viewTransform 0]
	
		set mT  [matfTranslate [math::linearalgebra::scale -1 $visor(camaraFocal)]]
		set mR  [matfRotate $angle $axis]
		set miT [matfTranslate $visor(camaraFocal)]
		
		set mRes [math::linearalgebra::matmul $miT $mR]
		set mRes [math::linearalgebra::matmul $mRes $mT]
		set pos [math::linearalgebra::matmul $mRes "$visor(camaraPos) 1.0"]
		
		
		set visor(camaraPos) "[lindex $pos 0] [lindex $pos 1] [lindex $pos 2]" 
		
		#puts "RadioE : [math::linearalgebra::norm [math::linearalgebra::sub $visor(camaraFocal) $visor(camaraPos)]]"		
		#ortogonalizo View UP	
		set vUp [lindex $viewTransform 1]
		set visor(camaraUp) "[lindex $vUp 0] [lindex $vUp 1] [lindex $vUp 2]"

	}
	
	proc displayToWorld { base x y } {
		upvar #0 VisorGL::$base visor
		
		#set viewport [tcl3dVectorFromList GLint {0 0 0}]
		set viewport 	[tcl3dVectorFromList GLint $visor(vec4i)]
		set mvmatrix   	[tcl3dVectorFromList GLdouble $visor(mat16)] 
		set projmatrix 	[tcl3dVectorFromList GLdouble $visor(mat16)] 
		
		
		glGetIntegerv GL_VIEWPORT $viewport
		glGetDoublev  GL_MODELVIEW_MATRIX  $mvmatrix
		glGetDoublev  GL_PROJECTION_MATRIX $projmatrix
		
		set viewList [tcl3dVectorToList $viewport 4]
		set mvList   [tcl3dVectorToList $mvmatrix 16]
		set projList [tcl3dVectorToList $projmatrix 16]
	
		
		set realy [expr [$viewport get 3] - $y - 1]
		set winList [gluUnProject $x $realy 0.0 $mvList $projList $viewList]
		
		$viewport Delete
		$mvmatrix Delete
		$projmatrix Delete

		return $winList
	}
	
	#devuelve el vector resultante de la diferencia entre la posicion anterior del raton, y la actual
	proc vectorDifPosRaton { base p0 p1} {
		upvar #0 VisorGL::$base visor
		#set o [displayToWorld $base [lindex $visor(ratonPosAnt) 0] 	[lindex $visor(ratonPosAnt) 1]]
		#set d [displayToWorld $base [lindex $visor(ratonPos) 0] 	[lindex $visor(ratonPos) 1]]
		
		set o [displayToWorld $base [lindex $p0 0] 	[lindex $p0 1]]
		set d [displayToWorld $base [lindex $p1 0] 	[lindex $p1 1]]
		
		
		set delta [lrange [math::linearalgebra::sub $o $d] 1 end]
		set delta [math::linearalgebra::scale 14.0 $delta]
		return $delta
	}
	
	
	#desplaza la posicion de la camara y el punto de vista en la direccion y magnitud de v
	proc camaraPan { base v } {
		upvar #0 VisorGL::$base visor
		
		set visor(camaraPos) [math::linearalgebra::add $visor(camaraPos) $v]
		set visor(camaraFocal) [math::linearalgebra::add $visor(camaraFocal) $v]
		
		$visor(togl) postredisplay
	}
	
	#cogido de VTK
	proc camaraSetup { base pos foc up } {
		upvar #0 VisorGL::$base visor

		#set the view plane normal from the view vector
		set viewPlaneNormal [math::linearalgebra::sub $pos $foc]
		set viewPlaneNormal [math::linearalgebra::unitLengthVector $viewPlaneNormal]
		
		#orthogonalize viewUp and compute viewSideways
		set viewSideways [math::linearalgebra::crossproduct $up $viewPlaneNormal]
		set viewSideways [math::linearalgebra::unitLengthVector $viewSideways]
		set orthoViewUp [math::linearalgebra::crossproduct $viewPlaneNormal $viewSideways]
		
		#translate by the vector from the position to the origin
		#set delta "[expr - [lindex $pos 0]] [expr - [lindex $pos 1]] [expr - [lindex $pos 2]] 0.0"
		set delta [math::linearalgebra::scale -1 $pos]
		
		set m [join [list $viewSideways $orthoViewUp $viewPlaneNormal "0.0 0.0 0.0 1.0"]]
		set mat [tcl3dVectorFromList GLfloat $m]
		set deltaV [tcl3dVectorFromList GLfloat $delta]
		set deltaN [tcl3dVector GLfloat 4]
		
		tcl3dMatfTransformVector $deltaV $mat $deltaN
		
		$mat Delete
		$deltaV Delete
		$deltaN Delete
		
		return [list $viewSideways $orthoViewUp $viewPlaneNormal [list [$deltaN get 0] [$deltaN get 1] [$deltaN get 2] [$deltaN get 3]]]
	}
	
	proc setCameraPres { base } {
		upvar #0 VisorGL::$base visor
		
		glMatrixMode GL_PROJECTION
		glLoadIdentity
		glFrustum -0.1333 0.1333 -0.1 0.1 0.2 150.0
		glMatrixMode GL_MODELVIEW
		glLoadIdentity
		gluLookAt 0 1.5 2 0 1.5 0 0 1 0
		glTranslatef 0.0 -8.0 -45.0
		#if { $visor(progressPres) < 0.0 } {
			#glRotatef [expr -1.0*720] 0.0 1.0 0.0
		#} else {
			glRotatef [expr -1.0*$visor(progressPres)*720] 0.0 1.0 0.0
		#}
	}
	
	
	#devuelve "xMin xMax yMin yMax zMin zMax" de todos las moleculas de la escena 
	proc boundingBox { base listMol } {
		upvar #0 VisorGL::$base visor
		
		set lX [list] ; set lY [list] ;  set lZ [list]
		if {$listMol == [list]} {
			return [list -3.0 3.0 -3.0 3.0 -3.0 3.0]
		} else {
			foreach mol $listMol {
				upvar #0 Data::$mol datos
	
				for {set x 0} {$x < $datos(numAtomos)} {incr x} {
					lappend lX $datos(coordX,$x)
					lappend lY $datos(coordY,$x)
					lappend lZ $datos(coordZ,$x)
				}
			}
			
			set lX [lsort -decreasing -real $lX]
			set lY [lsort -decreasing -real $lY]
			set lZ [lsort -decreasing -real $lZ]
			
			return [list [lindex $lX 0] [lindex $lX end] [lindex $lY 0] [lindex $lY end] [lindex $lZ 0] [lindex $lZ end]]
		}
	}
	
	#cogido de VTK
	proc camaraReset2 { base } {
		upvar #0 VisorGL::$base visor
		
		set bB [boundingBox $base $visor(moleculas)]
		
		set ext1 [list [lindex $bB 0] [lindex $bB 2] [lindex $bB 4]]
		set ext2 [list [lindex $bB 1] [lindex $bB 3] [lindex $bB 5]]
		
		set center [math::linearalgebra::scale 0.5 [math::linearalgebra::sub $ext1 $ext2]]
		
		set w1 [expr [lindex bB 1] - [lindex $bB 0]]
		set w2 [expr [lindex bB 3] - [lindex $bB 2]]
		set w3 [expr [lindex bB 5] - [lindex $bB 4]]
		
		set radius [expr sqrt($w1*$w1 + $w2*$w2 + $w3*$w3)]
		if {$radius == 0.0} {set radius 1.0}
		
		#radio de la esfera que rodea a la bounding box
		set radius [expr $radius * 0.5]
		
		
		#vector que une la posicion de la camara con el nuevo Focal
		set v [math::linearalgebra::sub $visor(camaraPos) $center]
		set v [math::linearalgebra::unitLengthVector $v]
		set v [math::linearalgebra::scale [expr $radius + 2.0] $v]
		
		set visor(camaraPos) $v
		set visor(camaraFocal) $center
		
		$visor(togl) postredisplay
	}
	
	#mejorar para que toda la escena sea visible
	proc camaraReset { base } {
		upvar #0 VisorGL::$base visor
		
		set bB [boundingBox $base $visor(moleculas)]
		
		#extremos de la Bounding Box
		set ext1 [list [lindex $bB 0] [lindex $bB 2] [lindex $bB 4]]
		set ext2 [list [lindex $bB 1] [lindex $bB 3] [lindex $bB 5]]
		
		#vector entre los extremos de la Bounding Box
		set vBB [math::linearalgebra::sub $ext2 $ext1]
		
		set center [math::linearalgebra::scale 0.5 $vBB]
		set center [math::linearalgebra::add $center $ext1]
		
		#vector entre el focal actual y el centro de la escena
		set vfc [math::linearalgebra::sub $center $visor(camaraFocal)]
		
		#desplazo la camara y el focal en la magnitud de ese vector
		camaraPan $base $vfc
		
		#acerco o alejo la camara segun el radio de la bounding box
		set radius [math::linearalgebra::norm $vBB]
		
		#radio de la esfera que rodea a la bounding box
		if {$radius == 0.0} {set radius 1.0}
		set radius [expr $radius * 0.5]
		
		
		#calculo la posicion de la camara para que la escena sea visible al completo
		#
		#
		#        /| 
		#       / |
		#      /  |
		#  	  /   | r
		#  	 /    |
		# 	/a    |
		# p ------ c
		#      b
		#
		# p : la posicion de la camara que queremos clcular
		# a : la mitad del angulo del viewAngle utilizado en el gluPerspective
		# c : el centro de la Bounding Box, que es el nuevo Focal
		# r : radio de la Bounding Box
		# distancia entre c y p
		# al considerar el triangulo rectangulo estamos tomando el plano de vista perpendicular a la camara
		#
		# tenemos que : tan(a) = r / b --> b = r / tan(a)
		
		
		#distancia a la que debe posicionarse la camara del focal
		set b [expr $radius / tan(($visor(viewAngle)*0.5)*$math::constants::degtorad)]
		
		set vcf [math::linearalgebra::sub $visor(camaraPos) $visor(camaraFocal)]
		set vcf [math::linearalgebra::unitLengthVector $vcf]
		
		set posC [math::linearalgebra::scale $b $vcf]
		set posC [math::linearalgebra::add $posC $visor(camaraFocal)]

		set visor(zoomPersp) 1.0
		set visor(zoomParal) 1.0
		#set visor(BBActual) $bB
		#set visor(radioFrustum) $radius
		set visor(camaraPos) $posC
	}

	
	
	proc camaraZoom { base factor } {
		upvar #0 VisorGL::$base visor
		
		if {$factor != 0} {
			set vfc [math::linearalgebra::sub $visor(camaraPos) $visor(camaraFocal)]
			set vfc [math::linearalgebra::scale $factor $vfc]
			set vfc [math::linearalgebra::add $vfc $visor(camaraFocal)]
			set visor(camaraPos) $vfc
		}
	}
	# -----------------------------------------------------------------------------------------
	
	
	
	proc cargaVisorMolData { base baseData baseConf } {
		upvar #0 VisorGL::$base visor
		upvar #0 Data::$baseData datos
		#upvar #0 Conf::$baseConf config
		
		#creo una nueva molecula 
		lappend visor(moleculas) $baseData
		
		#SELECCION
		set visor(atomosSeleccionados,$baseData) [list]
		set visor(enlacesSeleccionados,$baseData) [list]
		set visor(idEnlacesSelect,$baseData) [list]
		
		#Representacion
		#visor(estadoRepres,baseData,at) para cada atomo
		for {set x 0} {$x < $datos(numAtomos)} {incr x} {
			set visor(estadoRepres,$baseData,$x) "CB"
			set visor(visible,$baseData,$x) 1
		}
		
		
		#cambios que requieren modificar las Display Lists
		set visor(molModificadas) 		1
		set visor(molModificadasSelect) 1
		#set visor(medidasModificadas) 	1
		set visor(etqModificadas) 		1
		set visor(phModificados) 	1
		
	}
	
	proc actualizaVisorMol { base } {
		upvar #0 VisorGL::$base visor
		
		set visor(molModificadas) 		1
		set visor(molModificadasSelect) 	1
		set visor(medidasModificadas) 		1
		set visor(etqModificadas) 		1
		set visor(phModificados) 		1	
	}
	
	proc cambiarProyeccion { base modo } {
		upvar #0 VisorGL::$base visor
		set visor(proyeccion) $modo
	}
	
	proc devolverProyeccion { base } {
		upvar #0 VisorGL::$base visor
		return $visor(proyeccion)
	}
	
	
	
	proc delVisorMol { base } {
		upvar #0 VisorGL::$base visor
		
		foreach mol $visor(moleculas) {
			delVisorMolData $base $mol
		}
		
	}
	
	proc delVisorMolData { base baseData } {
		upvar #0 VisorGL::$base visor
		upvar #0 Data::$baseData datos
		
		set ind [lsearch -exact $visor(moleculas) $baseData]
		set visor(moleculas) [lreplace $visor(moleculas) $ind $ind]
		unset visor(atomosSeleccionados,$baseData) 
		unset visor(enlacesSeleccionados,$baseData)
		unset visor(idEnlacesSelect,$baseData)
		
		for {set x 0} {$x < $datos(numAtomos)} {incr x} {
			unset visor(estadoRepres,$baseData,$x)
			unset visor(visible,$baseData,$x)
		}
		
		eliminarMedidas $base
		
		set visor(molModificadas) 		1
		set visor(molModificadasSelect)		1
		set visor(medidasModificadas) 		1
		set visor(etqModificadas) 		1
		set visor(phModificados) 		1
		
	}
	
	proc delVisorMolSelecc { base } {
		upvar #0 VisorGL::$base visor
		set mols [listaMoleculasComplSelecc $base]
		if { $mols == [list] } {
			set mols $visor(moleculas)
		}
		foreach mol $mols {
			delVisorMolData $base $mol
		}
		
		estableceFicheroSeleccionado $base
		#if {[llength $visor(moleculas)] == 1} {
		#	upvar #0 Data::[lindex $visor(moleculas) 0] data
		#	set visor(ficheroSeleccionado) $data(nombreFich)
		#}
		return $mols
		
	}
	
	proc dibujarMoleculas { base baseConf } {
		upvar #0 VisorGL::$base visor
		
		foreach mol $visor(moleculas) {
			dibujarMolecula $base $mol $baseConf
		}
	}
	
	
	proc dibujarMolecula { base baseData baseConf } {
		upvar #0 VisorGL::$base visor
		upvar #0 Data::$baseData datos
		
		
		
		set color_difuso_ambiente { 0.1 0.0 0.8 1.0 }
		set color_especular {0.5 0.5 0.5 0.5}
		set brillo_specular_suave {5.0} 
		glMaterialfv GL_FRONT GL_AMBIENT_AND_DIFFUSE $color_difuso_ambiente
		glMaterialfv GL_FRONT GL_SPECULAR $color_especular
		glMaterialfv GL_FRONT GL_SHININESS $brillo_specular_suave
		
		#		
		#glEnable  GL_BLEND
		#glBlendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
		#
		
		set quadObj [gluNewQuadric]
		if {$visor(wireframe)} {
			gluQuadricDrawStyle $quadObj GLU_LINE
		}
		#atomos

    		for {set x 0} {$x < $datos(numAtomos)} {incr x} {
    			#set radio [seleccionaRadioRepresentacionAt $base $baseData $x]
			set radio [seleccionaRadioRepresentacionAt $base $baseData $x]
    			if { $visor(visible,$baseData,$x) && $radio > 0} {
    				glPushMatrix
    				glTranslatef $datos(coordX,$x) $datos(coordY,$x) $datos(coordZ,$x)
    				
    				#selecciona color
    				if {[lsearch -exact $visor(atomosSeleccionados,$baseData) $x] == -1} {
    					set color [colorToRGB $datos(colorAtom,$x)]
    				} else {
    					set color $visor(colorSeleccion)
    				}
    				
    				glColor4f [lindex $color 0] [lindex $color 1] [lindex $color 2] 0.5
    				#glColor4f [lindex $color 0] [lindex $color 1] [lindex $color 2] 0.5
    				gluSphere $quadObj $radio $visor(resolucion) $visor(resolucion) 
    				glPopMatrix
    			}
    		}
		
		
		
		glColor3f 0.8 0.8 0.8
		#enlaces
		for {set i 0} {$i < $datos(numAtomos)} {incr i} {
			foreach j $datos(conect,$i) {
				#para no repetir los enlaces
				if { $i < $j && $visor(visible,$baseData,$i) && $visor(visible,$baseData,$j)} {
					
					set a [list $datos(coordX,$i) $datos(coordY,$i) $datos(coordZ,$i)]
					set b [list $datos(coordX,$j) $datos(coordY,$j) $datos(coordZ,$j)]
					
					# C, el vector q una a y b. c = b - a
					set c [math::linearalgebra::sub $b $a]
					set long [math::linearalgebra::norm $c]
					
					
					set ang [math::linearalgebra::angle {0 0 1} $c]
					set ang [expr $ang*$math::constants::radtodeg]
					set eje [math::linearalgebra::crossproduct {0 0 1} $c]
					
					set longSeg [expr $long / 2.0]
					for {set x 0} {$x < 2} {incr x} {
						glPushMatrix
						
						set inc [expr $x/2.0]
						glTranslatef [expr [lindex $a 0] + $inc*[lindex $c 0]] [expr [lindex $a 1] + $inc*[lindex $c 1]] [expr [lindex $a 2] + $inc*[lindex $c 2]]
						glRotatef $ang [lindex $eje 0] [lindex $eje 1] [lindex $eje 2]
						
						
						#selecciono color
						if { $x < 1 } { set ext $i} else { set ext $j }
							
						if {[lsearch -exact $visor(atomosSeleccionados,$baseData) $ext] != -1 || \
							[lsearch -exact $visor(enlacesSeleccionados,$baseData) "$i $j"] != -1 || \
							[lsearch -exact $visor(enlacesSeleccionados,$baseData) "$j $i"] != -1 } {
							set color $visor(colorSeleccion)
						} else {
							set color [colorToRGB $datos(colorAtom,$ext)]
						}
						
						glColor4f [lindex $color 0] [lindex $color 1] [lindex $color 2] 0.5
						#glColor4f [lindex $color 0] [lindex $color 1] [lindex $color 2] 0.5
						
						set radio [seleccionaRadioRepresentacionEn $base $baseData $i $j]
						#segun el tipo de enlace
						switch $datos(tipoConect,$i,$j) {
							#enlace doble
							2 {
								glTranslatef -0.05 0.0 0.0
								dibujarEnlace $base $quadObj $radio $longSeg
								glTranslatef 0.10 0.0 0.0
								dibujarEnlace $base $quadObj $radio $longSeg
							}
							#enlace triple
							3 {
								dibujarEnlace $base $quadObj $radio $longSeg
								glTranslatef -0.05 0.0 0.0
								dibujarEnlace $base $quadObj $radio $longSeg
								glTranslatef 0.1 0.0 0.0
								dibujarEnlace $base $quadObj $radio $longSeg
							}
							#enlace simple
							default {
								dibujarEnlace $base $quadObj $radio $longSeg
								
							}
						}
						glPopMatrix
					}
				}
			}
		}
		#glDisable  GL_BLEND
		gluDeleteQuadric $quadObj	
	}
	
	proc dibujarEnlace { base quad radio long } {
		upvar #0 VisorGL::$base visor
		if { $radio == 0 } {
			glBegin GL_LINES
				glVertex3f 0.0 0.0 0.0
				glVertex3f 0.0 0.0 $long
			glEnd
		} else {
			gluCylinder $quad $radio $radio $long $visor(resolucion) 1
		}	
	}
	
	proc dibujarSeleccion { base } {
		upvar #0 VisorGL::$base visor
		
		set color_difuso_ambiente { 0.1 0.0 0.8 1.0 }
		set color_especular {0.5 0.5 0.5 0.5}
		set brillo_specular_suave {5.0} 
		glMaterialfv GL_FRONT GL_AMBIENT_AND_DIFFUSE $color_difuso_ambiente
		glMaterialfv GL_FRONT GL_SPECULAR $color_especular
		glMaterialfv GL_FRONT GL_SHININESS $brillo_specular_suave

		glEnable GL_BLEND
		#glBlendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
		
		set quadObj [gluNewQuadric]
		if {$visor(wireframe)} {
			gluQuadricDrawStyle $quadObj GLU_LINE
		}
		
		#puts "dibujo : $visor(listaMoverAtomos)"
		foreach elem $visor(listaMoverAtomos) {
			set mol [lindex $visor(moleculas) [lindex $elem 0]]
			upvar #0 Data::$mol datos
			set at [lindex $elem 1]
			glPushMatrix
			glTranslatef $datos(coordX,$at) $datos(coordY,$at) $datos(coordZ,$at)
			
			#selecciona color
			#if {[lsearch -exact $visor(atomosSeleccionados,$baseData) $x] == -1} {
				set color [colorToRGB $datos(colorAtom,$at)]
			#} else {
				#set color $visor(colorSeleccion)
			#}
			set radio [seleccionaRadioRepresentacionAt $base [lindex $visor(moleculas) [lindex $elem 0]] $at]
			if {$radio == 0.0 } { 
				set radio $visor(radioAtCB)
			}
			glColor4f [lindex $color 0] [lindex $color 1] [lindex $color 2] 0.5
			#glColor4f [lindex $color 0] [lindex $color 1] [lindex $color 2] 0.5
			gluSphere $quadObj $radio $visor(resolucion) $visor(resolucion) 
			glPopMatrix
	
	
		}
		glDisable GL_BLEND
		
		gluDeleteQuadric $quadObj
		
	}
	
	#------------------------------------------------------------------------------------------------
	
	#------------------------------------------ REPRESENTACION --------------------------------------
	proc seleccionaRadioRepresentacionAt { base baseData at } {
		upvar #0 VisorGL::$base visor
		upvar #0 Data::$baseData datos
		
		switch $visor(estadoRepres,$baseData,$at) {
			L   { return 0 }
			C   { return $visor(radioAtC) }
			CB  { return $visor(radioAtCB) }
			CPK { return [expr $datos(radioVdW,$at) * $visor(escalaCPK)]}
		}
	}
	
	proc seleccionaRadioRepresentacionEn { base baseData at1 at2 } {
		upvar #0 VisorGL::$base visor
		upvar #0 Data::$baseData datos
	
		if {$visor(estadoRepres,$baseData,$at1) == "L" || \
			$visor(estadoRepres,$baseData,$at2) == "L" } {
			return 0	
		} else {
			switch $datos(tipoConect,$at1,$at2) {
				2 { return 0.03}
				3 { return 0.02}
				default { return 0.07}
			}
		}
	}
	
	#cambiara la representacion de lo seleccionado, en caso de mo haber nada, de todo el visor
	proc cambiaRepresentacionVisor { base tipoRep } {
		upvar #0 VisorGL::$base visor
		
		set sel [list]
		foreach mol $visor(moleculas) {
			if {[llength $visor(atomosSeleccionados,$mol)] > 0} {
				lappend sel $mol
			}
		}
		if {[llength $sel] == 0} {
			set sel $visor(moleculas)
		}
		foreach mol $sel {
			cambiaRepresentacionMol $base $mol $tipoRep
		}
	}
	
	
	proc cambiaRepresentacionMol { base baseData tipoRep } {
		upvar #0 VisorGL::$base visor
		upvar #0 Data::$baseData datos
		
		set l $visor(atomosSeleccionados,$baseData)
		if {$l == [list]} {
			#buscar algo que genere series de numeros, al estilo de 0:1:$datos(numAtomos) de Matlab
			for {set x 0} {$x < $datos(numAtomos)} {incr x} {
				lappend l $x
			}
		}
		foreach e $l {
			set visor(estadoRepres,$baseData,$e) $tipoRep
		}
		set visor(molModificadas) 1
	}
	
	proc cambiarEscalaCPK { base escala } {
		upvar #0 VisorGL::$base visor
		
		set visor(escalaCPK) $escala
	}
	
	proc cambiaModoActivoVisor { base modo } {
		upvar #0 VisorGL::$base visor
		
		set visor(modoAct) $modo
		set visor(hudModificada) 1
		$visor(togl) postredisplay	
	}
	
	proc cambiaModoEjes { base modo } {
		upvar #0 VisorGL::$base visor
		set visor(ejesMostrar) $modo
		
		$visor(togl) postredisplay
	}
	proc devolverModoEjes { base } {
		upvar #0 VisorGL::$base visor
		return $visor(ejesMostrar)
	}
	
	
	proc cambiaModoPH { base modo elems dist } {
		upvar #0 VisorGL::$base visor
		
		set visor(phMostrar) 		$modo
		set visor(elemsPuentesH) 	$elems
		set visor(distPuentesH) 	$dist
		set visor(phModificados) 	1
	
		$visor(togl) postredisplay
	}
	
	
	
	proc ocultarMostrarAtomosMol { base baseData listaAt ocultarMostrar } {
		upvar #0 VisorGL::$base visor
		
		foreach at $listaAt {
			set visor(visible,$baseData,$at) $ocultarMostrar
		} 
		set visor(molModificadas) 1
		set visor(molModificadasSelect) 1
		set visor(medidasModificadas) 1
		set visor(etqModificadas) 1
		set visor(puentesHModificados)	1
	}
	
	proc ocultarMostrarHidrogenosMol { base baseData mostrarOcultar } {
		set listaH [Data::devolverHidrogenosMol $baseData]
		ocultarMostrarAtomosMol $base $baseData $listaH $mostrarOcultar		
	}; #finproc
	
	proc cambiarModoMostrarMoleculas { base modo } {
		upvar #0 VisorGL::$base visor
		set visor(moleculasMostrar) $modo
	}
	
	proc devolverModoMostrarMoleculas { base modo } {
		upvar #0 VisorGL::$base visor
		return $visor(moleculasMostrar)
	}
	#------------------------------------------------------------------------------------------------

	#------------------------------------------ SELECCION -------------------------------------------
	
	proc pica { base multiple } {
		upvar #0 VisorGL::$base visor
		
		#calcular tamaño apropiado del buffer
		set BUFSIZE 0
		foreach mol $visor(moleculas) {
			upvar #0 Data::$mol datos
			set BUFSIZE [expr $BUFSIZE + $datos(numAtomos)+2*$datos(numAtomos)]
		}
		set BUFSIZE [expr $BUFSIZE*4*[llength $visor(moleculas)]]
		
		
		set selectBuffer [tcl3dVector GLuint $BUFSIZE]

		set x [lindex $visor(ratonPos) 0]
		set y [lindex $visor(ratonPos) 1]
		

		set viewport [tcl3dVectorFromList GLint $visor(vec4i)]
		set proyeccion [tcl3dVectorFromList GLdouble $visor(mat16)]
		
		
		glSelectBuffer $BUFSIZE $selectBuffer
		glRenderMode GL_SELECT
		
		glMatrixMode GL_PROJECTION
		glGetDoublev GL_PROJECTION_MATRIX $proyeccion
		glPushMatrix
		glLoadIdentity
		
		glGetIntegerv GL_VIEWPORT $viewport
		
		
		#calculo area de seleccion
		if {!$multiple} {
			set centro 	[list $x [expr [lindex [tcl3dVectorToList $viewport 4] 3] - $y]]
			set delta 	[list 1 1]
		} else {
			set centro [list 	[expr ([lindex $visor(posFinSeleccion) 0] + [lindex $visor(posInicioSeleccion) 0]) / 2] \
			 					[expr [lindex [tcl3dVectorToList $viewport 4] 3] - (([lindex $visor(posFinSeleccion) 1] + [lindex $visor(posInicioSeleccion) 1]) / 2)] ]
			set delta  [list 	[expr abs([lindex $visor(posFinSeleccion) 0] - [lindex $visor(posInicioSeleccion) 0])] \
								[expr abs([lindex $visor(posFinSeleccion) 1] - [lindex $visor(posInicioSeleccion) 1])] ]
		}
		
		gluPickMatrix [lindex $centro 0] [lindex $centro 1] [lindex $delta 0] [lindex $delta 1] $viewport
		glMultMatrixd [tcl3dVectorToList $proyeccion 16]
		
		glMatrixMode GL_MODELVIEW
		glPushMatrix
		
		if { $visor(useDisplayList) == 1 } {
		   if { $visor(molListSelect) == -1 || $visor(molModificadasSelect) == 1} {
			   crearDisplayListMolSelect $base
			   set visor(molModificadasSelect) 0
		   }
		   glCallList $visor(molListSelect)
			
		} else {
		   dibujarMoleculasSelect $base $visor(baseConf)
	   	}
		glPopMatrix
		
		glMatrixMode GL_PROJECTION
		glPopMatrix
		
	
		set hits [glRenderMode GL_RENDER]
		if {!$multiple} {
			return [processHits $hits $selectBuffer]
		} else {
			return [processHitsMultiple $hits $selectBuffer]
		}
	}
	
	proc processHits { hits selectBuffer } {
	
	#puts "proceso impactos"
		set count 0
		set minZ 10000
		set obj [list]
		set nobj [list]
	#puts  "hits = $hits"
		for { set i 0 } { $i < $hits } { incr i } {
			set names [$selectBuffer get $count]
	#	puts " number of names for hit = $names"
			incr count
			set z [expr double ([$selectBuffer get $count]) / 0x7fffffff]
	#	puts -nonewline [format "  z1 is %g;"  \
			   [expr double ([$selectBuffer get $count]) / 0x7fffffff]]
			
			
			incr count
	#puts [format " z2 is %g" \
				   [expr double ([$selectBuffer get $count]) / 0x7fffffff]]
			incr count
	#	puts -nonewline "   the name is "
			set nobj [list]
			for { set j 0 } { $j < $names } { incr j } {
	#		puts -nonewline [format "%d " [$selectBuffer get $count]]
				lappend nobj [$selectBuffer get $count]
				incr count
			}
			
	#puts ""
	#		puts "Z = $z"
			if { $z <= $minZ } { set minZ $z ; set obj $nobj }
			
	#	puts ""
		}
	#puts $obj
		if {$obj != ""} { 
			return [list $obj]
		} else { 
			return [list]
		}
		
	}
	
	proc processHitsMultiple { hits selectBuffer } {

		set count 0
		set obj [list]
		set listaHits [list]
		for { set i 0 } { $i < $hits } { incr i } {
			set names [$selectBuffer get $count]
			incr count
			set z [expr double ([$selectBuffer get $count]) / 0x7fffffff]
			incr count ; incr count
			set obj [list]
			for { set j 0 } { $j < $names } { incr j } {
				lappend obj [$selectBuffer get $count]
				incr count
			}
			lappend listaHits $obj	
		}
		if { $listaHits != ""} { 
			return $listaHits
		} else {
			return [list]
		}
	}
	
	proc dibujarMoleculasSelect { base baseConf } {
		upvar #0 VisorGL::$base visor
		
		glInitNames
		glPushName 0
		
		set m 0
		foreach mol $visor(moleculas) {
			glLoadName $m
			glPushName 0
			incr m
			dibujarMoleculaSelect $base $mol
			glPopName 
		}
	}
	
	proc dibujarMoleculaSelect { base baseData } {
		upvar #0 VisorGL::$base visor
		upvar #0 Data::$baseData datos
		set n 0
		
		#puts "dibujar select"
		#set color_difuso_ambiente { 0.1 0.0 0.8 1.0 }
		#glMaterialfv GL_FRONT GL_AMBIENT_AND_DIFFUSE $color_difuso_ambiente
		
		set quadObj [gluNewQuadric]
		#atomos
		for {set x 0} {$x < $datos(numAtomos)} {incr x} {
			if {$visor(visible,$baseData,$x)} {
				glPushMatrix
				glTranslatef $datos(coordX,$x) $datos(coordY,$x) $datos(coordZ,$x)
	
				glLoadName $n
				incr n
				#el radio de la esfera es un poco mayor del que se pinta en el buffer de renderizado
				#para permitir un picado menos estricto
				gluSphere $quadObj 0.25 10 10
				glPopMatrix
			}
		}
		
		
		#glColor3f 0.8 0.8 0.8
		#enlaces
		set visor(idEnlacesSelect,$baseData) [list]
		for {set i 0} {$i < $datos(numAtomos)} {incr i} {
			foreach j $datos(conect,$i) {
				#para no repetir los enlaces
				if { $i < $j && $visor(visible,$baseData,$i) && $visor(visible,$baseData,$j)} {
					
					lappend visor(idEnlacesSelect,$baseData) "$i $j"
					incr n
					
					set a [list $datos(coordX,$i) $datos(coordY,$i) $datos(coordZ,$i)]
					set b [list $datos(coordX,$j) $datos(coordY,$j) $datos(coordZ,$j)]
					
					# C, el vector q una a y b. c = b - a
					set c [math::linearalgebra::sub $b $a]
					set long [math::linearalgebra::norm $c]
					
					
					set ang [math::linearalgebra::angle {0 0 1} $c]
					set ang [expr $ang*$math::constants::radtodeg]
					set eje [math::linearalgebra::crossproduct {0 0 1} $c]
					
					set longSeg [expr $long / 2.0]
					for {set x 0} {$x < 2} {incr x} {
						glPushMatrix
						
						set inc [expr $x/2.0]
						glTranslatef [expr [lindex $a 0] + $inc*[lindex $c 0]] [expr [lindex $a 1] + $inc*[lindex $c 1]] [expr [lindex $a 2] + $inc*[lindex $c 2]]
						glRotatef $ang [lindex $eje 0] [lindex $eje 1] [lindex $eje 2]
						
						glLoadName $n
						
						gluCylinder $quadObj 0.12 0.12 $longSeg 15 1
						
						glPopMatrix
					}
					
				}
			}
		}
		#puts $visor(idEnlacesSelect,$baseData)
		gluDeleteQuadric $quadObj
		
	}
	
	proc seleccion { base multiple } {
		upvar #0 VisorGL::$base visor
		set obj [pica $base $multiple]
		
		puts "picado : $obj"
		
		if {$obj != [list]} {
			if {$visor(SHIFT) == 0 && $multiple == 1} { deseleccionarTodo $base ; eliminarListaMedidas $base}
			foreach ob $obj {
				#set baseData "molec[lindex $ob 0]"
				set baseData [lindex $visor(moleculas) [lindex $ob 0]]
				puts $baseData
				set n [lindex $ob 1]
				
				upvar #0 Data::$baseData datos
				
				
				if { $n < $datos(numAtomos) } {
					set sel [lsearch $visor(atomosSeleccionados,$baseData) $n]
					if {$visor(SHIFT) == 0 && $multiple == 0 } { deseleccionarTodo $base ; eliminarListaMedidas $base}
					if {$sel == -1 || $visor(SHIFT) == 1 || $multiple == 1 } {
						seleccionaAtomo $base $baseData $n 
						seleccionaListaMedidas $base $ob 
					}
				} else {
					#tengo q identificar entre que atomos está
					set par [lindex $visor(idEnlacesSelect,$baseData) [expr $n - $datos(numAtomos) - 1]]
					set sel [lsearch $visor(enlacesSeleccionados,$baseData) $par]
					if {$visor(SHIFT) == 0 && $multiple == 0 } { deseleccionarTodo $base ; eliminarListaMedidas $base}
					if {$sel == -1 || $visor(SHIFT) == 1 || $multiple == 1} { 
						seleccionaEnlace $base $baseData [lindex $par 0] [lindex $par 1] 
					}					
					#if {$visor(SHIFT) == 0 && $multiple == 0 } { deseleccionarTodo $base ; eliminarListaMedidas $base}
				}
			}
		} else {
			deseleccionarTodo $base ; eliminarListaMedidas $base
		}
		
	}
	
	proc seleccionaAtomo { base baseData atomo } {
		upvar #0 VisorGL::$base visor
		
		set index [lsearch -exact $visor(atomosSeleccionados,$baseData) $atomo]
		if {$index == -1} { 
			lappend visor(atomosSeleccionados,$baseData) $atomo
			
		} else {
			set visor(atomosSeleccionados,$baseData) [lreplace $visor(atomosSeleccionados,$baseData) $index $index]
		}
		set visor(molModificadas) 1
	}
	
	proc seleccionaEnlace {base baseData e1 e2 } {
		upvar #0 VisorGL::$base visor
		 
		set index [lsearch -exact $visor(enlacesSeleccionados,$baseData) "$e1 $e2"]
		if {$index == -1} { 
			lappend visor(enlacesSeleccionados,$baseData) "$e1 $e2" 
			
		} else {
			set visor(enlacesSeleccionados,$baseData) [lreplace $visor(enlacesSeleccionados,$baseData) $index $index]
		}
		set visor(molModificadas) 1
	}
	
	proc seleccionarTodo { base} {
		upvar #0 VisorGL::$base visor
		foreach mol $visor(moleculas) {
			seleccionaMolecula $base $mol
		}
		estableceFicheroSeleccionado $base
		set visor(molModificadas) 1
	}
	
	proc deseleccionarTodo { base } {
		upvar #0 VisorGL::$base visor
		
		foreach mol $visor(moleculas) {
			set visor(atomosSeleccionados,$mol) [list]
			set visor(enlacesSeleccionados,$mol) [list]
		}
		estableceFicheroSeleccionado $base
		set visor(molModificadas) 1
	} 
	
	proc estableceFicheroSeleccionado { base } {
		upvar #0 VisorGL::$base visor
		
		if { [llength $visor(moleculas)] == 1 } {
			upvar #0 Data::[lindex $visor(moleculas) 0] datos
			set visor(ficheroSeleccionado) $datos(nombreFich)
		} else {
			set mols [listaMoleculasComplSelecc $base]
			if {[llength $mols] != 1 } {
				set visor(ficheroSeleccionado) [mc "FileNotDefined"]
			} else {
				upvar #0 Data::[lindex $mols 0] datos
				set visor(ficheroSeleccionado) $datos(nombreFich)
			}
		}
	}
	
	proc seleccionaMolecula { base baseData } {
		upvar #0 VisorGL::$base visor
		upvar #0 Data::$baseData datos
		
		set visor(atomosSeleccionados,$baseData) [list]
		for {set x 0} {$x < $datos(numAtomos)} {incr x} {
			lappend visor(atomosSeleccionados,$baseData) $x
		}
		
		estableceFicheroSeleccionado $base
		set visor(molModificadas) 1
	}
	
	proc deseleccionaMolecula { base baseData } {
		upvar #0 VisorGL::$base visor
		upvar #0 Data::$baseData datos
		
		set visor(atomosSeleccionados,$baseData) [list]
		#for {set x 0} {$x < $datos(numAtomos)} {incr x} {
		#	lappend visor(atomosSeleccionados,$baseData) $x
		#}
		estableceFicheroSeleccionado $base
		set visor(molModificadas) 1
	}
	
	
	
	proc listaAtomosSeleccionadosVisor { base } {
		upvar #0 VisorGL::$base visor
		set l [list]
		foreach mol $visor(moleculas) {
			foreach at $visor(atomosSeleccionados,$mol) {
				lappend l [list [lsearch -exact $visor(moleculas) $mol] $at]
			}
		}
		return $l
	}
	
	proc listaMolAtomosSeleccionadosVisor { base } {
		upvar #0 VisorGL::$base visor
		set l [list]
		foreach mol $visor(moleculas) {
			foreach at $visor(atomosSeleccionados,$mol) {
				lappend l [list $mol $at]
			}
		}
		return $l
	}
	
	
	
	proc listaAtomosSeleccionadosMol { base baseData } {
		upvar #0 VisorGL::$base visor
		#upvar #0 Data::$baseData data
		
		return $visor(atomosSeleccionados,$baseData)
	}
	
	proc listaMolEnlacesSeleccionadosVisor { base } {
		upvar #0 VisorGL::$base visor
		set l [list]
		foreach mol $visor(moleculas) {
			foreach en $visor(enlacesSeleccionados,$mol) {
				lappend l [list $mol [lindex $en 0] [lindex $en 1]]
			}
		}
		return $l
	}
	
	proc listaMoleculasComplSelecc { base } {
		upvar #0 VisorGL::$base visor		
		set l [list]
		foreach mol $visor(moleculas) {
			upvar #0 Data::$mol datos
			if {$datos(numAtomos) == [llength $visor(atomosSeleccionados,$mol)]} {
				lappend l $mol
			}
		}
		return $l
	}
	
	proc listaMoleculasParcSelecc { base } {
		upvar #0 VisorGL::$base visor		
		set l [list]
		foreach mol $visor(moleculas) {
			upvar #0 Data::$mol datos
			if {[llength $visor(atomosSeleccionados,$mol)] > 0} {
				lappend l $mol
			}
		}
		return $l
	}
	
	proc estaSeleccEnteraMolecula { base baseData } {
		upvar #0 VisorGL::$base visor
		upvar #0 Data::$baseData datos
		
		return [llength $visor(atomosSeleccionados,$baseData)] == $datos(numAtomos) 
		
	}
	
	proc dibujarRectanguloSeleccion { base pIni pFin } {
		upvar #0 VisorGL::$base visor
		glDisable GL_LIGHTING
		glColor3f 0.0 1.0 0.0
		
		
		glMatrixMode GL_PROJECTION
		glPushMatrix
		glLoadIdentity

		glOrtho 0.0 [expr double([lindex $visor(viewport) 0])] [expr double([lindex $visor(viewport) 1])] 0.0 0.0 1.0
	
		glMatrixMode GL_MODELVIEW
		glPushMatrix
		glLoadIdentity
		
		glEnable GL_LINE_STIPPLE
		glLineStipple 1 0x00FF
		
		glBegin GL_LINE_LOOP
			glVertex2i [lindex $pIni 0] [lindex $pIni 1]
			glVertex2i [lindex $pFin 0] [lindex $pIni 1]
			glVertex2i [lindex $pFin 0] [lindex $pFin 1]
			glVertex2i [lindex $pIni 0] [lindex $pFin 1] 
		glEnd
		
		glDisable GL_LINE_STIPPLE
		glEnable GL_LIGHTING
		glPopMatrix
	
		glMatrixMode GL_PROJECTION
		glPopMatrix 
	
		glMatrixMode GL_MODELVIEW	
	}
	
#-------------------------------- TEXTO EN PANTALLA----------------------------------------------
	# pos es un vector 3D
	proc escribirCad3D { base pos color cad } {
		upvar #0 VisorGL::$base visor
		glDisable GL_LIGHTING

		glColor3f [lindex $color 0] [lindex $color 1] [lindex $color 2]
		glRasterPos3f [lindex $pos 0] [lindex $pos 1] [lindex $pos 2] 
		
		glListBase $visor(fontText3D)
		set len [string length $cad]
		set sa [tcl3dVectorFromString GLubyte $cad]
		glCallLists $len GL_UNSIGNED_BYTE $sa
		$sa delete
		
		glEnable GL_LIGHTING
	}
	
	#pos es un vector 2D en coordenadas de pantalla
	proc escribirCad2D { base pos color cad } {
		upvar #0 VisorGL::$base visor
		
		glMatrixMode GL_PROJECTION
		glPushMatrix
		glLoadIdentity

		glOrtho 0.0 [expr double([lindex $visor(viewport) 0])] [expr double([lindex $visor(viewport) 1])] 0.0 0.0 1.0
	
		glMatrixMode GL_MODELVIEW
		glPushMatrix
		glLoadIdentity
		glDisable GL_LIGHTING

		
		glColor3f [lindex $color 0] [lindex $color 1] [lindex $color 2]
		glRasterPos2i [lindex $pos 0] [lindex $pos 1] 
		
		glListBase $visor(fontText2D)
		set len [string length $cad]
		set sa [tcl3dVectorFromString GLubyte $cad]
		glCallLists $len GL_UNSIGNED_BYTE $sa
		$sa delete
		
		
		glEnable GL_LIGHTING
		glPopMatrix
	
		glMatrixMode GL_PROJECTION
		glPopMatrix 
	
		glMatrixMode GL_MODELVIEW
	}
	
	proc dibujarHud { base } {
		upvar #0 VisorGL::$base visor
		escribirCad2D $base "10 30" "0.0 1.0 0.0" "VisorGL - powered by BANSHEE 2010"
		#escribirCad2D $base "10 50" "0.0 1.0 0.0" "   Versión en desarrollo"
		escribirCad2D $base "10 [expr [lindex $visor(viewport) 1] - 20]" "0.0 1.0 0.0" [format "Running with a %s (OpenGL %s, Tcl %s)" \
				   									[glGetString GL_RENDERER] \
				   									[glGetString GL_VERSION] [info patchlevel]]
		escribirCad2D $base "[expr [lindex $visor(viewport) 0] - 150] 30" "0.0 1.0 0.0" "Modo : $visor(modoAct)"
	}
	
	
	
	
	#------------------------------------------------------------------------------------------------

	
	#------------------------------------------ MEDIDAS ------------------------------------------------
	# molAt es un par de la forma molecula atomo
	
	proc seleccionaListaMedidas { base molAt } {
		upvar #0 VisorGL::$base visor
		#set baseData "molec[lindex $molAt 0]"
		set baseData [lindex $visor(moleculas) [lindex $molAt 0]]
	
		set index [lsearch -exact $visor(atomosMedidas) $molAt]	
		if {[lsearch -exact $visor(atomosSeleccionados,$baseData) [lindex $molAt 1]] == -1} {
			#se esta deseleccionando el atomo
			if {$index != -1} {
				#elimino de la lista
				set visor(atomosMedidas) [lreplace $visor(atomosMedidas) $index $index]
			}
		} else {
			#se esta seleccionando el atomo
			if {[llength $visor(atomosMedidas)] < 4} {
				lappend visor(atomosMedidas) $molAt
			} else {
				set visor(atomosMedidas) [lreplace $visor(atomosMedidas) 0 0]
				lappend visor(atomosMedidas) $molAt
			}
		}
	}	
	
	proc eliminarListaMedidas { base } {
		upvar #0 VisorGL::$base visor
		set visor(atomosMedidas) [list]
	}
	
	proc insertarMedida { base } {
		upvar #0 VisorGL::$base visor
		switch [llength $visor(atomosMedidas)] {
			2 {
				insertarDistancia $base [lindex $visor(atomosMedidas) 0] \
										[lindex $visor(atomosMedidas) 1]
			}
			3 {
				insertarAngulo $base 	[lindex $visor(atomosMedidas) 0] \
										[lindex $visor(atomosMedidas) 1] \
										[lindex $visor(atomosMedidas) 2]
			}
			4 {
				insertarTorsion $base 	[lindex $visor(atomosMedidas) 0] \
										[lindex $visor(atomosMedidas) 1] \
										[lindex $visor(atomosMedidas) 2] \
										[lindex $visor(atomosMedidas) 3]
			}
			default {
				
			}		
		} 
	}
	
	proc eliminarMedidas { base } {
		upvar #0 VisorGL::$base visor
		set visor(distancias) 		[list]
		set visor(angulos) 		[list]
		set visor(torsiones) 		[list]
		set visor(medidasModificadas) 	1
	}
	
	proc insertarDistancia { base molAt1 molAt2 } {
		upvar #0 VisorGL::$base visor
		lappend visor(distancias) [list $molAt1 $molAt2]
		set visor(medidasModificadas) 1
	}
	
	proc insertarAngulo { base molAt1 molAt2 molAt3 } {
		upvar #0 VisorGL::$base visor
		lappend visor(angulos) [list $molAt1 $molAt2 $molAt3]
		set visor(medidasModificadas) 1
	}
	
	proc insertarTorsion { base molAt1 molAt2 molAt3 molAt4 } {
		upvar #0 VisorGL::$base visor
		lappend visor(torsiones) [list $molAt1 $molAt2 $molAt3 $molAt4]
		set visor(medidasModificadas) 1
	}
	
	proc dibujarMedidas { base } {
		upvar #0 VisorGL::$base visor
		
		foreach dist $visor(distancias) {
			dibujarDistanciaMol $base [lindex $dist 0] [lindex $dist 1]
		} 
		foreach dist $visor(angulos) {
			dibujarAnguloMol $base [lindex $dist 0] [lindex $dist 1] [lindex $dist 2]
		}
		foreach dist $visor(torsiones) {
			dibujarTorsionMol $base [lindex $dist 0] [lindex $dist 1] [lindex $dist 2] [lindex $dist 3]
		}
	} 
	
	proc dibujarDistanciaMol { base molAt1 molAt2 } {
		upvar #0 VisorGL::$base visor

		set baseData1 [lindex $visor(moleculas) [lindex $molAt1 0]]
		set baseData2 [lindex $visor(moleculas) [lindex $molAt2 0]]
		set at1 [lindex $molAt1 1]
		set at2 [lindex $molAt2 1]
		
		upvar #0 Data::$baseData1 datos1
		upvar #0 Data::$baseData2 datos2
		
		if {$visor(visible,$baseData1,$at1) && $visor(visible,$baseData2,$at2)} {
			set dist [dibujarDistancia $base 	"$datos1(coordX,$at1) $datos1(coordY,$at1) $datos1(coordZ,$at1)" \
									"$datos2(coordX,$at2) $datos2(coordY,$at2) $datos2(coordZ,$at2)"]
			return $dist
		}

	}
	
	proc dibujarDistancia { base p1 p2 } {
		glDisable GL_LIGHTING
		glColor3f 0.0 1.0 0.0
		
		#glEnable GL_LINE_STIPPLE
		#glLineStipple 1 0x00FF
		
		glBegin GL_LINES
			glVertex3f [lindex $p1 0] [lindex $p1 1] [lindex $p1 2]
			glVertex3f [lindex $p2 0] [lindex $p2 1] [lindex $p2 2]
		glEnd
		
		#glDisable GL_LINE_STIPPLE
		glEnable GL_LIGHTING
		
		set c [math::linearalgebra::sub $p2 $p1]
		set dist [math::linearalgebra::norm $c]
		set m [math::linearalgebra::add [math::linearalgebra::scale 0.5 $c] $p1]
		escribirCad3D $base $m "0.0 1.0 0.0" [format "%3.2f" $dist]
		return $dist
	}
	
	proc dibujarAnguloMol { base molAt1 molAt2 molAt3 } {
		upvar #0 VisorGL::$base visor

		set baseData1 [lindex $visor(moleculas) [lindex $molAt1 0]]
		set baseData2 [lindex $visor(moleculas) [lindex $molAt2 0]]
		set baseData3 [lindex $visor(moleculas) [lindex $molAt3 0]]
		
		
		set at1 [lindex $molAt1 1]
		set at2 [lindex $molAt2 1]
		set at3 [lindex $molAt3 1]
		
		upvar #0 Data::$baseData1 datos1
		upvar #0 Data::$baseData2 datos2
		upvar #0 Data::$baseData3 datos3
		
		if {$visor(visible,$baseData1,$at1) && $visor(visible,$baseData2,$at2) && \
			$visor(visible,$baseData3,$at3) } {
			set ang [dibujarAngulo $base "$datos1(coordX,$at1) $datos1(coordY,$at1) $datos1(coordZ,$at1)" \
								"$datos2(coordX,$at2) $datos2(coordY,$at2) $datos2(coordZ,$at2)" \
								"$datos3(coordX,$at3) $datos3(coordY,$at3) $datos3(coordZ,$at3)"]
			return $ang
		}
	}
	
	proc dibujarAngulo { base p1 orig p2 } {
		glDisable GL_LIGHTING
		glColor3f 0.0 1.0 0.0
		
		#glEnable GL_LINE_STIPPLE
		#glLineStipple 1 0x00FF
		
		glBegin GL_LINE_STRIP
			glVertex3f [lindex $p1 0] [lindex $p1 1] [lindex $p1 2]
			glVertex3f [lindex $orig 0] [lindex $orig 1] [lindex $orig 2]
			glVertex3f [lindex $p2 0] [lindex $p2 1] [lindex $p2 2]
		glEnd
		
		#glDisable GL_LINE_STIPPLE
		glEnable GL_LIGHTING
		
		set ang [dibujarSemiarco $base $p1 $orig $p2]
		return $ang
	}

	proc dibujarSemiarco2 { base p1 orig p2 } {
		set a [math::linearalgebra::sub $p1 $orig]
		set b [math::linearalgebra::sub $p2 $orig]

		set ang [math::linearalgebra::angle $a $b]
		set ang [expr $ang * $math::constants::radtodeg]
		
		set longa [math::linearalgebra::norm $a]
		set longb [math::linearalgebra::norm $b]
		
		if { $longa < $longb } {
			set x $a ; set y $b
		} else {
			set x $b ; set y $a
		}

		#'x' es el vector mas corto e 'y' el mas largo 
		#igualo las longitudes
		set longMin [math::linearalgebra::norm $x] 
		set m [math::linearalgebra::scale [math::linearalgebra::norm $longMin] \
										 [math::linearalgebra::unitLengthVector $y]]
		
		# 'x' e 'y' vectores de la misma longitud
		
		#vector q une los extremos del angulo
		set c [math::linearalgebra::sub $m $x]
		
		glDisable GL_LIGHTING
		glColor3f 0.0 1.0 0.0
		
		
		glBegin GL_LINE_STRIP	
			set resArco 10.0	
			set inc [expr 1.0 / $resArco]
			for {set i 0} {$i <= $resArco} {incr i} {
				set p [math::linearalgebra::scale [expr $i*$inc] $c]
				set p [math::linearalgebra::add $p $x]
				set p [math::linearalgebra::unitLengthVector $p]
				set p [math::linearalgebra::scale $longMin $p]
				set p [math::linearalgebra::add $p $orig]
				
				glVertex3f [lindex $p 0] [lindex $p 1] [lindex $p 2]	
			}
		glEnd	
		glEnable GL_LIGHTING
		
		#pinto el valor del angulo en el punto medio del arco
		set p [math::linearalgebra::scale 0.5 $c]
		set p [math::linearalgebra::add $p $x]
		set p [math::linearalgebra::unitLengthVector $p]
		set p [math::linearalgebra::scale $longMin $p]
		set p [math::linearalgebra::add $p $orig]
		
		escribirCad3D $base $p "0.0 1.0 0.0" [format "%3.2f" $ang]
	}
	
	
	proc dibujarSemiarco { base p1 orig p2 } {
		
		#dibujarSemiarco2 $base $p1 $orig $p2
		
		
		set a [math::linearalgebra::sub $p1 $orig]
		set b [math::linearalgebra::sub $p2 $orig]

		set ang [math::linearalgebra::angle $a $b]
		set ang [expr $ang * $math::constants::radtodeg]
		
		set longa [math::linearalgebra::norm $a]
		set longb [math::linearalgebra::norm $b]
		
		if { $longa < $longb } {
			set x $a ; set y $b
		} else {
			set x $b ; set y $a
		}

		#'x' es el vector mas corto e 'y' el mas largo 
		#igualo las longitudes
		set longMin [math::linearalgebra::norm $x] 
		set m [math::linearalgebra::scale [math::linearalgebra::norm $longMin] \
										 [math::linearalgebra::unitLengthVector $y]]
		
		# 'x' e 'y' vectores de la misma longitud
		
		#vector q une los extremos del angulo
		set c [math::linearalgebra::sub $m $x]
		
		set p [math::linearalgebra::scale 0.5 $c]
		set p [math::linearalgebra::add $p $x]
		set p [math::linearalgebra::unitLengthVector $p]
		set p [math::linearalgebra::scale $longMin $p]
		set p [math::linearalgebra::add $p $orig]
		
		
		set ctrlPoints [list [math::linearalgebra::add $x $orig] $p [math::linearalgebra::add $m $orig]]
		
		

		#set ctrlPoints [list]
		#glBegin GL_LINE_STRIP	
		#	set resArco 10.0	
		#	set inc [expr 1.0 / $resArco]
		#	for {set i 0} {$i <= $resArco} {incr i} {
		#		set p [math::linearalgebra::scale [expr $i*$inc] $c]
		#		set p [math::linearalgebra::add $p $x]
		#		set p [math::linearalgebra::unitLengthVector $p]
		#		set p [math::linearalgebra::scale $longMin $p]
		#		set p [math::linearalgebra::add $p $orig]
				
		#		lappend ctrlPoints $p
				
		#		glVertex3f [lindex $p 0] [lindex $p 1] [lindex $p 2]	
		#	}
		#glEnd	
		
		
		glDisable GL_LIGHTING
		glColor3f 0.0 1.0 0.0
		
		glEnable GL_MAP1_VERTEX_3
		glMap1f GL_MAP1_VERTEX_3 0.0 1.0 3 [llength $ctrlPoints] [join $ctrlPoints]
		glBegin GL_LINE_STRIP
                for { set i 0 } { $i <= 30 } { incr i } {
                    glEvalCoord1f [expr double ($i)/30.0]
                }
                glEnd
		glDisable GL_MAP1_VERTEX_3
		
		puts "Control Points $ctrlPoints"
		glPointSize 5.0
                glColor3f 1.0 1.0 0.0
                glBegin GL_POINTS
                for { set i 0 } { $i < [llength $ctrlPoints] } { incr i } {
                    glVertex3fv [lindex $ctrlPoints $i]
                }
                glEnd
		
		
		glPointSize 1.0
		glEnable GL_LIGHTING
		
		#pinto el valor del angulo en el punto medio del arco
		
		
		escribirCad3D $base $p "0.0 1.0 0.0" [format "%3.2f" $ang]
		
		return $ang
		
	}
	
	proc dibujarTorsionMol { base molAt1 molAt2 molAt3 molAt4 } {
		upvar #0 VisorGL::$base visor

		set baseData1 [lindex $visor(moleculas) [lindex $molAt1 0]]
		set baseData2 [lindex $visor(moleculas) [lindex $molAt2 0]]
		set baseData3 [lindex $visor(moleculas) [lindex $molAt3 0]]
		set baseData4 [lindex $visor(moleculas) [lindex $molAt4 0]]
		
		
		set at1 [lindex $molAt1 1]
		set at2 [lindex $molAt2 1]
		set at3 [lindex $molAt3 1]
		set at4 [lindex $molAt4 1]
		
		upvar #0 Data::$baseData1 datos1
		upvar #0 Data::$baseData2 datos2
		upvar #0 Data::$baseData3 datos3
		upvar #0 Data::$baseData4 datos4
		
		if {$visor(visible,$baseData1,$at1) && $visor(visible,$baseData2,$at2) && \
			$visor(visible,$baseData3,$at3) && $visor(visible,$baseData4,$at4) } { 
			set ang [dibujarTorsion $base	"$datos1(coordX,$at1) $datos1(coordY,$at1) $datos1(coordZ,$at1)" \
									"$datos2(coordX,$at2) $datos2(coordY,$at2) $datos2(coordZ,$at2)" \
									"$datos3(coordX,$at3) $datos3(coordY,$at3) $datos3(coordZ,$at3)" \
									"$datos4(coordX,$at4) $datos4(coordY,$at4) $datos4(coordZ,$at4)" ]
			return $ang
		}
		
	}
	
	
	proc dibujarTorsion { base p1 p2 p3 p4 } {
		glDisable GL_LIGHTING
		glColor3f 0.0 1.0 0.0
		
		#calculo del vector del plano formado por p1, p2 y p3, perpendicular a la recta p3-p2
		
		set x1 [math::linearalgebra::sub $p1 $p2]
		set x2 [math::linearalgebra::sub $p3 $p2]
		
		set v1 [math::linearalgebra::crossproduct $x1 $x2] ; #usado para calcular es sentido del angulo despues
		set center [math::linearalgebra::scale 0.5 $x2]
		#puts "center $center"
		
		set x3 [Data::calculoProyecc $x1 $x2]
		set x4 [math::linearalgebra::sub $x1 $x3]
		
		set x5 [math::linearalgebra::scale 1 $x4]
		
		set x6 [math::linearalgebra::add $x5 $center]

		#a1 esta en el centro de p3-p2, perpendicualrmente a un distancia de 0.5*proyeccion
		set a1 [math::linearalgebra::add $x6 $p2]
		
		
		#calculo a2 como la interseccion de la recta que pasa por el punto O, y vector x1, y la recta que pasa por x5, y vector x3
		#recta 1 : r1 = O + s*x1
		#recta 2 : r2 = x5 + t*x3
		set A [list [list [lindex $x1 0] [lindex $x3 0]] [list [lindex $x1 1] [lindex $x3 1]]]
		set b [list [lindex $x5 0] [lindex $x5 1]]
		set res [catch {math::linearalgebra::solveGauss $A $b} sol]
		
		if {$res == 1} {
			#se ha producido un error las rectas son paralelas, por lo que no es necesario pintar
			#se le asignara el mismo valor de a1
			set a2 $a1
		} else {
			set x7 [math::linearalgebra::scale [lindex $sol 0] $x1]
			set a2 [math::linearalgebra::add $x7 $p2]
		}

		#para el otro lado
		set x1 [math::linearalgebra::sub $p4 $p3]
		set x2 [math::linearalgebra::sub $p2 $p3]
		
		set v2 [math::linearalgebra::crossproduct $x1 $x2] ; #usado para calcular es sentido del angulo despues
		
		set center [math::linearalgebra::scale 0.5 $x2]
		
		set x3 [Data::calculoProyecc $x1 $x2]
		set x4 [math::linearalgebra::sub $x1 $x3]
		
		set x5 [math::linearalgebra::scale 1 $x4]
		
		set x6 [math::linearalgebra::add $x5 $center]
		set x7 [math::linearalgebra::add $x5 $x3]
		
		
		#a1 esta en el centro de p2-p3, perpendicualrmente a un distancia de 0.5*proyeccion
		set a3 [math::linearalgebra::add $x6 $p3]
		
		#calculo a4 como la interseccion de la recta que pasa por el punto O, y vector x1, y la recta que pasa por x5, y vector x3
		#recta 1 : r1 = O + s*x1
		#recta 2 : r2 = x5 + t*x3
		set A [list [list [lindex $x1 0] [lindex $x3 0]] [list [lindex $x1 1] [lindex $x3 1]]]
		set b [list [lindex $x5 0] [lindex $x5 1]]
		set res [catch {math::linearalgebra::solveGauss $A $b} sol]
		
		if {$res == 1} {
			#se ha producido un error las rectas son paralelas, por lo que no es necesario pintar
			#se le asignara el mismo valor de a1
			set a2 $a1
		} else {
			set x7 [math::linearalgebra::scale [lindex $sol 0] $x1]
			set a4 [math::linearalgebra::add $x7 $p3]
		}
		set center [math::linearalgebra::add $center $p3]
		
		glBegin GL_LINE_STRIP	
			glVertex3f [lindex $p1 0] [lindex $p1 1] [lindex $p1 2]
			glVertex3f [lindex $p2 0] [lindex $p2 1] [lindex $p2 2]
			glVertex3f [lindex $p3 0] [lindex $p3 1] [lindex $p3 2]
			glVertex3f [lindex $p4 0] [lindex $p4 1] [lindex $p4 2]
		glEnd
		glBegin GL_LINES
			glVertex3f [lindex $p1 0] [lindex $p1 1] [lindex $p1 2]
			glVertex3f [lindex $a1 0] [lindex $a1 1] [lindex $a1 2]
			glVertex3f [lindex $p4 0] [lindex $p4 1] [lindex $p4 2]
			glVertex3f [lindex $a3 0] [lindex $a3 1] [lindex $a3 2]			
		glEnd
		
		glEnable GL_LIGHTING
		
		set ang [dibujarAngulo $base $a1 $center $a3]
		return $ang
	}
	
	#---------------------------------------------------------------------------------------------
	
	#-------------------------------- PUENTES DE HIDROGENO ---------------------------------------
	
	proc crearPuentesH { base } {
		upvar #0 VisorGL::$base visor
		#eliminarPuentesH $base
		set visor(listaPuentesH) [list]
		if {[llength $visor(elemsPuentesH)] > 0} {
			set listaPuentes [Data::calculaPuentesHidrogeno $visor(moleculas) $visor(elemsPuentesH) $visor(distPuentesH)]
			foreach puen $listaPuentes {
				set i [lindex $puen 0]
				set j [lindex $puen 1]
				if {$visor(visible,[lindex $i 0],[lindex $i 1]) && $visor(visible,[lindex $j 0],[lindex $j 1])} {
					#lappend visor(listaPuentesH) [list "[lindex $i 0] [lindex $i 1]" "[lindex $j 0] [lindex $j 1]"]
					lappend visor(listaPuentesH) $puen
				}
			}
			#dibujarPuentesH $base
		}
		#puts "Lista PH : $visor(listaPuentesH)"
		set visor(puentesHModificados) 1
	}
	
	proc eliminarPuentesH { base } {
		upvar #0 VisorGL::$base visor
		set visor(listaPuentesH) [list]
		set visor(phMostrar)			0
		set visor(puentesHModificados) 	1
	}
	
	proc dibujarPuentesH { base } {
		upvar #0 VisorGL::$base visor
		foreach puen $visor(listaPuentesH) {
			set i [lindex $puen 0]
			set j [lindex $puen 1]
			set at1 [lindex $i 1]
			set at2 [lindex $j 1]
			
			upvar #0 Data::[lindex $i 0] datos1
			upvar #0 Data::[lindex $j 0] datos2
			
			dibujarPuenteH $base 	"$datos1(coordX,$at1) $datos1(coordY,$at1) $datos1(coordZ,$at1)" \
									"$datos2(coordX,$at2) $datos2(coordY,$at2) $datos2(coordZ,$at2)"
		}
	}
	
	proc dibujarPuenteH { base p1 p2 } {
		glDisable GL_LIGHTING
		glColor3f 0.0 1.0 0.0
		
		glEnable GL_LINE_STIPPLE
		glLineStipple 1 0x00FF
		
		glBegin GL_LINES
			glVertex3f [lindex $p1 0] [lindex $p1 1] [lindex $p1 2]
			glVertex3f [lindex $p2 0] [lindex $p2 1] [lindex $p2 2]
		glEnd
		
		glDisable GL_LINE_STIPPLE
		glEnable GL_LIGHTING
	}
	
	
	
	#---------------------------------------------------------------------------------------------
	
	#-------------------------------------- EDICION ---------------------------------------------
	proc moverAtomos { base listMolAt v } {
		upvar #0 VisorGL::$base visor
		foreach ma $listMolAt {
			moverAtomoMol $base [lindex $visor(moleculas) [lindex $ma 0]] [lindex $ma 1] $v
		}
		set visor(molModificadas) 		1
		set visor(molModificadasSelect) 	1
		set visor(medidasModificadas) 		1
		set visor(etqModificadas) 		1
		set visor(phModificados)		1
	}
	
	proc moverAtomoMol { base baseData at v } {
		upvar #0 VisorGL::$base visor
		upvar #0 Data::$baseData datos
		
		set datos(coordX,$at) [expr $datos(coordX,$at) + [lindex $v 0]]
		set datos(coordY,$at) [expr $datos(coordY,$at) + [lindex $v 1]]
		set datos(coordZ,$at) [expr $datos(coordZ,$at) + [lindex $v 2]]
	} 
	
	#-----------------------------------------------------------------------------------------
	
	#--------------------------------------- ETIQUETAS ---------------------------------------
	
	proc establecerEtiquetasAMostrar { base etq onOff } {
		upvar #0 VisorGL::$base visor

		switch $etq {
			ID {set visor(etqId) $onOff}
			CODB {set visor(etqCodB) $onOff}
			CARGA {set visor(etqCarga) $onOff}
			CODTINK {set visor(etqCodTink) $onOff}
			QUIRA {set visor(etqQuira) $onOff}
		}
		set visor(etqModificadas) 1
	}
	
	proc dibujarEtiquetas { base } {
		upvar #0 VisorGL::$base visor
		foreach mol $visor(moleculas) {
			upvar #0 Data::$mol datos
			for {set x 0} {$x < $datos(numAtomos)} {incr x} {
				if {$visor(visible,$mol,$x)} {
					set text ""
					if {$visor(etqId)} 		{append text " [expr $x + 1] " }
					if {$visor(etqCodB)} 	{append text " [Data::codBrandy $mol $x] " }
					if {$visor(etqCarga)} 	{append text " $datos(carga,$x) " }
					if {$visor(etqCodTink)} {Fich::calculaProcsConvPRM $visor(baseConf) ; append text " [Fich::obtenerCodXYZ $mol $x] " }
					if {$visor(etqQuira)} {
						set index [lsearch $datos(quiralidad) [list $x *]]
						if {$index != -1} { append text "[lindex [lindex $datos(quiralidad) $index] 1]\n" }
					}
					if {$text != ""} {
						set despl "0.2 0.2 0.2"
						escribirCad3D $base [math::linearalgebra::add "$datos(coordX,$x) $datos(coordY,$x) $datos(coordZ,$x)" $despl] \
											"0.0 1.0 0.0" $text
					}
				}
			}
		}
	}
	#-----------------------------------------------------------------------------------------
	
	#----------------------------------- ROTACION MOLECULAS ----------------------------------
	proc calculaEjesCameraBB { base listBaseData } {
		upvar #0 VisorGL::$base visor
		
		set bB [boundingBox $base $listBaseData]
		
		#extremos de la Bounding Box
		set ext1 [list [lindex $bB 0] [lindex $bB 2] [lindex $bB 4]]
		set ext2 [list [lindex $bB 1] [lindex $bB 3] [lindex $bB 5]]
		
		#vector entre los extremos de la Bounding Box
		set vBB [math::linearalgebra::sub $ext2 $ext1]
		
		set center [math::linearalgebra::scale 0.5 $vBB]
		set center [math::linearalgebra::add $center $ext1]
		
		
		#calculo el ejeY
		set ejeY [math::linearalgebra::add $visor(camaraUp) $center]
		
		#calculo el ejeZ
		set b [math::linearalgebra::sub $visor(camaraFocal) $visor(camaraPos)]
		set ejeZ [math::linearalgebra::add $b $center]

		
		set ejeX [math::linearalgebra::crossproduct $b $visor(camaraUp)]
		set ejeX [math::linearalgebra::add $ejeX $center]
		
		return "[list $center] [list $ejeX] [list $ejeY] [list $ejeZ]"
	}
	
	proc rotarMolsEje2 { base listBaseData p1 p2 ang } {
		upvar #0 VisorGL::$base visor
		
		set axis [tcl3dVectorFromList GLfloat [math::linearalgebra::sub $p2 $p1]]
		#set m [tcl3dVector GLfloat 16]
		#set mT [tcl3dVector GLfloat 16]
		#set miT [tcl3dVector GLfloat 16]
		#set mR [tcl3dVector GLfloat 16]
		set m [tcl3dVectorFromList GLfloat $visor(mat16)]
		set mT [tcl3dVectorFromList GLfloat $visor(mat16)]
		set miT [tcl3dVectorFromList GLfloat $visor(mat16)]
		set mR [tcl3dVectorFromList GLfloat $visor(mat16)]
		
		
		tcl3dMatfTranslate [expr - [lindex $p1 0]]  [expr - [lindex $p1 1]] [expr - [lindex $p1 2]] $mT
		tcl3dMatfRotate $ang $axis $mR
		tcl3dMatfTranslate [lindex $p1 0]  [lindex $p1 1] [lindex $p1 2] $miT
		
		#puts "p1 : $p1"
		#puts "p2 : $p2"
		
		#puts "\nmT"
		#tcl3dMatfPrint $mT
		
		#puts "\nMR"
		#tcl3dMatfPrint $mR
		
		#puts "\nmiT"
		#tcl3dMatfPrint $miT
		
		
		
		tcl3dMatfMult $miT $mR $m
		tcl3dMatfMult $m $mT $m
		
		
	#	puts "\nmRes"
	#	tcl3dMatfPrint $m
		
		#puts "\nmRes to List"
		#puts [tcl3dVectorToList $m 16]
		#set xx [tcl3dVectorToList $m 16]
		#set nRest [list 	[list [lindex $xx 0] [lindex $xx 4] [lindex $xx 8] [lindex $xx 12]] \
						 	[list [lindex $xx 1] [lindex $xx 5] [lindex $xx 9] [lindex $xx 13]] \
		 					[list [lindex $xx 2] [lindex $xx 6] [lindex $xx 10] [lindex $xx 14]] \
		 					[list [lindex $xx 3] [lindex $xx 7] [lindex $xx 11] [lindex $xx 15]]]
		
		#puts "\nnRest : $nRest"
		
		foreach mol $listBaseData {		
			upvar #0 Data::$mol datos		
			for {set x 0} {$x < $datos(numAtomos)} {incr x} {
				set pos [tcl3dVectorFromList GLfloat "$datos(coordX,$x) $datos(coordY,$x) $datos(coordZ,$x) 1.0"]
	
				tcl3dMatfTransformVector $pos $m $pos
				#puts "\npos"
				#tcl3dVectorPrint $pos 4
				
						
				set npos [tcl3dVectorToList $pos 3]
				
		#		puts "Pos segun 1 : $npos"
				#puts "Npos   : $npos"
				
				#puts "PosTCL : [math::linearalgebra::matmul $nRest [list $datos(coordX,$x) $datos(coordY,$x) $datos(coordZ,$x) 1.0]]"
				#set npos [math::linearalgebra::matmul $nRest [list $datos(coordX,$x) $datos(coordY,$x) $datos(coordZ,$x) 1.0]]
				
				
				set datos(coordX,$x) [lindex $npos 0]
				set datos(coordY,$x) [lindex $npos 1]
				set datos(coordZ,$x) [lindex $npos 2]
				
				$pos Delete
			}
		}
		
		$m Delete
		$mT Delete
		$miT Delete
		
		$axis Delete
		
		
		set visor(molModificadas) 		1
		set visor(molModificadasSelect) 1
		set visor(medidasModificadas) 	1
		set visor(etqModificadas) 		1
	}
	
	#obsoleta
	proc rotarMolsEje { base listBaseData ejeA ejeB ang } {
		upvar #0 VisorGL::$base visor
		
		set eje [math::linearalgebra::sub $ejeB $ejeA]

		set T [matfTranslate [math::linearalgebra::scale -1 $ejeA]]
		set iT [matfTranslate $ejeA]
		set mRot [matfRotate $ang $eje]
		
		
		set Res [math::linearalgebra::matmul $iT $mRot]
		set Res [math::linearalgebra::matmul $Res $T]

		
						 
		#	puts "\n\nMRES :\n[lindex $Res 0]\n[lindex $Res 1]\n[lindex $Res 2]\n[lindex $Res 3]" 
		
		
		return $Res
		
		foreach mol $listBaseData {		
			upvar #0 Data::$mol datos		
			for {set x 0} {$x < $datos(numAtomos)} {incr x} {
				set pos [list $datos(coordX,$x) $datos(coordY,$x) $datos(coordZ,$x) 1.0]
				set npos [math::linearalgebra::matmul $Res $pos]
				
		#		puts "Pos segun 2 : $npos"
				set datos(coordX,$x) [lindex $npos 0]
				set datos(coordY,$x) [lindex $npos 1]
				set datos(coordZ,$x) [lindex $npos 2]
			}
		}
			
		set visor(molModificadas) 		1
		set visor(molModificadasSelect) 	1
		set visor(medidasModificadas) 		1
		set visor(etqModificadas) 		1
	}
	
	proc rotarMolsMatriz { base matrix } {
		upvar #0 VisorGL::$base visor
		
		if {$visor(listaMolRotar) != [list]} {
		
        		foreach mol $visor(listaMolRotar) {		
        			upvar #0 Data::$mol datos		
        			for {set x 0} {$x < $datos(numAtomos)} {incr x} {
        				set pos [list $datos(coordX,$x) $datos(coordY,$x) $datos(coordZ,$x) 1.0]
        				set npos [math::linearalgebra::matmul $matrix $pos]
        				
        		#		puts "Pos segun 2 : $npos"
        				set datos(coordX,$x) [lindex $npos 0]
        				set datos(coordY,$x) [lindex $npos 1]
        				set datos(coordZ,$x) [lindex $npos 2]
        			}
        		}
        			
        		set visor(molModificadas) 		1
        		set visor(molModificadasSelect) 	1
        		set visor(medidasModificadas) 		1
        		set visor(etqModificadas) 		1
			set visor(phModificados) 		1
			
		}
		
	}

	proc rotarMolsEje3 { base listBaseData ejeA ejeB ang } {
		upvar #0 VisorGL::$base visor
		
		set ab [math::linearalgebra::sub $ejeB $ejeA]
		set axis $ab
		set angle $ang
		set longT [math::linearalgebra::norm $ab]
		
		
		#Matriz de traslacion
		set T [list [list 1.0 0.0 0.0 [expr - [lindex $ejeA 0]]] \
					[list 0.0 1.0 0.0 [expr - [lindex $ejeA 1]]] \
					[list 0.0 0.0 1.0 [expr - [lindex $ejeA 2]]] \
					[list 0.0 0.0 0.0 1.0]]
		
		#inversa de la matriz de traslacion
		set iT [list [list 1.0 0.0 0.0 [lindex $ejeA 0]] \
					 [list 0.0 1.0 0.0 [lindex $ejeA 1]] \
					 [list 0.0 0.0 1.0 [lindex $ejeA 2]] \
					 [list 0.0 0.0 0.0 1.0]]
		
		
		
		
		#----
		set s [expr sin($math::constants::degtorad*$angle)]
		set c [expr cos($math::constants::degtorad*$angle)]
	
		set axis [math::linearalgebra::unitLengthVector $axis]
	
		set ux [lindex $axis 0]
		set uy [lindex $axis 1]
		set uz [lindex $axis 2]
		
		#m[0]  = c + (1-c) * ux;
		#m[1]  = (1-c) * ux*uy + s*uz;
		#m[2]  = (1-c) * ux*uz - s*uy;
		#m[3]  = 0;
		
		#m[4]  = (1-c) * uy*ux - s*uz;
		#m[5]  = c + (1-c) * pow(uy,2);
		#m[6]  = (1-c) * uy*uz + s*ux;
		#m[7]  = 0;
		
		#m[8]  = (1-c) * uz*ux + s*uy;
		#m[9]  = (1-c) * uz*uz - s*ux;
		#m[10] = c + (1-c) * pow(uz,2);
		#m[11] = 0;
		
		#m[12] = 0;
		#m[13] = 0;
		#m[14] = 0;
		#m[15] = 1;
		
		#0 4 8  12
		#1 5 9  13
		#2 6 10 14
		#3 7 11 15
		#----
		#segun tcl3D
		#set R [list [list [expr $c + (1-$c) * $ux] 			[expr (1-$c) * $uy*$ux - $s*$uz] 	[expr (1-$c) * $uz*$ux + $s*$uy] 0.0] \
					[list [expr (1-$c) * $ux*$uy + $s*$uz] 	[expr $c + (1-$c) * pow($uy,2)] 	[expr (1-$c) * $uz*$uz - $s*$ux] 0.0] \
					[list [expr (1-$c) * $ux*$uz - $s*$uy] 	[expr (1-$c) * $uy*$uz + $s*$ux] 	[expr $c + (1-$c) * pow($uz,2)] 0.0] \
					[list 0.0 0.0 0.0 1.0]]
		#segun OpenGL
		set R [list [list [expr $c+(1-$c)*pow($ux,2)] 		[expr (1-$c) * $uy*$ux - $s*$uz] 	[expr (1-$c) * $uz*$ux + $s*$uy] 0.0] \
					[list [expr (1-$c) * $ux*$uy + $s*$uz] 	[expr $c + (1-$c) * pow($uy,2)] 	[expr (1-$c) * $uy*$uz - $s*$ux] 0.0] \
					[list [expr (1-$c) * $ux*$uz - $s*$uy] 	[expr (1-$c) * $uy*$uz + $s*$ux] 	[expr $c + (1-$c) * pow($uz,2)] 0.0] \
					[list 0.0 0.0 0.0 1.0]]
		
		#Observar diferencias, tcl3d contiene errores
					 
		 #calculo una matriz que agrupa todas las transformaciones
		 set Res [list [list 1.0 0.0 0.0 0.0] \
				 [list 0.0 1.0 0.0 0.0] \
				 [list 0.0 0.0 1.0 0.0] \
				 [list 0.0 0.0 0.0 1.0]]
					 
		set Res [math::linearalgebra::matmul $iT $R]
		set Res [math::linearalgebra::matmul $Res $T]
					 
	#	puts "\n\nMRES3 :\n[lindex $Res 0]\n[lindex $Res 1]\n[lindex $Res 2]\n[lindex $Res 3]" 
	
		
		foreach mol $listBaseData {		
			upvar #0 Data::$mol datos		
			for {set x 0} {$x < $datos(numAtomos)} {incr x} {
				set pos [list $datos(coordX,$x) $datos(coordY,$x) $datos(coordZ,$x) 1.0]
				set npos [math::linearalgebra::matmul $Res $pos]
				
			#	puts "Pos segun 3 : $npos"
				
				set datos(coordX,$x) [lindex $npos 0]
				set datos(coordY,$x) [lindex $npos 1]
				set datos(coordZ,$x) [lindex $npos 2]
			}
		}
		
		 set visor(molModificadas) 			1
		 set visor(molModificadasSelect) 	1
		 set visor(medidasModificadas) 		1
		 set visor(etqModificadas) 			1														 
	}
	
	#--------------------------------- ORBITALES ------------------------------------------------
	#obsoleto
	proc leerFichMaya { filenameBase } {
		
		#set den "POS"
		
		#obtengo el numero de atomos del fichero mol original
		set f [list $filenameBase]_P.bma
		set fMay [open $f r+]
		set maya [list]
	
		#puts "Fichero Orbital : $f"
		
		#ignoro 4 primeras lineas
		gets $fMay linea 
		#puts "--> $linea"
		gets $fMay linea
		#puts "--> $linea"
		gets $fMay linea
		#puts "--> $linea"
		gets $fMay linea
		#puts "--> $linea"
		
		
		glPolygonMode GL_FRONT_AND_BACK GL_LINE
		
		
		glColor3f 1.0 0.1 0.1
		#glPolygonMode GL_FRONT_AND_BACK GL_LINE
		glBegin GL_TRIANGLES
		
		
		while {![eof $fMay] } {
			#set linea [split $linea " "]
			#lappend maya $linea
			#puts $linea
			for {set i 1} {$i <= 3} {incr i} {
        			gets $fMay normal
        			gets $fMay vertex
				
				#puts "normal $normal"
				#puts "vertex $vertex"
				glNormal3f [lindex $normal 0] [lindex $normal 1] [lindex $normal 2]
				glVertex3f [lindex $vertex 0] [lindex $vertex 1] [lindex $vertex 2]
			}
			#ignoro linea
			gets $fMay linea
			
			#gets $fMay linea
		}
		
		#glPolygonMode GL_FRONT_AND_BACK GL_FILL
		glEnd
		#glPolygonMode GL_FRONT_AND_BACK GL_FILL
		#puts $maya
		
		close $fMay
		
		
		
		#obtengo el numero de atomos del fichero mol original
		#set den "NEG"
		set f [list $filenameBase]_N.bma
		set fMay [open $f r+]
		set maya [list]
		
		#ignoro 4 primeras lineas
		gets $fMay linea ; gets $fMay linea
		gets $fMay linea ; gets $fMay linea
		
		
		#glPolygonMode GL_FRONT_AND_BACK GL_LINE
		
		
		glColor3f 0.1 0.1 1.0
		glPolygonMode GL_FRONT_AND_BACK GL_FILL
		glBegin GL_TRIANGLES
		
		
		while {![eof $fMay] } {
			#set linea [split $linea " "]
			#lappend maya $linea
			#puts $linea
			for {set i 1} {$i <= 3} {incr i} {
        			gets $fMay normal
        			gets $fMay vertex
				
				#puts "normal $normal"
				#puts "vertex $vertex"
				glNormal3f [lindex $normal 0] [lindex $normal 1] [lindex $normal 2]
				glVertex3f [lindex $vertex 0] [lindex $vertex 1] [lindex $vertex 2]
			}
			#ignoro linea
			gets $fMay linea
			
			#gets $fMay linea
		}
		
		#glPolygonMode GL_FRONT_AND_BACK GL_FILL
		glEnd
		#glPolygonMode GL_FRONT_AND_BACK GL_FILL
		#puts $maya
		
		close $fMay
		
		
		glPolygonMode GL_FRONT_AND_BACK GL_FILL
		
	}
	
	proc pintaNormalesFicheroMaya { filenameBase } {
		set den "NEG"
		set fMay [open "$filenameBase$den.bma" r+]
		set maya [list]
		
		glDisable GL_LIGHTING
		glColor3f 0.0 1.0 0.0
		#glPolygonMode GL_FRONT_AND_BACK GL_FILL
		glBegin GL_LINES
		
		#ignoro 4 primeras lineas
		gets $fMay linea ; gets $fMay linea
		gets $fMay linea ; gets $fMay linea
		
		set cont 0
		while {![eof $fMay]  } {
			
			#set linea [split $linea " "]
			#lappend maya $linea
			#puts $linea
			for {set i 1} {$i <= 3} {incr i} {
        			gets $fMay normal
        			gets $fMay vertex
				
				#puts "normal $normal"
				#puts "vertex $vertex"
				set normal [math::linearalgebra::add $normal $vertex]
				
				
				glVertex3f [lindex $normal 0] [lindex $normal 1] [lindex $normal 2]
				glVertex3f [lindex $vertex 0] [lindex $vertex 1] [lindex $vertex 2]
			}
			#ignoro linea
			gets $fMay linea
			
			#gets $fMay linea
			incr cont
		}
		glEnd
		glEnable GL_LIGHTING
		close $fMay
	}
	
	
	proc pintaCubo { base } {
		
		set dimensions 	[list 51 51 51]
		set origin 	[list -4.79173374 -4.81841993 -4.11713028]
		set spacing 	[list 0.307566881 0.289487869 0.302819669]
		
		set longX [expr 51*[lindex $spacing 0]]
		set longY [expr 51*[lindex $spacing 1]]
		set longZ [expr 51*[lindex $spacing 2]]
		
		glDisable GL_LIGHTING
		glColor3f 1.0 0.0 0.0
		glPolygonMode GL_FRONT_AND_BACK GL_LINE
		glBegin GL_LINES
		
		
		
		#pinto 
		
		
		set z [lindex $origin 2]
		
		set x -4.79173374
		for {set i 0} { $i < 51 } { incr i } {
			set y -4.81841993
			for {set j 0} { $j < 51 } { incr j } {
				
					glVertex3f $x $y $z
					glVertex3f $x $y [expr $z + $longZ*(4/51.0)]
					
				
				set y [expr $y + 0.289487869]
			}
			set x [expr $x + 0.307566881]
		}
		
		
		set x [lindex $origin 0]
		set z -4.11713028
		for {set k 0} { $k < 51 } { incr k } {
			set y -4.81841993
			for {set j 0} { $j < 51 } { incr j } {
				
					glVertex3f $x $y $z
					glVertex3f [expr $x + $longX*(4/51.0)] $y $z
					
				
				set y [expr $y + 0.289487869]
			}
			set z [expr $z + 0.302819669]
		}
		
		set y [lindex $origin 1]
		set x -4.79173374
		for {set i 0} { $i < 51 } { incr i } {
			set z -4.11713028
			for {set k 0} { $k < 51 } { incr k } {
				
					glVertex3f $x $y $z
					glVertex3f $x [expr $y + $longY*(4/51.0)] $z
					
				
				set z [expr $z + 0.302819669]
			}
			set x [expr $x + 0.307566881]
		}
		
		glEnd
		glEnable GL_LIGHTING
		glPolygonMode GL_FRONT_AND_BACK GL_FILL
		glColor3f 0.0 1.0 0.0
	}
	
	
	proc pintaCubo2 { base } {
		
		set dimensions 	[list 51 51 51]
		set origin 	[list -4.66762781 -4.05242491 -5.12728786]
		set spacing 	[list 0.212748334  0.202426419  0.178255647]
		
		set longX [expr 51*[lindex $spacing 0]]
		set longY [expr 51*[lindex $spacing 1]]
		set longZ [expr 51*[lindex $spacing 2]]
		
		glDisable GL_LIGHTING
		glColor3f 0.0 1.0 0.0
		
		glBegin GL_LINE_LOOP
			glVertex3f [lindex $origin 0] [lindex $origin 1] [lindex $origin 2]
			glVertex3f [expr [lindex $origin 0] + $longX] [lindex $origin 1] [lindex $origin 2]
			glVertex3f [expr [lindex $origin 0] + $longX] [expr [lindex $origin 1] + $longY] [lindex $origin 2]
			glVertex3f [lindex $origin 0] [expr [lindex $origin 1] + $longY] [lindex $origin 2]
		glEnd
		
		glBegin GL_LINE_LOOP
			glVertex3f [lindex $origin 0] [lindex $origin 1] [expr [lindex $origin 2] + $longZ]
			glVertex3f [expr [lindex $origin 0] + $longX] [lindex $origin 1] [expr [lindex $origin 2] + $longZ]
			glVertex3f [expr [lindex $origin 0] + $longX] [expr [lindex $origin 1] + $longY] [expr [lindex $origin 2] + $longZ]
			glVertex3f [lindex $origin 0] [expr [lindex $origin 1] + $longY] [expr [lindex $origin 2] + $longZ]
		glEnd
		
		glBegin GL_LINES
			glVertex3f [lindex $origin 0] [lindex $origin 1] [lindex $origin 2]
			glVertex3f [lindex $origin 0] [lindex $origin 1] [expr [lindex $origin 2] + $longZ]
		
			glVertex3f [expr [lindex $origin 0] + $longX] [lindex $origin 1] [lindex $origin 2]
			glVertex3f [expr [lindex $origin 0] + $longX] [lindex $origin 1] [expr [lindex $origin 2] + $longZ]
		
			glVertex3f [expr [lindex $origin 0] + $longX] [expr [lindex $origin 1] + $longY] [lindex $origin 2]
			glVertex3f [expr [lindex $origin 0] + $longX] [expr [lindex $origin 1] + $longY] [expr [lindex $origin 2] + $longZ]
		
			glVertex3f [lindex $origin 0] [expr [lindex $origin 1] + $longY] [lindex $origin 2]
			glVertex3f [lindex $origin 0] [expr [lindex $origin 1] + $longY] [expr [lindex $origin 2] + $longZ]
		glEnd
		
		glEnable GL_LIGHTING
		#glColor3f 1.0 0.0 0.0
		
		
		
	}
	
	
	
	#---------------------------------- GEOMETRIA ------------------------------------------------
	
	proc matfTranslate { v } {
		return [list [list 1.0 0.0 0.0 [lindex $v 0]] \
					 [list 0.0 1.0 0.0 [lindex $v 1]] \
					 [list 0.0 0.0 1.0 [lindex $v 2]] \
					 [list 0.0 0.0 0.0 1.0]]
	}
	
	proc matfRotate2 { ang axis } {
		#calcula la proyeccion de ab sobre el plano YZ
		set longT [math::linearalgebra::norm $axis]
		set u "0 [lindex $axis 1] [lindex $axis 2]"
		
		#calculo el angulo q debo rotar ab sobre el eje X para abatirlo sobre el plano XZ
		if {[lindex $u 1] != 0 || [lindex $u 2] != 0} {
			set long [math::linearalgebra::norm $u]
			#sea alphaX el angulo entre u y el plano XZ
			set sinalphaX [expr [lindex $u 1] / $long]
			set cosalphaX [expr [lindex $u 2] / $long]
		} else {
			set long 0.0
			set sinalphaX 0.0
			set cosalphaX 1.0
		}
					
		#matriz de rotacion sobre ejeX
		set RX [list [list 1.0 0.0 0.0 0.0] \
					 [list 0.0 $cosalphaX $sinalphaX 0.0] \
					 [list 0.0 [expr - $sinalphaX] $cosalphaX 0.0] \
					 [list 0.0 0.0 0.0 1.0]]			 
	   
		#inversa de la matriz de rotacion sobre ejeX
		set iRX [list [list 1.0 0.0 0.0 0.0] \
					  [list 0.0 $cosalphaX [expr - $sinalphaX] 0.0] \
					  [list 0.0 $sinalphaX $cosalphaX 0.0] \
					  [list 0.0 0.0 0.0 1.0]]			 
	   
					
	   #calculo el angulo que debo rotar el vector anterior sobre el ejeY para alinearlo con el ejeZ
	   set sinbetaY [expr [lindex $axis 0] / $longT]
	   set cosbetaY [expr $long / $longT]
	   
	   #matriz de rotacion sobre ejeY			 
	   set RY [list [list $cosbetaY 0.0 $sinbetaY 0.0] \
					[list 0.0 1.0 0.0 0.0] \
					[list [expr - $sinbetaY] 0.0 $cosbetaY 0.0] \
					[list 0.0 0.0 0.0 1.0]]			 
					
	   #inversa de la matriz de rotacion sobre ejeY
	   set iRY [list [list $cosbetaY 0.0 [expr - $sinbetaY] 0.0] \
					 [list 0.0 1.0 0.0 0.0] \
					 [list $sinbetaY 0.0 $cosbetaY 0.0] \
					 [list 0.0 0.0 0.0 1.0]]
					
	   #calculo el angulo que debo rotar sobre el eje Z
	   set sinPiZ [expr sin($ang * $math::constants::degtorad)]
	   set cosPiZ [expr cos($ang * $math::constants::degtorad)]
	   
	   #matriz de rotacion sobre el eje Z
	   set RZ [list [list $cosPiZ $sinPiZ 0.0 0.0] \
					[list [expr - $sinPiZ] $cosPiZ 0.0 0.0] \
					[list 0.0 0.0 1.0 0.0] \
					[list 0.0 0.0 0.0 1.0]]					 
	   
		set Res [math::linearalgebra::matmul $RX $RY]
		set Res [math::linearalgebra::matmul $Res $RZ]
		set Res [math::linearalgebra::matmul $Res $iRY]
		set Res [math::linearalgebra::matmul $Res $iRX]
		return $Res
	}
	
	proc matfRotate { angle axis } {
		set s [expr sin($math::constants::degtorad*$angle)]
		set c [expr cos($math::constants::degtorad*$angle)]
	
		set axis [math::linearalgebra::unitLengthVector $axis]
	
		set ux [lindex $axis 0]
		set uy [lindex $axis 1]
		set uz [lindex $axis 2]
		
		
		#segun OpenGL -- > Errores en la implementacion de tcl3d
		set R [list [list [expr $c+(1-$c)*pow($ux,2)] 		[expr (1-$c) * $uy*$ux - $s*$uz] 	[expr (1-$c) * $uz*$ux + $s*$uy] 0.0] \
					[list [expr (1-$c) * $ux*$uy + $s*$uz] 	[expr $c + (1-$c) * pow($uy,2)] 	[expr (1-$c) * $uy*$uz - $s*$ux] 0.0] \
					[list [expr (1-$c) * $ux*$uz - $s*$uy] 	[expr (1-$c) * $uy*$uz + $s*$ux] 	[expr $c + (1-$c) * pow($uz,2)] 0.0] \
					[list 0.0 0.0 0.0 1.0]]
		return $R
		
	}
	
	#-----------------------------------------------------------------------------------------
	
	#---------------------------------- MISCELANEAS ------------------------------------------
	
	#devuelve el color asociado al simbolo de un atomo
	proc colorToRGB { val } {
		set rr 0; set gg 0; set bb 0
		scan $val "#%2x%2x%2x" rr gg bb
		set rr [format "%1.4f" [expr $rr.0/255]]
		set gg [format "%1.4f" [expr $gg.0/255]]
		set bb [format "%1.4f" [expr $bb.0/255]]
		return "$rr $gg $bb"
	}; #finproc
	
	proc cambiarColorFondo { base color } {
		upvar #0 VisorGL::$base visor
		set visor(backColor) [colorToRGB $color]
	}
	
	proc cambiarColorFondoRGB { base color } {
		upvar #0 VisorGL::$base visor
		set visor(backColor) $color
	}
	
	proc cambiarResolucionVisor { base numeroLados } {
		upvar #0 VisorGL::$base visor
		set visor(resolucion) $numeroLados
		set visor(molModificadas) 1
	} 
	
	proc salvarImagenVisor { base filename formato } {
		upvar #0 VisorGL::$base visor
		
		set w [lindex $visor(viewport) 0]
		set h [lindex $visor(viewport) 1]
		set numChans 4
		
		set vec [tcl3dVector GLubyte [expr $w*$h*$numChans]]
		glReadPixels 0 0 $w $h GL_RGBA GL_UNSIGNED_BYTE $vec
		set ph [image create photo -width $w -height $h]
		tcl3dVectorToPhoto $vec $ph $w $h $numChans
		
		$ph write $filename -format $formato
		
		image delete $ph
		$vec delete
	}
	
	
	proc cambiarModoHUD { base modo } {
		upvar #0 VisorGL::$base visor
		set visor(hudMostrar) $modo
	}
	
	proc devolverModoHUD { base } {
		upvar #0 VisorGL::$base visor
		return $visor(hudMostrar)
	}
	
	
	proc orbtemp { base } {
		upvar #0 VisorGL::$base visor
		
		
		set visor(orbList) [glGenLists 1]
		glNewList $visor(orbList) GL_COMPILE
		
		
		for {set x 0} {$x < 10} {incr x} {
			for {set y 0} {$y < 10} {incr y} {
				for {set z 0} {$z < 10} {incr z} {
					set v($x,$y,$z) "[expr rand()] [expr rand()] [expr rand()]"
				}	
			}
		}
		
		
		#pinta malla simple
		glColor3f 0.0 1.0 0.0 
		#glBegin GL_LINE_STRIP
		#creo una malla con datos
		for {set x 0} {$x < 9} {incr x} {
			for {set y 0} {$y < 9} {incr y} {
				for {set z 0} {$z < 9} {incr z} {
					glBegin GL_LINE_LOOP 
						set c $v($x,$y,$z)
						glColor3f [lindex $c 0] [lindex $c 1] [lindex $c 2]
						glVertex3f $x $y $z
						
						set c $v([expr $x+1],$y,$z)
						glColor3f [lindex $c 0] [lindex $c 1] [lindex $c 2]
						glVertex3f [expr $x+1] $y $z
					
						set c $v([expr $x+1],[expr $y+1],$z)
						glColor3f [lindex $c 0] [lindex $c 1] [lindex $c 2]
						glVertex3f [expr $x+1] [expr $y+1] $z
					
						set c $v($x,[expr $y+1],$z)
						glColor3f [lindex $c 0] [lindex $c 1] [lindex $c 2]
						glVertex3f $x [expr $y+1] $z
					
						set c $v($x,$y,$z)
						glColor3f [lindex $c 0] [lindex $c 1] [lindex $c 2]
						glVertex3f $x $y $z	
					glEnd
				}
			}
		}
		#glEnd
		
		
		
		glEndList
	} 
	
	
	
    
	
	
	
	
	
}; #finnamespace


	









