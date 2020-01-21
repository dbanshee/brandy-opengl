//
// Marching Cubes Example Program 
// by Cory Bloyd (corysama@yahoo.com)
//
// A simple, portable and complete implementation of the Marching Cubes
// and Marching Tetrahedrons algorithms in a single source file.
// There are many ways that this code could be made faster, but the 
// intent is for the code to be easy to understand.
//
// For a description of the algorithm go to
// http://astronomy.swin.edu.au/pbourke/modelling/polygonise/
//
// This code is public domain.
//

#include <stdio.h>
#include <math.h>
#include <stdlib.h>
//This program requires the OpenGL and GLUT libraries
// You can obtain them for free from http://www.opengl.org
#include <GL/glut.h>

struct GLvector
{
        GLfloat fX;
        GLfloat fY;
        GLfloat fZ;     
};

struct ivector {
	int iX;
	int iY;
	int iZ;
};


//asEdgeVertex[iEdge].fX = fX + (a2fVertexOffset[ a2iEdgeConnection[iEdge][0] ][0]  +  fOffset * a2fEdgeDirection[iEdge][0]) * fScaleX;

//These tables are used so that everything can be done in little loops that you can look at all at once
// rather than in pages and pages of unrolled code.

//a2fVertexOffset lists the positions, relative to vertex0, of each of the 8 vertices of a cube
static const GLfloat a2fVertexOffset[8][3] =
{
        {0.0, 0.0, 0.0},{1.0, 0.0, 0.0},{1.0, 1.0, 0.0},{0.0, 1.0, 0.0},
        {0.0, 0.0, 1.0},{1.0, 0.0, 1.0},{1.0, 1.0, 1.0},{0.0, 1.0, 1.0}
};

//a2iEdgeConnection lists the index of the endpoint vertices for each of the 12 edges of the cube
static const GLint a2iEdgeConnection[12][2] = 
{
        {0,1}, {1,2}, {2,3}, {3,0},
        {4,5}, {5,6}, {6,7}, {7,4},
        {0,4}, {1,5}, {2,6}, {3,7}
};

//a2fEdgeDirection lists the direction vector (vertex1-vertex0) for each edge in the cube
static const GLfloat a2fEdgeDirection[12][3] =
{
        {1.0, 0.0, 0.0},{0.0, 1.0, 0.0},{-1.0, 0.0, 0.0},{0.0, -1.0, 0.0},
        {1.0, 0.0, 0.0},{0.0, 1.0, 0.0},{-1.0, 0.0, 0.0},{0.0, -1.0, 0.0},
        {0.0, 0.0, 1.0},{0.0, 0.0, 1.0},{ 0.0, 0.0, 1.0},{0.0,  0.0, 1.0}
};


//indices relativos a la esquina inferior izquierda delantera de un cubo, pertenecientes a los extremos de la arista dada
static const GLint adyCubeNormals [12][2][3] = {
	{{0, 0, 0}, {1, 0, 0}},
	{{1, 0, 0}, {1, 1, 0}},
	{{1, 1, 0}, {0, 1, 0}},
	{{0, 1, 0}, {0, 0, 0}},
	{{0, 0, 1}, {1, 0, 1}},
	{{1, 0, 1}, {1, 1, 1}},
	{{1, 1, 1}, {0, 1, 1}},
	{{0, 1, 1}, {0, 0, 1}},
	{{0, 0, 0}, {0, 0, 1}},
	{{1, 0, 0}, {1, 0, 1}},
	{{1, 1, 0}, {1, 1, 1}},
	{{0, 1, 0}, {0, 1, 1}}
	
};

//a2iTetrahedronEdgeConnection lists the index of the endpoint vertices for each of the 6 edges of the tetrahedron
static const GLint a2iTetrahedronEdgeConnection[6][2] =
{
        {0,1},  {1,2},  {2,0},  {0,3},  {1,3},  {2,3}
};

//a2iTetrahedronEdgeConnection lists the index of verticies from a cube 
// that made up each of the six tetrahedrons within the cube
static const GLint a2iTetrahedronsInACube[6][4] =
{
        {0,5,1,6},
        {0,1,2,6},
        {0,2,3,6},
        {0,3,7,6},
        {0,7,4,6},
        {0,4,5,6},
};


GLenum    ePolygonMode = GL_FILL;
GLint     iDataSetSize = 16;
GLfloat   fStepSize = 1.0/iDataSetSize;
//GLfloat   fTargetValue = 48.0;
GLfloat   fTargetValue = 10.0;

GLfloat   fTime = 0.0;
GLvector  sSourcePoint[3];
GLboolean bSpin = true;
GLboolean bMove = true;
GLboolean bLight = true;

FILE* fout;


int primero = 0;
GLvector p;


GLvoid vMarchingCubes();
//GLvoid vMarchCube1(GLfloat fX, GLfloat fY, GLfloat fZ, GLfloat fScale);
//GLvoid vMarchCube2(GLfloat fX, GLfloat fY, GLfloat fZ, GLfloat fScale);
//GLvoid (*vMarchCube)(GLfloat fX, GLfloat fY, GLfloat fZ, GLfloat fScale) = vMarchCube1;

GLvoid vMarchCube1(int iX, int iY, int iZ, int orb);
GLvoid (*vMarchCube)(int iX, int iY, int iZ, int orb) = vMarchCube1;


//tipos
typedef struct cubePoint{
	double x;
	double y;
	double z;
	double denP;
	double denN;
};

//Variables
int 	dimensions[3];
float 	origin[3];
float 	spacing[3];
struct cubePoint ***CUBE;


void inicializaCuboDefecto(){

	int i, j, k;
	int pos;
	double x, y, z;


	//Inicializacion provisional
	dimensions[0]=dimensions[1]=dimensions[2] = 51;
	origin[0] = -4.79173374; 	origin[1] = -4.81841993; 	origin[2] = -4.11713028;
	spacing[0] = 0.307566881; 	spacing[1] = 0.289487869; 	spacing[2] =  0.302819669;
	

	//reservo memoria para el cubo
	CUBE = (struct cubePoint ***)malloc(dimensions[0]*sizeof(struct cubePoint**));
	for(i=0;i<dimensions[0];i++){
		CUBE[i] = (struct cubePoint**)malloc(dimensions[1]*sizeof(struct cubePoint *));
		for(j=0;j<dimensions[1];j++){
			CUBE[i][j] = (struct cubePoint *)malloc(dimensions[2]*sizeof(struct cubePoint));
			//printf("Reserva para %i %i\n", CUBE[i][j]);
		}
	}
	
	x = origin[0];
	for(i=0; i<dimensions[0]; i++){
		y = origin[1];
		for(j=0; j<dimensions[1]; j++){
			z = origin[2];
			for(k=0; k<dimensions[2]; k++){
				//pos = i*dimensions[0]+j*dimensions[1]+k;
				
				//Asigno posiciones
				CUBE[i][j][k].x = x;
				CUBE[i][j][k].y = y;
				CUBE[i][j][k].z = z;
				
				
				CUBE[i][j][k].denP = 25 - sqrt((25-i)*(25-i) + (25-j)*(25-j) + (25-k)*(25-k));
				//CUBE[i][j][k].denP = floor(sqrt(((2-i)*(2-i)) + ((2-j)*(2-j)) + ((2-k)*(2-k))));
				//CUBE[i][j][k].denP = sqrt(((2-i)*(2-i)) + ((2-j)*(2-j)) + ((2-k)*(2-k)));
				//printf("Asigno %i %i %i --> %e\n", i, j, k,sqrt(((2-i)*(2-i)) + ((2-j)*(2-j)) + ((2-k)*(2-k))));
				
				z = z + spacing[2];
				
			}
			y = y + spacing[1];
		}
		x = x + spacing[0];
	} 
}


