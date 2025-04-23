.data
menu_msg: .asciiz "\n========================================================\n\tLibrary Management System\n========================================================\n1. ADMIN\n2. USER\nEnter choice: "
invalid_opt: .asciiz "Invalid option\n"
buffer: .space 100
book_count: .word 5
.align 2             
books: .space 200         
book1: .asciiz "00. Peer e Kamil,Nimra Ahmed\n"
book2: .asciiz "01. It end with us,Colleen Hoover\n"
book3: .asciiz "02. Computer Organization and Design,David A. Patterson and John L. Hennessy\n"
book4: .asciiz "03. Digital Logic and Computer Design,M. Morris Mano\n"
book5: .asciiz "04. Pride and Prejudice,Jane Austen\n"
admin_login_msg: .asciiz "\n========================================================\n\t\t\tADMIN\n========================================================\n\t\t\tLOG IN\n========================================================" 
admin_login_username_msg: .asciiz "\nEnter username: "
admin_login_password_msg: .asciiz "\nEnter password: "
admin_username: .asciiz "maham"
admin_password: .asciiz "12345"
admin_buffer_username: .space 20        
admin_buffer_password: .space 20  
admin_menu_msg: .asciiz "\n========================================================\n\tLibrary Management System\n========================================================\n\n1. View Book List\n2. Add New Book\n3. Remove Book\n4. Update Book Details\n5. Exit\nChoose an option: "
msg_booklist: .asciiz "Book List:\n"
prompt_r_id:  .asciiz "Enter ID of the book to remove: "
success_r_msg:.asciiz "Book removed successfully.\n"
invalid_r_msg:.asciiz "Invalid index. Try again.\n"
msg_newbookdetails: .asciiz "Enter new book details: "
msg_bookadded: .asciiz " Book has been added to List\n"
invalid_indexx: .asciiz "\nInvalid book index. Please try again.\n"
prompt_id: .asciiz "\nEnter the index of the book to update: "
prompt_new: .asciiz "\nEnter new book details: "
success_msg: .asciiz "\nBook updated successfully.\n"
memory_error_msg: .asciiz "\nError: Memory allocation failed. Please try again.\n"
user_login_msg: .asciiz "\n========================================================\n\t\t\tUSER\n========================================================\n\t\t\tLOG IN\n========================================================" 
user_login_username_msg: .asciiz "\nEnter username: "
user_login_password_msg: .asciiz "\nEnter password: "
user_username: .asciiz "saleha"
user_password: .asciiz "123" 
user_buffer_username: .space 20        
user_buffer_password: .space 20  
user_menu_msg: .asciiz "\n========================================================\n\tLibrary Management System\n========================================================\n\n1. View Availble Book \n2. Search Book\n3. Borrow Book\n4. Return Book \n5. Exit\nChoose an option: "
prompt: .asciiz "Enter book ID to search: "
book_found: .asciiz "Book found!\nThe details of book are : "
not_fond: .asciiz "Book not found!\n"
msg_returnbookdetails: .asciiz "Enter details of book (ID. NAME , AUTHOR) "
msg_return: .asciiz " Book has been returned\n"
msg_borrowbook: .asciiz "Enter ID of book: "
msg_borrowed: .asciiz " Book has been borrowed\n"
whatnext:.asciiz "\nWhat do you want next: \n1)Log Out\n2)Menu \n3)Exit\n "
whatnextt:.asciiz "What do you want to do next: \n1)Main Menu\n2)Exit\n "
no_books_msg: .asciiz "No books available to remove.\n"
.text 
.globl main 
main:
jal initialize_books 
jal Menu
initialize_books:
    la $t0, books       
    la $t1, book1         
    sw $t1, 0($t0)         
    la $t1, book2
    sw $t1, 4($t0)
    la $t1, book3
    sw $t1, 8($t0)
    la $t1, book4
    sw $t1, 12($t0)
    la $t1, book5
    sw $t1, 16($t0)
    jr $ra

Menu:
    li $v0, 4
    la $a0, menu_msg
    syscall
    li $v0, 5
    syscall
    move $t0, $v0
    beq $t0, 1, admin
    beq $t0, 2, user
    j invalid

admin:
    li $v0, 4
    la $a0, admin_login_msg
    syscall
    li $v0, 4
    la $a0, admin_login_username_msg
    syscall
    li $v0, 8
    la $a0, admin_buffer_username
    li $a1, 20
    syscall
    la $t0, admin_buffer_username
    jal remove_newline
    li $v0, 4
    la $a0, admin_login_password_msg
    syscall
    li $v0, 8
    la $a0, admin_buffer_password
    li $a1, 20
    syscall
    la $t0, admin_buffer_password
    jal remove_newline
    la $t0, admin_buffer_username     
    la $t1, admin_username     
    jal string_compare
    beq $v0, 0, compare_password   
    j invalid
