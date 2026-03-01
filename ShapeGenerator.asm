section .data
	menu db "Choose a shape:", 10, \
 		"1. Square", 10, \
		"2. Triangle", 10, \
		"3. Line", 10, \
		"4. Rectangle", 10, \
		"5. Circle", 10, \
		"0. quit", 10, \
		"Enter: ", 0
	menu_count equ $ - menu

	ask db "enter size: ", 0
	ask_count equ $ -ask

	invalid db "Invalid choice!",10, 0
	invalid_count equ $ - invalid

	block db 0xE2, 0x96, 0x88, 0		; character for drawing
	block_count equ $ - block

	character db "A", 0		; character for drawing
	character_count equ $ - character

	circle db "*", 0
	circle_count equ $ - circle

	space db " ", 0 	; character for spacing
	space_count equ $ - space

	underscore db "_", 0       ;character for drawing line
	underscore_count equ $ - underscore

	newline db 10, 0 	; character for printing on a new row
	newline_count equ $ - newline

section .bss
	menu_input resb 2
;---------------------------------------------------------------------------------
	size resb 10
	size1 resb 10
	size2 resb 10
	size3 resb 10
	size4 resb 10
	vertical_size resb 10
	count resb 10

section .text
	global _start

_start:

menu_loop:
;print the menu to the user
	call reg_newline
	call reg_newline

	mov eax, 4
	mov ebx, 1
	mov ecx, menu
	mov edx, menu_count
	int 0x80


;collect input from user
	mov eax, 3
	mov ebx, 0
	mov ecx, menu_input
	mov edx, 2
	int 0x80

	cmp byte [menu_input], '0'
	je exit

	cmp byte [menu_input], '1'
	je print_square

	cmp byte [menu_input], '2'
	je print_triangle

	cmp byte [menu_input], '3'
	je print_line

	cmp byte [menu_input], '4'
	je print_rectangle

	cmp byte [menu_input], '5'
	je print_circle

	jmp print_invalid

;------------------------------------------------------------------------------------
print_square:
	mov eax, 4
	mov ebx, 1
	mov ecx, ask
	mov edx, ask_count
	int 0x80

	mov eax, 3
	mov ebx, 0
	mov ecx, size
	mov edx, 10
	int 0x80

	call reg_newline

	mov al, [size]
	sub al, '0'

	mov [size3], al
	add al, al
	mov [size2], al
	mov byte [size4], al
	jmp square_loop
square_loop:
	cmp byte [size2], 1
	je newline_loop

	mov eax, 4
	mov ebx, 1
	mov ecx, block
	mov edx, block_count
	int 0x80

	sub byte [size2], 1
	jmp square_loop
newline_loop:
	cmp byte[size3], 1
	je menu_loop

	mov eax, 4
	mov ebx, 1
	mov ecx, newline
	mov edx, newline_count
	int 0x80

	mov al, [size4]
	mov [size2], al

	sub byte [size3], 1
	jmp square_loop
;------------------------------------------------------------------
print_triangle:
	mov eax, 4
	mov ebx, 1
	mov ecx, ask
	mov edx, ask_count
	int 0x80

	mov eax, 3
	mov ebx, 0
	mov ecx, size
	mov edx, 10
	int 0x80

	mov al, [size]
	sub al, '0'

	mov [size1], al
	mov byte [size3], al

	add byte al, al
	mov [size2], al

	mov byte [size4], 1
	mov byte [count], 1

	jmp triangle_space_loop

triangle_space_loop:
	mov al, [size3]
	mov bl, [size4]
	sub byte bl, 1
	cmp al, 1
	je print_char


	mov eax, 4
	mov ebx, 1
	mov ecx, space
	mov edx, space_count
	int 0x80


	sub byte [size3], 1
	jmp triangle_space_loop

print_char:
	cmp byte [size4], 0
	je print_newline_triangle

	mov eax, 4
	mov ebx, 1
	mov ecx, character
	mov edx, character_count
	int 0x80

	sub byte [size4], 1
	jmp print_char

print_newline_triangle:
	cmp byte [size1], 1
	je menu_loop

	mov eax, 4
	mov ebx, 1
	mov ecx, newline
	mov edx, newline_count
	int 0x80

	sub byte [size2], 1

	sub byte [size1], 1
	mov al, [size1]
	mov byte [size3], al


	add byte [count], 2
	mov al, [count]
	mov [size4], al

	jmp triangle_space_loop

