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

.loop:
	cmp [RDI], BYTE 0 ; me fijo si a es nulo
	je .terminar
	cmp [RSI], BYTE 0 ; me fijo si a es nulo
	je .terminar


	mov BH, BYTE [RDI] ; agarro el caracter de a
	mov BL, BYTE [RSI] ; agarro el caracter de b
	cmp BH, BL ; me fijo que sean iguales los caracteres
	je .rutinaIguales
	; si no son iguales tengo que comparar su orden lexografico
	; si a > b
	jg .amayor
	; sino b < a
	dec RAX ; si no son iguales devuelvo -1
	ret

.amayor:
	inc RAX ; si no son iguales devuelvo 1
	ret


.rutinaIguales:
	inc RDI
	inc RDX
	jmp .loop

.lendistintas:


.terminar:
	ret

; char* strClone(char* a)
strClone:
	; calculo cuanta memoria tengo que pedir con strlen
	mov RBX, RDI        ; guardar el puntero original a
    call strLen         ; calcula longitud
    inc RAX             ; incluye el '\0'
    mov RDI, RAX		; muevo cuanto tengo que pedir de memoria a rdi asi llamo a malloc
    call malloc         ; pido la memoria
    mov RBP, RAX        ; guardo el puntero destino

.recorrer:
	; si llegue al final termino
	cmp [RBX], BYTE 0
	je .terminar
	
	;sino copio la letra
	mov BL, [RAX]
	mov BL, BYTE [RBX]
	inc RBX
	inc RAX
	jmp .recorrer

.terminar:
	mov [RAX], BYTE 0 ; me guardo el \0
	mov RAX, RBP ; restauro al puntero copiado
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
