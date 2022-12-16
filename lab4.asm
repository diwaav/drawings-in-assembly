#######################################################################################
# Created by:  Ashwini Vittala, Diwa
#              dashwini
#              31 May 2021
# Assignment:  Lab 4: Functions and Graphics 
#              CSE 12/L
#              UC Santa Cruz, Spring 2021
# Description: You need to use this program with lab4_s21_test, and it draws out 
#              various designs using pixels 
########################################################################################
# Spring 2021 CSE12 Lab 4 Template
######################################################
# Macros made for you (you will need to use these)
######################################################

# Macro that stores the value in %reg on the stack 
#	and moves the stack pointer.
.macro push(%reg)
	subi $sp $sp 4
	sw %reg 0($sp)
.end_macro 

# Macro takes the value on the top of the stack and 
#	loads it into %reg then moves the stack pointer.
.macro pop(%reg)
	lw %reg 0($sp)
	addi $sp $sp 4	
.end_macro

#################################################
# Macros for you to fill in (you will need these)
#################################################

# Macro that takes as input coordinates in the format
#	(0x00XX00YY) and returns x and y separately.
# args: 
#	%input: register containing 0x00XX00YY
#	%x: register to store 0x000000XX in
#	%y: register to store 0x000000YY in
.macro getCoordinates(%input %x %y)
	# YOUR CODE HERE
	sll %y, %input, 16                      # logical left shift  0x00YY0000
	srl %y, %y, 16                          # logical right shift 0x000000YY and store into y
	srl %x, %input, 16                      # logical right shift 0x000000XX and store into x
.end_macro

# Macro that takes Coordinates in (%x,%y) where
#	%x = 0x000000XX and %y= 0x000000YY and
#	returns %output = (0x00XX00YY)
# args: 
#	%x: register containing 0x000000XX
#	%y: register containing 0x000000YY
#	%output: register to store 0x00XX00YY in
.macro formatCoordinates(%output %x %y)
	# YOUR CODE HERE
	sll %x. %x, 16                           # logical left shift a half word so its 0x00XX0000
	or %output, %x, %y                       # the output is 0x00XX0000 + 0x000000YY = 0x00XX00YY
.end_macro 

# Macro that converts pixel coordinate to address
# 	  output = origin + 4 * (x + 128 * y)
# 	where origin = 0xFFFF0000 is the memory address
# 	corresponding to the point (0, 0), i.e. the memory
# 	address storing the color of the the top left pixel.
# args: 
#	%x: register containing 0x000000XX
#	%y: register containing 0x000000YY
#	%output: register to store memory address in
.macro getPixelAddress(%output %x %y)
	# YOUR CODE HERE
	mul %output, %y, 128                      # 128 * y
	add %output, %x, %output                  # x + (128 * y)
	mul %output, %output, 4                   # 4 * (x + (128 * y))
	addi %output, %output, 0xFFFF0000         # origin + 4 * (x + 128 * y)
.end_macro


.text
# prevent this file from being run as main
li $v0 10 
syscall

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  Subroutines defined below
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#*****************************************************
# Clear_bitmap: Given a color, will fill the bitmap 
#	display with that color.
# -----------------------------------------------------
# Inputs:
#	$a0 = Color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
clear_bitmap: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	li $t3, 0
	li $t4, 0                                 # set x and y to (0,0) coordinate
	clrow: 
		getPixelAddress($t5, $t3, $t4)    # put the pixel address into t5
		sw $a0, 0($t5)                    # put color into pixel address
		addi $t3, $t3, 1                  # prep for next row
		ble $t3, 127, clrow               # if the row is not done, keep going
		nop
	li $t3, 0                                 # x coordinate reset
	addi $t4, $t4, 1                          # move to next row (or next y)
	ble $t4, 127, clrow                       # if we are not at last column, keep going
	nop
 	jr $ra
 	nop

#*****************************************************
# draw_pixel: Given a coordinate in $a0, sets corresponding 
#	value in memory to the color given by $a1
# -----------------------------------------------------
#	Inputs:
#		$a0 = coordinates of pixel in format (0x00XX00YY)
#		$a1 = color of pixel in format (0x00RRGGBB)
#	Outputs:
#		No register outputs
#*****************************************************
draw_pixel: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	getCoordinates($a0, $t0, $t1)             # pulls apart the output and gives you x and y in t0 and t1
	getPixelAddress($t2, $t0, $t1)            # finds the memory address we need to put color into
	sw $a1, 0($t2)                            # puts the color, a1, into the memory address in t2
	jr $ra
	nop
	
