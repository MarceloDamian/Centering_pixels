.data
frameBuffer: .space 0x80000 # 512 wide X 256 high pixels
m: .word 25   # sample outer square length 
n: .word 91   # sample inner square length 
c1r: .word 0x00000000 # sample color for the inner square 
c1g: .word 0x00000000 # sample color for the inner square 
c1b: .word 0x000000ff # sample color for the inner square 
c2r: .word 0x00000000 # sample color for the inner square 
c2g: .word 0x0000ff00 # sample color for the inner square 
c2b: .word 0x000000ff # sample color for the inner square 

newline: .asciiz  "\n" # prints endline
onepixel: .word 4      # a pixel is 4 bytes 
pixelbyrow: .word 2048 # 512 pixels times 4 = 2048. 

.text

    addi $t0, $t0, 0  # saves initalizer $t0 as 0 
  
    addi $t1, $zero, 139264  # 139264= 256 (512) + 2048(4) max bytes for yellow rectangle
    
    lw $s6,onepixel($zero) # loads s6 register with 4. 
    lw $s7, m($zero)  # Sets s7 = m or inner square length

createbackground:
  
    # Creates yellow rectangular background
    li $t2, 0x00ffff00      # This loads the immediate Yellow into the t2 register
    add $gp, $gp, $s6        # Increments global pointer register by a word (4 bytes) 
    	
    # adds 1 to temporary value each recursive call // Counter
    addi $t0, $t0, 1                               
    bne $t1, $t0, makeyellowbit     #  If it hasnt mapped through all the bytes then branch until it does.
      
    j drawinnersquare # jumps to this once yellow bit screen is finished
    
makeyellowbit:
    sw $t2, ($gp)           # Stores new t2 into global pointer
    j createbackground	    # Jumps back to createbackground.


drawinnersquare:

addi $t0, $zero, 0   # clears t0 register
addi $t1, $zero, 0   # clears t1 register 
addi $t2, $zero, 0   # clears t2 register
addi $t3, $zero, 0   # clears t3 register
addi $t4, $zero, 0   # clears t4 register 
addi $t5, $zero, 0   # clears t5 register 
addi $t6, $zero, 0   # clears t6 register 

lw $s0 ,pixelbyrow($zero) # s0 = 2048
lw $s1, n($zero) # s1= n

mul $t0, $s1, $s6 # t0 = n times 4
mul $t1, $s7 $s6 # t1 = m times 4

sub $t2, $t0, $t1 # difference between both square lengths = ( n(4) - m(4) ) 

addi $t3, $zero, 2 # t3 = 2

div $t2, $t3 #  ( n(4) - m(4) ) / 2
 
mflo $t4  # quotient of ( n(4) - m(4) ) / 2

div $t4, $s6   # divide  (( n(4) - m(4) ) / 2 ) /  4

mfhi $t5       # remainder of divide (( n(4) - m(4) ) / 2 ) /  4

seq $t5, $t5, 0  #  is (( n(4) - m(4) ) / 2 ) /  4 == to 0 . If true then 1, if false then 0

beq $t5, $zero, hardexit # if previous was false then terminate program. if not then proceed to next code

sgt $t6,$s1,$s7  # if n is greater than m then t6=1 else t6=0. 

beq $t6, $zero, hardexit    # if t6=0 then hardexit. if t6=1 then continue to the next code

addi $t0, $zero, 0   # clears t0  This will store the distance from rectangle
addi $t1, $zero, 0   # clears t0  This will store the distance from rectangle
addi $t2, $zero, 0   # clears t0  This will store the end product 
addi $t3, $zero, 0   # clears t0  This will store the end product 
addi $t4, $zero, 0   # This clears t2 register 
addi $t5, $zero, 0   # This clears t2 register 
addi $t6, $zero, 0   # This clears t2 register 

div $t0, $s0, 8 # 2048 divided by 8 is equal to 256 

sub $t0, $t0, $s1  # t0= 256 - n

div $t0,$t0, 2  # t0= (256-n) / 2 

div $t0, $s6  # ((256-n) / 2 )/ 4

mfhi $s2  # mfhi is the remainder which is the module answer so (((256-n) / 2 )/ 4) mod 4 = 2




sub $t0, $t0, $s2  # t3 = (((256-n) / 2 )/ 4 ) -  remainder of (((256-n) / 2 )/ 4) mod 4 

mul $t2, $s0, $t0 # t2 has the product of 2048 and (((256-n) / 2 )/ 4 ) -  remainder of (((256-n) / 2 )/ 4) mod 4 

addi $t1, $zero, 0   # clears t1 register
addi $t5, $zero, 0   # clears t5 register


div $t1, $s0, $s6  # t1= 2048 / 4
sub $t1, $t1, $s1  # t1= (2048/4) - n
div $t1,$t1, 2  # t1= (512 - n) / 2 
div $t1, $s6  # ((512 - n) / 2) / 4

mfhi $s3  # mfhi is the remainder which is the module answer so ((512 - n) / 2) / 4


sub $t1, $t1, $s3  # t1 = ((512 - n) / 2) / 4 -  remainder which is the module answer so ((512 - n) / 2) / 4
mul $t5, $t1, $s6      #t5= (((512 - n) / 2) / 4 -  remainder which is the module answer so ((512 - n) / 2) / 4) times 4 // making sure the outer square is centerable
add $t2, $t2, $t5  # t2 = (2048 x the product of 2048 and (((256-n) / 2 )/ 4 ) -  remainder of (((256-n) / 2 )/ 4) mod 4) + ((((512 - n) / 2) / 4 -  remainder which is the module answer so ((512 - n) / 2) / 4) times 4)
		   #t2= first byte of outer square

