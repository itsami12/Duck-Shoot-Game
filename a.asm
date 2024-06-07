.model small
.stack 100
.data    
    
    game_over db 'GAME OVER  $'
    game_winner db 'Game Winner $'
    static_score db 'SCORE :$'
    static_bullet db 'Bullets:$'
    inputPrompt db 'Enter your name: $'
    inputPrompt1 db 'Enter your choice: $'
    nameBuffer db 4, '$'
     
   
    imageFileNameA db "f.bin",0    
    imageFileNameB db "f1.bin",0  
    imageFileNameC db "f2.bin",0   
    imageFileNameD db "f3.bin",0 
    imageFileNameE db "f5.bin",0   
    imageFileNameF db "f6.bin",0
    
    imageBufferA db 40*94 DUP(0)
    imageBufferB db 35*122 DUP(0)
    imageBufferC db 162*270 DUP(0)  
    imageBufferD db  8*16 DUP(0) 
    imageBufferE db  18*61 DUP(0)
    numberString db 6 DUP(0)
    
      
    fileHandleA dw 2 DUP(0)
    fileHandleB dw 2 DUP(0) 
    fileHandleC dw 2 DUP(0)  
    fileHandleD dw 2 DUP(0)  
    fileHandleE dw 2 DUP(0)
    fileHandleF dw 2 DUP(0) 
    
     frequencies dw 1292, 1355, 1436, 1521, 1612, 1715, 1809, 1917, 2031, 2152, 2280, 2415, 2559
                    dw 2711, 2873, 3043, 3225, 3619, 3834, 4063, 3043, 2280, 3043, 3619, 2711, 2415
                    dw 2559, 2711, 3043, 1809, 1521, 1621, 1521, 1809, 2280, 2031, 2415
            
     freq dw 0        
    counter_s db 0
    ducks_hunted db 0
    
    
    score dw 0
    tempPosY dw 0
    tempPosX dw 0
    position_x dw 0
    position_y dw 0
    temp_c dw 0
    temp_r dw 0
    color db 0
    num_rows dw 0
    num_cols dw 0
    temp dw 0  
    
    duck2x dw 100
    duck2y dw  50
    cursorx dw 0
    cursory dw 0  
     cursor2x dw 0
    cursor2y dw 0  
    
    random db 0
    
    duckx dw 245
    ducky dw 50 
    
 
.code


     

createFile proc
    mov ah, 3Ch          ; Create file
    mov cx, 2           ; File attribute: normal
    lea dx, imageFileNameF
    int 21h
       
    mov [fileHandleF], ax ; Store file handle
    ret

    ret
createFile endp

writeFile proc
    mov ah, 40h          ; Write to file
    mov bx, [fileHandleF] ; File handle
    lea dx, numberString ; Buffer with data to write
    mov cx, 6            ; Number of bytes to write (length of the string including null terminator)
    int 21h
    
    ret

    ret
writeFile endp

openFile proc
    mov ah, 3Dh       
    mov al, 0            
    int 21h 
    mov bx, ax 
    ret
openFile endp

readFile proc
    mov ah, 3Fh           
    int 21h   
    ret
readFile endp

closeFile proc
    mov ah, 3Eh         
    int 21h  
    ret
closeFile endp

loadImage proc
    mov  dx, fileHandleA
    call openFile    
    mov dx, fileHandleA+2
    call readFile
    call closeFile
    ret
loadImage endp

loadImage2 proc
    mov  dx, fileHandleB    
    call openFile    
    mov dx, fileHandleB+2
    call readFile
    call closeFile
    ret
loadImage2 endp 

loadImage3 proc
    mov  dx, fileHandleC    
    call openFile    
    mov dx, fileHandleC+2
    call readFile
    call closeFile
    ret
loadImage3 endp    

loadImage4 proc
    mov  dx, fileHandleD    
    call openFile    
    mov dx, fileHandleD+2
    call readFile
    call closeFile
    ret
loadImage4 endp   

loadImage5 proc
    mov  dx, fileHandleE    
    call openFile    
    mov dx, fileHandleE+2
    call readFile
    call closeFile
    ret
loadImage5 endp 

loadImage6 proc
    
    mov ax,score
    call createFile      ; Create the file first
    call writeFile       ; Write data to the file
    call closeFile       ; Close the file
    ret
    ret
loadImage6 endp

loadImages proc
    mov fileHandleA, offset imageFileNameA
    mov fileHandleA+2, offset imageBufferA
    mov cx, 40*94 
    call loadImage
    ret
loadImages endp 