void inicializaCuboFichero(char* filename){
	
	FILE* fin;
	int MAXCAD = 1024;
	char line[MAXCAD];
	char line2[MAXCAD];
	int i, j, k;
	int pos;
	float x, y, z;
	int num;

	
	fin = fopen(filename, "r");
	if(fin==NULL){
		printf("No se ha podido abrir : %s\n",filename);
	}else{
		//ignoro las 11 primeras lineas
		
		//for(i=1; i<=11; i++){
		//	fgets(line,MAXCAD,fin); 
		//}
		
		
		//Inicializacion provisional
		//dimensions[0]=dimensions[1]=dimensions[2] = 51;
		//origin[0] = -4.79173374; 	origin[1] = -4.81841993; 	origin[2] = -4.11713028;
		//spacing[0] = 0.307566881; 	spacing[1] = 0.289487869; 	spacing[2] =  0.302819669;
		
		
		
		for(i=1; i<=5; i++){
			fgets(line,MAXCAD,fin); 
		}
		
		printf("%s\n",line);
		fscanf(fin,"%i %i %i",&dimensions[0],&dimensions[1],&dimensions[2]);
		
		
		fgets(line,MAXCAD,fin); 
		fgets(line,MAXCAD,fin); 
		fgets(line,MAXCAD,fin); 

		
		fscanf(fin,"%f %f %f",&x,&y,&z);
		//origin[0]=double(x); origin[1]=double(y); origin[2]=double(z);
		origin[0]=x; origin[1]=y; origin[2]=z;
		
		
		fgets(line,MAXCAD,fin); 
		fgets(line,MAXCAD,fin); 
		fgets(line,MAXCAD,fin); 
		
		fscanf(fin,"%f %f %f",&x,&y,&z);
		//spacing[0]=double(x); spacing[1]=double(y); spacing[2]=double(z);
		spacing[0]=x; spacing[1]=y; spacing[2]=z;
		
		
		printf("Spacing : %d %d %d\n", dimensions[0], dimensions[1], dimensions[2]);
		printf("Origin : %f %f %f\n", origin[0], origin[1], origin[2]);
		printf("Spacing : %f %f %f\n", spacing[0], spacing[1], spacing[2]);
		
		
		fgets(line,MAXCAD,fin); 
		printf("%s\n",line);
		fgets(line,MAXCAD,fin); 
		printf("%s\n",line);
		fgets(line,MAXCAD,fin); 
		printf("%s\n",line);
		fgets(line,MAXCAD,fin); 
		printf("%s\n",line);
		fgets(line,MAXCAD,fin); 
		printf("%s\n",line);
		//fgets(line,MAXCAD,fin); 
		//printf("%s\n",line);
		
		
		
		printf("----------\n");
		//return;
		
		
		
		
		
		

		//reservo memoria para el cubo
		CUBE = (struct cubePoint ***)malloc(dimensions[0]*sizeof(struct cubePoint**));
		for(i=0;i<dimensions[0];i++){
			CUBE[i] = (struct cubePoint**)malloc(dimensions[1]*sizeof(struct cubePoint *));
			for(j=0;j<dimensions[1];j++){
				CUBE[i][j] = (struct cubePoint *)malloc(dimensions[2]*sizeof(struct cubePoint));
				//printf("Reserva para %i %i\n", CUBE[i][j]);
			}
		}
		
		x = origin[0];
		for(i=0; i<dimensions[0];i++){
			y = origin[1];
			for(j=0; j<dimensions[1]; j++){
				z = origin[2];
				for(k=0; k<dimensions[2]; k++){
					//pos = i*dimensions[0]+j*dimensions[1]+k;
					
					//Asigno posiciones
					CUBE[i][j][k].x = x;
					CUBE[i][j][k].y = y;
					CUBE[i][j][k].z = z;
					
					
					
					
					//Asigno densidades
					
					
					//fscanf(fin,"%e",&CUBE[i][j][k].denP);
					//if(CUBE[i][j][k].denP != 0.0){
					//	printf("%e\n",CUBE[i][j][k].denP);
					//}
					fscanf(fin,"%d",&num);
					//if(num > 0) {printf("%d\n",num); system("PAUSE");}
					//printf("%d\n",num);
					CUBE[i][j][k].denP = double(num);
					//printf("%e\n",CUBE[i][j][k].denP);
					//system("PAUSE");
					
					z = z + spacing[2];
					
				}
				y = y + spacing[1];
			}
			x = x + spacing[0];
		} 
		
		//ignoro 2 lineas
		fgets(line,MAXCAD,fin); 
		printf("%s\n",line);
		fgets(line,MAXCAD,fin); 
		printf("%s\n",line);
		fgets(line,MAXCAD,fin); 
		printf("%s\n",line);
		for(i=0; i<dimensions[0];i++){
			for(j=0; j<dimensions[1]; j++){
				for(k=0; k<dimensions[2]; k++){
					fscanf(fin,"%d",&num);
					//if(num > 0) {printf("%d\n",num); system("PAUSE");}
					//printf("%d\n",num);
					CUBE[i][j][k].denN = double(num);
				}
			}
		}
		fgets(line,MAXCAD,fin); 
		printf("%s\n",line);
		
		
		fclose(fin);
		printf("Termino\n");
		
		//dimensions[0]=dimensions[1]=dimensions[2] = 51;
		//origin[0] = -4.79173374; 	origin[1] = -4.81841993; 	origin[2] = -4.11713028;
		//spacing[0] = 0.307566881; 	spacing[1] = 0.289487869; 	spacing[2] =  0.302819669;
		
	}
	
	
	



}


int main(int argc, char **argv) 
{ 
		char line [1024];
		

		
		if(argc != 3){
			printf("Error. Numero incorrecto de argumentos\n");
			return -1;
		}else{
			printf("Input File : %s\n", argv[1]);
			
			inicializaCuboFichero(argv[1]);
			//inicializaCuboDefecto();
			
			
			vMarchingCubes();
			return 0;
		}
}


//fGetOffset finds the approximate point of intersection of the surface
// between two points with the values fValue1 and fValue2
GLfloat fGetOffset(GLfloat fValue1, GLfloat fValue2, GLfloat fValueDesired)
{
        GLdouble fDelta = fValue2 - fValue1;

        if(fDelta == 0.0)
        {
                return 0.5;
        }
        return (fValueDesired - fValue1)/fDelta;
}


GLvoid vNormalizeVector(GLvector &rfVectorResult, GLvector &rfVectorSource)
{
        GLfloat fOldLength;
        GLfloat fScale;
		//double fScaleX = spacing[0];
		//double fScaleY = spacing[1];
		//double fScaleZ = spacing[2];

        fOldLength = sqrtf( (rfVectorSource.fX * rfVectorSource.fX) +
                            (rfVectorSource.fY * rfVectorSource.fY) +
                            (rfVectorSource.fZ * rfVectorSource.fZ) );

        if(fOldLength == 0.0)
        {
                rfVectorResult.fX = rfVectorSource.fX;
                rfVectorResult.fY = rfVectorSource.fY;
                rfVectorResult.fZ = rfVectorSource.fZ;
        }
        else
        {
                fScale = 1.0/fOldLength;
                rfVectorResult.fX = rfVectorSource.fX*fScale;
                rfVectorResult.fY = rfVectorSource.fY*fScale;
                rfVectorResult.fZ = rfVectorSource.fZ*fScale;
        }
}


//Generate a sample data set.  fSample1(), fSample2() and fSample3() define three scalar fields whose
// values vary by the X,Y and Z coordinates and by the fTime value set by vSetTime()
GLvoid vSetTime(GLfloat fNewTime)
{
        GLfloat fOffset;
        GLint iSourceNum;

        for(iSourceNum = 0; iSourceNum < 3; iSourceNum++)
        {
                sSourcePoint[iSourceNum].fX = 0.5;
                sSourcePoint[iSourceNum].fY = 0.5;
                sSourcePoint[iSourceNum].fZ = 0.5;
        }

        fTime = fNewTime;
        fOffset = 1.0 + sinf(fTime);
        sSourcePoint[0].fX *= fOffset;
        sSourcePoint[1].fY *= fOffset;
        sSourcePoint[2].fZ *= fOffset;
}



