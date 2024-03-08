push {}

.data
time:  .double

.text
.global main 


main:
ldr r0,=time
mov r7, #78
swi 0
ldr r0,=time
ldr r9, [r0] //epoch https://www.epochconverter.com/
add r0, #4
ldr r10, [r0] //ms?




pop {}
------------------------------------------------------------------------------------
 moverAsteroid:
 53         .fnstart
 54         push {r0,r1,r2,r3,r4,r5,lr}
 55         ldr r0, =planeta
 56         ldr r1, =longp
 57         ldr r1, [r1]
 58         mov r4, r1
 59         mov r5, #1
 60         ldrb r2, [r0]
 61         
 62         cmp r2, #'O'
 63         beq mover
 64         
 65         add r0, #1      @Avanzamos caracter
 66         
 67         add r3, #1
 68         cmp r3, r4
 69         beq finMoverAsteroid
 70         
 71         bal moverAsteroid
 72 
 73 mover:
 74         push {r0,r1,r2}
 75         mov r0, #' '
 76         mov r1, #'O'
 77         strb r2, [r0]
 78         sub r2, #55                   @Guardar posicion actual en R4
 79         strb r2, [r1]
 80         pop {r0,r1,r2}                 @Borrar V posicion anterior
         //strb r2, [r3]
 82         //add r0, #1
 83         add r3, #1
 84         cmp r3, r4
 85         beq finMoverAsteroid
 86
 87         bal moverAsteroid
 88
 89 finMoverAsteroid:
 90         pop {r0,r1,r2,r3,r4,r5,lr}
 91         bx lr
 92         .fnend
