# Program to convert a roman numeral given by the user into standard "arabic" notation. The user
# is able to enter values until they input 0 (stops the program). If the user inputs an invaled
# roman numeral, than they will get an error and retype.
# Written by Josh P.


	.data
	.align	2
prompt:	.asciiz	"Enter a roman numeral (0 to exit)"
answr:	.asciiz	"Numerical value: "
endmsg:	.asciiz	"You entered 0. That was your last input."
badmsg:	.asciiz	"That is not a roman numeral. Enter a real roman numeral."
input:	.space	20

	.text
	.globl	main

main:


# Start of the loop
loop:


# Prompting the user to enter a roman numeral
	la	$a0, prompt
	la	$a1, input
	la	$a2, 17 		# 15 characters is the longest roman numeral
	li	$v0, 54
	syscall
	
	
# Need to check for user entering 0 (then exit loop)
	la	$a1, input		# a1 = input string
	lb	$t1, 0($a1)		# t1 = first value of input
	li	$t2, 48			# t2 = 48 (decimal value for "0" is 48)
	beq	$t1, $t2, fini		# if (userInput == 0)
	
	
# Finding the length of the string
	li	$s5, 0			# s5: size = 0
length:	
	add	$s1, $a1, $s5		# s1 = the input at character i
	lb	$t1, 0($s1)		# t2 = character i of input
	beq	$t1, $0, lenFound	# if (s4 == null)
	addi	$s5, $s5, 1		# s5: size = size + 1
	j	length
	
	
# Finding the numerical value correlated with the roman numeral.
# Starts at the ith number and works way to the start.
lenFound:
	li	$s0, 0			# s0: conversionCount = 0
	li	$s2, 0			# s2: characterCount = 0
	addi	$s5, $s5, -1		# s5: size = size - 1 (for hex value a0)
	
	# setting parameters for error function
	la	$a0, input
	move	$a1, $s5
	jal	errorChecking
	
	# checking to see if the roman numeral has an error
	li	$t1, -1
	beq	$v0, $t1, badInput
	
	# setting parameters for conversion function
	la	$a0, input
	move	$a1, $s5
	jal	conversionFunct
	
	# moving return value from function
	move	$s0, $v0
	
	# Check if the value is -1 (user entered false roman numeral)
	li	$t4, -1
	beq	$s0, $t4, badInput
	j	done

# syscall for an incorrect input
badInput:
	la	$a0, badmsg
	li	$a1, 2
	li	$v0, 55
	syscall
	
# End of loop for bad input
	j	loop
	
	
done:
# Display the results from conversion
	move	$a1, $s0
	la	$a0, answr
	li	$v0, 56
	syscall


# End of the loop
	j	loop


# End messege when the user enters 0
fini:
	la	$a0, endmsg
	li	$a1, 1
	li	$v0, 55
	syscall
	
	
# TTFN
	li	$v0, 10
	syscall




# Function to compute the coversion from a roman numeral to standard notation.
# The function will either return the correct number or a number indicating that the user
# did not enter a roman numeral.
# Parameters: a0 - input(roman numeral) a1 - input count
# Return: v0 - standard notation number
conversionFunct:
	
	# function preamble
	addi	$sp, $sp, -24
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	sw	$s3, 16($sp)
	sw	$s4, 20($sp)
	
	move 	$s3, $a1		# moving parameter of input
	