compare_password:
    la $t0, admin_buffer_password     
    la $t1, admin_password      
    jal string_compare
    beq $v0, 0, admin_menu         
    j invalid
string_compare:
    li $v0, 0  
string_compare_loop:
    lb $t2, 0($t0)  
    lb $t3, 0($t1)   
    bne $t2, $t3, strings_not_equal 
    beqz $t2, strings_equal        
    addi $t0, $t0, 1  
    addi $t1, $t1, 1 
    j string_compare_loop
strings_not_equal:
    li $v0, 1  
    jr $ra
strings_equal:
    li $v0, 0  
    jr $ra
remove_newline:
    li $t1, 10 
remove_newline_loop:
    lb $t2, 0($t0)              
    beqz $t2, end_remove        
    beq $t2, $t1, null_terminate 
    addi $t0, $t0, 1             
    j remove_newline_loop
null_terminate:
    sb $zero, 0($t0)            
end_remove:
    jr $ra
admin_menu:
    li $v0, 4             
    la $a0, admin_menu_msg      
    syscall
    li $v0, 5
    syscall
    move $t0, $v0
    beq $t0, 1, view_books
    beq $t0, 2, add_book
    beq $t0,3,remove_book
    beq $t0,4,update_book
    beq $t0, 5, exit
    j invalid_menu_option
#view book method    
view_books:
    li $v0, 4
    la $a0, msg_booklist
    syscall
    la $t0, books          
    lw $t1, book_count     
view_books_loop:
    beqz $t1, end_view_books
    lw $a0, 0($t0)        
    li $v0, 4
    syscall
    addi $t0, $t0, 4       
    addi $t1, $t1, -1      
    j view_books_loop
end_view_books:
    li $v0, 4
    la $a0, whatnext
    syscall
    li $v0, 5
    syscall
    move $t0, $v0
    beq $t0, 1, Menu
    beq $t0,2,admin_menu
    j exit
#remove book method
remove_book:
    li $v0, 4
    la $a0, prompt_r_id           # Prompt user to enter the book index
    syscall
    li $v0, 5                     # Read the user's input index
    syscall
    move $t1, $v0                 # Store the input index in $t1

    lw $t2, book_count            # Load the total number of books
    beqz $t2, no_books_error      # If no books, display an error

    la $t3, books                 # Load the base address of the books array
    li $t4, -1                    # Initialize a variable to store the match index
    li $t5, 0                     # Initialize a loop counter for book index

find_book_loop:
    lw $t6, 0($t3)                # Load the address of the current book
    beqz $t6, no_match_found      # If null, all books checked, no match found

    lb $a0, 0($t6)                # Load the first character of the book index (e.g., "0")
    lb $a1, 1($t6)                # Load the second character of the book index (e.g., "0")

    div $t7, $t1, 10              # Divide input index by 10 to get the first digit
    mfhi $t8                      # Extract the remainder (second digit)
    addi $t7, $t7, 48             # Convert first digit to ASCII ('0' = 48)
    addi $t8, $t8, 48             # Convert second digit to ASCII ('0' = 48)

   sub $t9, $a0, $t7             # Compare the first character (book index vs input index)
    bne $t9, $zero, next_book      # If not equal, check the next book (compare against $zero)
    sub $t9, $a1, $t8             # Compare the second character (book index vs input index)
    bne $t9, $zero, next_book              # If not equal, check the next book

    move $t4, $t5                 # Match found, store the index
    j remove_found_book           # Jump to book removal logic

next_book:
    addi $t3, $t3, 4              # Move to the next book in the array
    addi $t5, $t5, 1              # Increment the loop counter
    subi $t2, $t2, 1              # Decrement the remaining books count
    bgtz $t2, find_book_loop      # If there are more books, continue

no_match_found:
    li $v0, 4
    la $a0, invalid_r_msg         # Display "No match found" message
    syscall
    j remove_book                 # Retry removing a book

remove_found_book:
    lw $t2, book_count            # Reload the total book count
    sub $t2, $t2, 1               # Decrement book count
    sw $t2, book_count            # Save the updated count
    la $t3, books                 # Load the base address of the books array
    sll $t4, $t4, 2               # Convert book index to byte offset
    add $t3, $t3, $t4             # Calculate the address of the matched book