loadImages2 proc
    mov fileHandleB, offset imageFileNameB
    mov fileHandleB+2, offset imageBufferB
    mov cx,35*122
    call loadImage2
    ret
loadImages2 endp

loadImages3 proc
    mov fileHandleC, offset imageFileNameC
    mov fileHandleC+2, offset imageBufferC
    mov cx,162*270
    call loadImage3
    ret
loadImages3 endp   

loadImages4 proc
    mov fileHandleD, offset imageFileNameD
    mov fileHandleD+2, offset imageBufferD
    mov cx,8*16
    call loadImage4
    ret
loadImages4 endp     

loadImages5 proc
    mov fileHandleE, offset imageFileNameE
    mov fileHandleE+2, offset imageBufferE
    mov cx,18*61
    call loadImage5
    ret
loadImages5 endp

restorePosition proc
    mov ax, position_x
    mov tempPosX, ax
    mov ax, position_y
    mov tempPosY, ax
    mov ax, num_cols
    mov temp_c, ax
    mov ax, num_rows
    mov temp_r, ax
    ret
restorePosition endp

moveRightPixel proc 
    mov al, color
    mov ah, 0ch
    int 10h
    inc cx
    ret
moveRightPixel endp

printImage proc
    mov dx, tempPosY
    outerLoop:
    mov cx, tempPosX
    mov ax, temp_c
    mov temp, ax
    innerLoop:
    mov al, [si]
    sub al, 30h
    mov color, al
    call moveRightPixel         
    inc si         
    dec temp
    cmp temp, 0        
    jne innerLoop 
    dec temp_r         
    mov cx, position_x     
    inc dx  
    cmp temp_r, 0        
    jne outerLoop   
    ret
printImage endp

graphicMode proc      
    mov ah, 0
    mov al, 13h  
    int 10h  
    ret
graphicMode endp  

name1 proc
    
    mov dx, offset inputPrompt
    mov ah, 09h
    mov cx, 90
    mov bx, 90
    int 21h   
    ret
name1 endp 


SOUND proc

    mov     al, 182         
    out     43h, al        
    mov     ax, freq    
    out     42h, al        
    mov     al, ah         
    out     42h, al 
    in      al, 61h         
    or      al, 00000011b   
    out     61h, al         
    mov     bx, 25         
    pause1:
    mov     cx, 6550
    pause2:
    dec     cx
    jne     pause2
    dec     bx
    jne     pause1
    in      al, 61h         
    and     al, 11111100b   
    out     61h, al       
    RET
SOUND endp

SOUND1 PROC
    mov temp,36
    mov si,offset frequencies
    SOUNDER:
    mov ax,[si]
    mov freq,ax
    call SOUND
	add si,2
	dec temp
    cmp temp,0
    jne SOUNDER
	RET
SOUND1 endp
  

print_bullets proc
    mov ah,02h   ;set position
    mov dh,24
    mov dl,18
    int 10h
    mov ah, 2
    mov dl, counter_s
    add dl,'0'
    int 21h


    mov ah,02h   ;set position
    mov dh,24
    mov dl,10
    int 10h
    mov ah, 9
    mov dx, offset static_bullet
    int 21h
    ret
print_bullets endp
                   
random1 proc
        mov ah,2ch
        int 21H
        ret
random1 endp 
selectGameMode proc
    mov dx, offset inputPrompt1
    mov ah, 09h
    int 21h

    mov ah, 01h   ; Read a character from standard input
    int 21h
    sub al, '0'   ; Convert ASCII character to numeric value

    cmp al, 1     ; Check if user selected single duck game
    je singleDuckGame
    cmp al, 2     ; Check if user selected two ducks game
    je twoDucksGame
    cmp al, 3     ; Check if user selected to terminate the program
    je terminateProgram

    jmp selectGameMode ; If user enters an invalid choice, prompt again

singleDuckGame:
    call single   ; Run the single duck game
    jmp selectGameMode ; After the game ends, prompt for another choice

twoDucksGame:
    call double
    jmp selectGameMode ; After the game ends, prompt for another choice

terminateProgram:
    mov ah, 4Ch  
    int 21h
selectGameMode endp 