#*****************************************************
# get_pixel:
#  Given a coordinate, returns the color of that pixel	
#-----------------------------------------------------
#	Inputs:
#		$a0 = coordinates of pixel in format (0x00XX00YY)
#	Outputs:
#		Returns pixel color in $v0 in format (0x00RRGGBB)
#*****************************************************
get_pixel: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	getCoordinates($a0, $t0, $t1)             # pulls apart the output and gives you x and y in t0 and t1
	getPixelAddress($t2, $t0, $t1)            # finds the memory address we need to put color into
	lw $v0, 0($t2)                            # put pixel color in $v0
	jr $ra
	nop

#*****************************************************
# draw_horizontal_line: Draws a horizontal line
# ----------------------------------------------------
# Inputs:
#	$a0 = y-coordinate in format (0x000000YY)
#	$a1 = color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
draw_horizontal_line: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	li $t0, 0                                  # assume x=0 when we start
	row:
		getPixelAddress($t1, $t0, $a0)     # get the adress to put x and y into
		sw $a1, 0($t1)                     # put the color, a1, into the pixel address
		addi $t0, $t0, 1                   # next slot, so x = x+1 but y stays the same
		ble $t0, 127, row                  # if we arent done with the end of the row where x=127, then keep going
		nop
 	jr $ra
 	nop

#*****************************************************
# draw_vertical_line: Draws a vertical line
# ----------------------------------------------------
# Inputs:
#	$a0 = x-coordinate in format (0x000000XX)
#	$a1 = color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
draw_vertical_line: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	li $t0, 0                                  # assume y = 0 to start
	column:
		getPixelAddress($t1, $a0, $t0)     # get the address to put x and y into
		sw $a1, 0($t1)                     # put the color, a1, into the pixel address
		addi $t0, $t0, 1                   # next slot
		ble $t0, 127, column               # if we arent at the bottom of the column, keep going
		nop
 	jr $ra
 	nop


#*****************************************************
# draw_crosshair: Draws a horizontal and a vertical 
#	line of given color which intersect at given (x, y).
#	The pixel at (x, y) should be the same color before 
#	and after running this function.
# -----------------------------------------------------
# Inputs:
#	$a0 = (x, y) coords of intersection in format (0x00XX00YY)
#	$a1 = color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
draw_crosshair: nop
	
	# HINT: Store the pixel color at $a0 before drawing the horizontal and 
	# vertical lines, then afterwards, restore the color of the pixel at $a0 to 
	# give the appearance of the center being transparent.
	
	# Note: Remember to use push and pop in this function to save your t-registers
	# before calling any of the above subroutines.  Otherwise your t-registers 
	# may be overwritten.  
	
	# YOUR CODE HERE, only use t0-t7 registers (and a, v where appropriate)
	push($ra)                                # current spot
	
	getCoordinates($a0, $t5, $t6)            # x = $t5, y = $t6
	getPixelAddress($t0, $t5, $t6)           # $t0 = address for the pixel w/color

	lw $a0, 0($t0)                           # save the color
	
	push($a0)                                # push everything we are using into memory
	push($t0)
	push($t5)
	push($t6)
	move $a0, $t6                            # prep $a0 as the y value of intersection
	jal draw_horizontal_line                 # draw horizontal line
	nop
	pop($t6)                                 # pop everything we are using from memory
	pop($t5)
	pop($t0)
	pop($a0)
	
	push($a0)                                # push everything we are using into memory
	push($t0)
	push($t5)
	push($t6)
	move $a0, $t5                            # prep $a0 as the x value of intersection
	jal draw_vertical_line                   # draw vertical line
	nop
	pop($t6)                                 # pop everything we are using from memory
	pop($t5)
	pop($t0)
	pop($a0)
	
	sw $a0, 0($t0)                           # retores original color
	
	# HINT: at this point, $ra has changed (and you're likely stuck in an infinite loop). 
	# Add a pop before the below jump return (and push somewhere above) to fix this.
	
	pop($ra)                                 # restore current spot and exit
	jr $ra
	nop
