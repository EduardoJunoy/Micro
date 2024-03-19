// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// +++++++++++   Practica 3 - SBM 2023
// +++++++++++   v: ddga
// Nombre Alumno:
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#include <stdio.h>
#include <stdlib.h>


//declaración funciones (no usando .h)
unsigned int AccHuida(unsigned long* aceleracion_x, unsigned long* aceleracion_y, unsigned long* aceleracion_z,  
					  char idPlanet, int gravedadPlanet, int numLunas, int gravLunas, int presionSolar, int presionAtmsf, 
					  int* vel_x, int* vel_y, int* vel_z, unsigned int Empuje);

void Decode(char* encriptado, char* desencrip,
			int rotM);

// INICIO CODIGO C
int main(){
	//variables para Ejercicio 1
	unsigned long acel_x, acel_y, acel_z;
	int vel_x, vel_y, vel_z;
	char idPlanet = 24; //TATOOM id
	unsigned int ElEmpuje = 31;
	int gravedad_Planeta = 14;
	int gravedad_Lunas = 8;
	int numero_Lunas = 3;
	int presion_Solar = 5;
	int presion_Atmr = 6;
	unsigned int usoEmpuje = 4;

	//variables para Ejercicio 2
	char  encriptado[80]= "lpz gv apzmuv oz vxjhkviz vhdbj ndi kzgj";
	char desencriptado[80];
	int clave = 0, salir = 0;
	
	//llamada a función AccHuida aquí
	usoEmpuje = AccHuida(&acel_x, &acel_y, &acel_z, idPlanet, gravedad_Planeta, numero_Lunas, gravedad_Lunas, presion_Solar, presion_Atmr,
							&vel_x, &vel_y, &vel_z, ElEmpuje);

	//impresión por pantalla de la salida de la función AccHuida
	printf("¿Se ha usado el empuje? --> %u\n",usoEmpuje);
	printf(" valor de empuje %u \n", ElEmpuje);
	printf("--> Aceleracion(x,y,z) %lu %lu %lu \n", acel_x, acel_y, acel_z);
	printf("--> Velocidad  (x,y,z) %u %u %u \n", vel_x, vel_y, vel_z);


	//impresión por pantalla del inicio del ejercicio 2
	printf("\nTarea para desencriptar el mensaje: %s\n", encriptado);

	//código y llamada a la función Decode aquí. Bucle para averiguar la clave de rotación del mensaje
	do{
		printf("Introduzca la clave desencriptar [0-26]:\n");
		scanf("%d", &clave);

		// A RELLENAR POR ALUMNO
		Decode(encriptado, desencriptado, clave);
		
		//impresión por pantalla de la salida de la función Decode
		printf("Desencriptado: rotM=%d Mensaje %s\n",clave,desencriptado);
		
		//opcion de usuario para probar otras rotaciones
		printf("Desea probar otra clave? SI=0 / NO=1\n");
		scanf("%d",&salir);
	}while(salir==0);
	//FIN DEL PROGRAMA en C a implementar por alumno aquí

	return 0;
}