# Loop for the function
findNumVal:
	add	$s1, $a0, $s2		# s1: the input character at i
	add	$s4, $s1, 1		# s4: the input character at i+1 (for prefix)
	lb	$t2, 0($s1)		# t2: character i of input
	lb	$t3, 0($s4)		# t3: character i+1 to check for prefix
	
	
	# conversion for C (decimal value of 67)
	li	$t1, 67	
	beq	$t1, $t2, conversion100
	
	# conversion for D (decimal value of 68)
	li	$t1, 68
	beq	$t1, $t2, conversion500
	
	# conversion for I (decimal value of 73)
	li	$t1, 73
	beq	$t1, $t2, conversion1
	
	# conversion for L (decimal value of 76)
	li	$t1, 76
	beq	$t1, $t2, conversion50
	
	# conversion for M (decimal value of 77)
	li	$t1, 77
	beq	$t1, $t2, conversion1000
	
	# conversion for V (decimal value of 86)
	li	$t1, 86
	beq	$t1, $t2, conversion5
	
	# conversion for X (decimal value of 88)
	li	$t1, 88
	beq	$t1, $t2, conversion10
	
	# conversion for c (decimal value of 99)
	li	$t1, 99
	beq	$t1, $t2, conversion100
	
	# conversion for d (decimal value of 100)
	li	$t1, 100
	beq	$t1, $t2, conversion500
	
	# conversion for i (decimal value of 105)
	li	$t1, 105
	beq	$t1, $t2, conversion1
	
	# conversion for l (decimal value of 108)
	li	$t1, 108
	beq	$t1, $t2, conversion50
	
	# conversion for m (decimal value of 109)
	li	$t1, 109
	beq	$t1, $t2, conversion1000
	
	# conversion for v (decimal value of 118)
	li	$t1, 118
	beq	$t1, $t2, conversion5
	
	# conversion for x (decimal value of 120)
	li	$t1, 120
	beq	$t1, $t2, conversion10
	
	# should happen when all variables are gone through
	j	functDone
	
	
# The conversions and addition for the roman numerals to normal numbers
# Conversion from M (or m) to 1000
conversion1000:
	addi 	$s0, $s0, 1000
	addi	$s2, $s2, 1
	j	findNumVal

		
# Conversion from D (or d) to 500
conversion500:
	addi	$s0, $s0, 500
	addi	$s2, $s2, 1
	j	findNumVal


# Conversion from C (or c) to 100
conversion100:
	# Check for prefix M (or m)
	li	$t1, 77			
	beq	$t3, $t1, prefix100
	
	li	$t1, 109
	beq	$t3, $t1, prefix100
	
	# check for prefix D (or d)
	li	$t1, 68
	beq	$t3, $t1, prefix100
	
	li	$t1, 100
	beq	$t3, $t1, prefix100
	
	# no prefix, than do this
	addi	$s0, $s0, 100
	addi	$s2, $s2, 1
	j	findNumVal

# Prefix handler for C (or c)
prefix100:
	addi	$s0, $s0, -100
	addi 	$s2, $s2, 1
	j	findNumVal
	
	
# Conversion from L (or l) to 50
conversion50:
	addi	$s0, $s0, 50
	addi	$s2, $s2, 1
	j	findNumVal


# Conversion from X (or x) to 10
conversion10:
	# check for prefix C (or c)
	li	$t1, 67
	beq	$t3, $t1, prefix10
	
	li	$t1, 99
	beq	$t3, $t1, prefix10
	
	# check for prefix L (or l)
	li	$t1, 76
	beq	$t3, $t1, prefix10
	
	li	$t1, 108
	beq	$t3, $t1, prefix10
	
	# no prefix, than do this
	addi	$s0, $s0, 10
	addi	$s2, $s2, 1
	j	findNumVal
	
# Prefix handler for X (or x)
prefix10:
	addi	$s0, $s0, -10
	addi	$s2, $s2, 1
	j	findNumVal
	

# Conversion from V (or v) to 5
conversion5:
	addi	$s0, $s0, 5
	addi	$s2, $s2, 1
	j	findNumVal


# Conversion from I (or i) to 1
conversion1:
	# Check for prefix X (or x)
	li	$t1, 88
	beq	$t3, $t1, prefix1
	
	li	$t1, 120
	beq	$t3, $t1, prefix1
	
	# Check for prefix V (or v)
	li	$t1, 86
	beq	$t3, $t1, prefix1
	
	li	$t1, 118
	beq	$t3, $t1, prefix1
	
	# if no prefix, than do this
	addi	$s0, $s0, 1
	addi	$s2, $s2, 1
	j	findNumVal

# Prefix handler for I (or i)
prefix1:
	addi	$s0, $s0, -1
	addi	$s2, $s2, 1
	j	findNumVal


