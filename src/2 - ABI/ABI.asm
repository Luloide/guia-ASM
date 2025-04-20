extern sumar_c
extern restar_c
;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS

global alternate_sum_4
global alternate_sum_4_using_c
global alternate_sum_4_using_c_alternative
global alternate_sum_8
global product_2_f
global product_9_f

;########### DEFINICION DE FUNCIONES
; uint32_t alternate_sum_4(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; parametros: 
; x1 --> EDI
; x2 --> ESI
; x3 --> EDX
; x4 --> ECX
alternate_sum_4:
  sub EDI, ESI
  add EDI, EDX
  sub EDI, ECX

  mov EAX, EDI
  ret

; uint32_t alternate_sum_4_using_c(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; parametros: 
; x1 --> EDI
; x2 --> ESI
; x3 --> EDX
; x4 --> ECX
alternate_sum_4_using_c:
  ;prologo
  push RBP ;pila alineada
  mov RBP, RSP ;strack frame armado
  push R12
  push R13	; preservo no volatiles, al ser 2 la pila queda alineada

  mov R12D, EDX ; guardo los parámetros x3 y x4 ya que están en registros volátiles
  mov R13D, ECX ; y tienen que sobrevivir al llamado a función

  call restar_c 
  ;recibe los parámetros por EDI y ESI, de acuerdo a la convención, y resulta que ya tenemos los valores en esos registros
  
  mov EDI, EAX ;tomamos el resultado del llamado anterior y lo pasamos como primer parámetro
  mov ESI, R12D
  call sumar_c

  mov EDI, EAX
  mov ESI, R13D
  call restar_c

  ;el resultado final ya está en EAX, así que no hay que hacer más nada

  ;epilogo
  pop R13 ;restauramos los registros no volátiles
  pop R12
  pop RBP ;pila desalineada, RBP restaurado, RSP apuntando a la dirección de retorno
  ret


alternate_sum_4_using_c_alternative:
  ;prologo
  push RBP ;pila alineada
  mov RBP, RSP ;strack frame armado
  sub RSP, 16 ; muevo el tope de la pila 8 bytes para guardar x4, y 8 bytes para que quede alineada

  mov [RBP-8], RCX ; guardo x4 en la pila

  push RDX  ;preservo x3 en la pila, desalineandola
  sub RSP, 8 ;alineo
  call restar_c 
  add RSP, 8 ;restauro tope
  pop RDX ;recupero x3
  
  mov EDI, EAX
  mov ESI, EDX
  call sumar_c

  mov EDI, EAX
  mov ESI, [RBP - 8] ;leo x4 de la pila
  call restar_c

  ;el resultado final ya está en EAX, así que no hay que hacer más nada

  ;epilogo
  add RSP, 16 ;restauro tope de pila
  pop RBP ;pila desalineada, RBP restaurado, RSP apuntando a la dirección de retorno
  ret


; uint32_t alternate_sum_8(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4, uint32_t x5, uint32_t x6, uint32_t x7, uint32_t x8);
; registros y pila: x1[EDI], x2[ESI], x3[EDX], x4[ECX], x5[R8D], x6[R9D], x7[RBP + 0x10], x8[RBP + 0x18]
alternate_sum_8:
	;prologo

	push RBP ;pila alineada
  mov RBP, RSP ;strack frame armado

  mov R12D, EDX ; guardo los parámetros x3  ya que están en registros volátiles
  mov R13D, ECX ; guardo x4
  mov R14D, R8D ; guardo x5
  mov R15D, R9D ; guardo x6

  call restar_c ; x1-x2
  
  mov EDI, EAX ;tomamos el resultado del llamado anterior y lo pasamos como primer parámetro
  mov ESI, R12D
  call sumar_c ;res + x3

  mov EDI, EAX
  mov ESI, R13D
  call restar_c ;res - x4

  mov EDI, EAX ;tomamos el resultado del llamado anterior y lo pasamos como primer parámetro
  mov ESI, R14D
  call sumar_c ;res + x5

  mov EDI, EAX
  mov ESI, R15D
  call restar_c ; res - x6
  
  mov EDI, EAX ;tomamos el resultado del llamado anterior y lo pasamos como primer parámetro
  mov ESI, [RBP + 0x10]
  call sumar_c ;res + x7

  mov EDI, EAX
  mov ESI, [RBP + 0x18]
  call restar_c ; res - x8


	;epilogo
  pop RBP
	ret


; SUGERENCIA: investigar uso de instrucciones para convertir enteros a floats y viceversa
;void product_2_f(uint32_t * destination, uint32_t x1, float f1);
;registros: destination[RDI], x1[ESI], f1[xmm0]
product_2_f:
  movd xmm1, ESI; lo paso a un este registro SIMD
  cvtdq2ps xmm1,xmm1; convierto el entero a float
  mulss xmm1, xmm0; multiplico los floats
  cvtps2dq xmm1, xmm1; convierto el float en entero
  movd [RDI], xmm1; muevo el entero al regustro destination
	ret


;extern void product_9_f(double * destination
;, uint32_t x1, float f1, uint32_t x2, float f2, uint32_t x3, float f3, uint32_t x4, float f4
;, uint32_t x5, float f5, uint32_t x6, float f6, uint32_t x7, float f7, uint32_t x8, float f8
;, uint32_t x9, float f9);
;registros y pila: destination[rdi], x1[eax], f1[xmm0], x2[ebx], f2[xmm1], x3[ecx], f3[xmm2], x4[edx], f4[xmm3]
;	, x5[esi], f5[xmm4], x6[ebp], f6[xmm5], x7[esp], f7[xmm6], x8[RBP + 0x10], f8[xmm7],
;	, x9[?], f9[?]
product_9_f:
	;prologo
	push rbp
	mov rbp, rsp

	;convertimos los flotantes de cada registro xmm en doubles
	cvtss2sd xmm0,xmm0 
  cvtss2sd xmm1,xmm1 
  cvtss2sd xmm2,xmm2 
  cvtss2sd xmm3,xmm3 
  cvtss2sd xmm4,xmm4 
  cvtss2sd xmm5,xmm5 
  cvtss2sd xmm6,xmm6 
  cvtss2sd xmm7,xmm7 
 

	;multiplicamos los doubles en xmm0 <- xmm0 * xmm1, xmmo * xmm2 , ...
	; COMPLETAR
  mulsd xmm0,xmm1
  mulsd xmm0,xmm2
  mulsd xmm0,xmm3
  mulsd xmm0,xmm4
  mulsd xmm0,xmm5
  mulsd xmm0,xmm6
  mulsd xmm0,xmm7

	; convertimos los enteros en doubles y los multiplicamos por xmm0.
	; COMPLETAR
  cvtsi2sd xmm1, eax
  mulsd xmm0,xmm1
  cvtsi2sd xmm1, ebx
  mulsd xmm0,xmm1
  cvtsi2sd xmm1, ecx
  mulsd xmm0,xmm1
  cvtsi2sd xmm1, edx
  mulsd xmm0,xmm1
  cvtsi2sd xmm1, esi
  mulsd xmm0,xmm1
  cvtsi2sd xmm1, ebp
  mulsd xmm0,xmm1
  cvtsi2sd xmm1, esp
  mulsd xmm0,xmm1 
  ; muevo los que tenia en el stack
  cvtsi2sd xmm1, [RBP + 0x10]
  mulsd xmm0,xmm1
  ; muevo el resultado de xmm0 al destino
  movd [RDI], xmm0

	; epilogo
	pop rbp
	ret

