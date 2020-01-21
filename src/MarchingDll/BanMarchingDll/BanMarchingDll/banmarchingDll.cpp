/******************************************************************************************************

	Libreria Dinamica DLL para interpretes TCL/TK

		Incorpora 2 nuevos comandos a TCL
			

    Desarrollado para BrandyMol 1.5

		Funciones para el dibujo de orbitales moleculares

  Autores : 
				OSCAR NOEL AMAYA GARCIA
				GREGORIO TORRES GARCIA
				FRANCISCO NAJERA ALBENDIN

********************************************************************************************************/

#include <windows.h>
#include <tcl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "marching.h"


#ifndef DECLSPEC_EXPORT
#define DECLSPEC_EXPORT __declspec(dllexport)
#endif // DECLSPEC_EXPORT


 BOOL APIENTRY
 DllMain(HANDLE hModule, DWORD dwReason, LPVOID lpReserved)
 {
     return TRUE;
 }

 EXTERN_C int DECLSPEC_EXPORT
 Banmarchingdll_Init(Tcl_Interp* interp)
 {
 #ifdef USE_TCL_STUBS
     Tcl_InitStubs(interp, "8.5", 0);
 #endif
     Tcl_Obj *version = Tcl_SetVar2Ex(interp, "Banmarching_version", NULL,
                                      Tcl_NewDoubleObj(0.1), TCL_LEAVE_ERR_MSG);
	 if (version == NULL)
		return TCL_ERROR;
    int r = Tcl_PkgProvide(interp, "Banmarchingdll", Tcl_GetString(version));
	Tcl_CreateCommand(interp, "cargarFicheroOrbital", cargarFicheroOrbital, NULL, NULL);
	Tcl_CreateCommand(interp, "pintarSuperficieIsovalorOrbital", pintarSuperficieIsovalor, NULL, NULL);
	Tcl_CreateCommand(interp, "cambiarModoTransparenciaOrbital", cambiarModoTransparencia, NULL, NULL);	
	Tcl_CreateCommand(interp, "cambiarModoRepresentacionOrbital", cambiarModoRepresentacion, NULL, NULL);

	return r;
 }

 EXTERN_C int DECLSPEC_EXPORT
Banmarchingdll_SafeInit(Tcl_Interp* interp)
 {
     // We don't need to be specially safe so...
     return Banmarchingdll_Init(interp);
 }

 

