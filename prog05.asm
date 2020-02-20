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

;messages to be printed to the screen
progTitle		BYTE	"Generating, Sorting, and Counting Random Integers!", 0
authName		BYTE	"Written by Chelsea Marie Hicks", 0
instructions	BYTE	"WRITE THE INSTRUCTIONS HERE", 0

.code
main PROC

; (insert executable instructions here)

	exit	; exit to operating system
main ENDP

;additional procedures

;------------------------------------------------------------------------
; introduction   -NEEDS TO BE FINISHED
;
; Procedure introduces the program, programmer, and displays instructions
; Receives: none
; Returns: none
; Preconditions: none
; Registers changed: edx
;------------------------------------------------------------------------
introduction PROC USES edx
	mov		edx, OFFSET progTitle
	call	WriteString
	call	Crlf
	ret
introduction ENDP



END main
