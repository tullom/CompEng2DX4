SYSCTL_RCGCGPIO_R            EQU 0x400FE608  ; General-Purpose Input/Output Run Mode Clock Gating Control Register
GPIO_PORTM_DATA_R            EQU 0x400633FC  ; Access Port Pins 0 - 7  for Port N
GPIO_PORTM_DIR_R             EQU 0x40063400  ; Direction Register for Port N
GPIO_PORTM_DEN_R             EQU 0x4006351C  ; Digital Enable Register for Port N
COUNTER						 EQU 0x00000000  ; state number counter
DELAY						 EQU 0x3FFFFF


        AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
        EXPORT Start



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
    ORR R0, R0, #2_11100000             ;Set bits 5-7 to output       
    STR R0, [R1]
    NOP    
    NOP
    
    ;Studio 1 STEP 7
    LDR R1, =GPIO_PORTM_DEN_R         
    LDR R0, [R1]
    ORR R0, R0, #2_11100011            ;Digital enable the output bits
    STR R0, [R1]
    NOP
    NOP
    BX  LR                            ; return to Start

Start
      BL  PortM_Init                ; The BL instruction is like a function call
      
      ;Studio 1 STEP 8                                      
      LDR R1, =GPIO_PORTM_DATA_R
      LDR R3, =COUNTER
	  LDR R4, =DELAY
	  
clknoten   

	  LDR R0, [R1]
      AND R2, R0, #2_01 ;Mask to check
      CMP R2, #2_01
      BNE clknoten
	  BEQ clken
	  
clken
	  LDR R4, =DELAY
del   SUB R4, R4, #0x1
	  CMP R4, #0x0
	  BNE del
	  
	  ;LDR R0, [R1]
	  ;EOR R0, R0, #2_10000000 ;Turn on light
	  ;STR R0, [R1]
	  
	  CMP R3, #0x0
      BEQ state1
	  CMP R3, #0x01
      BEQ state2
	  CMP R3, #0x2
      BEQ state3
	  CMP R3, #0x3
      BEQ state4
	  CMP R3, #0x4
      BEQ unlocked
	  B clknoten
	  
state1  LDR R0, [R1]
        AND R2, R0, #2_11 ;Mask to check
        CMP R2, #2_01
		BNE fail
		
		LDR R0, [R1]
		AND R0, R0, #2_00000000 ;Turn on light
		STR R0, [R1]
		
		LDR R0, [R1]
		ORR R0, R0, #2_00100000 ;Turn on light
		STR R0, [R1]
		
		ADD R3, R3, #0x1
        B clknoten
		
state2  LDR R0, [R1]
        AND R2, R0, #2_11 ;Mask to check
        CMP R2, #2_01
		BNE fail
		
		LDR R0, [R1]
		AND R0, R0, #2_00000000 ;Turn on light
		STR R0, [R1]

		LDR R0, [R1]
		ORR R0, R0, #2_01000000 ;Turn on light
		STR R0, [R1]

		ADD R3, R3, #0x1
        B clknoten
		
state3  LDR R0, [R1]
        AND R2, R0, #2_11 ;Mask to check
        CMP R2, #2_01
		BNE fail
		
		LDR R0, [R1]
		AND R0, R0, #2_00000000 ;Turn on light
		STR R0, [R1]
		
		LDR R0, [R1]
		ORR R0, R0, #2_01100000 ;Turn on light
		STR R0, [R1]
		
		ADD R3, R3, #0x1
        B clknoten

state4  LDR R0, [R1]
        AND R2, R0, #2_11 ;Mask to check
        CMP R2, #2_11
		BNE fail

		LDR R0, [R1]
		AND R0, R0, #2_00000000 ;Turn on light
		STR R0, [R1]

		LDR R0, [R1]
		ORR R0, R0, #2_10000000 ;Turn on light
		STR R0, [R1]

		;LDR R0, [R1]
		;ORR R0, R0, #2_01000000 ;Turn on light
		;STR R0, [R1]
		
		ADD R3, R3, #0x01
        B clknoten
		
fail    LDR R3, =COUNTER
		B clknoten

unlocked LDR R3, =COUNTER
		 LDR R0, [R1]
		 AND R0, R0, #2_00000000 ;Turn off light
		 STR R0, [R1]
		 B clknoten

      ALIGN                         ;Make sure the end of this section is aligned
      END  