double  proc 
  call loadImages3
    call graphicMode
    mov num_rows,162
    mov num_cols,270
    mov position_x,10
    mov position_y,0
    mov si,offset imageBufferC
    call restorePosition
    call printImage

    

    call loadImages4
    mov num_rows,8
    mov num_cols,16
    mov position_x,10
    mov position_y,10
    mov si, offset imageBufferD
    call restorePosition
    call printImage


    
    checkInput:
        mov ah, 01h
        int 16h
        jz move_duck
        ; Read keyboard input
        mov ah, 00h
        int 16h

        ; Check for arrow key scan codes
        cmp ah, 48h ; Up arrow key scan code
        je move_up
        cmp ah, 50h ; Down arrow key scan code
        je move_down
        cmp ah, 4Bh ; Left arrow key scan code
        je move_left
        cmp ah, 4Dh ; Right arrow key scan code
        je move_right
        cmp ah,31 ; space for shoot
        je shoot
        je shoot1  
        jmp checkInput


    move_up:
        dec position_y
        dec position_y
        dec position_y
        call moveImage4
        jmp checkInput
    move_down:
        inc position_y
        inc position_y
        inc position_y
        call moveImage4
        jmp checkInput
    move_left:
        dec position_x
        dec position_x
        dec position_x
        call moveImage4
        jmp checkInput
    move_right:
        inc position_x
        inc position_x
        inc position_x
        call moveImage4
        jmp checkInput
    
    move_duck:
    call random1
    mov al, random
    cmp al, 0
    je move_random_up
    cmp al, 1
    je move_random_down
    cmp al, 2
    je move_random_left
    cmp al, 3
    je move_random_right

move_random_up:
    dec ducky
    call moveImage4
    jmp checkInput

move_random_down:
    inc ducky
    call moveImage4
    jmp checkInput

move_random_left:
    dec duckx
    call moveImage4
    jmp checkInput

move_random_right:
    inc duckx
    call moveImage4
    jmp checkInput  
    
     shoot1:
        ;display 
        inc counter_s
        cmp counter_s, 5  ; Check if 's' button pressed more than 5 times
        jg exit
        mov ax,cursorx
        mov bx,duckx

        cmp ax,bx       ; lower bound
        jl not_between  ; Jump if position_x is less than 10

        add bx,50       ; Jump if position_x is greater than 20
        cmp ax,bx       ; upper bound
        jg not_between

        mov ax,cursory
        mov bx,ducky

        cmp ax,bx       ; lower bound
        jl not_between  ; Jump if position_x is less than 10

        add bx,50       ; Jump if position_x is greater than 20
        cmp ax,bx       ; upper bound
        jg not_between
          

        jmp scored
    scored:
        inc score
        mov ax,score
        cmp ax,10
        jge winner
        mov duckx,245
        jmp checkInput
                        
   
                         
  
move_duck2:
    call random1
    mov al, random
    cmp al, 0
    je move_random_up2
    cmp al, 1
    je move_random_down2
    cmp al, 2
    je move_random_left2
    cmp al, 3
    je move_random_right2 
    call moveImage4
    jmp checkInput 

move_random_up2:
    dec duck2y
    call moveImage4
    jmp checkInput

move_random_down2:
    inc duck2y
    call moveImage4
    jmp checkInput

move_random_left2:
    dec duck2x
    call moveImage4
    jmp checkInput

