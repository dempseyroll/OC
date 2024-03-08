.data
planeta: .ascii "1 |________________________________________ Vidas: 3 |\n"
         .ascii "2 |                                                  |\n"
         .ascii "3 |         *** Intenta aterrizar en Argos ***       |\n"
         .ascii "4 |__________________________________________________|\n"
         .ascii "5 |                        V                         |\n"
         .ascii "6 |                                                  |\n"
         .ascii "7 |                                                  |\n"
         .ascii "8 |                                                  |\n"
         .ascii "9 |                                                  |\n"
         .ascii "10|                                                  |\n"
         .ascii "11|                                                  |\n"
         .ascii "12|                                                  |\n"
         .ascii "13|                                                  |\n"
         .ascii "14|                                                  |\n"
         .ascii "15|                                                  |\n"
         .ascii "16|                                                  |\n"
         .ascii "17|                                                  |\n"
         .ascii "18|                                                  |\n"
         .ascii "19|                                                  |\n"
         .ascii "20+--------------------------------------------------+\n"
         .ascii "21|                                                  |\n"
         .ascii "22|             superficie de Argos                  |\n"


longp = . - planeta
enter: .ascii "\n"
lenenter = . - enter
cls: .asciz "\x1b[H\x1b[2J"
lencls = .-cls

teclaIngresada: .asciz "x"
longteclaIngresada = . - teclaIngresada

mensajeGanaste:  .asciz "| Felicitaciones has GANADO |"
longmensajeGanaste = . - mensajeGanaste


.text

imprimirMapa:
	.fnstart

        mov r7, #4 			 @ Salida por pantalla
        mov r0, #1 			 @ salida cadena
        mov r2, $longp 			 @Tamaño de la cadena
        ldr r1, =planeta

	swi 0

  	bx lr

	.fnend

leerComando:

        .fnstart

	push {r0,r1,r2,r3,r6,r7,lr}

	mov r8,#993 @Si la nave llega a esta posicion o mayor, se considera que se gano


	bl clearScreen
	bl imprimirMapa

	mov r7,  #3     		 @ Lectura x teclado
        mov r0, #0      		 @ Ingreso de cadena
        mov r2, #1      		 @ Leer cant caracteres
        ldr r1, =teclaIngresada 	 @ donde se guarda lo ingresado

	swi #0

	ldrb r1, [r1]                   // Cargar el carácter ingresado en el registro r3

	//push {r0, r1, r2, r7}
	//mov r7, #4	@Salida por Pantalla
	//mov r0, #1	@salida cadena
	//mov r2,  $lenenter
	//ldr r1, =enter
	//pop {r0, r1, r2, r7}
	//swi 0

	cmp r1, #'W'
        beq teclaPresionada_W           // Saltar a handle_a si son iguales

        cmp r1, #'S'
        beq teclaPresionada_S

        cmp r1, #'A'
        beq teclaPresionada_A

        cmp r1, #'D'
        beq teclaPresionada_D


	cmp r1, #'w'
        beq teclaPresionada_W           // Saltar a handle_a si son iguales

        cmp r1, #'s'
        beq teclaPresionada_S

        cmp r1, #'a'
        beq teclaPresionada_A

        cmp r1, #'d'
        beq teclaPresionada_D

	bal finLeerComando

	//pop {r0,r1,r2,r3,r7,lr}
	//bx lr
	//.fnend

teclaPresionada_W:

        ldr r5, =planeta
        add r5, r4
         // Acá chequeamos si a donde quiere moverse hay un '_', no se mueva y no haga nada.
        push {r5}
        sub r5, #55
        ldrb r5, [r5]
        cmp r5, #'_'
        beq leerComando
        pop {r5}

        sub r4,#55                   @Guardar posicion actual en R4
        mov r6,#' '                  @Borrar V posicion anterior
        strb r6, [r5]

        sub r5,#55
        mov r7,#'V'
        strb r7, [r5]

        bal leerComando

teclaPresionada_S:
        ldr r5, =planeta
        add r5, r4
        add r4,#55                   // Guardar posicion actual en R4
        mov r6,#' '                  // Borrar V posicion anterior
        strb r6, [r5]

	push {r0, r1, r2, r7}
	mov r7, #3      @Entrada por Pantalla
        mov r0, #0      @Ingreso de cadena
        mov r2,  $lenenter @Leer cant caracteres
        ldr r1, =enter	@donde se guarda lo ingresado
        swi 0
	pop {r0, r1, r2, r7}

	push {r0, r1, r2, r7}
        mov r7, #4      @Salida por Pantalla
        mov r0, #1      @salida cadena
        mov r2,  $lenenter
        ldr r1, =enter
	swi 0
        pop {r0, r1, r2, r7}
        @swi 0

        add r5,#55
        mov r7,#'V'
        strb r7, [r5]

	cmp r4, r8
	bgt ganasteJuego
//	bgt finLeerComando
	bal leerComando

ganasteJuego:
        push {r0,r1,r2,r5,r6}

        ldr r5, =planeta                // Posicion donde se escribe el mensajeGanaste - (Posicion 285 asciz
        mov r6,#344
        add r5,r6

        ldr r0, =mensajeGanaste         // Menaje que debe mostrar al ganar

avanzar:
        ldrb r1,[r0]

        cmp r1,#0                       // Recorrer cadena asciz "mensajeGanaste"
        beq finRecorrerCadena
//      beq finLeerComando

        ldr r2,[r0]                     //Guardar caracter "mensajeGanaste" en R2
        strb r2,[r5]                    //Insertar el caracter del "mensajeGanaste" en el Mapa (planeta)

        add r0 ,#1                      //Avanzar al siguiente caracter de asciz "mensajeGanaste"
        add r5,#1                       //Avanzar al siguiente caracter de asciz "planeta"
        bal avanzar

finRecorrerCadena:

        pop {r0,r1,r2,r5,r6}

	bl clearScreen
        bl imprimirMapa                 //Me muestra el mapa con mensaje de "GANASTE"

        bal finLeerComando


teclaPresionada_A:

        ldr r5, =planeta
        add r5,r4
	// Acá chequeamos si a donde quiere moverse hay una '|', no se mueva y no haga nada.
	push {r5}
	sub r5, #1
	ldrb r5, [r5]
	cmp r5, #'|'
	beq leerComando
	pop {r5}

        mov r6, #' '
        strb r6,[r5]

        sub r5, #1
        sub r4, #1
        mov r7, #'V'
        strb r7, [r5]

	bal leerComando

teclaPresionada_D:

        ldr r5, =planeta
        add  r5,r4
        // Acá chequeamos si a donde quiere moverse hay una '|', no se mueva y no haga nada.
        push {r5}
        add r5, #1
        ldrb r5, [r5]
        cmp r5, #'|'
        beq leerComando
        pop {r5}

        mov r6, #' '
        strb r6,[r5]

        add r5, #1
        add r4, #1
        mov r7, #'V'
        strb r7, [r5]

        bal leerComando


finLeerComando:
	pop {r0,r1,r2,r3,r6,r7,lr}
        bx lr
        .fnend


clearScreen:

	.fnstart

	push {r0,r1,r2,r7}

	mov r0, #1
	ldr r1,=cls
	ldr r2, =lencls
	mov r7,#4
	swi #0

	pop {r0,r1,r2,r7}

	bx lr
	.fnend



.global main
main:
	 mov r4 ,#247

	 bl leerComando

	 mov r7, #1
         swi 0                           @ SWI, Software interrupt

