; McMaster 2DX4
; Function:
; Modify this Lab 1 Milestone 1
; Runs on MSP432E401Y
; Ama Simons
; Last Modified: January 13th 2020
 
; Original: Copyright 2014 by Jonathan W. Valvano, valvano@mail.utexas.edu
                                             ; Note: You Need to Update Port F (used in Studio 1) to Port N (used in Lab 1). Review Studio 1 for more details.
SYSCTL_RCGCGPIO_R            EQU 0x400FE608  ; General-Purpose Input/Output Run Mode Clock Gating Control Register
GPIO_PORTN_DATA_R            EQU 0x400643FC  ; Access Port Pins 0 - 7  for Port N
GPIO_PORTN_DIR_R             EQU 0x40064400  ; Direction Register for Port N
GPIO_PORTN_DEN_R             EQU 0x4006451C  ; Digital Enable Register for Port N

;Set up for Port M
GPIO_PORTM_DIR_R             EQU 0x40063400
GPIO_PORTM_DEN_R             EQU 0x4006351C
GPIO_PORTM_DATA_R             EQU 0x400633FC
COUNTER                      EQU 0xFFFFF


        AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
        EXPORT Start



;Function PortN_Init
PortN_Init
    ; Studio 1 STEP 1
    LDR R1, =SYSCTL_RCGCGPIO_R      
    LDR R0, [R1]                
    ORR R0,R0, #0x1000
    STR R0, [R1]                          
    NOP
    NOP                             
 
    ;Studio 1 STEP 5
    LDR R1, =GPIO_PORTN_DIR_R      
    LDR R0, [R1]
    ORR R0,R0, #0x0002                    ;Or in binary 00010000
    STR R0, [R1]
    NOP    
    NOP
    
    ;Studio 1 STEP 7
    LDR R1, =GPIO_PORTN_DEN_R         
    LDR R0, [R1]
    ORR R0, R0, #0x0002
    STR R0, [R1]
    NOP
    NOP
    BX  LR                            ;return to Start
    
;Function PortM_Init
PortM_Init
    ; Studio 1 STEP 1
    LDR R1, =SYSCTL_RCGCGPIO_R      
    LDR R0, [R1]                
    ORR R0,R0, #0x800
    STR R0, [R1]                          
    NOP
    NOP  

    ;Studio 1 STEP 5
    LDR R1, =GPIO_PORTM_DIR_R      
    LDR R0, [R1]
    ORR R0,R0, #0x0000                   
    STR R0, [R1]
    NOP    
    NOP
    
    ;Studio 1 STEP 7
    LDR R1, =GPIO_PORTM_DEN_R         
    LDR R0, [R1]
    ORR R0, R0, #0x0001
    STR R0, [R1]
    NOP
    NOP
    BX  LR                            ; return to Start
    
    
    

Start
      BL  PortN_Init                ; The BL instruction is like a function call
      BL  PortM_Init
      
      
      
      ;Studio 1 STEP 8                                      
      LDR R1, =GPIO_PORTN_DATA_R
      LDR R0, [R1]
      
loop  LDR R4, =GPIO_PORTM_DATA_R
      LDR R3, [R4]
      STR R0, [R1]

      CMP R3, #0x0
      BEQ loop1
      B loop
      
loop1 ORR R0, R0, #0x0002
      STR R0, [R1]
      EOR R0, R0, #0x0002
      LDR R3, [R4]
      
      CMP R3, #0x0
      BEQ loop1
      B loop
      
      ALIGN                         ;Make sure the end of this section is aligned
      END  
