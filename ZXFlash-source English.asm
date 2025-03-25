; --------------------------------------------
; Modifications to the original Spectrum ROM
; --------------------------------------------

L0000   DI                      ; Disable interrupts.
        XOR     A               ; Signal coming from START.
        LD      DE,$FFFF        ; Top of possible physical RAM.
        JP      $386E           ; Replaced $11CB with $386E to call the Flash menu.

;--------------------------------------------------
; ZX-Flash V 0.3 Call during initialization
;--------------------------------------------------

L386E
        .org $386e              ; Using free space in ROM

        di                      ; Disable interrupts

start : ld sp,$EFFF             ; Set the stack pointer position
        call Cls                ; Clear screen
	ld a,1                  ; Border color: Blue
	out ($FE),a        
	
menu:
        ld ix,Textos            ; Load menu text
menu_loop:
        ld h,(ix+1)
        ld l,(ix+0)
        ld a,h
        or l
        jr z,Opciones           ; If zero, jump to options
        inc ix
        inc ix
        call PintaString        ; Print the text string
        jr menu_loop	

Opciones:  
;        ld hl,$F000
;        ld (hl),4
        ld ix,Atributos+2
        ld a,$79
        call Cambia_attr         ; Change attributes

teclas:
        ld a, $EF               ; Read key row 6,7,8,9,0
 	in a, ($FE)        
       	bit 4,a			
 	jr z,abajo 	; "6" key pressed			
 	bit 3,a
 	jr z,arriba 	; "7" key pressed
        ld a, $BF               ; Read key row H,J,K,L,Enter
 	in a, ($FE)        
       	bit 0,a 			
 	jp z,enter 	; "Enter" key pressed
        jr teclas       ; No key pressed, repeat loop
                
arriba:
        ld a,$0F	; Attribute value
        call Cambia_attr
        dec ix
        dec ix
        dec ix
        ld a,(ix+0)
        cp (ix+1)
        jr nz, arriba_1        ; Cursor is not at the top
        ld ix,Atributos+29     ; Cursor was at the top
arriba_1:
        ld a,$79             ; Attribute $79 for selection
        call Cambia_attr         
        call pausa
        jp teclas        
      
abajo:
        ld a,$0F
        call Cambia_attr
        inc ix
        inc ix
        inc ix
        ld a,(ix+0)
        cp (ix+1)
        jr nz, abajo_1        ; Cursor is not at the bottom
        ld ix,Atributos+2 
abajo_1:
        ld a,$79             ; Attribute $79 for selection
        call Cambia_attr         
        call pausa
        jp teclas

enter:

	ld de,$C000     ; Copy (execute) into the last 16K RAM bank
	ld hl,ProgRAM
	ld bc,FinprogRAM-ProgRAM ; Exact size
	ldir
	jp $C000	; Execution jumps to the program in RAM

ProgRAM:
        ld b,(ix+2)     ; B contains the program order number
        ld a,b
        ex af,af'	; Preserve the selected program number in a'
        ld a,b
        or a
        rl a		; b = b * 2
        rl a		; b = b * 2
        ld b,a
        add a,b
        add a,b		; a = b * 3 
        ld b,a		; b contains the number of pulses to switch to the first bank
 
        ld b,4		; Must be 4
mapea:  ld hl,$3FFF	; Read address to trigger the counter
        ld d,(hl)	; Activate counter
        djnz mapea	; Position over the first bank
        ld b,a
        cp 0
        jr z,ya_en_ROM1 
; Last change
mapeaROM1:
        ld hl,$3FFF	; Map to the first bank
        ld a,(hl)	; Activate counter
        djnz mapeaROM1

ya_en_ROM1:        
        ld hl,$0000	; Transfer the first ROM bank to RAM
        ld de,$4000
        ld bc,$4000
        ldir
        ld b,2

mapeaROM2:
        ld hl,$3FFF	; Map to the second bank
        ld a,(hl)	; Activate counter
        djnz mapeaROM2
        
        ld hl,$0000	; Transfer the second ROM bank to RAM
        ld de,$8000
        ld bc,$4000
        ldir
        
        ld b,2

mapeaROM3:
        ld hl,$3FFF	; Map to the third bank
        ld a,(hl)	; Activate counter
        djnz mapeaROM3
        
        ld hl,$C000+ProgSCR-ProgRAM	; Transfer program to screen memory
        ld de,$4000
        ld bc,FinprogSCR-ProgSCR
        ldir
        jp $4000  

ProgSCR:
        ld hl,$0000	; Transfer the third ROM bank to RAM
        ld de,$C000
        ld bc,$4000
        ldir
        
        ld b,200

bloqueaROM:
        ld hl,$3FFF	; Read address to trigger counter
        ld a,(hl)	; Activate counter
        djnz bloqueaROM	; Execute reads until ROM is locked.
        jp Finaliza

; *** Preserve FF for compatibility with some programs ***
          .org $39F8
        DEFB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF   
        
; ***********************************
; ************ Routines **************
; ***********************************
          .org $3A04

Cambia_attr:		; Change n attributes to value "a" at address (IX)
        ld l,(ix+0)
        ld h,(ix+1)
        push hl
        pop de
        inc de
        ld bc,$19
        ld (hl),a 	; Attribute value
	ldir
	ret
pausa:
        ld b,255
pausa_1:
        ld a,255 
pausa_2:
        dec a
        jp nz,pausa_2
        djnz pausa_1
        ret
        
Cls:    
        ; Clear the screen
        ; Uses hl, de, bc
        ld hl,16384
	ld de,16385
	ld bc,6143
	ld (hl),0
	ldir
	ld hl,22528
	ld de,22529
	ld bc,767
	ld (hl),15
	ldir
	ret
	        
PintaChar:
	; a = Character.
	; hl = Screen address.
	; Uses de, hl, and b
	push hl         ; Save screen address
	sub 32		
	ld h,0
	ld l,a
	add hl,hl	
	add hl,hl
	add hl,hl
	ld de,$3d00
	add hl,de
	ex de,hl	; 'de' now holds the character address  
	pop hl          ; 'hl' holds the screen address
	ld b,8          ; Number of bytes per character.
PintaChar_loop:
	ld a,(de)
	ld (hl),a
	inc h
	inc de
	djnz PintaChar_loop
	ret