//vMarchCube1 performs the Marching Cubes algorithm on a single cube
//GLvoid vMarchCube1(GLfloat fX, GLfloat fY, GLfloat fZ, GLfloat fScale)
GLvoid vMarchCube1(int iX, int iY, int iZ, int orb)
{
        extern GLint aiCubeEdgeFlags[256];
        extern GLint a2iTriangleConnectionTable[256][16];

        GLint iCorner, iVertex, iVertexTest, iEdge, iTriangle, iFlagIndex, iEdgeFlags;
        GLfloat fOffset;
        GLvector sColor;
        GLfloat afCubeValue[8];
        GLvector asEdgeVertex[12];
        GLvector asEdgeNorm[12];
		float fScaleX = spacing[0];
		float fScaleY = spacing[1];
		float fScaleZ = spacing[2];
		float fX, fY, fZ;
		
		GLvector gradv0, gradv1;
		GLvector p0, p1;
		ivector v0, v1;
		
		
		//pos = i*dimensions[0]+j*dimensions[1]+k;

        //Make a local copy of the values at the cube's corners
        /*
		for(iVertex = 0; iVertex < 8; iVertex++)
        {
                afCubeValue[iVertex] = fSample(fX + a2fVertexOffset[iVertex][0]*fScale,
                                                   fY + a2fVertexOffset[iVertex][1]*fScale,
                                                   fZ + a2fVertexOffset[iVertex][2]*fScale);
				
        }
		*/
		/*
		fX = CUBE[iX][iY][iZ].x;
		fY = CUBE[iX][iY][iZ].y;
		fZ = CUBE[iX][iY][iZ].z;
		*/
		
		if(orb == 0){	
			afCubeValue[0] = CUBE[iX][iY][iZ].denP;
			afCubeValue[1] = CUBE[iX+1][iY][iZ].denP;
			afCubeValue[2] = CUBE[iX+1][iY+1][iZ].denP;
			afCubeValue[3] = CUBE[iX][iY+1][iZ].denP;
			afCubeValue[4] = CUBE[iX][iY][iZ+1].denP;
			afCubeValue[5] = CUBE[iX+1][iY][iZ+1].denP;
			afCubeValue[6] = CUBE[iX+1][iY+1][iZ+1].denP;
			afCubeValue[7] = CUBE[iX][iY+1][iZ+1].denP;
		}else{
			afCubeValue[0] = CUBE[iX][iY][iZ].denN;
			afCubeValue[1] = CUBE[iX+1][iY][iZ].denN;
			afCubeValue[2] = CUBE[iX+1][iY+1][iZ].denN;
			afCubeValue[3] = CUBE[iX][iY+1][iZ].denN;
			afCubeValue[4] = CUBE[iX][iY][iZ+1].denN;
			afCubeValue[5] = CUBE[iX+1][iY][iZ+1].denN;
			afCubeValue[6] = CUBE[iX+1][iY+1][iZ+1].denN;
			afCubeValue[7] = CUBE[iX][iY+1][iZ+1].denN;
		}
		
		/*
		for(iVertex = 0; iVertex < 8; iVertex++){
			printf("Vertex %i : %e\n",iVertex,afCubeValue[iVertex]);
		}
		*/
		
		

        //Find which vertices are inside of the surface and which are outside
        iFlagIndex = 0;
        for(iVertexTest = 0; iVertexTest < 8; iVertexTest++)
        {
                if(afCubeValue[iVertexTest] <= fTargetValue) 
                        iFlagIndex |= 1<<iVertexTest;
        }

        //Find which edges are intersected by the surface
        iEdgeFlags = aiCubeEdgeFlags[iFlagIndex];

        //If the cube is entirely inside or outside of the surface, then there will be no intersections
        if(iEdgeFlags == 0) 
        {
                return;
        }

        //Find the point of intersection of the surface with each edge
        //Then find the normal to the surface at those points
        for(iEdge = 0; iEdge < 12; iEdge++)
        {
                //if there is an intersection on this edge
                if(iEdgeFlags & (1<<iEdge))
                {
				
						/*
                        fOffset = fGetOffset(afCubeValue[ a2iEdgeConnection[iEdge][0] ], 
                                                     afCubeValue[ a2iEdgeConnection[iEdge][1] ], fTargetValue);


						
                        asEdgeVertex[iEdge].fX = fX + (a2fVertexOffset[ a2iEdgeConnection[iEdge][0] ][0]  +  fOffset * a2fEdgeDirection[iEdge][0]) * fScaleX;
                        asEdgeVertex[iEdge].fY = fY + (a2fVertexOffset[ a2iEdgeConnection[iEdge][0] ][1]  +  fOffset * a2fEdgeDirection[iEdge][1]) * fScaleY;
                        asEdgeVertex[iEdge].fZ = fZ + (a2fVertexOffset[ a2iEdgeConnection[iEdge][0] ][2]  +  fOffset * a2fEdgeDirection[iEdge][2]) * fScaleZ;
						*/
					

                        //vGetNormal(asEdgeNorm[iEdge], asEdgeVertex[iEdge].fX, asEdgeVertex[iEdge].fY, asEdgeVertex[iEdge].fZ);
						//vGetNormal(asEdgeNorm[iEdge], iX, iY, iZ);
						
						
						
						
						//obtengo los indices de los extremos del segmento
						v0.iX = iX + adyCubeNormals[iEdge][0][0];
						v0.iY = iY + adyCubeNormals[iEdge][0][1];
						v0.iZ = iZ + adyCubeNormals[iEdge][0][2];
						
						v1.iX = iX + adyCubeNormals[iEdge][1][0];
						v1.iY = iY + adyCubeNormals[iEdge][1][1];
						v1.iZ = iZ + adyCubeNormals[iEdge][1][2];
						
						
					
						//extremos de la arista
						p0.fX = CUBE[v0.iX][v0.iY][v0.iZ].x;
						p0.fY = CUBE[v0.iX][v0.iY][v0.iZ].y;
						p0.fZ = CUBE[v0.iX][v0.iY][v0.iZ].z;
						
						p1.fX = CUBE[v1.iX][v1.iY][v1.iZ].x;
						p1.fY = CUBE[v1.iX][v1.iY][v1.iZ].y;
						p1.fZ = CUBE[v1.iX][v1.iY][v1.iZ].z;
						
						
						//obtengo el offset
						if(orb == 0){
							fOffset = fGetOffset(	CUBE[v0.iX][v0.iY][v0.iZ].denP, 
													CUBE[v1.iX][v1.iY][v1.iZ].denP, fTargetValue);
						}else{
							fOffset = fGetOffset(	CUBE[v0.iX][v0.iY][v0.iZ].denN, 
													CUBE[v1.iX][v1.iY][v1.iZ].denN, fTargetValue);
						}
											   
						
						//el vertice intermedio
						asEdgeVertex[iEdge].fX = p0.fX*(1-fOffset) + p1.fX*fOffset;
						asEdgeVertex[iEdge].fY = p0.fY*(1-fOffset) + p1.fY*fOffset;
						asEdgeVertex[iEdge].fZ = p0.fZ*(1-fOffset) + p1.fZ*fOffset;
					
						
						
						
						
						//Calculo la normal al vertice
						
						//calculo los gradientes en ambos extremos
						if(orb == 0){
							gradv0.fX = (CUBE[v0.iX-1][v0.iY][v0.iZ].denP - CUBE[v0.iX+1][v0.iY][v0.iZ].denP) / spacing[0];
							gradv0.fY = (CUBE[v0.iX][v0.iY-1][v0.iZ].denP - CUBE[v0.iX][v0.iY+1][v0.iZ].denP) / spacing[1];
							gradv0.fZ = (CUBE[v0.iX][v0.iY][v0.iZ-1].denP - CUBE[v0.iX][v0.iY][v0.iZ+1].denP) / spacing[2];
							
							
							gradv1.fX = (CUBE[v1.iX-1][v1.iY][v1.iZ].denP - CUBE[v1.iX+1][v1.iY][v1.iZ].denP) / spacing[0];
							gradv1.fY = (CUBE[v1.iX][v1.iY-1][v1.iZ].denP - CUBE[v1.iX][v1.iY+1][v1.iZ].denP) / spacing[1];
							gradv1.fZ = (CUBE[v1.iX][v1.iY][v1.iZ-1].denP - CUBE[v1.iX][v1.iY][v1.iZ+1].denP) / spacing[2];
						}else{
							//printf("paaso\n");
							gradv0.fX = (CUBE[v0.iX-1][v0.iY][v0.iZ].denN - CUBE[v0.iX+1][v0.iY][v0.iZ].denN) / spacing[0];
							gradv0.fY = (CUBE[v0.iX][v0.iY-1][v0.iZ].denN - CUBE[v0.iX][v0.iY+1][v0.iZ].denN) / spacing[1];
							gradv0.fZ = (CUBE[v0.iX][v0.iY][v0.iZ-1].denN - CUBE[v0.iX][v0.iY][v0.iZ+1].denN) / spacing[2];
							
							
							gradv1.fX = (CUBE[v1.iX-1][v1.iY][v1.iZ].denN - CUBE[v1.iX+1][v1.iY][v1.iZ].denN) / spacing[0];
							gradv1.fY = (CUBE[v1.iX][v1.iY-1][v1.iZ].denN - CUBE[v1.iX][v1.iY+1][v1.iZ].denN) / spacing[1];
							gradv1.fZ = (CUBE[v1.iX][v1.iY][v1.iZ-1].denN - CUBE[v1.iX][v1.iY][v1.iZ+1].denN) / spacing[2];
						}
						
						
						//interpolo los gradientes, esta sera la normal del vertice
						asEdgeNorm[iEdge].fX = (1-fOffset)*gradv0.fX + fOffset*gradv1.fX;
						asEdgeNorm[iEdge].fY = (1-fOffset)*gradv0.fY + fOffset*gradv1.fY;
						asEdgeNorm[iEdge].fZ = (1-fOffset)*gradv0.fZ + fOffset*gradv1.fZ;
						
						
						
						
						/*
						printf("Offset : %e\n", fOffset);
						printf("Cubo : %i %i %i\n", iX, iY, iZ);
						printf("Arista : %i\n", iEdge);
						printf("EXtremo 0: %i %i %i\n", v0.iX, v0.iY, v0.iZ);
						printf("Grad X (%i %i %i) - (%i %i %i)\n", v0.iX-1, v0.iY, v0.iZ, v0.iX+1, v0.iY, v0.iZ);
						printf("Grad Y (%i %i %i) - (%i %i %i)\n", v0.iX, v0.iY-1, v0.iZ, v0.iX, v0.iY+1, v0.iZ);
						printf("Grad Z (%i %i %i) - (%i %i %i)\n", v0.iX, v0.iY, v0.iZ-1, v0.iX, v0.iY, v0.iZ+1);
						printf("Grad v0 : (%f %f %f)\n", gradv0.fX, gradv0.fY, gradv0.fZ);
						
						printf("EXtremo 1: %i %i %i\n", v1.iX, v1.iY, v1.iZ);
						printf("Grad X (%i %i %i) - (%i %i %i)\n", v1.iX-1, v1.iY, v1.iZ, v1.iX+1, v1.iY, v1.iZ);
						printf("Grad Y (%i %i %i) - (%i %i %i)\n", v1.iX, v1.iY-1, v1.iZ, v1.iX, v1.iY+1, v1.iZ);
						printf("Grad Z (%i %i %i) - (%i %i %i)\n", v1.iX, v1.iY, v1.iZ-1, v1.iX, v1.iY, v1.iZ+1);
						printf("Grad v1 : (%f %f %f)\n", gradv1.fX, gradv1.fY, gradv1.fZ);
						
						
						printf("Normal interpolada: (%f %f %f)\n", asEdgeNorm[iEdge].fX, asEdgeNorm[iEdge].fY, asEdgeNorm[iEdge].fZ);
						vNormalizeVector(asEdgeNorm[iEdge],asEdgeNorm[iEdge]);
						
						printf("Normal interpolada Normalizada: (%f %f %f)\n", asEdgeNorm[iEdge].fX, asEdgeNorm[iEdge].fY, asEdgeNorm[iEdge].fZ);
						printf("Vertice : (%f %f %f)\n\n\n", asEdgeVertex[iEdge].fX, asEdgeVertex[iEdge].fY, asEdgeVertex[iEdge].fZ);
						*/
						//exit(0);
						
						
						vNormalizeVector(asEdgeNorm[iEdge],asEdgeNorm[iEdge]);
						
						
                }
        }


		

        //Draw the triangles that were found.  There can be up to five per cube
        for(iTriangle = 0; iTriangle < 5; iTriangle++)
        {
                if(a2iTriangleConnectionTable[iFlagIndex][3*iTriangle] < 0)
                        break;
				fprintf(fout, "\n");
                for(iCorner = 0; iCorner < 3; iCorner++)
                {
                        iVertex = a2iTriangleConnectionTable[iFlagIndex][3*iTriangle+iCorner];

                        //vGetColor(sColor, asEdgeVertex[iVertex], asEdgeNorm[iVertex]);
                        //glColor3f(sColor.fX, sColor.fY, sColor.fZ);
                        //glNormal3f(asEdgeNorm[iVertex].fX,   asEdgeNorm[iVertex].fY,   asEdgeNorm[iVertex].fZ);
                        //glVertex3f(asEdgeVertex[iVertex].fX, asEdgeVertex[iVertex].fY, asEdgeVertex[iVertex].fZ);
						//printf("%f, %f, %f\n",asEdgeVertex[iVertex].fX,asEdgeVertex[iVertex].fY,asEdgeVertex[iVertex].fZ);
						fprintf(fout, "%f %f %f\n", asEdgeNorm[iVertex].fX,   asEdgeNorm[iVertex].fY,   asEdgeNorm[iVertex].fZ);
						fprintf(fout, "%f %f %f\n",asEdgeVertex[iVertex].fX,asEdgeVertex[iVertex].fY,asEdgeVertex[iVertex].fZ);
                }
				
        }
		
}


   

