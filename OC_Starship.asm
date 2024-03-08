
.data
planeta: .ascii "1 |________________________________________ Vidas: 3 |\n"
         .ascii "2 |                                                  |\n"
         .ascii "3 |         *** Intenta aterrizar en Argos ***       |\n"
         .ascii "4 |__________________________________________________|\n"
         .ascii "5 |                        V                         |\n"
         .ascii "6 |                                                  |\n"
         .ascii "7 |                                                  |\n"
         .ascii "8 |                        O O                       |\n"
         .ascii "9 |    O                                             |\n"
         .ascii "10|                        O O                       |\n"
         .ascii "11|               O O O                   O          |\n"
         .ascii "12|                          O                       |\n"
         .ascii "13|                   O     O                        |\n"
         .ascii "14|                                                  |\n"
         .ascii "15|               O   O           O      O           |\n"
         .ascii "16|                                                  |\n"
         .ascii "17|                             O                    |\n"
         .ascii "18|       O             O                O  O O      |\n"
         .ascii "19|    O     O                         O          O  |\n"
         .ascii "20+--------------------------------------------------+\n"
         .ascii "21|                                                  |\n"
         .ascii "22|             superficie de Argos                  |\n"

longp = . - planeta
enter: .ascii "\n"
cls: .asciz "\x1b[H\x1b[2J"
lencls = .-cls

teclaIngresada: .asciz "x"
longteclaIngresada = . - teclaIngresada

mensajeGanaste:  .asciz "| Felicitaciones GANASTE |"
longmensajeGanaste = . - mensajeGanaste

mensajePerdiste: .asciz "|   PERDISTE   |"
longmensajePerdiste = . - mensajePerdiste

ingresarNombre: .asciz "|   Ingrese su  Nombre   |\n"
longingresarNombre = . - ingresarNombre

nombreIngresado: .asciz "                                                 \n"
longNombreIngreso = . - nombreIngresado

//jugarDeNuevo: .asciz "| Presione 1 para jugar de nuevo. Presione 2 para finalizar. |"
//longjugarDeNuevo = . - jugarDeNuevo

opcionPerdiste: .asciz " "
longOp = . - opcionPerdiste

.text


leerNombre:
	.fnstart

	mov r7,  #3                      @ Lectura x teclado
        mov r0, #0                       @ Ingreso de cadena
        mov r2, #50                       @ Leer cant caracteres
        ldr r1, =nombreIngresado          @ donde se guarda lo ingresado

        swi #0
	bx lr

        .fnend

ingreseNombre:
        .fnstart

        mov r7, #4                       @ Salida por pantalla
        mov r0, #1                       @ salida cadena
        mov r2, $longingresarNombre      @Tamaño de la cadena
        ldr r1, =ingresarNombre

        swi 0
        bx lr

        .fnend

imprimirMapa:
	.fnstart

	mov r7, #4                       @ Salida por pantalla
        mov r0, #1                       @ salida cadena
        mov r2, $longNombreIngreso      @Tamaño de la cadena
        ldr r1, =nombreIngresado

        swi 0

        mov r7, #4 			 @ Salida por pantalla
        mov r0, #1 			 @ salida cadena
        mov r2, $longp 			 @Tamaño de la cadena
        ldr r1, =planeta

	swi 0

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

leerComando:

	.fnstart
	push {r0,r1,r2,r3,r6,r7,lr}
	mov r8,#990 			//Si la nave llega a esta posicion o mayor, se considera que se gano

	bl clearScreen
	bl imprimirMapa

	mov r7,  #3     		 @ Lectura x teclado
        mov r0, #0      		 @ Ingreso de cadena
        mov r2, #1      		 @ Leer cant caracteres
        ldr r1, =teclaIngresada 	 @ donde se guarda lo ingresado

	swi #0

	ldrb r1, [r1]                   // Cargar el carácter ingresado en el registro R1

	cmp r1, #'W'
        beq teclaPresionada_W           // Saltar a teclaPresionada_W  si son iguales

        cmp r1, #'S'
        beq teclaPresionada_S

        cmp r1, #'A'
        beq teclaPresionada_A

        cmp r1, #'D'
        beq teclaPresionada_D


	cmp r1, #'w'
        beq teclaPresionada_W

        cmp r1, #'s'
        beq teclaPresionada_S

        cmp r1, #'a'
        beq teclaPresionada_A

        cmp r1, #'d'
        beq teclaPresionada_D

	bal finLeerComando