move_random_right2:
    inc duck2x
    call moveImage4
    jmp checkInput
    shoot:
        ;display
        inc counter_s
        cmp counter_s, 5  ; Check if 's' button pressed more than 5 times
        jg exit 
        mov ax,cursor2x
        mov bx,duck2x

        cmp ax,bx       ; lower bound
        jl not_between  ; Jump if position_x is less than 10

        add bx,50       ; Jump if position_x is greater than 20
        cmp ax,bx       ; upper bound
        jg not_between

        mov ax,cursor2y
        mov bx,duck2y

        cmp ax,bx       ; lower bound
        jl not_between  ; Jump if position_x is less than 10

        add bx,50       ; Jump if position_x is greater than 20
        cmp ax,bx       ; upper bound
        jg not_between
        

        jmp scored1
    scored1:
        inc score
        mov ax,score
        cmp ax,10
        jge winner
        
       
        mov duck2x,100
        jmp checkInput 
        
        
    
        
    not_between:
      jmp checkInput
      

    moveImage4 proc
        mov ax,duckx
        cmp ax,5
        jb reset_duck 
        
        mov ax,duck2x
        cmp ax,5
        jb reset_duck1

        mov bx,position_x
        push bx
        mov bx,position_y
        push bx
        mov bx,num_cols
        push bx
        mov bx,num_rows
        push bx
    
        call loadImages3
        ; call graphicMode
        mov num_rows,162
        mov num_cols,270
        mov position_x,10
        mov position_y,0
        mov si,offset imageBufferC
        call restorePosition
        call printImage

        call loadImages5
        mov num_rows,18
        mov num_cols,61
        mov ax,duckx
        mov position_x,ax
        mov ax,ducky
        mov position_y,ax
        mov si, offset imageBufferE
        call restorePosition
        call printImage  
        
        
        call loadImages5
        mov num_rows,18
        mov num_cols,61
        mov ax,duck2x
        mov position_x,ax
        mov ax,duck2y
        mov position_y,ax
        mov si, offset imageBufferE
        call restorePosition
        call printImage

        dec duckx
        dec duckx
        dec duckx
        dec duckx
        dec duckx
        dec duckx
        dec duckx
        dec duckx
        dec duckx   
        
         dec duck2x
         dec duck2x
         dec duck2x
         dec duck2x
         dec duck2x
         dec duck2x
         dec duck2x
         dec duck2x
         dec duck2x
        
        pop bx
        mov num_rows,bx
        pop bx
        mov num_cols,bx
        pop bx
        mov position_y,bx
        pop bx
        mov position_x,bx
        call loadImages3
        mov si, offset imageBufferC
        call restorePosition
        call printImage

        mov ax,position_x
        mov cursorx,ax
        mov ax,position_y
        mov cursory,ax 
        
        mov ax,position_x
        mov cursor2x,ax
        mov ax,position_y
        mov cursor2y,ax
        ; Move and print imageBufferD
        mov si, offset imageBufferD
        call restorePosition
        call printImage
        

        
         call   print_score1
        call   print_bullets

         print_score1 proc
    mov ah,02h   ;set position
    mov dh,24
    mov dl,37
    int 10h
    mov ah, 2
    mov dx, score
    add dx,'0'
    int 21h


    mov ah,02h   ;set position
    mov dh,24
    mov dl,30
    int 10h
    mov ah, 9
    mov dx, offset static_score
    int 21h
    ret
print_score1 endp   
     
    
    ret
    reset_duck:
        mov duckx,245
        ret   
        reset_duck1:
        mov duck2x,100
        ret
    moveImage4 endp
    
    exit:
        mov ah,02h   ;set position
        mov dh,10
        mov dl,14
        int 10h
        mov ah, 9
        mov dx, offset game_over
        int 21h
 

        mov ah, 00h  
        int 16h 
        mov ah,04ch
        int 21h
    winner:
        mov ah,02h   ;set position
        mov dh,10
        mov dl,14
        int 10h
        mov ah, 9
        mov dx, offset game_winner
        int 21h
 

    mov ah, 00h  
        int 16h 
        
    ret    


double endp



single proc
    
     call loadImages3
    call graphicMode
    mov num_rows,162
    mov num_cols,270
    mov position_x,10
    mov position_y,0
    mov si,offset imageBufferC
    call restorePosition
    call printImage

    

    call loadImages4
    mov num_rows,8
    mov num_cols,16
    mov position_x,10
    mov position_y,10
    mov si, offset imageBufferD
    call restorePosition
    call printImage


    
    checkInput:
        mov ah, 01h
        int 16h
        jz move_duck
        ; Read keyboard input
        mov ah, 00h
        int 16h

        ; Check for arrow key scan codes
        cmp ah, 48h ; Up arrow key scan code
        je move_up
        cmp ah, 50h ; Down arrow key scan code
        je move_down
        cmp ah, 4Bh ; Left arrow key scan code
        je move_left
        cmp ah, 4Dh ; Right arrow key scan code
        je move_right
        cmp ah,31 ; space for shoot
        je shoot 
        
        jmp checkInput
        


    move_up:
        dec position_y
        dec position_y
        dec position_y
        call moveImage41
        jmp checkInput
    move_down:
        inc position_y
        inc position_y
        inc position_y
        call moveImage41
        jmp checkInput
    move_left:
        dec position_x
        dec position_x
        dec position_x
        call moveImage41
        jmp checkInput
    move_right:
        inc position_x
        inc position_x
        inc position_x
        call moveImage41
        jmp checkInput
    
        move_duck:
    call random1
    mov al, random
    cmp al, 0
    je move_random_up
    cmp al, 1
    je move_random_down
    cmp al, 2
    je move_random_left
    cmp al, 3
    je move_random_right

move_random_up:
    dec ducky
    call moveImage41
    jmp checkInput

move_random_down:
    inc ducky
    call moveImage41
    jmp checkInput

move_random_left:
    dec duckx
    call moveImage41
    jmp checkInput

