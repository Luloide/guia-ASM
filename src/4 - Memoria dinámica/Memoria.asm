extern malloc
extern free
extern fprintf

section .data

section .text

global strCmp
global strClone
global strDelete
global strPrint
global strLen

; ** String **

; int32_t strCmp(char* a, char* b)
strCmp:
	xor RAX, RAX
	; si las longitudes no son iguales, los strings son diferentes seguro
	call strLen ; calculo la longitud de a
	mov R8, RAX ; guardo la len de a
	mov RDX, RDI; guardo a en otro lado
	mov RDI, RSI ;muevo b a donde esta a asi puedo llamar a la fucnion correctamente
	call strLen ; calculo la longitud de b
	mov R9, RAX ; guardo len de b
	cmp R8, R9
	jne .terminar 

	; ahora comparo caracter a caracter si son iguales
.loop:
	cmp [RDI], BYTE 0 ; me fijo si es nulo
	je .terminar
	mov RCX, [RDX]
	cmp [RDI], RCX ; me fijo que sean iguales los caracteres
	je .rutinaIguales
	inc RAX ; si no son iguales devuelvo 1
	ret

.rutinaIguales:
	inc RDI
	inc RDX
	jmp .loop

.terminar:
	ret

; char* strClone(char* a)
strClone:
	ret

; void strDelete(char* a)
strDelete:
	ret

; void strPrint(char* a, FILE* pFile)
strPrint:
	ret

; uint32_t strLen(char* a)
strLen:
	xor RAX, RAX ; limpio el valor de rax asi queda en 0
	cmp [RDI], BYTE 0 ; chequeo que la palabra no sea vacia
	je .terminar
.loop:
	inc RAX ; incremento el contador
	inc RDI ; agarro el proximo caracter
	cmp [RDI], BYTE 0 ; me fijo si es nulo
	je .terminar
	jmp .loop

.terminar:
	ret
