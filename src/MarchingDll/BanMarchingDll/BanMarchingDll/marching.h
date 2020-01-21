#ifndef _marching_h_
#define _marching_h_

int cargarFicheroOrbital(ClientData clientData, Tcl_Interp *interp, int argc, CONST char *argv[]);
int pintarSuperficieIsovalor(ClientData clientData, Tcl_Interp *interp, int argc, CONST char *argv[]);
int cambiarModoTransparencia(ClientData clientData, Tcl_Interp *interp, int argc, CONST char *argv[]);
int cambiarModoRepresentacion(ClientData clientData, Tcl_Interp *interp, int argc, CONST char *argv[]);

#endif