//vMarchingCubes iterates over the entire dataset, calling vMarchCube on each cube
GLvoid vMarchingCubes()
{
		//FILE* fout;
		
		char filename[256];
		int isovalor;
		int i, j, k;
		
		
		
		for(isovalor=0; isovalor < 255; isovalor++ ){
			fTargetValue = float(isovalor);
			
			//Orbital Positivo
			sprintf(filename, "orbital_%i_P.bma",isovalor);
			
			fout = fopen(filename,"w+");
			fprintf(fout, "BANMAYA\n");
		
		
			fprintf(fout, "TRIANGLES\n");
			fprintf(fout, "NORMALs & VERTEXS\n");
			
			
		
			for(i=2; i<dimensions[0]-3;i++){
				for(j=2; j<dimensions[1]-3; j++){
					for(k=2; k<dimensions[2]-3; k++){
						//printf("Marching %i %i %i --> %e\n", i, j, k,CUBE[i][j][k].denP);
						vMarchCube(i,j,k,0);
					}
				}
			}
			
			fprintf(fout, "END");
			fflush(fout);
			fclose(fout);
			
			//Orbital Negativo
			sprintf(filename, "orbital_%i_N.bma",isovalor);
			
			fout = fopen(filename,"w+");
			fprintf(fout, "BANMAYA\n");
			
			
			fprintf(fout, "TRIANGLES\n");
			fprintf(fout, "NORMALs & VERTEXS\n");
			
			
			for(i=0; i<dimensions[0]-1;i++){
				for(j=0; j<dimensions[1]-1; j++){
					for(k=0; k<dimensions[2]-1; k++){
						//if(CUBE[i][j][k].denN != 0.0){ printf("Marching %i %i %i --> %e\n", i, j, k,CUBE[i][j][k].denN);}
						//printf("Marching %i %i %i --> %e\n", i, j, k,CUBE[i][j][k].denN);
						vMarchCube(i,j,k,1);
					}
				}
			}
			fprintf(fout, "END");
			fflush(fout);
			fclose(fout);
		}
		
		
		
		
}



