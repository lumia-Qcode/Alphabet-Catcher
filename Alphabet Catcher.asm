[org 0x100]

    jmp start
        welcome: db 'GAME START!'
        points: db 'SCORE:  '
        fouls: db 'MISSED:  '
		play: db 'PRESS R FOR RESTART GAME. PRESS Q FOR QUIT GAME.'
		quit: db 'EXITING GAME...'
        box: db 0xDC
        box_row: db 24
        box_col: db 38
		box_row2: db 24
		box_col2: db 20
        oldisr: dd 0
		rand: dw 0
		randnum: dw 0
		welcome_msg: db 'FALLING ALPHABETS!',0
		over: db 'GAME OVER!',0
		start_msg: db 'PRESS 0 FOR SINGLE PLAYER. PRESS 1 FOR MULTIPLAYER.'
		oldtimerisr: dd 0
		score_msg: db 'Score: ',0
		misses: dw 0
		score: dw 0
		characters: times 5 dw 0    
		positions: times 5 dw 0    
		delays: times 5 dw 0        
		active: times 5 dw 0        
		colors: dw 0x0A, 0x09, 0x04, 0x0D,0x0C
		shift_flag: dw 0
		tickcount: dw 0
		ticksec: dw 0 
		tickmin: dw 0
		tickhour: dw 0
		mode: dw 0
		restartFlag: dw 0

        
    clrscr:
        push es
        push ax
        push di

        mov ax,0xb800
        mov es,ax
        mov di,0

    nextChar:
        mov word[es:di],0x0720
        add di,2
        cmp di,4000
        jne nextChar

        pop di
        pop ax
        pop es
        ret
        
    clear:                              
        push bx
        push cx
            
        mov bx,35        
    l2:
        mov cx,50000    
    l3:
        dec cx
        cmp cx,0
        jne l3
        
        dec bx
        cmp bx,0
        jne l2
        
        pop cx
        pop bx
        ret
        
		; To clear the box from previous position after moving
    clear_box:       
        push ax
        push es
        push di
        
        mov ax,0xb800
        mov es,ax
        
        ; Calculate current box position and clear it
        mov al, 80
        mul byte [box_row]    ; Multiply row by 80
        add al, [box_col]     ; Add column
        mov di, ax
        shl di, 1             ; Multiply by 2 for attribute
        
        mov word [es:di], 0x0720  ; Clear with space
		
	    ; Calculate current box position and clear it
        mov al, 80
        mul byte [box_row2]    ; Multiply row by 80
        add al, [box_col2]     ; Add column
        mov di, ax
        shl di, 1             ; Multiply by 2 for attribute
        
        mov word [es:di], 0x0720  ; Clear with space
        
        pop di
        pop es
        pop ax
        ret
		
	printnum:
		push bp
		mov bp, sp
		push es
		push ax
		push bx
		push cx
		push dx
		push di
		
		mov ax, 0xb800
		mov es, ax ; point es to video base
		mov ax, [bp+4] ; load number in ax
		mov bx, 10 ; use base 10 for division
		mov cx, 0 ; initialize count of digits
	nextdigitt: 
		mov dx, 0 ; zero upper half of dividend
		div bx ; divide by 10
		add dl, 0x30 ; convert digit into ascii value
		push dx ; save ascii value on stack
		inc cx ; increment count of values
		cmp ax, 0 ; is the quotient zero
		jnz nextdigitt ; if no divide it again
		mov di, [bp+6] ; point di to 70th column
	nextposs: 
		pop dx ; remove a digit from the stack
		mov dh, 0x1F ; use normal attribute
		mov [es:di], dx ; print char on screen
		add di, 2 ; move to next screen location
		loop nextposs ; repeat for all digits on stack
		pop di
		pop dx
		pop cx
		pop bx
		pop ax
		pop es
		pop bp
		ret 4

		; To print timer
	printTime:
		push bp
		mov bp, sp
		push es
		push ax
		push bx
		push cx
		push dx
		push di

		push word 0xb800
		pop es			 ; point es to video base

		mov ax, [bp+4] ; load number in ax
		mov bx, 10 ; use base 10 for division
		mov cx, 0 ; initialize count of digits
	nextdigitt2: 
		mov dx, 0 ; zero upper half of dividend
		div bx ; divide by 10
		add dl, 0x30 ; convert digit into ascii value
		push dx ; save ascii value on stack
		inc cx ; increment count of values
		cmp ax, 0 ; is the quotient zero
		jnz nextdigitt2 ; if no divide it again
		mov di, [bp+10] ; point di to 70th column
	nextposs2: 
		pop dx ; remove a digit from the stack
		mov dh, 0x84 ; use normal attribute
		mov [es:di], dx ; print char on screen
		add di, 2 ; move to next screen location
		loop nextposs2 ; repeat for all digits on stack
		mov dl,':'

		mov word [es:di],dx
		add di,2

		mov ax, [bp+6] ; load number in ax
		mov bx, 10 ; use base 10 for division
		mov cx, 0 ; initialize count of digits
	nextdigitt3: 
		mov dx, 0 ; zero upper half of dividend
		div bx ; divide by 10
		add dl, 0x30 ; convert digit into ascii value
		push dx ; save ascii value on stack
		inc cx ; increment count of values
		cmp ax, 0 ; is the quotient zero
		jnz nextdigitt3 ; if no divide it again
	nextposs3: 
		pop dx ; remove a digit from the stack
		mov dh, 0x84 ; use normal attribute
		mov [es:di], dx ; print char on screen
		add di, 2 ; move to next screen location
		loop nextposs3 ; repeat for all digits on stack

		mov dl,':'

		mov word [es:di],dx
		add di,2

		mov ax, [bp+8] ; load number in ax
		mov bx, 10 ; use base 10 for division
		mov cx, 0 ; initialize count of digits
	nextdigitt4: 
		mov dx, 0 ; zero upper half of dividend
		div bx ; divide by 10
		add dl, 0x30 ; convert digit into ascii value
		push dx ; save ascii value on stack
		inc cx ; increment count of values
		cmp ax, 0 ; is the quotient zero
		jnz nextdigitt4 ; if no divide it again
	nextposs4: 
		pop dx ; remove a digit from the stack
		mov dh, 0x84 ; use normal attribute
		mov [es:di], dx ; print char on screen
		add di, 2 ; move to next screen location
		loop nextposs4 ; repeat for all digits on stack

		pop di
		pop dx
		pop cx
		pop bx
		pop ax
		pop es
		pop bp
		ret 8

		; Print game start msg
	display_start:
		pusha
		mov di,1794
		mov si,start_msg
		push word 0xb800
		pop es
		mov cx,50
		mov ah,0x0A
		cld
	next_st:
		lodsb
		stosw
		loop next_st
		
		popa
		ret
		
     ; New function to display score
    display_score:
        push es
        push ax
        push bx
        push di

        mov ax, 0xb800
        mov es, ax
        
        ; Position for score (after "SCORE: ")
  
		push word 40
		push word [score]
		call printnum

        ; Position for misses (after "MISSED: ")
     
		push word 124
		push word [misses]
		call printnum


        pop di
        pop bx
        pop ax
        pop es
        ret
		
		; Print game start screen
    display_Welcome: 
        push bp
        mov bp,sp
        push es
        push ax
        push di
        push si
        push cx
        
        mov ax,0xb800
        mov es,ax        
        mov di,1988        
        mov cx,11        
        mov si,[bp+4]    
        mov ah,0x0A        
            
        cld                
    l1: 
		lodsb            
        stosw            
        loop l1            
        
        pop cx
        pop si
        pop di
        pop ax
        pop es
        pop bp
        ret 2
        
		; display game over screen
	display_end:
		pusha
    
		call clrscr        ; Clear the screen first
    
		push word 0xb800
		pop es
		mov di, 1798
		mov si, play
		mov cx, 48
		mov ah, 0x0E
		cld
    
	play_loop:
		lodsb
		stosw
		loop play_loop
    
		mov di, 1988       ; Position for displaying text
		mov si, over       ; Load "GAME OVER!" string
		mov cx, 10         ; Length of "GAME OVER!"
		mov ah, 0x0A       ; Light green color
		cld
    
	display_loop:
		lodsb              
		stosw              
		loop display_loop  
    
		; Display final score
		mov di, 2150       
		mov ax, 0x0A00     
		mov al, 'S'
		stosw
		mov al, 'c'
		stosw
		mov al, 'o'
		stosw
		mov al, 'r'
		stosw
		mov al, 'e'
		stosw
		mov al, ':'
		stosw
		mov al, ' '
		stosw
    
		mov ax, [score]    
		add ax, '0'        
		mov ah, 0x0A       
		stosw
    
		add di, 148
		push di            
		push word [ticksec]
		push word [tickmin]
		push word [tickhour]
		call printTime		; printing timer
    
	wait_for_key:
		mov ah, 0
		int 0x16           ; Wait for keypress
    
		cmp al, 'q'        ; Check for 'q'
		je quit_game
		cmp al, 'Q'        ; Check for 'Q'
		je quit_game
		cmp al, 'r'        ; Check for 'r'
		je restart_game
		cmp al, 'R'        ; Check for 'R'
		je restart_game
		jmp wait_for_key   ; If not q/Q/r/R, keep waiting
    
	quit_game:
		call clrscr
		mov di, 1988
		mov si, quit 
		mov cx, 15
		mov ah, 0x0A
		cld
	quit_loop:		; display quit msg
		lodsb
		stosw
		loop quit_loop
    
		call clear
		call clrscr
		popa                ; Restore all registers before terminating
		mov ax, 0x4c00
		int 0x21            ; Terminate program
		ret

	restart_game:
		; First unhook both interrupts
		cli
		xor ax, ax
		mov es, ax
    
		; Restore original keyboard ISR
		mov ax, [oldisr]
		mov word [es:9*4], ax
		mov ax, [oldisr+2]
		mov word [es:9*4+2], ax
    
		; Restore original timer ISR
		mov ax, [oldtimerisr]
		mov word [es:8*4], ax
		mov ax, [oldtimerisr+2]
		mov word [es:8*4+2], ax
		sti
    
		; Reset all game variables
		mov word [score], 0
		mov word [misses], 0
		mov word [shift_flag], 0
		mov byte [box_col], 38
		mov byte [box_row], 24
		mov word [tickcount], 0
		mov word [ticksec], 0
		mov word [tickmin], 0
		mov word [tickhour], 0
		mov word [restartFlag],0
		mov word [mode],0
	
		; Clear character arrays
		mov cx, 5
		mov di, characters
	clear_chars:
		mov word [di], 0
		add di, 2
		loop clear_chars
    
		mov cx, 5
		mov di, positions
	clear_pos:
		mov word [di], 0
		add di, 2
		loop clear_pos
    
		mov cx, 5
		mov di, delays
	clear_del:
		mov word [di], 0
		add di, 2
		loop clear_del
    
		mov cx, 5
		mov di, active
	clear_act:
		mov word [di], 0
		add di, 2
		loop clear_act
    
		popa                ; Restore registers
		mov word [restartFlag],1
		ret
	
    print_metrics:
        push bp
        mov bp,sp
        push ax
        push es
        push si
        push di
        push cx
        
        mov ax,0xb800
        mov es,ax
        mov ah,0x1F            
        
        mov di,26            
        mov cx,8            
        mov si,[bp+4]      ; print score msg
        cld
    next_ch:
        lodsb
        stosw
        loop next_ch
        
        xor di,di
        xor si,si
        xor cx,cx
        xor al,al
        
        mov di,110            
        mov cx,9           
        mov si,[bp+6]      ; print miss msg
        cld
    next_ch2:
        lodsb
        stosw
        loop next_ch2
        
        pop cx
        pop di
        pop si
        pop es
        pop ax
        pop bp
        ret 4
    
    print_box:
        push ax
        push bx
        push es
        push di
        
        mov ax,0xb800
        mov es,ax
        
        ; Calculate position
        xor ax,ax
        mov al,80
        mul byte [box_row]    ; row * 80
        add al,[box_col]      ; add column
        mov di,ax
        shl di,1              ; multiply by 2 for attributes
        
        mov ah,0x07           ; attribute
        mov al,[box]          ; character
        mov [es:di],ax        ; display
		
		cmp word [mode],1
		je printBox2
		jmp end5
		
	printBox2:
		xor ax,ax
        mov al,80
        mul byte [box_row2]    ; row * 80
        add al,[box_col2]      ; add column
        mov di,ax
        shl di,1              ; multiply by 2 for attributes
        
        mov ah,0x07           ; attribute
        mov al,[box]          ; character
        mov [es:di],ax        ; display
		
	end5:	  
        pop di
        pop es
        pop bx
        pop ax
        ret
		
		; printing secs of timer
	printSec: 
		push bp 
		mov bp, sp 
		push es 
		push ax 
		push bx 
		push cx 
		push dx 
		push di 
		mov ax, 0xb800 
		mov es, ax ; point es to video base 
		mov ax, [bp+4] ; load number in ax 
		mov bx, 10 ; use base 10 for division 
		mov cx, 0 ; initialize count of digits 
	nextdigit: 
		mov dx, 0 ; zero upper half of dividend 
		div bx ; divide by 10 
		add dl, 0x30 ; convert digit into ascii value 
		push dx ; save ascii value on stack 
		inc cx ; increment count of values 
		cmp ax, 0 ; is the quotient zero 
		jnz nextdigit ; if no divide it again 
		mov di,154
		mov word [es:di],0x07
		add di,2
		mov word [es:di],0x07
		add di,2
		mov word [es:di],0x07
		xor di,di
		mov di, 156 ; point di to 70th column 
	nextpos: 
		pop dx ; remove a digit from the stack 
		mov dh, 0x0A 
		mov [es:di], dx ; print char on screen 
		add di, 2 ; move to next screen location 
		loop nextpos ; repeat for all digits on stack 
		cmp word [bp+4],9
		jbe nextpos2
		jmp  end
	nextpos2:
		sub di,4
		mov dh,0x0A
		mov dl,0
		add dl,0x30
		mov [es:di],dx
	end:
		pop di 
		pop dx 
		pop cx 
		pop bx 
		pop ax
		pop es 
		pop bp 
		ret 2 

		; printing mins of timer
	printMin: 
		push bp 
		mov bp, sp 
		push es 
		push ax 
		push bx 
		push cx 
		push dx 
		push di 
		mov ax, 0xb800 
		mov es, ax ; point es to video base 
		mov ax, [bp+4] ; load number in ax 
		mov bx, 10 ; use base 10 for division 
		mov cx, 0 ; initialize count of digits 
	nextdigit2: 
		mov dx, 0 ; zero upper half of dividend 
		div bx ; divide by 10 
		add dl, 0x30 ; convert digit into ascii value 
		push dx ; save ascii value on stack 
		inc cx ; increment count of values 
		cmp ax, 0 ; is the quotient zero 
		jnz nextdigit2 ; if no divide it again 
		mov di,148
		mov word [es:di],0x07
		add di,2
		mov word [es:di],0x07
		add di,2
		mov word [es:di],0x07
		xor di,di
		mov di, 150 
	nextpos3: 
		pop dx ; remove a digit from the stack 
		mov dh, 0x0A
		mov [es:di], dx ; print char on screen 
		add di, 2 ; move to next screen location 
		loop nextpos3 ; repeat for all digits on stack 
		mov dl,':'
		mov word [es:di],dx
		cmp word [bp+4],9
		jbe nextpos4
		jmp  end2
	nextpos4:
		sub di,4
		mov dh,0x0A
		mov dl,0
		add dl,0x30
		mov [es:di],dx
	end2:
		pop di 
		pop dx 
		pop cx 
		pop bx 
		pop ax
		pop es 
		pop bp 
		ret 2 
		
		; printing hours of timer
	printHour: 
		push bp 
		mov bp, sp 
		push es 
		push ax 
		push bx 
		push cx 
		push dx 
		push di 
		mov ax, 0xb800 
		mov es, ax ; point es to video base 
		mov ax, [bp+4] ; load number in ax 
		mov bx, 10 ; use base 10 for division 
		mov cx, 0 ; initialize count of digits 
	nextdigit3:
		mov dx, 0 ; zero upper half of dividend 
		div bx ; divide by 10 
		add dl, 0x30 ; convert digit into ascii value 
		push dx ; save ascii value on stack 
		inc cx ; increment count of values 
		cmp ax, 0 ; is the quotient zero 
		jnz nextdigit3 ; if no divide it again 
		mov di,142
		mov word [es:di],0x07
		add di,2
		mov word [es:di],0x07
		add di,2
		mov word [es:di],0x07
		xor di,di
		mov di, 144
	nextpos5: 
		pop dx ; remove a digit from the stack 
		mov dh, 0x0A
		mov [es:di], dx ; print char on screen 
		add di, 2 ; move to next screen location 
		loop nextpos5; repeat for all digits on stack 
		mov dl,':'
		mov word [es:di],dx
		cmp word [bp+4],9
		jbe nextpos6
		jmp  end3
	nextpos6:
		sub di,4
		mov dh,0x0A
		mov dl,0
		add dl,0x30
		mov [es:di],dx
	end3:
		pop di 
		pop dx 
		pop cx 
		pop bx 
		pop ax
		pop es 
		pop bp 
		ret 2 

		; Keyboard isr 
	new_kbisr:
		push ax
		push bx
		push dx
		push si
		push di
		push es
		push ds
    
		mov ax, cs
		mov ds, ax
    
		in al, 0x60           ; Read scan code from keyboard
	
		; Check for shift keys 
		cmp al, 0x2A           ; Left shift press
		je set_shift
		cmp al, 0x36           ; Right shift press
		je set_shift
		cmp al, 0xAA           ; Left shift release
		je clear_shift
		cmp al, 0xB6           ; Right shift release
		je clear_shift
	
	
		cmp word [shift_flag],1		; if shift is pressed, move fastly
		je move_fast
		jmp move_normally
	
	move_fast:
		 ; Check if Player 1 (arrow keys)
		cmp al, 0x4B           ; Left arrow (Player 1)
		je move_fast_left
		cmp al, 0x4D           ; Right arrow (Player 1)
		je move_fast_right

		; Check if Player 2 (a and d keys)
		cmp al, 0x1E           ; 'a' key (Player 2 move left)
		je move_fast_left2
		cmp al, 0x20           ; 'd' key (Player 2 move right)
		je move_fast_right2
	
		jmp exit_handler

	move_normally:
		; Check if Player 1 (arrow keys)
		cmp al, 0x4B           ; Left arrow (Player 1)
		je move_left
		cmp al, 0x4D           ; Right arrow (Player 1)
		je move_right

		; Check if Player 2 (a and d keys)
		cmp al, 0x1E           ; 'a' key (Player 2 move left)
		je move_left2
		cmp al, 0x20           ; 'd' key (Player 2 move right)
		je move_right2
	
	exit_handler:
		pop ds
		pop es
		pop di
		pop si
		pop dx
		pop bx
		pop ax
		jmp far [cs:oldisr]    ; Jump to the original interrupt handler

	move_fast_right:
		call clear_box
		cmp byte [box_col], 78
		jae wrap_left
		add byte [box_col], 2
		jmp update_display

	move_fast_left:
		call clear_box
		cmp byte [box_col], 2
		jbe wrap_right
		sub byte [box_col], 2
		jmp update_display

	move_right:
		call clear_box
		cmp byte [box_col], 78
		jae wrap_left
		add byte [box_col], 1
		jmp update_display

	wrap_left:
		mov byte [box_col], 0
		jmp update_display

	move_left:
		call clear_box
		cmp byte [box_col], 2
		jbe wrap_right
		sub byte [box_col], 1
		jmp update_display

	wrap_right:
		mov byte [box_col], 78
		jmp update_display
	
	move_fast_right2:
		call clear_box
		cmp byte [box_col2], 78
		jae wrap_left
		add byte [box_col2], 2
		jmp update_display

	move_fast_left2:
		call clear_box
		cmp byte [box_col2], 2
		jbe wrap_right
		sub byte [box_col2], 2
		jmp update_display

	move_right2:
		call clear_box
		cmp byte [box_col2], 78
		jae wrap_left2
		add byte [box_col2], 1
		jmp update_display

	wrap_left2:
		mov byte [box_col2], 0
		jmp update_display

	move_left2:
		call clear_box
		cmp byte [box_col2], 2
		jbe wrap_right2
		sub byte [box_col2], 1
		jmp update_display
	
	wrap_right2:
		mov byte [box_col2], 78

	update_display:      ; Update the display after moving the boxes
		call print_box   ; Print Player 1's box
		jmp exit_handler

	set_shift:               ; Set shift flag for fast movement
		mov word [shift_flag], 1
		jmp exit_handler

	clear_shift:             ; Clear shift flag
		mov word [shift_flag], 0
		jmp exit_handler

	   
	check_collision:
		push bp
		mov bp, sp
		push ax
		push bx
		push dx
    
		; Calculate box position
		xor ax, ax
		mov al, 80
		mul byte [box_row]        ; row * 80
		add ax, [box_col]         ; add column
		shl ax, 1                 ; multiply by 2 for attributes
    
		; Compare positions
		cmp ax, [positions]
		je collision_detected1

		cmp ax, [positions+2]
		je collision_detected1
    
		cmp ax, [positions+4]
		je collision_detected1
    
		cmp ax, [positions+6]
		je collision_detected1
    
		cmp ax, [positions+8]
		je collision_detected1
    
		jmp no_collision
    
	collision_detected1:  
	
		; If positions match - collision detected
		inc word [score]          ; Increment score by 1
		call display_score        ; Immediately update score display
		mov ax, 1                 ; Return 1 for collision
		jmp check_done
    
	no_collision:
		call display_score
		xor ax, ax                ; Return 0 for no collision
    
	check_done:
		mov [bp+4],ax
		pop dx
		pop bx
		pop ax
		pop bp
		ret 2
        
	; Generate random number (max value in stack)
	
	randG:
		push bp
		mov bp, sp
		pusha
		cmp word [rand], 0
		jne next

		mov ah, 00h   ; interrupt to get system timer in CX:DX 
		INT 1AH
		inc word [rand]
		mov [randnum], dx
		jmp next1

	next:
		mov ax, 25173          ; LCG Multiplier
		mul word  [randnum]     ; DX:AX = LCG multiplier * seed
		add ax, 13849          ; Add LCG increment value
		
		; Modulo 65536, AX = (multiplier*seed+increment) mod 65536
		mov [randnum], ax          ; Update seed = return value

	next1:
		xor dx, dx
		mov ax, [randnum]
		mov cx, [bp+4]
		inc cx
		div cx
		mov [bp+6], dx
		popa
		pop bp
		ret 2

		; Initialize character at index SI
	init_char:
		push bp
		mov bp, sp
		pusha
    
		mov si, [bp+4]
    
		; Generate random character (A-Z)
		sub sp,2
		push word 25
		call randG
		pop ax
		add al, 41h


		;continue:
		xor bx,bx
		mov bx, si
		shl bx, 1
		mov byte ah,[colors+bx]
		mov [characters+bx], ax
    
    
		; Generate random column (0-79)
		sub sp,2
		push word 80
		call randG
		pop ax
		add ax,80
		shl ax, 1
		mov [positions+bx], ax
    
		; Set as active
		mov word [active+bx], 1
    
		; Initialize delay
		mov word [delays+bx], 0
    
		popa
		pop bp
		ret 2
	

		; Timer interrupt handler

	timer_isr:
		push ax
		push bx
		push cx
		push dx
		push si
		push di
		push es
		inc word [cs:tickcount]			; incr tick count
		cmp word [cs:tickcount],16		; if ticks equal 16, now start incremeting secs
		jae change1
		jmp continue
		
	change1:
		mov word [tickcount],0	; re-initlize tick count
		inc word [cs:ticksec]	; increment tick sec
		cmp word [cs:ticksec],60	; if 60 secs passed, now start incrementing mins
		jae change
		jmp continue
		
	change:
		mov word [cs:ticksec],0		; re-initlize tick sec
		inc word [cs:tickmin]		; increment tick min
		cmp word [cs:tickmin],60	; if 60 mins passed, now start incrementing tick hours
		jae change2
		jmp continue
		
	change2:
		mov word [cs:tickmin],0		; re-initilize tick min
		inc word [cs:tickhour]		; increment tick hour
		cmp word [cs:tickhour],24	; if 24 hours passed, now re-initlize hrs
		jae change3
		jmp continue
		
	change3:
		mov word [cs:tickhour],0
		
		; printing timer
	continue:
		push word [cs:ticksec] 
		call printSec 
		push word [cs:tickmin]
		call printMin
		push word [cs:tickhour]
		call printHour
	
		; Check win conditions based on mode
		cmp word [mode], 1
		je check_multiplayer_win
    
		; Single player win check (10 points)
		cmp word [score], 10
		jae game_over_handler
		jmp check_misses
    
	check_multiplayer_win:
		; Multiplayer win check (20 points)
		cmp word [score], 20
		jae game_over_handler
    
	check_misses:    
		; Check if game should end due to misses
		cmp word [misses], 10
		jae game_over_handler     ; Jump to game over if misses >= 10
    
		mov cx, 5        ; Process 5 characters
		xor si, si       ; Character index
    
	process_chars:
		mov bx, si
		shl bx, 1        ; BX = index * 2 for word addressing

		; Skip if not active
		cmp word [active+bx], 0
		je next_char
    
		; Update delay counter
		inc word [delays+bx]
		mov ax, si
		add ax, 3        ; Different speed for each character
		cmp word [delays+bx], ax
		jl next_char
    
		; Reset delay
		mov word [delays+bx], 0
    
		; Clear old position
		push word 0xb800
		pop es
		mov di, [positions+bx]
		mov word [es:di], 0x0720
    
		; check collision
		xor ax,ax
		mov al, 80
		mul byte [box_row]        ; row * 80
		add ax, [box_col]         ; add column
		shl ax, 1                 ; multiply by 2 for attributes
		cmp ax,[positions+bx]
		je collision_detected
		call display_score
  
		; Move down
		add word [positions+bx], 160
	
    
		; Check bottom
		cmp word [positions+bx], 3840
		ja reset_char
    
		; Draw new position
		mov di, [positions+bx]
		mov ax, [characters+bx]
		mov [es:di], ax
		jmp next_char

	collision_detected:
		inc word [score]
		call display_score
		; Check win conditions after score increment
		cmp word [mode], 1
		je check_mp_win_collision
		
		; Single player win check
		cmp word [score], 10
		jae game_over_handler
		jmp continue_collision
    
	check_mp_win_collision:
		; Multiplayer win check
		cmp word [score], 20
		jae game_over_handler
    
	continue_collision:
		call display_score
		mov word [active+bx], 0
		push si
		call init_char
		jmp next_char
    
	reset_char:
		inc word [misses]
		mov word [active+bx], 0
		push si
		call init_char
    
		; Check if misses reached 10 after increment
		cmp word [misses], 10
		jae game_over_handler
    
	next_char:
		inc si
		cmp si, 5        ; Changed from loop to explicit comparison
		jb process_chars ; Use jb (jump if below) instead of loop
    
	timer_exit:
		pop es
		pop di
		pop si
		pop dx
		pop cx
		pop bx
		pop ax
		jmp far [cs:oldtimerisr]
		
		; Modify the game_over_handler to match the same behavior
	game_over_handler:
		; First unhook timer interrupt
		cli
		xor ax, ax
		mov es, ax
		mov ax, [oldtimerisr]
		mov word [es:8*4], ax
		mov ax, [oldtimerisr+2]
		mov word [es:8*4+2], ax
		sti
    
		; Clean up stack from timer_isr
		pop es
		pop di
		pop si
		pop dx
		pop cx
		pop bx
		pop ax
    
		; Call display end screen
		call display_end
		cmp word [restartFlag],1
		je start 
		ret

	start:
		call clrscr
		call display_start		; Display game start screen

	againInput:
		mov ah, 0		; Taking keyboard input 
		int 0x16
    
		cmp al, '0'		; Single player mode
		je singlePlayer
    
		cmp al, '1'		; Multiplayer mode
		je multiPlayer
    
		; Handle ESC key explicitly
		cmp al, 27
		je exit_program
		jmp againInput

	singlePlayer:
		mov word [mode], 0
		jmp game_continue

	multiPlayer:
		mov word [mode], 1

		; printing game 
	game_continue:    
		call clrscr 
		push word welcome
		call display_Welcome
		call clear
		call clrscr
    
		push word fouls
		push word points
		call print_metrics
		call print_box   
    
		; Initialize characters
		mov cx, 5
		xor si, si
	init_loop:
		push si
		call init_char
		inc si
		loop init_loop

		; Pointing es to IVT Base
		xor ax, ax
		mov es, ax
    
		; Hook keyboard interrupt
		mov ax, [es:9*4]
		mov [oldisr], ax
		mov ax, [es:9*4+2]
		mov [oldisr+2], ax
    
		; Hook timer interrupt
		xor ax, 0
		mov ax, [es:8*4]
		mov [oldtimerisr], ax
		mov ax, [es:8*4+2]
		mov [oldtimerisr+2], ax
    
		cli
		mov word [es:9*4], new_kbisr
		mov [es:9*4+2], cs
		mov word [es:8*4], timer_isr
		mov [es:8*4+2], cs
		sti
    
	take_input:
		mov ah, 0
		int 0x16             ; wait for keyboard input  
		cmp al, 27           ; if ESC key is pressed
		je exit_program      ; Terminate program
		jmp take_input

		; Modify the exit_program section to include the restart/quit handling
	exit_program:
		; Unhook timer interrupt
		cli
		xor ax, ax
		mov es, ax
		mov ax, [oldtimerisr]
		mov word [es:8*4], ax
		mov ax, [oldtimerisr+2]
		mov word [es:8*4+2], ax
		sti

		; Display game over screen and handle restart/quit
		call display_end
		cmp word [restartFlag],1
		je do
		jmp ending
	do:
		jmp start

		; Note: display_end now handles the restart/quit logic
		; If it returns (not restarting), we continue to terminate
	ending:
		mov dx, start
		add dx, 15
		mov cl, 4
		shr dx, cl
		mov ax, 0x3100
		int 21h