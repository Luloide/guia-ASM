#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>

#include "../test-utils.h"
#include "Memoria.h"

int main() {
	/* Acá pueden realizar sus propias pruebas */
	// test strLen
	assert(strLen("") == 0);
	assert(strLen("a") == 1);
	assert(strLen("hola") == 4);

	// test strcmp

	assert(strCmp("", "a") == 1);
	return 0;
}