functDone:
	# Check to see if user entered any non-roman numeral characters
	beq	$s2, $s3, goodInput		# if (characterCount == size)
	li	$v0, -1				# if false, sets return to -1 (indicates bad input)
	j	epilogue


# Jumps to here for a good input
goodInput:
	move	$v0, $s0			# putting total into return value
	
	
epilogue:
	# function epilogue
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	lw	$s4, 20($sp)
	addi	$sp, $sp, 24
	jr	$ra


# Function that goes through a roman numeral and checks for any errors. As of now,
# it does not check for all cases but it works for most. If the roman numeral has an
# error, the function will return with -1. If theres no error, the function returns 0.
# Parameters: a0 - input (roman numeral), a1 - input count
# Return: v0 - error or no error (-1 or 0
errorChecking:

	# funcrion preamble
	addi	$sp, $sp, -36
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	sw	$s3, 16($sp)
	sw	$s4, 20($sp)
	sw	$s5, 24($sp)
	sw	$s6, 28($sp)
	sw	$s7, 32($sp)	
	
	# set up count values for each letter
	li	$s5, 0			# s5: countM = 0
	li	$s6, 0			# s6: countD = 0
	li	$s7, 0			# s7: countC = 0
	li	$t4, 0			# t4: countL = 0
	li	$t5, 0			# t5: countX = 0
	li	$t6, 0			# t6: countV = 0
	li	$t7, 0			# t7: countI = 0
	
inputLoop:
	add	$s0, $a0, $s2		# s1: the input character at i
	add	$s1, $s0, 1		# s4: the input character at i+1 (for prefix)
	lb	$t2, 0($s0)		# t2: character i of input
	lb	$t3, 0($s1)		# t3: character i+1 to check for prefix
	li	$s3, 0			# s3: return value = 0
	move	$s4, $a1		# parameters
	
	
	# Send to checkI if current character is I or i
	li	$t1, 73
	beq	$t1, $t2, checkI
	
	li	$t1, 105
	beq	$t1, $t2, checkI
	
	# Send to checkV if current character is V or v
	li	$t1, 86
	beq	$t1, $t2, checkV
	
	li	$t1, 118
	beq	$t1, $t2, checkV
	
	# Send to checkX if current character is X or x
	li	$t1, 88
	beq	$t1, $t2, checkX
	
	li	$t1, 120
	beq	$t1, $t2, checkX
	
	# Send to checkL if current character is L or l
	li	$t1, 76
	beq	$t1, $t2, checkL
	
	li	$t1, 108
	beq	$t1, $t2, checkL
	
	# Send to checkC if current character is C or c
	li	$t1, 67
	beq	$t2, $t1, checkC
	
	li	$t1, 99
	beq	$t2, $t1, checkC
	
	# Send to checkD if current character is D or d
	li	$t1, 68
	beq	$t1, $t2, checkD
	
	li	$t1, 100
	beq	$t1, $t2, checkD
	
	# Send to checkM if current character is M or m
	li	$t1, 77			
	beq	$t2, $t1, checkM
	
	li	$t1, 109
	beq	$t2, $t1, checkM
	
	# Check if s2 (character count) and the size are the same
	beq	$s2, $s4, errorDone
	
	addi	$s2, $s2, 1
	j	inputLoop
	
	
# Checking errors with I (or i)
checkI:
	# if an I appears before an M
	li	$t1, 77
	beq	$t1, $t3, error
	
	li	$t1, 109
	beq	$t1, $t3, error
	
	# if an I appears before an D
	li	$t1, 68
	beq	$t1, $t3, error
	
	li	$t1, 100
	beq	$t1, $t3, error
	
	# if an I appears before an C
	li	$t1, 67
	beq	$t1, $t3, error
	
	li	$t1, 99
	beq	$t1, $t3, error
	
	# if an I appears before an L
	li	$t1, 76
	beq	$t1, $t3, error
	
	li	$t1, 108
	beq	$t1, $t3, error
	
	# check if there are too many I's
	li	$t1, 4
	bge	$t7, $t1, error
	
	# all is good, add to counter
	addi	$s2, $s2, 1
	j	inputLoop
	
	