// For any edge, if one vertex is inside of the surface and the other is outside of the surface
//  then the edge intersects the surface
// For each of the 8 vertices of the cube can be two possible states : either inside or outside of the surface
// For any cube the are 2^8=256 possible sets of vertex states
// This table lists the edges intersected by the surface for all 256 possible vertex states
// There are 12 edges.  For each entry in the table, if edge #n is intersected, then bit #n is set to 1

GLint aiCubeEdgeFlags[256]=
{
        0x000, 0x109, 0x203, 0x30a, 0x406, 0x50f, 0x605, 0x70c, 0x80c, 0x905, 0xa0f, 0xb06, 0xc0a, 0xd03, 0xe09, 0xf00, 
        0x190, 0x099, 0x393, 0x29a, 0x596, 0x49f, 0x795, 0x69c, 0x99c, 0x895, 0xb9f, 0xa96, 0xd9a, 0xc93, 0xf99, 0xe90, 
        0x230, 0x339, 0x033, 0x13a, 0x636, 0x73f, 0x435, 0x53c, 0xa3c, 0xb35, 0x83f, 0x936, 0xe3a, 0xf33, 0xc39, 0xd30, 
        0x3a0, 0x2a9, 0x1a3, 0x0aa, 0x7a6, 0x6af, 0x5a5, 0x4ac, 0xbac, 0xaa5, 0x9af, 0x8a6, 0xfaa, 0xea3, 0xda9, 0xca0, 
        0x460, 0x569, 0x663, 0x76a, 0x066, 0x16f, 0x265, 0x36c, 0xc6c, 0xd65, 0xe6f, 0xf66, 0x86a, 0x963, 0xa69, 0xb60, 
        0x5f0, 0x4f9, 0x7f3, 0x6fa, 0x1f6, 0x0ff, 0x3f5, 0x2fc, 0xdfc, 0xcf5, 0xfff, 0xef6, 0x9fa, 0x8f3, 0xbf9, 0xaf0, 
        0x650, 0x759, 0x453, 0x55a, 0x256, 0x35f, 0x055, 0x15c, 0xe5c, 0xf55, 0xc5f, 0xd56, 0xa5a, 0xb53, 0x859, 0x950, 
        0x7c0, 0x6c9, 0x5c3, 0x4ca, 0x3c6, 0x2cf, 0x1c5, 0x0cc, 0xfcc, 0xec5, 0xdcf, 0xcc6, 0xbca, 0xac3, 0x9c9, 0x8c0, 
        0x8c0, 0x9c9, 0xac3, 0xbca, 0xcc6, 0xdcf, 0xec5, 0xfcc, 0x0cc, 0x1c5, 0x2cf, 0x3c6, 0x4ca, 0x5c3, 0x6c9, 0x7c0, 
        0x950, 0x859, 0xb53, 0xa5a, 0xd56, 0xc5f, 0xf55, 0xe5c, 0x15c, 0x055, 0x35f, 0x256, 0x55a, 0x453, 0x759, 0x650, 
        0xaf0, 0xbf9, 0x8f3, 0x9fa, 0xef6, 0xfff, 0xcf5, 0xdfc, 0x2fc, 0x3f5, 0x0ff, 0x1f6, 0x6fa, 0x7f3, 0x4f9, 0x5f0, 
        0xb60, 0xa69, 0x963, 0x86a, 0xf66, 0xe6f, 0xd65, 0xc6c, 0x36c, 0x265, 0x16f, 0x066, 0x76a, 0x663, 0x569, 0x460, 
        0xca0, 0xda9, 0xea3, 0xfaa, 0x8a6, 0x9af, 0xaa5, 0xbac, 0x4ac, 0x5a5, 0x6af, 0x7a6, 0x0aa, 0x1a3, 0x2a9, 0x3a0, 
        0xd30, 0xc39, 0xf33, 0xe3a, 0x936, 0x83f, 0xb35, 0xa3c, 0x53c, 0x435, 0x73f, 0x636, 0x13a, 0x033, 0x339, 0x230, 
        0xe90, 0xf99, 0xc93, 0xd9a, 0xa96, 0xb9f, 0x895, 0x99c, 0x69c, 0x795, 0x49f, 0x596, 0x29a, 0x393, 0x099, 0x190, 
        0xf00, 0xe09, 0xd03, 0xc0a, 0xb06, 0xa0f, 0x905, 0x80c, 0x70c, 0x605, 0x50f, 0x406, 0x30a, 0x203, 0x109, 0x000
};

//  For each of the possible vertex states listed in aiCubeEdgeFlags there is a specific triangulation
//  of the edge intersection points.  a2iTriangleConnectionTable lists all of them in the form of
//  0-5 edge triples with the list terminated by the invalid value -1.
//  For example: a2iTriangleConnectionTable[3] list the 2 triangles formed when corner[0] 
//  and corner[1] are inside of the surface, but the rest of the cube is not.
//
//  I found this table in an example program someone wrote long ago.  It was probably generated by hand