mul  $t7, $s1, $s6  # t7 = n times 4 
add $t8, $t7, $zero  # t8= (n times 4) + 0

addi $t5, $zero, 0 # clears t5
add $t5, $t2, $t7  # t5 = first byte of outer square + proper offset to last byte for first horizontal line


addi $t1, $zero, 0   # This clears t1 register
addi $t0, $zero, 0   # This clears t0 register
addi $t6, $zero, 0   # This clears t6 register

lw $t0,c1r($zero) # loads s6 register with 4. 
lw $t1,c1g($zero) # loads s6 register with 4. 
lw $t6,c1b($zero) # loads s6 register with 4. 

or $t3,$t0,$t1  # if its t0 or t1 store it into t3
or $t3,$t3,$t6  # if its t3 or t6 store it again into t3

la $t4,frameBuffer # loads address for framebuffer 

addi $t1, $zero, 0   # This clears t1 register
addi $t0, $zero, 0   # This clears t1 register

	  
   secwhile:

      	beq $s1,$t0, exit  # if N = the counter that increments every iteration branch to exit
      	        	         	         
	while:
	
	 beq $t5,$t2, morethanone # if t5= first byte of outer square then branch to the next line.
	 
	 add $t1, $t4, $t2  # t1 is equal to the address of t4 plus the address of the first byte that is continuously changin
	 sw $t3,($t1) # store the color to this address with the offset.
	
	 add $t2, $t2, $s6  # increment first byte by 4 bytes 
	   
	 j while 
	    
   
    morethanone:
	 
	 addi $t0, $t0, 1   # increments t0 
	 
	 add  $t5, $t5, $s0  # first byte of outer square + 2048. this shifts it downward. 
     	 
     	 sub $t2, $t2, $t7  # t2= first byte of first row - n(4)
     	 add  $t2, $t2, $s0  # this is the first byte plus one column down 
     	 
     	 
     b secwhile
     

exit:

addi $t3, $zero, 0   # This clears t3 register                                             
addi $t4, $zero, 0   # This clears t4 register

addi $t1, $zero, 0   # This clears t1 register
addi $t0, $zero, 0   # This clears t0 register
addi $t6, $zero, 0   # This clears t6 register
addi $t3, $zero, 0   # This clears t3 register

lw $t0,c2r($zero) # loads s6 register with 4. 
lw $t1,c2g($zero) # loads s6 register with 4. 
lw $t6,c2b($zero) # loads s6 register with 4. 

or $t3,$t0,$t1    # if its t0 or t1 store it into t3
or $t3,$t3,$t6    # if its t3 or t6 store it again into t3

la $t4,frameBuffer # loads address for framebuffer this works

addi $t0, $zero, 0   # This clears t0 register
addi $t1, $zero, 0   # This clears t1 register
addi $t7, $zero, 0   # This clears t7 register
addi $t6, $zero, 0   # This clears t6 register

mul $t7, $s7,$s6   #   t7= m(4)

mul $s4, $s0, $s1  # 2048 times n
sub $t5,$t5, $s4  # t5 = last byte of last line of outer square  - (2048 times n)= last byte of first row
sub $t5, $t5, $t8  # last byte of first row  - n(4) = first byte of first line
add $t6, $t5, $t7  # last byte of inner square = first byte of first line + new inner square distance m(4) #m(4)
 
# difference between the length of one square to the other and it has to be positive. 

sub $t8, $t8, $t7 # difference between both square lengths ( n(4) - m(4) ) 
addi $t9, $zero, 2 # t9 = 2

addi $t2, $zero, 0   # This clears t2 register 
div $t8, $t9 # ( n(4) - m(4) ) / 2
 
mflo $t2 # length of outer square to inner square.    

add $t6, $t6, $t2  # shifts first byte of the square to the right by an appropriate length to make it centerable 
add $t5, $t5, $t2  # shifts last byte of the first line square to the right by an appropriate length to make it centerable 

addi $t9, $zero, 0 # clears out t9 

div $t2, $s6  # length of outer square to inner square divided by 4.

mflo $t9 #  quotient of length of outer square to inner square divided by 4.

mul $t9, $t9, $s0 # shifts it down by 2048 times

add $t6, $t6, $t9  # shifts square to the bottom by 2048
add $t5, $t5, $t9 # shifts square to the bottom by 2048 


   innersquare:

      	beq $s7,$t0, hardexit  # if m = counter incrementing by 1, then hardexit if not go through another iteration.


	innerwhile:
	
	 beq $t6,$t5, innerone # t6= last byte of inner square, t5 = first byte of inner square 
	 
	 add $t1, $t4, $t5  # t1 is equal to the address of t4 plus the offset
	 
	 sw $t3,($t1) # store the color to this address with the offset.
	
	 add $t5, $t5, $s6  # increment first byte by 4 bytes
	   
	 j innerwhile  # loop through and only break if it creates a line for the inner square

	
   
    innerone:
	 
	 addi $t0, $t0, 1    # t0 incrementing by one 
	 
	 add  $t6, $t6, $s0  # first byte of inner square + 2048. this shifts it downward. 
     	 
    	 sub $t5, $t5, $t7   # t2= first byte of first row - n(4)
    	 add  $t5, $t5, $s0  # this is the first byte plus one column down and continues
    	 	 
         b innersquare


hardexit:
 		  
li $v0,10 # exit code
syscall # exit to OS
        
       