move_random_right:
    inc duckx
    call moveImage41
    jmp checkInput

    shoot:
        ;display
        inc counter_s
        cmp counter_s, 5  ; Check if 's' button pressed more than 5 times
        jg exit 
        mov ax,cursorx
        mov bx,duckx

        cmp ax,bx       ; lower bound
        jl not_between  ; Jump if position_x is less than 10

        add bx,50       ; Jump if position_x is greater than 20
        cmp ax,bx       ; upper bound
        jg not_between

        mov ax,cursory
        mov bx,ducky

        cmp ax,bx       ; lower bound
        jl not_between  ; Jump if position_x is less than 10

        add bx,50       ; Jump if position_x is greater than 20
        cmp ax,bx       ; upper bound
        jg not_between
        
       
        jmp scored
    scored:
        inc score
        mov ax,score
        cmp ax,3
        jge winner 
        
        mov duckx,245  
        
        jmp checkInput

      
    
    not_between:
      jmp checkInput
      

    moveImage41 proc
        mov ax,duckx
        cmp ax,3
        jb reset_duck

        mov bx,position_x
        push bx
        mov bx,position_y
        push bx
        mov bx,num_cols
        push bx
        mov bx,num_rows
        push bx
    
        call loadImages3
        ; call graphicMode
        mov num_rows,162
        mov num_cols,270
        mov position_x,10
        mov position_y,0
        mov si,offset imageBufferC
        call restorePosition
        call printImage

        call loadImages5
        mov num_rows,18
        mov num_cols,61
        mov ax,duckx
        mov position_x,ax
        mov ax,ducky
        mov position_y,ax
        mov si, offset imageBufferE
        call restorePosition
        call printImage

        dec duckx
        dec duckx
        dec duckx
        dec duckx
        dec duckx
        dec duckx
        dec duckx
        dec duckx
        dec duckx
        pop bx
        mov num_rows,bx
        pop bx
        mov num_cols,bx
        pop bx
        mov position_y,bx
        pop bx
        mov position_x,bx
        call loadImages3
        mov si, offset imageBufferC
        call restorePosition
        call printImage

        mov ax,position_x
        mov cursorx,ax
        mov ax,position_y
        mov cursory,ax
        ; Move and print imageBufferD
        mov si, offset imageBufferD
        call restorePosition
        call printImage
        
        

        call   print_score2 
   
        call   print_bullets
                              
                              print_score2 proc
    mov ah,02h   ;set position
    mov dh,24
    mov dl,37
    int 10h
    mov ah, 2
    mov dx, score 
    add dx,'0'
    int 21h


    mov ah,02h   ;set position
    mov dh,24
    mov dl,30
    int 10h
    mov ah, 9
    mov dx, offset static_score
    int 21h
    ret
print_score2 endp   
    
     
    
    ret
    reset_duck:
        mov duckx,245
        ret
    moveImage41 endp
    
    exit:
        
        

        mov ah,02h   ;set position
        mov dh,10
        mov dl,14
        int 10h
        mov ah, 9
        mov dx, offset game_over
        int 21h
 
        call loadImage6
        
        mov ah, 00h  
        int 16h 
         
        mov ah,04ch
        int 21h
    winner:
        mov ah,02h   ;set position
        mov dh,10
        mov dl,14
        int 10h
        mov ah, 9
        mov dx, offset game_winner
        int 21h
 

        mov ah, 00h  
        int 16h
        
        call loadImage6 
        mov ah,04ch
        int 21h 
        
    ret 
        
single endp
    
                      
main proc
    mov ax, @data
    mov ds, ax
    call loadImages
    call graphicMode
    mov num_rows, 40
    mov num_cols, 94
    mov position_x, 10
    mov position_y, 10
    mov si, offset imageBufferA
    call restorePosition
    call printImage 
    call name1
      
     mov position_x, 100
    mov position_y, 100
    
    L1:
 
        mov ah, 0
        int 16h 
        cmp al, 08
        je l2
        mov dl, al
        mov ah, 2
        int 21h
        jmp L1 
    
    
    l2:
    
        mov dl, 10       
        mov ah, 02h      
        int 21h

        mov dl, 13       
        mov ah, 02h      
        int 21h  
    
        mov ah, 9
                         

    ; Open, read, and display another image
    call loadImages2
    call graphicMode 
    
    mov position_x, 10
    mov position_y, 10 
    mov num_rows, 35
    mov num_cols, 122
    mov si, offset imageBufferB
    call restorePosition 
    call printImage  
                    
    call SOUND1
    
    call selectGameMode
        
        
   
                  
                  
   
               
   
main endp
end main