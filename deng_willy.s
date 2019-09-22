/*

Purpose: A recursive program to see if the string is a palindrome

*/

//Write an ARM program that recursively checks whether a string is a palindrome.
//Take the string as input, and output true or false. The code must be recursive.

.data
hello_input_string:     .asciz "Input a string: "
newline:                .asciz "\n"

true:                   .asciz "true"
false:                  .asciz "false"

string_specifier:       .asciz "%[^\n]"	// Input is of format string
string_input_buffer:	.space 256

// For testing code outputs
output_specifier:       .asciz "%s \n"

.text
.global main

main:
    ldr x0, =hello_input_string
    bl printf

    ldr x0, =string_specifier
    ldr x1, =string_input_buffer
    bl scanf

    // Save the input buffers into register for continued use
    ldr x19, =string_input_buffer

    // Create counter to traverse the string and remove all blank spaces / special characters
    mov x20, #0
    mov x26, #0
    mov x25, x19

    // First make sure to remove all spaces
    bl remove_space

    // TEST removed special characters and blank spaces
    /*
	mov x1, x19
	ldr x0, =output_specifier
	bl printf
	*/
	// TEST removed special characters and blank spaces

    // Reset the counter
    mov x20, #0

    // Then traverse and change to lower case
    bl string_traverse

	// TEST that all upper case are lower case
	/*
	mov x1, x19
	ldr x0, =output_specifier
	bl printf
	*/
	// TEST that all upper case are lower case

    // Return from branch link and then check for midpoint
    mov x22, #0

    // Copy length of string into saved
    mov x23, x20
    bl midpoint_checker

	// Return from branch link and then setup arguments for palindrome check
    sub x0, x23, #1
    mov x1, x19
    mov x2, #0
    mov x3, x22
    mov x4, x1
    bl palindrome

    // Return from branch link and flush
    ldr x0, =newline
    bl printf

    // Exit program
    b exit

// Subroutine to replace all upper with lower case and to get the count of the string
string_traverse:
    // x19 holds the address of the start of string
    // x20 holds the counter and serves as the offset for the character
    ldrb w2, [x19, x20]

    // If the loaded character is 0 (ASCII value of null char), then exit
    cbz w2, loop_exit

    // Else check replacements
    cmp w2, #'A'
    beq to_lower

    cmp w2, #'B'
    beq to_lower

    cmp w2, #'C'
    beq to_lower

    cmp w2, #'D'
    beq to_lower

    cmp w2, #'E'
    beq to_lower

    cmp w2, #'F'
    beq to_lower

    cmp w2, #'G'
    beq to_lower

    cmp w2, #'H'
    beq to_lower

    cmp w2, #'I'
    beq to_lower

    cmp w2, #'J'
    beq to_lower

    cmp w2, #'K'
    beq to_lower

    cmp w2, #'L'
    beq to_lower

    cmp w2, #'M'
    beq to_lower

    cmp w2, #'N'
    beq to_lower

    cmp w2, #'O'
    beq to_lower

    cmp w2, #'P'
    beq to_lower

    cmp w2, #'Q'
    beq to_lower

    cmp w2, #'R'
    beq to_lower

    cmp w2, #'S'
    beq to_lower

    cmp w2, #'T'
    beq to_lower

    cmp w2, #'U'
    beq to_lower

    cmp w2, #'V'
    beq to_lower

    cmp w2, #'W'
    beq to_lower

    cmp w2, #'X'
    beq to_lower

    cmp w2, #'Y'
    beq to_lower

    cmp w2, #'Z'
    beq to_lower

    // Increment the counter and loop back
    add x20, x20, #1
    b string_traverse

    // Exit
    loop_exit:
    // br x30 will take us back the instruction after bl string_traverse
    br x30

// Subroutine that makes all upper case characters lower case
to_lower:
    // Add 32 from each upper case ASCII to get lower case
    add w21, w2, #32
    strb w21, [x19, x20]
    strb w21, [x25, x20]

    // Increment counter and loop back
    add x20, x20, #1
    b string_traverse