shift_books:
    lw $t6, 4($t3)                # Load the next book's address
    sw $t6, 0($t3)                # Move it one position back
    addi $t3, $t3, 4              # Increment book pointer
    subi $t2, $t2, 1              # Decrement counter
    bgtz $t2, shift_books         # Continue shifting if there are books left

done_shifting:
    li $v0, 4
    la $a0, success_r_msg         # Display success message
    syscall
    li $v0, 4
    la $a0, whatnext              # Ask user for the next action
    syscall
    li $v0, 5
    syscall
    move $t0, $v0
    beq $t0, 1, Menu              # Go to main menu
    beq $t0, 2, admin_menu        # Go to admin menu
    j exit

no_books_error:
    li $v0, 4
    la $a0, no_books_msg          # Display "No books available" message
    syscall
    j admin_menu


# Update book details method
update_book:
    li $v0, 4
    la $a0, prompt_id
    syscall
    li $v0, 5
    syscall
    move $t2, $v0                 
    lw $t1, book_count            
    bge $t2, $t1, invalid_index1  
    bltz $t2, invalid_index1      
    li $v0, 4
    la $a0, prompt_new
    syscall
    li $v0, 8
    la $a0, buffer
    li $a1, 100
    syscall
    li $v0, 9
    li $a0, 100
    syscall
    beqz $v0, memory_error        
    move $t3, $v0                
    la $t1, buffer
copy_new_details:
    lb $t4, 0($t1)
    sb $t4, 0($t3)
    beqz $t4, end_copy_new
    addi $t1, $t1, 1
    addi $t3, $t3, 1
    j copy_new_details
end_copy_new:
    la $t0, books
    mul $t2, $t2, 4
    add $t0, $t0, $t2
    sw $v0, 0($t0)
    li $v0, 4
    la $a0, success_msg
    syscall
    li $v0, 4
    la $a0, whatnext
    syscall
    li $v0, 5
    syscall
    move $t0, $v0
    beq $t0, 1, Menu
    beq $t0, 2, admin_menu
    j exit
invalid_index1:
    li $v0, 4
    la $a0, invalid_indexx
    syscall
    j update_book
memory_error:
    li $v0, 4
    la $a0, memory_error_msg
    syscall
    li $v0, 4
    la $a0, whatnext
    syscall
    li $v0, 5
    syscall
    move $t0, $v0
    beq $t0, 1, Menu
    beq $t0, 2, admin_menu
    j exit

#add book method
add_book:
    lw $t0, book_count
    li $t2, 100               
    bge $t0, $t2, admin_menu
    li $v0, 4             
    la $a0, msg_newbookdetails
    syscall
    li $v0, 8              
    la $a0, buffer
    li $a1, 100
    syscall
    li $v0, 9
    li $a0, 100
    syscall            
    la $t1, buffer
    move $t2, $v0
copy_loop:
    lb $t3, 0($t1)
    sb $t3, 0($t2)
    addiu $t1, $t1, 1
    addiu $t2, $t2, 1
    bnez $t3, copy_loop
    lw $t0, book_count
    la $t1, books
    mul $t0, $t0, 4         
    add $t1, $t1, $t0
    sw $v0, 0($t1)     
    lw $t0, book_count
    addi $t0, $t0, 1
    sw $t0, book_count
    li $v0, 4            
    la $a0, msg_bookadded
    syscall
    li $v0, 4
    la $a0, whatnext
    syscall
    li $v0, 5
    syscall
    move $t0, $v0
    beq $t0, 1, Menu
    beq $t0, 2, admin_menu
    j exit
user:
    li $v0, 4
    la $a0, user_login_msg
    syscall
    li $v0, 4
    la $a0, user_login_username_msg
    syscall
    li $v0, 8
    la $a0, user_buffer_username
    li $a1, 20
    syscall
    la $t0, user_buffer_username
    jal remove_newline
    li $v0, 4
    la $a0, user_login_password_msg
    syscall
    li $v0, 8
    la $a0, user_buffer_password
    li $a1, 20
    syscall
    la $t0, user_buffer_password
    jal remove_newline
    la $t0, user_buffer_username     
    la $t1, user_username     
    jal string_compare
    beq $v0, 0, compare_user_password   
    j invalid
 compare_user_password:
    la $t0, user_buffer_password     
    la $t1, user_password      
    jal string_compare
    beq $v0, 0, user_menu         
    j invalid  
