#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>

#include "../test-utils.h"
#include "ABI.h"

int main() {
	/* Acá pueden realizar sus propias pruebas */
	uint32_t res;  
	double res2;


	assert(alternate_sum_4_using_c(8, 2, 5, 1) == 10);

	assert(alternate_sum_4_using_c_alternative(8, 2, 5, 1) == 10);

	assert(alternate_sum_8(8, 2, 5, 1, 8, 2, 5, 1) == 20);

	product_2_f(&res, 10, 2.0f);
	assert( res == 20);

	product_2_f(&res, 489, 465.01f);
	assert(res == 227388);

	product_9_f(&res2, 1, 1.0f, 2, 2.0f, 3, 3.0f, 4, 4.0f, 5, 5.0f, 6, 6.0f, 7, 7.0f, 8, 8.0f, 9, 9.0f);
	assert(res2 == 131680894400.0);
	return 0;
}
