Diwa Ashwini Vittala
dashwini
CSE 12 Spring 2021
Lab 4: Functions and Graphs

DESCRIPTION
In this lab, a file called lab4.asm can be use jointly with another file (in MARS) to create various 
visual designs such as horizontal lines, vertical lines, cross hairs with the intersection 
point as the same color as it was before, and drawing pixels individually. 
In this lab, I learned how to use Bitmap display and work with pixels. I also learned how the "push"
and "pop" works with memory to similate stacks. I also learned the defference between a subroutine 
and macro and how to use each one/ refrence it in other parts of the code.

FILES
All files in directory CSE_12/dashwini/Lab4 (except this one)
lab4.asm - This file must be opened using MARS. It contains all the subroutines and 
	macros I created for the lab, like drawing horizontal/vertial/cross hair lines,
	manipulating pixels/coordingates, etc.
lab4_s21_test.asm - This file links to the lab4.asm and contains the colors and the instructions 
	to print a certain type of design in bitmap display.

INSTRUCTIONS
To start, open MARS and open the "lab4.asm" and "lab4_s21_test.asm" file.
In the test file (lab4_s21_test.asm), we will first need to set up the bitmap display:
1. Go to tools > bitmap display
2. Change the setting to match the following:
   Unit Width in Pixels: 4
   Unit Height in Pixels: 4
   Display Width in Pixels: 512
   Display Width in Pixels: 512
   Base Address for display: 0xffff0000 (memory map)
3. Connect to MIPS
Then, hit assemble > clear in "Mars Messages" > run
This should display lines and colors in the same pattern as discriped in the test file.