//-------------------   Mover Asteroid  --------------------------------------------------------------------------------

moverAsteroid:
         push {r0,r1,r2,r3,r4,r5,r6}
         ldr r0, =planeta
         mov r1, $longp
         mov r4, #1		@Contador de control

mover:
         cmp r4, r1
         beq finMoverAsteroid

         ldrb r2, [r0]
         cmp r2, #'O'
         beq cambiar

         add r0, #1
         add r4, #1
         bal mover

cambiar:
         mov r3, #' '
         mov r5, #'O'
       	 mov r8, r0
	 mov r9, r8

         sub r8, #55
	 ldrb r8, [r8]
         cmp r8, #'_'
         beq borrarAsteroid

         strb r3, [r0]
         sub r6, r0, #55
         strb r5, [r6]

         add r0, #1
         add r4, #1

         bal mover

borrarAsteroid:

	mov r10, #' '
	strb r10, [r9]

	bal mover

finMoverAsteroid:

        pop {r0,r1,r2,r3,r4,r5,r6}

	ldr r5, =planeta
        add r5,r4
        mov r6,#'V'                     // Borrar V posicion anterior
        strb r6, [r5]   		@Borramos la nave de la posición actual

	bal leerComando

//--------------------------------------------------------Fin Asteroif ----------------------------------------------------------------------

teclaPresionada_W:
        ldr r5, =planeta
        add r5, r4			@Apuntamos r5 a la posición de la nave

	mov r10,#'O'
        mov r12,r5
        add r12,#55
        ldrb r12,[r12]

	cmp r12,r10
        beq altVida

	// Acá chequeamos si a donde quiere moverse hay un '_', no se mueva y no haga nada.

        push {r5}
        sub r5, #55
        ldrb r5, [r5]
        cmp r5, #'_'
	beq moverAsteroid
        pop {r5}

        sub r4,#55                   @Guardar posicion actual en R4
        mov r6,#' '                  @Borrar V posicion anterior
        strb r6, [r5]		     @Se borra la nave reemplazando espacio vacío

        sub r5,#55		     @En este bloque obtenemos espacio de arriba, y luego colocamos la nave a donde avanza.
        mov r7,#'V'
        strb r7, [r5]


	bal moverAsteroid

teclaPresionada_S:

	ldr r5, =planeta
        add r5, r4		    @Apuntamos a la posición de la nave
       	add r4,#55                   // Guardar posicion actual en R4

	mov r10,#'O'
        mov r12,r5		@Se copia la posición actual de la nave
	add r12,#55		@Se le suma el equivalente al descenso de una posición.
        ldrb r12,[r12]

        mov r6,#' '                // Borrar V posicion anterior
        strb r6, [r5]		   @Borramos la nave de la posición actual

        add r5,#55		   @Sumamos una posición al espacio actual (vacío) y luego escribimos la nave.
        mov r7,#'V'
        strb r7, [r5]

	cmp r12,r10		@Se hace la comparación para detectar colisión al bajar.
        beq altVida

	cmp r4, r8		@Detección de si se llegó a una posición de ganar el juego.
	bgt ganasteJuego

	bal moverAsteroid


// -----------------------------------------------------------------------------------------------------------------

