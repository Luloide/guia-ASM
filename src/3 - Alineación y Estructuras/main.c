#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>
#include "../test-utils.h"
#include "Estructuras.h"

int main() {
	/* Acá pueden realizar sus propias pruebas */
	// lista con 0 nodos
	lista_t lista_vacia;
	lista_vacia.head = NULL;
	assert(cantidad_total_de_elementos(&lista_vacia) == 0);

	// lista con 1 nodo
	lista_t lista;
	nodo_t nodo1 = {NULL,1,NULL,8};
	lista.head = &nodo1;
	assert(cantidad_total_de_elementos(&lista) == 8);

	// lista con mas de un nodo
	lista_t lista2;
	nodo_t nodo2 ={&nodo1,1,NULL, 10};
	lista2.head = &nodo2;
	assert(cantidad_total_de_elementos(&lista2) == 18);
	return 0;
}
