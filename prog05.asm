TITLE Programming Assignment #5     (prog05.asm)

; Author: Chelsea Marie Hicks
; OSU email address: hicksche@oregonstate.edu
; Course number/section: CS271-400
; Project Number: Program #5      Due Date: Sunday, March 1 by 11:59 PM
;
; Description: Program generates 200 random integers in the range of [10...29], 
;		stores them in an array, and displays the list of values to the screen
;		with 20 integers per line. The program continues with sorting the list
;		in ascending order, calculating and displaying the median value, and 
;		displaying the sorted list of values. A second array is used to keep 
;		track of the number of times each value between 10-29 appears in the
;		randomly generated list. This count array also gets displayed to the
;		screen.

INCLUDE Irvine32.inc
ARRAYSIZE		EQU		200				;defines constant size for array
LO				EQU		10				;defines lower limit for array vals = 10
HI				EQU		29				;defines upper limit for array vals = 29

.data
array			DWORD	ARRAYSIZE	DUP(?)

;messages to be printed to the screen
progTitle		BYTE	"Generating, Sorting, and Counting Random Integers!", 0
authName		BYTE	"Written by Chelsea Marie Hicks", 0
instructions	BYTE	"This program generates 200 random integers in the range "
				BYTE	"[10...29], displays the original list, sorts the list, ", 0dh, 0ah
				BYTE	"displays the median value, displays the list in sorted "
				BYTE	"ascending order, then displays the number of instances ",  0dh, 0ah
				BYTE	"of each generated value.", 0

.code
main PROC
	call	Randomize					;initialize sequence for random values

;Introduce the program
	push	OFFSET progTitle			;pass strings by reference prior to proc call
	push	OFFSET authName
	push	OFFSET instructions
	call	introduction

;Fill array with 200 random integers with values in the range of 10-29
	push	OFFSET array				;pass array by reference
	push	ARRAYSIZE					;pass global constants as values
	push	LO
	push	HI
	call	fillArray					


	exit	; exit to operating system
main ENDP

;additional procedures for program below

;------------------------------------------------------------------------
; introduction 
;
; Procedure introduces the program, programmer, and displays instructions
; Receives: addresses of parameters on system stack
; Returns: none
; Preconditions: none
; Registers changed: edx
; Post-conditions: none
;------------------------------------------------------------------------
introduction PROC USES edx
	push	ebp								;set up stack frame
	mov		ebp, esp
	mov		edx, [ebp + 20]					;print title to screen
	call	WriteString
	call	Crlf	
	mov		edx, [ebp + 16]					;print authName to screen
	call	WriteString
	call	Crlf
	call	Crlf
	mov		edx, [ebp + 12]					;print instructions to screen
	call	WriteString
	call	Crlf
	pop		ebp
	ret		16
introduction ENDP

;------------------------------------------------------------------------
; fillArray 
;
; Procedure fills an array with random integers
; Receives: array (reference), LO (value), HI (value), ARRAYSIZE (value)
; Returns: none
; Preconditions: none
; Registers changed: eax, ecx, edi 
; Post-conditions: none
;------------------------------------------------------------------------
fillArray PROC USES eax ecx
	push	ebp								;set up stack frame
	mov		ebp, esp
	mov		ecx, [ebp + 20]					;ARRAYSIZE in loop counter
	mov		edi, [ebp + 24]					;first element in array
;loop to generate random number within range taken from Lecture 20 slides
generateNums:
	mov		eax, [ebp + 12]					;HI val, 29
	call	WriteInt
	sub		eax, [ebp + 16]					;29-10 = 19
	inc		eax								;14
	call	RandomRange						;eax in [0..14]
	add		eax, [ebp + 12]					;eax in [10..29]
	mov		[edi], eax						;insert integer value in array element
	add		edi, 4							;next element in array
	loop	generateNums					;repeat until array is filled
	pop		ebp
	ret		20
fillArray ENDP

;------------------------------------------------------------------------
; sortList 
;
; 
; Receives: 
; Returns: 
; Preconditions: 
; Registers changed: 
; Post-conditions: 
;------------------------------------------------------------------------
sortList PROC 

	ret
sortList ENDP

;------------------------------------------------------------------------
; displayMedian 
;
; 
; Receives: 
; Returns: 
; Preconditions: 
; Registers changed: 
; Post-conditions: 
;------------------------------------------------------------------------
displayMedian PROC 

	ret
displayMedian ENDP

;------------------------------------------------------------------------
; displayList 
;
; 
; Receives: 
; Returns: 
; Preconditions: 
; Registers changed: 
; Post-conditions: 
;------------------------------------------------------------------------
displayList PROC 

	ret
displayList	ENDP

;------------------------------------------------------------------------
; countList 
;
; 
; Receives: 
; Returns: 
; Preconditions: 
; Registers changed: 
; Post-conditions: 
;------------------------------------------------------------------------
countList PROC 

	ret
countList ENDP

END main