// Subroutine that removes whitespace
remove_space:

	// Load in oringinal string and then read byte by byte
	ldrb w2, [x19, x20]
	add x20, x20, #1

    // If the loaded character is 0 (ASCII value of null char), then exit
    cbz w2, remove_space_loop_exit

	// Check if the byte is an blank space or anything with ASCII value lower
	cmp w2, #47
	blt remove_space

	// Exclusive check for ':' character
	cmp w2, #58
	beq remove_space

	// Exclusive check for ';' character
	cmp w2, #59
	beq remove_space

	// Exclusive check for '?' character
	cmp w2, #63
	beq remove_space

	// Store the btye if it isn't a blank space and increment characters
	strb w2, [x19, x26]
	add x26, x26, #1
	b remove_space

// Exit remove space loop
remove_space_loop_exit:

   // Insert a null character to signify the end of the string and store it
    mov w2, #0
    strb w2, [x19, x26]

    // br x30 will take us back the instruction after bl remove_space
    br x30

// Check if string is palindrome subroutine
palindrome:
    // x0 is length-1
    // x1 holds the address of the start of string (left ptr) (w5)
    // x2 is the index
    // x3 is the midpoint
	// x4 is the copy of x1 address (right ptr) (w6)

    //Setup access to string array w5 = stringarray[x2] and w6 = stringarray[x0]
    ldrb w5, [x1, x2]
    ldrb w6, [x4, x0]

    // Checks to see if length - 1 and index are equal
    cmp x0, x2
    beq is_palindrome

    // Checks to see if stringarray[x2] == stringarray[x0]
    cmp w5, w6
    beq palindrome_recurse

    // If not equal go to not_palindrome

not_palindrome:
	// Reached the end
	// Store address and link register and go to end_recurse
    ldr x0, =false
    stp x30, x1, [sp, #-16]!
   	bl printf

   	// Returns back to bl palindrome
    ldp x30, x1, [sp], #16
   	br x30

is_palindrome:
	// Reached the end
	// Store address and link register and clear off each recursive stack
    ldr x0, =true
    stp x30, x1, [sp, #-16]!
    bl printf

    // Returns back to bl palindrome
    ldp x30, x1, [sp], #16
    br x30

palindrome_recurse:
    // Store frame pointer (x29), link register (x30), length-1 (x0), address of string start (x1), index count (x2), midpoint (x3), copy string address (x4)
    sub sp, sp, #16
    str x29, [sp, #0]
    str x30, [sp, #8]

    // Move frame pointer
    add x29, sp, #8

    // Make room for index on stack, along with other variables
    sub sp, sp, #64

    // Store it with respect to frame pointer
    str x2, [x29, #-16]
    str x0, [x29, #-16]
    str x3, [x29, #-16]
    str x4, [x29, #-16]

	// If it has reached the midpoint stop
    cmp x2, x3
    beq is_palindrome

	// Increment x2 and decrement x0
    add x2, x2, #1
    sub x0, x0, #1

    // Branch and link to original function
    bl palindrome

// Subroutine to clear off each recursive stack
end_recurse:
    // Clear off stack space used to hold index and other variables
    add sp, sp, #64

    // Load the frame pointer and link register
    ldr x29, [sp, #0]
    ldr x30, [sp, #8]

    // Clear off stack space used to hold frame pointer and link register
    add sp, sp, #16

    // Return back to main
    br x30

// Subroutine to find the mindpoint index used for odd and even length strings
midpoint_checker:
    // length - 2
    sub x20, x20, #2

    // Increment count until midpoint
    add x22, x22, #1

    // If length > 2, loop
    cmp x20, #2
    bgt midpoint_checker

    // otherwise return
    br x30

exit:
    mov x0, #0
    mov x8, #93
    svc #0
