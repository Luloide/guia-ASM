

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
NODO_OFFSET_NEXT EQU 0
NODO_OFFSET_CATEGORIA EQU 8
NODO_OFFSET_ARREGLO EQU 16
NODO_OFFSET_LONGITUD EQU 24
NODO_SIZE EQU 32
PACKED_NODO_OFFSET_NEXT EQU 0
PACKED_NODO_OFFSET_CATEGORIA EQU 8
PACKED_NODO_OFFSET_ARREGLO EQU 9
PACKED_NODO_OFFSET_LONGITUD EQU 17
PACKED_NODO_SIZE EQU 21
LISTA_OFFSET_HEAD EQU 0
LISTA_SIZE EQU 8
PACKED_LISTA_OFFSET_HEAD EQU 8
PACKED_LISTA_SIZE EQU 8

;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS
global cantidad_total_de_elementos
global cantidad_total_de_elementos_packed

;########### DEFINICION DE FUNCIONES
;extern uint32_t cantidad_total_de_elementos(lista_t* lista);
;registros: lista[RDI]
cantidad_total_de_elementos:
	xor RAX, RAX ; inicializo en 0 la cantidad de elementos
	mov RDI, [RDI]; agarro el head
	; chequear si ese head es null (lista vacia)
	cmp RDI, 0
	je .terminar
	
.loop:
	; longitud esta a 12 bytes de distancia desde el inicio
	add RAX, [RDI + NODO_OFFSET_LONGITUD] ; agrego la longitud a la cantidad de elementos actuales
	mov RDI, [RDI]; agarro el proximo nodo
	cmp RDI, 0; chequeo que proximo nodo no sea nulo
	je .terminar;si no es nulo
	jmp .loop

.terminar:
	ret


;extern uint32_t cantidad_total_de_elementos_packed(packed_lista_t* lista);
;registros: lista[?]
cantidad_total_de_elementos_packed:
		xor RAX, RAX ; inicializo en 0 la cantidad de elementos
	mov RDI, [RDI]; agarro el head
	; chequear si ese head es null (lista vacia)
	cmp RDI, 0
	je .terminar
	
.loop:
	; longitud esta a 12 bytes de distancia desde el inicio
	add RAX, [RDI + PACKED_NODO_OFFSET_LONGITUD] ; agrego la longitud a la cantidad de elementos actuales
	mov RDI, [RDI]; agarro el proximo nodo
	cmp RDI, 0; chequeo que proximo nodo no sea nulo
	je .terminar;si no es nulo
	jmp .loop

.terminar:
	ret