GLint a2iTriangleConnectionTable[256][16] =  
{
        {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {0, 8, 3, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {0, 1, 9, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {1, 8, 3, 9, 8, 1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {1, 2, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {0, 8, 3, 1, 2, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {9, 2, 10, 0, 2, 9, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {2, 8, 3, 2, 10, 8, 10, 9, 8, -1, -1, -1, -1, -1, -1, -1},
        {3, 11, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {0, 11, 2, 8, 11, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {1, 9, 0, 2, 3, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {1, 11, 2, 1, 9, 11, 9, 8, 11, -1, -1, -1, -1, -1, -1, -1},
        {3, 10, 1, 11, 10, 3, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {0, 10, 1, 0, 8, 10, 8, 11, 10, -1, -1, -1, -1, -1, -1, -1},
        {3, 9, 0, 3, 11, 9, 11, 10, 9, -1, -1, -1, -1, -1, -1, -1},
        {9, 8, 10, 10, 8, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {4, 7, 8, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {4, 3, 0, 7, 3, 4, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {0, 1, 9, 8, 4, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {4, 1, 9, 4, 7, 1, 7, 3, 1, -1, -1, -1, -1, -1, -1, -1},
        {1, 2, 10, 8, 4, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {3, 4, 7, 3, 0, 4, 1, 2, 10, -1, -1, -1, -1, -1, -1, -1},
        {9, 2, 10, 9, 0, 2, 8, 4, 7, -1, -1, -1, -1, -1, -1, -1},
        {2, 10, 9, 2, 9, 7, 2, 7, 3, 7, 9, 4, -1, -1, -1, -1},
        {8, 4, 7, 3, 11, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {11, 4, 7, 11, 2, 4, 2, 0, 4, -1, -1, -1, -1, -1, -1, -1},
        {9, 0, 1, 8, 4, 7, 2, 3, 11, -1, -1, -1, -1, -1, -1, -1},
        {4, 7, 11, 9, 4, 11, 9, 11, 2, 9, 2, 1, -1, -1, -1, -1},
        {3, 10, 1, 3, 11, 10, 7, 8, 4, -1, -1, -1, -1, -1, -1, -1},
        {1, 11, 10, 1, 4, 11, 1, 0, 4, 7, 11, 4, -1, -1, -1, -1},
        {4, 7, 8, 9, 0, 11, 9, 11, 10, 11, 0, 3, -1, -1, -1, -1},
        {4, 7, 11, 4, 11, 9, 9, 11, 10, -1, -1, -1, -1, -1, -1, -1},
        {9, 5, 4, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {9, 5, 4, 0, 8, 3, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {0, 5, 4, 1, 5, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {8, 5, 4, 8, 3, 5, 3, 1, 5, -1, -1, -1, -1, -1, -1, -1},
        {1, 2, 10, 9, 5, 4, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {3, 0, 8, 1, 2, 10, 4, 9, 5, -1, -1, -1, -1, -1, -1, -1},
        {5, 2, 10, 5, 4, 2, 4, 0, 2, -1, -1, -1, -1, -1, -1, -1},
        {2, 10, 5, 3, 2, 5, 3, 5, 4, 3, 4, 8, -1, -1, -1, -1},
        {9, 5, 4, 2, 3, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {0, 11, 2, 0, 8, 11, 4, 9, 5, -1, -1, -1, -1, -1, -1, -1},
        {0, 5, 4, 0, 1, 5, 2, 3, 11, -1, -1, -1, -1, -1, -1, -1},
        {2, 1, 5, 2, 5, 8, 2, 8, 11, 4, 8, 5, -1, -1, -1, -1},
        {10, 3, 11, 10, 1, 3, 9, 5, 4, -1, -1, -1, -1, -1, -1, -1},
        {4, 9, 5, 0, 8, 1, 8, 10, 1, 8, 11, 10, -1, -1, -1, -1},
        {5, 4, 0, 5, 0, 11, 5, 11, 10, 11, 0, 3, -1, -1, -1, -1},
        {5, 4, 8, 5, 8, 10, 10, 8, 11, -1, -1, -1, -1, -1, -1, -1},
        {9, 7, 8, 5, 7, 9, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {9, 3, 0, 9, 5, 3, 5, 7, 3, -1, -1, -1, -1, -1, -1, -1},
        {0, 7, 8, 0, 1, 7, 1, 5, 7, -1, -1, -1, -1, -1, -1, -1},
        {1, 5, 3, 3, 5, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {9, 7, 8, 9, 5, 7, 10, 1, 2, -1, -1, -1, -1, -1, -1, -1},
        {10, 1, 2, 9, 5, 0, 5, 3, 0, 5, 7, 3, -1, -1, -1, -1},
        {8, 0, 2, 8, 2, 5, 8, 5, 7, 10, 5, 2, -1, -1, -1, -1},
        {2, 10, 5, 2, 5, 3, 3, 5, 7, -1, -1, -1, -1, -1, -1, -1},
        {7, 9, 5, 7, 8, 9, 3, 11, 2, -1, -1, -1, -1, -1, -1, -1},
        {9, 5, 7, 9, 7, 2, 9, 2, 0, 2, 7, 11, -1, -1, -1, -1},
        {2, 3, 11, 0, 1, 8, 1, 7, 8, 1, 5, 7, -1, -1, -1, -1},
        {11, 2, 1, 11, 1, 7, 7, 1, 5, -1, -1, -1, -1, -1, -1, -1},
        {9, 5, 8, 8, 5, 7, 10, 1, 3, 10, 3, 11, -1, -1, -1, -1},
        {5, 7, 0, 5, 0, 9, 7, 11, 0, 1, 0, 10, 11, 10, 0, -1},
        {11, 10, 0, 11, 0, 3, 10, 5, 0, 8, 0, 7, 5, 7, 0, -1},
        {11, 10, 5, 7, 11, 5, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {10, 6, 5, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {0, 8, 3, 5, 10, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {9, 0, 1, 5, 10, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {1, 8, 3, 1, 9, 8, 5, 10, 6, -1, -1, -1, -1, -1, -1, -1},
        {1, 6, 5, 2, 6, 1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {1, 6, 5, 1, 2, 6, 3, 0, 8, -1, -1, -1, -1, -1, -1, -1},
        {9, 6, 5, 9, 0, 6, 0, 2, 6, -1, -1, -1, -1, -1, -1, -1},
        {5, 9, 8, 5, 8, 2, 5, 2, 6, 3, 2, 8, -1, -1, -1, -1},
        {2, 3, 11, 10, 6, 5, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {11, 0, 8, 11, 2, 0, 10, 6, 5, -1, -1, -1, -1, -1, -1, -1},
        {0, 1, 9, 2, 3, 11, 5, 10, 6, -1, -1, -1, -1, -1, -1, -1},
        {5, 10, 6, 1, 9, 2, 9, 11, 2, 9, 8, 11, -1, -1, -1, -1},
        {6, 3, 11, 6, 5, 3, 5, 1, 3, -1, -1, -1, -1, -1, -1, -1},
        {0, 8, 11, 0, 11, 5, 0, 5, 1, 5, 11, 6, -1, -1, -1, -1},
        {3, 11, 6, 0, 3, 6, 0, 6, 5, 0, 5, 9, -1, -1, -1, -1},
        {6, 5, 9, 6, 9, 11, 11, 9, 8, -1, -1, -1, -1, -1, -1, -1},
        {5, 10, 6, 4, 7, 8, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {4, 3, 0, 4, 7, 3, 6, 5, 10, -1, -1, -1, -1, -1, -1, -1},
        {1, 9, 0, 5, 10, 6, 8, 4, 7, -1, -1, -1, -1, -1, -1, -1},
        {10, 6, 5, 1, 9, 7, 1, 7, 3, 7, 9, 4, -1, -1, -1, -1},
        {6, 1, 2, 6, 5, 1, 4, 7, 8, -1, -1, -1, -1, -1, -1, -1},
        {1, 2, 5, 5, 2, 6, 3, 0, 4, 3, 4, 7, -1, -1, -1, -1},
        {8, 4, 7, 9, 0, 5, 0, 6, 5, 0, 2, 6, -1, -1, -1, -1},
        {7, 3, 9, 7, 9, 4, 3, 2, 9, 5, 9, 6, 2, 6, 9, -1},
        {3, 11, 2, 7, 8, 4, 10, 6, 5, -1, -1, -1, -1, -1, -1, -1},
        {5, 10, 6, 4, 7, 2, 4, 2, 0, 2, 7, 11, -1, -1, -1, -1},
        {0, 1, 9, 4, 7, 8, 2, 3, 11, 5, 10, 6, -1, -1, -1, -1},
        {9, 2, 1, 9, 11, 2, 9, 4, 11, 7, 11, 4, 5, 10, 6, -1},
        {8, 4, 7, 3, 11, 5, 3, 5, 1, 5, 11, 6, -1, -1, -1, -1},
        {5, 1, 11, 5, 11, 6, 1, 0, 11, 7, 11, 4, 0, 4, 11, -1},
        {0, 5, 9, 0, 6, 5, 0, 3, 6, 11, 6, 3, 8, 4, 7, -1},
        {6, 5, 9, 6, 9, 11, 4, 7, 9, 7, 11, 9, -1, -1, -1, -1},
        {10, 4, 9, 6, 4, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {4, 10, 6, 4, 9, 10, 0, 8, 3, -1, -1, -1, -1, -1, -1, -1},
        {10, 0, 1, 10, 6, 0, 6, 4, 0, -1, -1, -1, -1, -1, -1, -1},
        {8, 3, 1, 8, 1, 6, 8, 6, 4, 6, 1, 10, -1, -1, -1, -1},
        {1, 4, 9, 1, 2, 4, 2, 6, 4, -1, -1, -1, -1, -1, -1, -1},
        {3, 0, 8, 1, 2, 9, 2, 4, 9, 2, 6, 4, -1, -1, -1, -1},
        {0, 2, 4, 4, 2, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {8, 3, 2, 8, 2, 4, 4, 2, 6, -1, -1, -1, -1, -1, -1, -1},
        {10, 4, 9, 10, 6, 4, 11, 2, 3, -1, -1, -1, -1, -1, -1, -1},
        {0, 8, 2, 2, 8, 11, 4, 9, 10, 4, 10, 6, -1, -1, -1, -1},
        {3, 11, 2, 0, 1, 6, 0, 6, 4, 6, 1, 10, -1, -1, -1, -1},
        {6, 4, 1, 6, 1, 10, 4, 8, 1, 2, 1, 11, 8, 11, 1, -1},
        {9, 6, 4, 9, 3, 6, 9, 1, 3, 11, 6, 3, -1, -1, -1, -1},
        {8, 11, 1, 8, 1, 0, 11, 6, 1, 9, 1, 4, 6, 4, 1, -1},
        {3, 11, 6, 3, 6, 0, 0, 6, 4, -1, -1, -1, -1, -1, -1, -1},
        {6, 4, 8, 11, 6, 8, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {7, 10, 6, 7, 8, 10, 8, 9, 10, -1, -1, -1, -1, -1, -1, -1},
        {0, 7, 3, 0, 10, 7, 0, 9, 10, 6, 7, 10, -1, -1, -1, -1},
        {10, 6, 7, 1, 10, 7, 1, 7, 8, 1, 8, 0, -1, -1, -1, -1},
        {10, 6, 7, 10, 7, 1, 1, 7, 3, -1, -1, -1, -1, -1, -1, -1},
        {1, 2, 6, 1, 6, 8, 1, 8, 9, 8, 6, 7, -1, -1, -1, -1},
        {2, 6, 9, 2, 9, 1, 6, 7, 9, 0, 9, 3, 7, 3, 9, -1},
        {7, 8, 0, 7, 0, 6, 6, 0, 2, -1, -1, -1, -1, -1, -1, -1},
        {7, 3, 2, 6, 7, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {2, 3, 11, 10, 6, 8, 10, 8, 9, 8, 6, 7, -1, -1, -1, -1},
        {2, 0, 7, 2, 7, 11, 0, 9, 7, 6, 7, 10, 9, 10, 7, -1},
        {1, 8, 0, 1, 7, 8, 1, 10, 7, 6, 7, 10, 2, 3, 11, -1},
        {11, 2, 1, 11, 1, 7, 10, 6, 1, 6, 7, 1, -1, -1, -1, -1},
        {8, 9, 6, 8, 6, 7, 9, 1, 6, 11, 6, 3, 1, 3, 6, -1},
        {0, 9, 1, 11, 6, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {7, 8, 0, 7, 0, 6, 3, 11, 0, 11, 6, 0, -1, -1, -1, -1},
        {7, 11, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {7, 6, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {3, 0, 8, 11, 7, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {0, 1, 9, 11, 7, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {8, 1, 9, 8, 3, 1, 11, 7, 6, -1, -1, -1, -1, -1, -1, -1},
        {10, 1, 2, 6, 11, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {1, 2, 10, 3, 0, 8, 6, 11, 7, -1, -1, -1, -1, -1, -1, -1},
        {2, 9, 0, 2, 10, 9, 6, 11, 7, -1, -1, -1, -1, -1, -1, -1},
        {6, 11, 7, 2, 10, 3, 10, 8, 3, 10, 9, 8, -1, -1, -1, -1},
        {7, 2, 3, 6, 2, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {7, 0, 8, 7, 6, 0, 6, 2, 0, -1, -1, -1, -1, -1, -1, -1},
        {2, 7, 6, 2, 3, 7, 0, 1, 9, -1, -1, -1, -1, -1, -1, -1},
        {1, 6, 2, 1, 8, 6, 1, 9, 8, 8, 7, 6, -1, -1, -1, -1},
        {10, 7, 6, 10, 1, 7, 1, 3, 7, -1, -1, -1, -1, -1, -1, -1},
        {10, 7, 6, 1, 7, 10, 1, 8, 7, 1, 0, 8, -1, -1, -1, -1},
        {0, 3, 7, 0, 7, 10, 0, 10, 9, 6, 10, 7, -1, -1, -1, -1},
        {7, 6, 10, 7, 10, 8, 8, 10, 9, -1, -1, -1, -1, -1, -1, -1},
        {6, 8, 4, 11, 8, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {3, 6, 11, 3, 0, 6, 0, 4, 6, -1, -1, -1, -1, -1, -1, -1},
        {8, 6, 11, 8, 4, 6, 9, 0, 1, -1, -1, -1, -1, -1, -1, -1},
        {9, 4, 6, 9, 6, 3, 9, 3, 1, 11, 3, 6, -1, -1, -1, -1},
        {6, 8, 4, 6, 11, 8, 2, 10, 1, -1, -1, -1, -1, -1, -1, -1},
        {1, 2, 10, 3, 0, 11, 0, 6, 11, 0, 4, 6, -1, -1, -1, -1},
        {4, 11, 8, 4, 6, 11, 0, 2, 9, 2, 10, 9, -1, -1, -1, -1},
        {10, 9, 3, 10, 3, 2, 9, 4, 3, 11, 3, 6, 4, 6, 3, -1},
        {8, 2, 3, 8, 4, 2, 4, 6, 2, -1, -1, -1, -1, -1, -1, -1},
        {0, 4, 2, 4, 6, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {1, 9, 0, 2, 3, 4, 2, 4, 6, 4, 3, 8, -1, -1, -1, -1},
        {1, 9, 4, 1, 4, 2, 2, 4, 6, -1, -1, -1, -1, -1, -1, -1},
        {8, 1, 3, 8, 6, 1, 8, 4, 6, 6, 10, 1, -1, -1, -1, -1},
        {10, 1, 0, 10, 0, 6, 6, 0, 4, -1, -1, -1, -1, -1, -1, -1},
        {4, 6, 3, 4, 3, 8, 6, 10, 3, 0, 3, 9, 10, 9, 3, -1},
        {10, 9, 4, 6, 10, 4, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {4, 9, 5, 7, 6, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {0, 8, 3, 4, 9, 5, 11, 7, 6, -1, -1, -1, -1, -1, -1, -1},
        {5, 0, 1, 5, 4, 0, 7, 6, 11, -1, -1, -1, -1, -1, -1, -1},
        {11, 7, 6, 8, 3, 4, 3, 5, 4, 3, 1, 5, -1, -1, -1, -1},
        {9, 5, 4, 10, 1, 2, 7, 6, 11, -1, -1, -1, -1, -1, -1, -1},
        {6, 11, 7, 1, 2, 10, 0, 8, 3, 4, 9, 5, -1, -1, -1, -1},
        {7, 6, 11, 5, 4, 10, 4, 2, 10, 4, 0, 2, -1, -1, -1, -1},
        {3, 4, 8, 3, 5, 4, 3, 2, 5, 10, 5, 2, 11, 7, 6, -1},
        {7, 2, 3, 7, 6, 2, 5, 4, 9, -1, -1, -1, -1, -1, -1, -1},
        {9, 5, 4, 0, 8, 6, 0, 6, 2, 6, 8, 7, -1, -1, -1, -1},
        {3, 6, 2, 3, 7, 6, 1, 5, 0, 5, 4, 0, -1, -1, -1, -1},
        {6, 2, 8, 6, 8, 7, 2, 1, 8, 4, 8, 5, 1, 5, 8, -1},
        {9, 5, 4, 10, 1, 6, 1, 7, 6, 1, 3, 7, -1, -1, -1, -1},
        {1, 6, 10, 1, 7, 6, 1, 0, 7, 8, 7, 0, 9, 5, 4, -1},
        {4, 0, 10, 4, 10, 5, 0, 3, 10, 6, 10, 7, 3, 7, 10, -1},
        {7, 6, 10, 7, 10, 8, 5, 4, 10, 4, 8, 10, -1, -1, -1, -1},
        {6, 9, 5, 6, 11, 9, 11, 8, 9, -1, -1, -1, -1, -1, -1, -1},
        {3, 6, 11, 0, 6, 3, 0, 5, 6, 0, 9, 5, -1, -1, -1, -1},
        {0, 11, 8, 0, 5, 11, 0, 1, 5, 5, 6, 11, -1, -1, -1, -1},
        {6, 11, 3, 6, 3, 5, 5, 3, 1, -1, -1, -1, -1, -1, -1, -1},
        {1, 2, 10, 9, 5, 11, 9, 11, 8, 11, 5, 6, -1, -1, -1, -1},
        {0, 11, 3, 0, 6, 11, 0, 9, 6, 5, 6, 9, 1, 2, 10, -1},
        {11, 8, 5, 11, 5, 6, 8, 0, 5, 10, 5, 2, 0, 2, 5, -1},
        {6, 11, 3, 6, 3, 5, 2, 10, 3, 10, 5, 3, -1, -1, -1, -1},
        {5, 8, 9, 5, 2, 8, 5, 6, 2, 3, 8, 2, -1, -1, -1, -1},
        {9, 5, 6, 9, 6, 0, 0, 6, 2, -1, -1, -1, -1, -1, -1, -1},
        {1, 5, 8, 1, 8, 0, 5, 6, 8, 3, 8, 2, 6, 2, 8, -1},
        {1, 5, 6, 2, 1, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {1, 3, 6, 1, 6, 10, 3, 8, 6, 5, 6, 9, 8, 9, 6, -1},
        {10, 1, 0, 10, 0, 6, 9, 5, 0, 5, 6, 0, -1, -1, -1, -1},
        {0, 3, 8, 5, 6, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {10, 5, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {11, 5, 10, 7, 5, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {11, 5, 10, 11, 7, 5, 8, 3, 0, -1, -1, -1, -1, -1, -1, -1},
        {5, 11, 7, 5, 10, 11, 1, 9, 0, -1, -1, -1, -1, -1, -1, -1},
        {10, 7, 5, 10, 11, 7, 9, 8, 1, 8, 3, 1, -1, -1, -1, -1},
        {11, 1, 2, 11, 7, 1, 7, 5, 1, -1, -1, -1, -1, -1, -1, -1},
        {0, 8, 3, 1, 2, 7, 1, 7, 5, 7, 2, 11, -1, -1, -1, -1},
        {9, 7, 5, 9, 2, 7, 9, 0, 2, 2, 11, 7, -1, -1, -1, -1},
        {7, 5, 2, 7, 2, 11, 5, 9, 2, 3, 2, 8, 9, 8, 2, -1},
        {2, 5, 10, 2, 3, 5, 3, 7, 5, -1, -1, -1, -1, -1, -1, -1},
        {8, 2, 0, 8, 5, 2, 8, 7, 5, 10, 2, 5, -1, -1, -1, -1},
        {9, 0, 1, 5, 10, 3, 5, 3, 7, 3, 10, 2, -1, -1, -1, -1},
        {9, 8, 2, 9, 2, 1, 8, 7, 2, 10, 2, 5, 7, 5, 2, -1},
        {1, 3, 5, 3, 7, 5, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {0, 8, 7, 0, 7, 1, 1, 7, 5, -1, -1, -1, -1, -1, -1, -1},
        {9, 0, 3, 9, 3, 5, 5, 3, 7, -1, -1, -1, -1, -1, -1, -1},
        {9, 8, 7, 5, 9, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {5, 8, 4, 5, 10, 8, 10, 11, 8, -1, -1, -1, -1, -1, -1, -1},
        {5, 0, 4, 5, 11, 0, 5, 10, 11, 11, 3, 0, -1, -1, -1, -1},
        {0, 1, 9, 8, 4, 10, 8, 10, 11, 10, 4, 5, -1, -1, -1, -1},
        {10, 11, 4, 10, 4, 5, 11, 3, 4, 9, 4, 1, 3, 1, 4, -1},
        {2, 5, 1, 2, 8, 5, 2, 11, 8, 4, 5, 8, -1, -1, -1, -1},
        {0, 4, 11, 0, 11, 3, 4, 5, 11, 2, 11, 1, 5, 1, 11, -1},
        {0, 2, 5, 0, 5, 9, 2, 11, 5, 4, 5, 8, 11, 8, 5, -1},
        {9, 4, 5, 2, 11, 3, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {2, 5, 10, 3, 5, 2, 3, 4, 5, 3, 8, 4, -1, -1, -1, -1},
        {5, 10, 2, 5, 2, 4, 4, 2, 0, -1, -1, -1, -1, -1, -1, -1},
        {3, 10, 2, 3, 5, 10, 3, 8, 5, 4, 5, 8, 0, 1, 9, -1},
        {5, 10, 2, 5, 2, 4, 1, 9, 2, 9, 4, 2, -1, -1, -1, -1},
        {8, 4, 5, 8, 5, 3, 3, 5, 1, -1, -1, -1, -1, -1, -1, -1},
        {0, 4, 5, 1, 0, 5, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {8, 4, 5, 8, 5, 3, 9, 0, 5, 0, 3, 5, -1, -1, -1, -1},
        {9, 4, 5, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {4, 11, 7, 4, 9, 11, 9, 10, 11, -1, -1, -1, -1, -1, -1, -1},
        {0, 8, 3, 4, 9, 7, 9, 11, 7, 9, 10, 11, -1, -1, -1, -1},
        {1, 10, 11, 1, 11, 4, 1, 4, 0, 7, 4, 11, -1, -1, -1, -1},
        {3, 1, 4, 3, 4, 8, 1, 10, 4, 7, 4, 11, 10, 11, 4, -1},
        {4, 11, 7, 9, 11, 4, 9, 2, 11, 9, 1, 2, -1, -1, -1, -1},
        {9, 7, 4, 9, 11, 7, 9, 1, 11, 2, 11, 1, 0, 8, 3, -1},
        {11, 7, 4, 11, 4, 2, 2, 4, 0, -1, -1, -1, -1, -1, -1, -1},
        {11, 7, 4, 11, 4, 2, 8, 3, 4, 3, 2, 4, -1, -1, -1, -1},
        {2, 9, 10, 2, 7, 9, 2, 3, 7, 7, 4, 9, -1, -1, -1, -1},
        {9, 10, 7, 9, 7, 4, 10, 2, 7, 8, 7, 0, 2, 0, 7, -1},
        {3, 7, 10, 3, 10, 2, 7, 4, 10, 1, 10, 0, 4, 0, 10, -1},
        {1, 10, 2, 8, 7, 4, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {4, 9, 1, 4, 1, 7, 7, 1, 3, -1, -1, -1, -1, -1, -1, -1},
        {4, 9, 1, 4, 1, 7, 0, 8, 1, 8, 7, 1, -1, -1, -1, -1},
        {4, 0, 3, 7, 4, 3, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {4, 8, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {9, 10, 8, 10, 11, 8, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {3, 0, 9, 3, 9, 11, 11, 9, 10, -1, -1, -1, -1, -1, -1, -1},
        {0, 1, 10, 0, 10, 8, 8, 10, 11, -1, -1, -1, -1, -1, -1, -1},
        {3, 1, 10, 11, 3, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {1, 2, 11, 1, 11, 9, 9, 11, 8, -1, -1, -1, -1, -1, -1, -1},
        {3, 0, 9, 3, 9, 11, 1, 2, 9, 2, 11, 9, -1, -1, -1, -1},
        {0, 2, 11, 8, 0, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {3, 2, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {2, 3, 8, 2, 8, 10, 10, 8, 9, -1, -1, -1, -1, -1, -1, -1},
        {9, 10, 2, 0, 9, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {2, 3, 8, 2, 8, 10, 0, 1, 8, 1, 10, 8, -1, -1, -1, -1},
        {1, 10, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {1, 3, 8, 9, 1, 8, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {0, 9, 1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {0, 3, 8, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
        {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}
};