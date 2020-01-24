

; McMaster 2DX4
; Function:
; This code allows LED D3 To Turn On 
; Runs on MSP432E401Y
; Ama Simons
; Last Modified: January 9th 2020 
 
; Original: Copyright 2014 by Jonathan W. Valvano, valvano@mail.utexas.edu

SYSCTL_RCGCGPIO_R            EQU 0x400FE608  ;General-Purpose Input/Output Run Mode Clock Gating Control Register
GPIO_PORTF_DIR_R             EQU 0x4005D400  ;Access Port Pins 0 - 7  for Port N
GPIO_PORTF_DEN_R             EQU 0x4005D51C  ;Direction Register for Port N
GPIO_PORTF_DATA_R            EQU 0x4005D3FC  ;Digital Enable Register for Port N



        AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
        EXPORT Start



;Function PortF_Init
PortF_Init
    ; STEP 1
    LDR R1, =SYSCTL_RCGCGPIO_R      
    LDR R0, [R1]                
    ORR R0,R0, #0x20
    STR R0, [R1]                          
    NOP
	NOP                             
  
   ; STEP 5
    LDR R1, =GPIO_PORTF_DIR_R      
    LDR R0, [R1]
    ORR R0,R0, #0x10                  	;Or in binary 00010000
    STR R0, [R1]                    
    ; STEP 7
    LDR R1, =GPIO_PORTF_DEN_R         
    LDR R0, [R1]
    ORR R0, R0, #0x10
    STR R0, [R1]	
    BX  LR                            ; return

Start
	BL  PortF_Init                ;The BL instruction is like a function call 
    ;STEP 8                              		
    LDR R1, =GPIO_PORTF_DATA_R
	LDR R0,[R1]
    ORR R0,R0, #0x10
    STR R0, [R1]
	ALIGN                         ;Make sure the end of this section is aligned
    END   