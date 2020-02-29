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
ARRAYSIZE		EQU		200				;defines global constant size for array
COUNTSIZE		EQU		20				;defines global constant size for counts array
LO				EQU		10				;defines global constant lower limit for values
HI				EQU		29				;defines global constant upper limit for values

.data
array			DWORD	ARRAYSIZE	DUP(?)
countArray		DWORD	COUNTSIZE	DUP(?)

;messages to be printed to the screen
progTitle		BYTE	"Generating, Sorting, and Counting Random Integers!", 0
authName		BYTE	"Written by Chelsea Marie Hicks", 0
descrip1		BYTE	"This program generates 200 random integers in the range 10-29 and displays the unsorted list.", 0
descrip2		BYTE	"The list then gets sorted in ascending order and both the median value and sorted list are displayed.", 0
descrip3		BYTE	"Finally, the program determines and displays the number of instances of each value in the list.", 0

medianMsg		BYTE	"The median value of this array is ", 0
unsortedTitle	BYTE	"The unsorted list of randomly generated numbers is as follows...", 0
sortedTitle		BYTE	"The sorted list of randomly generated numbers is as follows...", 0

.code
main PROC
	call	Randomize					;initialize sequence for random values

;Introduce the program
	push	OFFSET progTitle			;pass strings by reference prior to proc call
	push	OFFSET authName
	call	introduction

;Print program description to the screen
	push	OFFSET descrip1
	push	OFFSET descrip2
	push	OFFSET descrip3
	call	description	

;Fill array with 200 random integers with values in the range of 10-29
	push	OFFSET array				;pass array by reference
	push	ARRAYSIZE					;pass global constants as values
	push	LO
	push	HI
	call	fillArray					

;Display the list of integers before sorting with 20 numbers per line and two spaces between each
	push	OFFSET array				;pass unsorted array by reference
	push	ARRAYSIZE					;pass size of array by value
	push	OFFSET unsortedTitle		;pass array title by reference
	call	displayList

;Sort the list of integers in ascending order (low to high) using ??? sort
	push	OFFSET array				;pass unsorted array by reference
	push	ARRAYSIZE					;pass size of array by value
	call	sortList

;Calculate and display median value, rounded to nearest integer
	push	OFFSET array				;pass sorted array by reference
	push	ARRAYSIZE					;pass size of array by value
	push	OFFSET medianMsg			;pass message to screen by reference
	call	displayMedian

;Display the list of integers after sorting with 20 numbers per line and two spaces between each
	push	OFFSET array				;pass sorted array by reference
	push	ARRAYSIZE					;pass size of array by value
	push	OFFSET sortedTitle			;pass array title by reference
	call	displayList

;Count and display the number of times each valuue appears in the list of integers
	push	OFFSET array				;pass sorted array by reference
	push	ARRAYSIZE					;pass size of array by value
	push	OFFSET countArray			;pass count array by reference
	push	LO							;pass Lo by value
	call	countList

;Print farewell message to the screen
	


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
introduction PROC
	push	ebp								;set up stack frame
	mov		ebp, esp
	mov		edx, [ebp+12]					;print title to screen
	call	WriteString
	call	Crlf	
	mov		edx, [ebp+8]					;print authName to screen
	call	WriteString
	call	Crlf
	call	Crlf
	pop		ebp
	ret		8
introduction ENDP

;------------------------------------------------------------------------
; description 
;
; Procedure prints the description of what the program will do
; Receives: addresses of parameters on system stack
; Returns: none
; Preconditions: none
; Registers changed: edx
; Post-conditions: none
;------------------------------------------------------------------------
description PROC
	push	ebp								;set up stack frame
	mov		ebp, esp
	mov		edx, [ebp+16]					;print description of program to screen
	call	WriteString
	call	Crlf
	mov		edx, [ebp+12]					
	call	WriteString
	call	Crlf
	mov		edx, [ebp+8]					
	call	WriteString
	call	Crlf
	call	Crlf
	pop		ebp
	ret		12
description ENDP

;------------------------------------------------------------------------
; fillArray 
;
; Procedure fills an array with random integers
; Receives: array (reference), LO (value), HI (value), ARRAYSIZE (value)
; Returns: none
; Preconditions: none
; Registers changed: eax, ecx, esi 
; Post-conditions: none
;------------------------------------------------------------------------
fillArray PROC 
	push	ebp								;set up stack frame
	mov		ebp, esp
	mov		esi, [ebp+20]					;first element in array
	mov		ecx, [ebp+16]					;ARRAYSIZE in loop counter
;loop to generate random number within range taken from Lecture 20 slides
generateNums:
	mov		eax, [ebp+8]					;HI val, 29
	;call WriteInt
	sub		eax, [ebp+12]					;29-10 = 19
	inc		eax								;20
	call	RandomRange						;eax in [0..20]
	add		eax, [ebp+12]					;eax in [10..29]
	mov		[esi], eax						;insert integer value in array element
	add		esi, 4							;next element in array
	loop	generateNums					;repeat until array is filled
	pop		ebp
	ret		16