teclaPresionada_A:
        ldr r5, =planeta
        add r5,r4
        // Acá chequeamos si a donde quiere moverse hay una '|', no se mueva y no haga nada.
        push {r5}
        sub r5, #1
        ldrb r5, [r5]
        cmp r5, #'|'

        beq moverAsteroid
        pop {r5}

	mov r10,#'O'
        mov r12,r5
        sub r12,#1
        ldrb r12,[r12]


        mov r6, #' '
        strb r6,[r5]

        sub r5, #1
        sub r4, #1
        mov r7, #'V'
        strb r7, [r5]

	cmp r12,r10
        beq altVida

        bal moverAsteroid

teclaPresionada_D:

        ldr r5, =planeta
        add r5,r4

	 // Acá chequeamos si a donde quiere moverse hay una '|', no se mueva y no haga nada.
        push {r5}
        add r5, #1
        ldrb r5, [r5]
        cmp r5, #'|'

	//beq leerComando
        beq moverAsteroid
        pop {r5}

	mov r10,#'O'
        mov r12,r5
        add r12,#1
        ldrb r12,[r12]

        mov r6, #' '
        strb r6,[r5]

        add r5, #1
        add r4, #1
        mov r7, #'V'
        strb r7, [r5]

	cmp r12,r10
        beq altVida

        bal moverAsteroid

altVida:


        mov r10, #' '
        strb r10, [r9]
        push {r5,r6}
        ldr r5, =planeta
        mov r6, #51
        add r5,r6

        sub r11, #1
        strb r11,[r5]
        pop {r5,r6}

        cmp r11, #'0'
        beq perdisteJuego

	bal moverAsteroid


//------------------------------------- Mensaje Ganaste Juego --------------------------------------------------------------

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

        ldr r2,[r0]                     //Guardar caracter "mensajeGanaste" en R2
        strb r2,[r5]                    //Insertar el caracter del "mensajeGanaste" en el Mapa (planeta)

        add r0 ,#1                      //Avanzar al siguiente caracter de asciz "mensajeGanaste"
        add r5,#1                       //Avanzar al siguiente caracter de asciz "planeta"
        bal avanzar

finRecorrerCadena:
        pop {r0,r1,r2,r5,r6}

	bl clearScreen
        bl imprimirMapa                 //Me muestra el mapa con mensaje de "GANASTE"

        bal gameOver



//---------------------------------------------------------------------------------------------------------------------------------

//------------------------------------- Mensaje Ganaste Perdiste --------------------------------------------------------------

perdisteJuego:
        push {r0,r1,r2,r5,r6}

        ldr r5, =planeta                // Posicion donde se escribe el mensajePerder - (Posicion 350) asciz
        mov r6,#350
        add r5,r6

        ldr r0, =mensajePerdiste         // Menaje que debe mostrar al Perder
avanzarPerdiste:
        ldrb r1,[r0]

        cmp r1,#0                       // Recorrer cadena asciz "mensajePerdiste"
        beq finRecorrerPerdiste

        ldr r2,[r0]                     //Guardar caracter "mensajePerdiste" en R2
        strb r2,[r5]                    //Insertar el caracter del "mensajePerdiste" en el Mapa (planeta)

        add r0 ,#1                      //Avanzar al siguiente caracter de asciz "mensajePerdiste"
        add r5,#1                       //Avanzar al siguiente caracter de asciz "planeta"
        bal avanzarPerdiste

finRecorrerPerdiste:
        pop {r0,r1,r2,r5,r6}

        bl clearScreen
        bl imprimirMapa                 //Me muestra el mapa con mensaje de "Perdiste"

        bal gameOver




//-----------------------------------------------------------------------------------------------------------------------------$


gameOver:

	bal finLeerComando


finLeerComando:
	pop {r0,r1,r2,r3,r6,r7,lr}
        bx lr
        .fnend


.global main
main:

	 bl ingreseNombre
	 bl leerNombre

	 mov r4 ,#247
	 mov r11, #'3'	@Vidas iniciales. En ASCII. Vida 0= 48

	 bl leerComando

	 mov r7, #1
         swi 0                           @ SWI, Software interrupt