;--------------------------------------------------------------------
print_line:
	mov eax, 4
	mov ebx, 1
	mov ecx, ask
	mov edx, ask_count
	int 0x80

	mov eax, 3
	mov ebx, 0
	mov ecx, size
	mov edx, 10
	int 0x80

	mov al, [size]
	sub al, '0'
	mov [size2], al
	add byte [size2], al
	add byte [size2], al

	jmp line_loop

line_loop:
	cmp byte [size2], 0
	je menu_loop

	mov eax, 4
	mov ebx, 1
	mov ecx, underscore
	mov edx, underscore_count
	int 0x80

	sub byte [size2], 1
	jmp line_loop

;--------------------------------------------------------------------
print_rectangle:

	mov eax, 4
	mov ebx, 1
	mov ecx, ask
	mov edx, ask_count
	int 0x80

	mov eax, 3
	mov ebx, 0
	mov ecx, size
	mov edx, 10
	int 0x80

	call reg_newline

	mov al, [size]
	sub al, '0'

	mov [size3], al
	add al, al
	add al,al
	mov [size2], al
	mov byte [size4], al
	jmp rectangle_loop
rectangle_loop:
	cmp byte [size2], 1
	je rec_newline_loop

	mov eax, 4
	mov ebx, 1
	mov ecx, block
	mov edx, block_count
	int 0x80

	sub byte [size2], 1
	jmp rectangle_loop
rec_newline_loop:
	cmp byte[size3], 1
	je menu_loop

	mov eax, 4
	mov ebx, 1
	mov ecx, newline
	mov edx, newline_count
	int 0x80

	mov al, [size4]
	mov [size2], al

	sub byte [size3], 1
	jmp rectangle_loop
;--------------------------------------------------------------------
print_circle:
	call reg_newline

	mov byte [size], 6
	mov al, [size]
	mov byte [size3], al
	add byte al, al
	mov byte [size1], al
	mov byte [size2], al

horizontal_component1:
	cmp byte [size1], 8
	je print_circle_char

	cmp byte [size1], 5
	je print_circle_char

	cmp byte [size1], 0
	je newline_circle

	mov eax, 4
	mov ebx, 1
	mov ecx, space
	mov edx, space_count
	int 0x80


	sub byte [size1], 1

	jmp horizontal_component1



horizontal_component2:
	cmp byte [size1], 11
	je print_circle_char

	cmp byte [size1], 2
	je print_circle_char

	cmp byte [size1], 0
	je newline_circle

	mov eax, 4
	mov ebx, 1
	mov ecx, space
	mov edx, space_count
	int 0x80


	sub byte [size1], 1

	jmp horizontal_component2



horizontal_component3:
	cmp byte [size1], 12
	je print_circle_char

	cmp byte [size1], 1
	je print_circle_char

	cmp byte [size1], 0
	je newline_circle

	mov eax, 4
	mov ebx, 1
	mov ecx, space
	mov edx, space_count
	int 0x80


	sub byte [size1], 1

	jmp horizontal_component3

print_circle_char:
	mov eax, 4
	mov ebx, 1
	mov ecx, circle
	mov edx, circle_count
	int 0x80

	sub byte [size1], 1

	jmp component_check

newline_circle:
	mov eax, 4
	mov ebx, 1
	mov ecx, newline
	mov edx, newline_count
	int 0x80

	sub byte [size3], 1

	mov byte al, [size2]
	mov byte [size1], al
	jmp component_check

component_check:
	cmp byte [size3], 6
	je horizontal_component1

	cmp byte [size3], 5
	je horizontal_component2

	cmp byte [size3], 4
	je horizontal_component3

	cmp byte [size3], 3
	je horizontal_component3

	cmp byte [size3], 2
	je horizontal_component2

	cmp byte [size3], 1
	je horizontal_component1

	cmp byte [size3], 0
	je menu_loop

	jmp menu_loop
;--------------------------------------------------------------------
reg_newline:
	mov eax, 4
	mov ebx, 1
	mov ecx, newline
	mov edx, newline_count
	int 0x80
	ret
;---------------------------------------------------------------------
print_invalid:
	mov eax, 4
	mov ebx, 1
	mov ecx, invalid
	mov edx, invalid_count
	int 0x80

	jmp menu_loop
;---------------------------------------------------------------------
print_space:
	mov eax, 4
	mov ebx, 1
	mov ecx, space
	mov edx, space_count
	int 0x80
	ret
;---------------------------------------------------------------------
exit:
	mov eax, 1
	mov ebx, 0
	int 0x80

