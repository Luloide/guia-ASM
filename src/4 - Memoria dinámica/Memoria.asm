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
	;a viene en RDI y b viene en RSI
	xor RAX, RAX
	cmp [RDI], BYTE 0 ; a es vacio?
	je .chequearB
	cmp [RSI], BYTE 0 ; b es vacio?
	je .amayor ;si a es vacia y b no gana b
	jmp .loop

.chequearB:
	cmp [RSI], BYTE 0; ; si a es vacia y b tambien son iguales
	je .terminar
	inc RAX ; caso a vacio b no es vacio
	ret


.loop:
	cmp [RDI], BYTE 0 ; me fijo si a es nulo
	je .chequearBtermino ; me fijo si b es nulo, si lo es ambos son iguales sino b gana

	mov BH, BYTE [RDI] ; agarro el caracter de a
	mov BL, BYTE [RSI] ; agarro el caracter de b
	cmp BH, BL ; me fijo que sean iguales los caracteres
	je .rutinaIguales
	; si no son iguales tengo que comparar su orden lexografico
	; si a > b
	jg .amayor
	; sino b < a
	inc RAX ; si no son iguales devuelvo 1 pues b es mayor
	ret

.amayor:
	dec RAX ; 
	ret


.rutinaIguales:
	inc RDI
	inc RSI
	jmp .loop

.chequearBtermino:
	cmp [RSI], BYTE 0 ; me fijo si b es nulo
	je .terminar
	inc RAX
	ret

.terminar:
	ret

; char* strClone(char* a)
strClone:
	push RBX ; como es volatil lo debo de restablecer
	; calculo cuanta memoria tengo que pedir con strlen
	mov RBX, RDI        ; guardar el puntero original a
    call strLen         ; calcula longitud
    inc RAX             ; incluye el '\0'
    mov RDI, RAX		; muevo cuanto tengo que pedir de memoria a rdi asi llamo a malloc
    call malloc         ; pido la memoria
    mov R8, RAX        ; guardo el puntero destino

.recorrer:
	; si llegue al final termino
	cmp [RBX], BYTE 0
	je .terminar
	
	;sino copio la letra
	mov DL, BYTE [RBX]
	mov [R8], DL
	inc RBX
	inc R8
	jmp .recorrer

.terminar:
	mov [R8], BYTE 0 ; me guardo el \0
	pop RBX
	ret



; void strDelete(char* a)
strDelete:
	; me pasan un puntero por RDI
	call free ; freeo ese puntero?
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