user_menu:
    li $v0, 4             
    la $a0, user_menu_msg      
    syscall
    li $v0, 5
    syscall
    move $t0, $v0
     beq $t0, 1,avb_view_books
     beq $t0,2,search_book
     beq $t0,3,borrow_book
     beq $t0,4,return_book
     beq $t0,5,exit
     j invalid_menu_option  
#avb_book method 
avb_view_books:
    li $v0, 4
    la $a0, msg_booklist
    syscall
    la $t0, books          
    lw $t1, book_count    
avb_view_books_loop:
    beqz $t1, avb_end_view_books
    lw $a0, 0($t0)        
    li $v0, 4
    syscall
    addi $t0, $t0, 4       
    addi $t1, $t1, -1      
    j avb_view_books_loop
avb_end_view_books:
    li $v0, 4
    la $a0, whatnext
    syscall
    li $v0, 5
    syscall
    move $t0, $v0
    beq $t0, 1, Menu
    beq $t0,2,user_menu
    j exit
#return book method
return_book:
    lw $t0, book_count
    li $t2, 100               
    bge $t0, $t2, user_menu
    li $v0, 4           
    la $a0, msg_returnbookdetails
    syscall
    li $v0, 8             
    la $a0, buffer
    li $a1, 100
    syscall
    li $v0, 9
    li $a0, 100
    syscall               
    la $t1, buffer
    move $t2, $v0  
return_loop:
    lb $t3, 0($t1)
    sb $t3, 0($t2)
    addiu $t1, $t1, 1
    addiu $t2, $t2, 1
    bnez $t3, return_loop
    lw $t0, book_count
    la $t1, books
    mul $t0, $t0, 4        
    add $t1, $t1, $t0
    sw $v0, 0($t1)         
    lw $t0, book_count
    addi $t0, $t0, 1
    sw $t0, book_count
    li $v0, 4             
    la $a0, msg_return
    syscall
    li $v0, 4
    la $a0, whatnext
    syscall
    li $v0, 5
    syscall
    move $t0, $v0
    beq $t0, 1, Menu
    beq $t0, 2, user_menu
    j exit  
  
#borrew book method
borrow_book:
    li $v0, 4
    la $a0, msg_borrowbook         # Display prompt for borrowing a book
    syscall
    li $v0, 5                      # Read user input (book index)
    syscall
    move $t1, $v0                  # Store the input index in $t1

    lw $t2, book_count             # Load the total number of books
    beqz $t2, no_books_error1       # If no books, display an error

    la $t3, books                  # Load the base address of the books array
    li $t4, -1                     # Initialize a variable to store the match index
    li $t5, 0                      # Initialize a loop counter for book index

find_book_loop_borrow:
    lw $t6, 0($t3)                 # Load the address of the current book
    beqz $t6, no_match_found_borrow # If null, all books checked, no match found

    lb $a0, 0($t6)                 # Load the first character of the book index (e.g., "0")
    lb $a1, 1($t6)                 # Load the second character of the book index (e.g., "0")

    div $t7, $t1, 10               # Divide input index by 10 to get the first digit
    mfhi $t8                       # Extract the remainder (second digit)
    addi $t7, $t7, 48              # Convert first digit to ASCII ('0' = 48)
    addi $t8, $t8, 48              # Convert second digit to ASCII ('0' = 48)

    sub $t9, $a0, $t7              # Compare the first character (book index vs input index)
    bne $t9, $zero, next_book_borrow # If not equal, check the next book

    sub $t9, $a1, $t8              # Compare the second character (book index vs input index)
    bne $t9, $zero, next_book_borrow # If not equal, check the next book

    move $t4, $t5                  # Match found, store the index
    j borrow_found_book            # Jump to book borrowing logic

next_book_borrow:
    addi $t3, $t3, 4               # Move to the next book in the array
    addi $t5, $t5, 1               # Increment the loop counter
    subi $t2, $t2, 1               # Decrement the remaining books count
    bgtz $t2, find_book_loop_borrow # If there are more books, continue

no_match_found_borrow:
    li $v0, 4
    la $a0, invalid_r_msg          # Display "No match found" message
    syscall
    j borrow_book                  # Retry borrowing a book

borrow_found_book:
    lw $t2, book_count             # Reload the total book count
    sub $t2, $t2, 1                # Decrement book count
    sw $t2, book_count             # Save the updated count
    la $t3, books                  # Load the base address of the books array
    sll $t4, $t4, 2                # Convert book index to byte offset
    add $t3, $t3, $t4              # Calculate the address of the matched book