fillArray ENDP

;------------------------------------------------------------------------
; sortList 
;
; Procedure to sort the array elements in ascending order
; Receives: array (reference) and ARRAYSIZE (value)
; Returns: none
; Preconditions: none
; Registers changed: eax, ecx
; Post-conditions: none
;------------------------------------------------------------------------
sortList PROC 
	push	ebp								;set up stack frame
	mov		ebp, esp
	mov		ecx, [ebp+8]					;ARRAYSIZE set as the counter
	dec		ecx
outerLoop:
	push	ecx								;save outer loop counter
	mov		esi, [ebp+12]					;first value in array
innerLoop:
	mov		eax, [esi]						;insert value in array
	cmp		[esi+4], eax					;compare contiguous values
	jg		nextElement						;if [esi+4] >= [esi], continue inner loop
	xchg	eax, [esi+4]					;swap vals if first[esi] is more than latter[esi+4]
	mov		[esi], eax					
nextElement:
	add		esi, 4							;point to next val in array
	loop	innerLoop						;continue to loop to compare next two vals

	pop		ecx
	loop	outerLoop

	pop		ebp
	ret		8
sortList ENDP

;------------------------------------------------------------------------
; displayMedian 
;
; Procedure calculates and displays the median of the sorted array 
; Receives: array (reference) and ARRAYSIZE (value)
; Returns: none
; Preconditions: array sorted in order
; Registers changed: eax, ebx, edx
; Post-conditions: none
;------------------------------------------------------------------------
displayMedian PROC 
	push	ebp								;set up stack frame
	mov		ebp, esp
	mov		esi, [ebp+16]					;array address
	mov		eax, [ebp+12]					;size of the array

	;determine whether array contains an even or odd number of elements by dividing by 2
	mov		edx, 0							;edx equal to zero before calculation, post-div will contain remainder
	mov		ebx, 2
	div		ebx								;divide size of array in eax by 2
	cmp		edx, 0							;if equal to zero, no remainder and array size is even
	je		middleAverage

;find the middle value if the number of elements is odd
middleValue:
	mov		ebx, 4							;retrieving memory address of middle element (ARRAYSIZE/2 * 4 (DWORD))
	mul		ebx
	add		esi, eax						;middle value address located at beginning + distance to middle
	mov		eax, [esi]						;place median value in eax to be printed to screen
	jmp		printMedian		

;find the average of the two middle elements when number of elements is even
middleAverage:
	dec		eax								;finding address of two middle elements
	mov		ebx, 4
	mul		ebx
	add		esi, eax						;middle left value located at beginning + distance to ((ARRAYSIZE/2) - 1 * 4(DWORD))
	mov		eax, [esi]						;place middle left value in eax to be used for finding avg of vals
	mov		ebx, [esi+4]					;place middle right value in ebx to be used for finding avg of vals
	add		eax, ebx						;find the sum of the two middle values and divide by 2
	mov		ebx, 2			
	mov		edx, 0
	div		ebx
	cmp		edx, 1							;check if there is a remainder from division
	jne		printMedian
	inc		eax

printMedian:
	mov		edx, OFFSET medianMsg			;print median to screen
	call	WriteString
	call	WriteDec
	mov		eax, "."
	call	WriteChar
	call	Crlf

	pop		ebp
	ret		12
displayMedian ENDP

;------------------------------------------------------------------------
; displayList 
;
; Procedure displays the contents of an array
; Receives: array (reference), ARRAYSIZE/COUNTSIZE (value), title (reference)
; Returns: none
; Preconditions: none
; Registers changed: eax, ebx, ecx, edx
; Post-conditions: none
;------------------------------------------------------------------------
displayList PROC 
	push	ebp								;set up stack frame
	mov		ebp, esp
	mov		edx, [ebp+8]					;print array title to screen
	call	WriteString
	call	Crlf
	mov		esi, [ebp+16]					;first element of the array
	mov		ecx, [ebp+12]					;loop counter containing ARRAYSIZE = 200
	mov		ebx, 0							;counter for elements printed on a line 

printValue:
	mov		eax, [esi]						;current value in array
	call	WriteDec						;print value to screen and two spaces
	mov		eax, "  "
	call	WriteChar
	call	WriteChar
	add		esi, 4							;move to next element in array
	inc		ebx								;increase counter for elements printed						
	cmp		ebx, 20							;check if 20 values printed and skip to next line if ebx=20
	jne		nextValue
	call	Crlf
	mov		ebx, 0							;reset counter for values printed

nextValue:
	loop	printValue

	call	Crlf
	pop		ebp
	ret		12
displayList	ENDP

;------------------------------------------------------------------------
; countList 
;
; Procedure counts and displays the number of times each value appears in the array 
; Receives: array (reference), ARRAYSIZE (value), countArray (reference), LO (value)
; Returns: none
; Preconditions: Para
; Registers changed: 
; Post-conditions: none
;------------------------------------------------------------------------
countList PROC 
	push	ebp								;set up stack frame
	mov		ebp, esp
	pop		ebp
	ret		16
countList ENDP

END main