# Checking errors with V (or v)
checkV:
	# if an V appears before an M
	li	$t1, 77
	beq	$t1, $t3, error
	
	li	$t1, 109
	beq	$t1, $t3, error
	
	# if an V appears before an D
	li	$t1, 68
	beq	$t1, $t3, error
	
	li	$t1, 100
	beq	$t1, $t3, error
	
	# if an V appears before an C
	li	$t1, 67
	beq	$t1, $t3, error
	
	li	$t1, 99
	beq	$t1, $t3, error
	
	# if an V appears before an L
	li	$t1, 76
	beq	$t1, $t3, error
	
	li	$t1, 108
	beq	$t1, $t3, error
	
	# if an V appears before an X
	li	$t1, 88
	beq	$t1, $t3, error
	
	li	$t1, 120
	beq	$t1, $t3, error
	
	# if an V appears before an V
	li	$t1, 86
	beq	$t1, $t3, error
	
	li	$t1, 118
	beq	$t1, $t3, error
	
	# check if there are too many V's
	addi	$t6, $t6, 1
	li	$t1, 2
	bge	$t6, $t1, error
	
	# all is good, add to counter
	addi	$s2, $s2, 1
	j	inputLoop


# Checking errors with X (or x)	
checkX:
	# if an X appears before an M
	li	$t1, 77
	beq	$t1, $t3, error
	
	li	$t1, 109
	beq	$t1, $t3, error
	
	# if an X appears before a D
	li	$t1, 68
	beq	$t1, $t3, error
	
	li	$t1, 100
	beq	$t1, $t3, error
	
	# check if there are too many I's
	addi	$t5, $t5, 1
	li	$t1, 5
	bge	$t5, $t1, error
	
	# all is good, add to counter
	addi	$s2, $s2, 1
	j	inputLoop


# Checking errors with L (or l)
checkL:
	# if an L appears before a M
	li	$t1, 77
	beq	$t1, $t3, error
	
	li	$t1, 109
	beq	$t1, $t3, error
	
	# if an L appears before a D
	li	$t1, 68
	beq	$t1, $t3, error
	
	li	$t1, 100
	beq	$t1, $t3, error
	
	# if an L appears before a C
	li	$t1, 76
	beq	$t1, $t3, error
	
	li	$t1, 108
	beq	$t1, $t3, error
	
	# if an L appears before an L
	li	$t1, 76
	beq	$t1, $t3, error
	
	li	$t1, 108
	beq	$t1, $t3, error
	
	# check if there are too many L's
	addi	$t4, $t4, 1
	li	$t4, 2
	bge	$t4, $t1, error
	
	# all is good, add to counter
	addi	$s2, $s2, 1
	j	inputLoop
	
	
# Checking errors with C (or c)
checkC:
	# check if there are too many I's
	li	$t1, 5
	bge	$s7, $t1, error
	
	# all is good, add to counter
	addi	$s2, $s2, 1
	j	inputLoop

	
# Checking errors with D (or d)
checkD:
	# if a D appears before an M
	li	$t1, 77
	beq	$t1, $t3, error
	
	li	$t1, 109
	beq	$t1, $t3, error
	
	# if a D appears before a D
	li	$t1, 68
	beq	$t1, $t3, error
	
	li	$t1, 100
	beq	$t1, $t3, error
	
	# check if there are too many D's
	addi	$s6, $s6, 1
	li	$t1, 2
	bge	$s6, $t1, error
	
	# all is good, add to counter
	addi	$s2, $s2, 1
	j	inputLoop
	
# Checking errors with M (or m)
checkM:
	# check if there are too many I's
	addi	$s5, $s5, 1
	li	$t1, 5
	bge	$s5, $t1, error
	
	# all is good, add to counter
	addi	$s2, $s2, 1
	j	inputLoop
	

# If an error appears, make return value -1
error:
	li	$s3, -1

		
errorDone:
	move	$v0, $s3
	
	# function epilogue
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	lw	$s4, 20($sp)
	lw	$s5, 24($sp)
	lw	$s6, 28($sp)
	lw	$s7, 32($sp)
	addi	$sp, $sp, 36
	jr	$ra