shift_books_borrow:
    lw $t6, 4($t3)                 # Load the next book's address
    sw $t6, 0($t3)                 # Move it one position back
    addi $t3, $t3, 4               # Increment book pointer
    subi $t2, $t2, 1               # Decrement counter
    bgtz $t2, shift_books_borrow   # Continue shifting if there are books left

done_shifting_borrow:
    li $v0, 4
    la $a0, msg_borrowed           # Display success message for borrowing
    syscall
    li $v0, 4
    la $a0, whatnext               # Ask user for the next action
    syscall
    li $v0, 5
    syscall
    move $t0, $v0
    beq $t0, 1, main               # Go to main menu
    beq $t0, 2, user_menu          # Go to user menu
    j exit

no_books_error1:
    li $v0, 4
    la $a0, no_books_msg           # Display "No books available" message
    syscall
    j user_menu                    # Go back to the user menu

invalid_index_borrow:
    li $v0, 4
    la $a0, invalid_r_msg          # Display "Invalid index" message
    syscall
    j borrow_book                  # Retry borrowing a book

#search book method
search_book:
    li $v0, 4
    la $a0, prompt                  # Display prompt for searching a book
    syscall
    li $v0, 5                       # Read user input (book index)
    syscall
    move $t1, $v0                   # Store the input index in $t1

    lw $t2, book_count              # Load the total number of books
    beqz $t2, no_books_error_search # If no books, display an error

    la $t3, books                   # Load the base address of the books array
    li $t4, -1                      # Initialize a variable to store the match index
    li $t5, 0                       # Initialize a loop counter for book index

find_book_loop_search:
    lw $t6, 0($t3)                  # Load the address of the current book
    beqz $t6, no_match_found_search # If null, all books checked, no match found

    lb $a0, 0($t6)                  # Load the first character of the book index (e.g., "0")
    lb $a1, 1($t6)                  # Load the second character of the book index (e.g., "0")

    div $t7, $t1, 10                # Divide input index by 10 to get the first digit
    mfhi $t8                        # Extract the remainder (second digit)
    addi $t7, $t7, 48               # Convert first digit to ASCII ('0' = 48)
    addi $t8, $t8, 48               # Convert second digit to ASCII ('0' = 48)

    sub $t9, $a0, $t7               # Compare the first character (book index vs input index)
    bne $t9, $zero, next_book_search # If not equal, check the next book

    sub $t9, $a1, $t8               # Compare the second character (book index vs input index)
    bne $t9, $zero, next_book_search # If not equal, check the next book

    move $t4, $t5                   # Match found, store the index
    j search_found_book             # Jump to book search found logic

next_book_search:
    addi $t3, $t3, 4                # Move to the next book in the array
    addi $t5, $t5, 1                # Increment the loop counter
    subi $t2, $t2, 1                # Decrement the remaining books count
    bgtz $t2, find_book_loop_search # If there are more books, continue

no_match_found_search:
    li $v0, 4
    la $a0, invalid_r_msg           # Display "No match found" message
    syscall
    j search_book                   # Retry searching a book

search_found_book:
    la $a0, book_found              # Display success message for book found
    li $v0, 4
    syscall
    lw $t3, 0($t3)                  # Load the address of the found book
    la $a0, ($t3)                   # Load the book name or details
    li $v0, 4
    syscall
    li $v0, 4
    la $a0, whatnext                # Ask user for the next action
    syscall
    li $v0, 5
    syscall
    move $t0, $v0
    beq $t0, 1, Menu                # Go to main menu
    beq $t0, 2, user_menu           # Go to user menu
    j exit

no_books_error_search:
    li $v0, 4
    la $a0, no_books_msg            # Display "No books available" message
    syscall
    j user_menu                     # Go back to the user menu

invalid_index_search:
    li $v0, 4
    la $a0, invalid_r_msg           # Display "Invalid index" message
    syscall
    j search_book  
exit:
    li $v0, 10
    syscall
invalid:
    li $v0, 4
    la $a0, invalid_opt
    syscall
    li $v0, 4
    la $a0, whatnextt
    syscall
    li $v0, 5
    syscall
    move $t0, $v0
    beq $t0, 1, Menu
    j exit
invalid_menu_option:
    li $v0, 4
    la $a0, invalid_opt
    syscall
    li $v0, 4
    la $a0, whatnext
    syscall
    li $v0, 5
    syscall
    move $t0, $v0
    beq $t0, 1, Menu
    beq $t0,2,admin_menu
    j exit
