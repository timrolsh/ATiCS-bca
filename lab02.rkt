#|
Tim Rolshud
ATiCS Period 3
December 13th, 2022

This lab was formatted with raco fmt.
|#

#lang racket

(define test_list '(45 12 94 65 23 6 43 2))
(display "test_list is defined as: ")
test_list

#|
1. Given list node (linked-list) and index (index), return list value at n.
Return null if list index is out of bounds.
|#
(define (get-element linked-list index)
    (cond
        [(null? linked-list) null]
        [(equal? 0 index) (car linked-list)]
        [else (get-element (cdr linked-list) (- index 1))]))
(display "(get-element test_list 3) -> 65: ")
(get-element test_list 3)
(display "(get-element test_list -1) -> '(): ")
(get-element test_list -1)
(display "(get-element test_list 10) -> '(): ")
(get-element test_list 10)

#|
2. Given list (linked-list) and element to add (element), return new list with added element to the
end
|#
(define (append-element linked-list element)
    (cond
        [(null? linked-list) (cons element null)]
        [else (cons (car linked-list) (append-element (cdr linked-list) element))]))
(display "(append-element '(1 2 3) 4) -> '(1 2 3 4): ")
(append-element '(1 2 3) 4)
(display "(append-element '() 4) -> '(4): ")
(append-element '() 4)

#|
3. Given two lists (first, second), return new list with all elements added together.
Append all elements of first list, then when first list is null, append all elements of second list.
|#
(define (append-list first second)
    (cond
        [(not (null? first)) (cons (car first) (append-list (cdr first) second))]
        [(and (null? first) (not (null? second))) (cons (car second) (append-list null (cdr second)))]
        [else null]))
(display "(append-list '(6 5 4) '(1 2 3)) -> '(6 5 4 1 2 3): ")
(append-list '(6 5 4) '(1 2 3))
(display "(append-list null null) -> '(): ")
(append-list null null)
(display "(append-list 1 null) -> (1): ")
(append-list '(1) null)
(display "(append-list null 2) -> (2): ")
(append-list null '(2))

#|
4. Given a list (linked-list), reverse that list.
|#
(define (backwards linked-list)
    (backwards-helper linked-list null))

; helper recursvie function for backwards function
(define (backwards-helper linked-list new-list)
    (cond
        [(null? linked-list) new-list]
        [else (backwards-helper (cdr linked-list) (cons (car linked-list) new-list))]))
(display "(backwards '(1 2 3 4 5)) -> '(5 4 3 2 1): ")
(backwards '(1 2 3 4 5))
(display "(backwards null) -> '(): ")
(backwards null)

#|
Given a string (text), return whether that string is "balanced" in terms of parantheses.
|#
(define (paren-balanced? text)
    (paren-balanced-helper text null))

#|
Main helped method for paren-balanced?, uses stack to verify parentheses.
if character is ( [ {, push the closing value equivalent onto the stack.
if character is ) ] }, pop that element off stack, if element you are popping doesn't match with
closing character, return false, if you try to pop off stack while stack is empty, return false too
if you made it to the end of the string and stack is empty, return true
|#
(define (paren-balanced-helper text stack)
    (cond
        [(and (equal? stack null) (equal? "" text)) #t]
        [(and (not (equal? stack null)) (equal? "" text)) #f]
        [(is-opening-character (substring text 0 1))
            (paren-balanced-helper 
                (substring text 1) 
                (append-element stack (open-to-close (substring text 0 1))))]
        [(is-closing-character (substring text 0 1))
            (cond
                [(equal? stack null) #f]
                [else
                    (cond
                        [(not (equal? (substring text 0 1) (get-element stack (- (length stack) 1)))) 
                        #f]
                        [else (paren-balanced-helper (substring text 1) (remove-last stack))])])]
        [else (paren-balanced-helper (substring text 1) stack)]))

#|
Return true if the character is (, [, or {.
|#
(define (is-opening-character character)
    (or (equal? character "(") (equal? character "[") (equal? character "{")))

#|
Return true if the character is ), ], or }.
|#
(define (is-closing-character character)
    (or (equal? character ")") (equal? character "]") (equal? character "}")))

#|
Return the linked list with the last element removed
|#
(define (remove-last linked-list)
    (if (null? (cdr linked-list)) '() (cons (car linked-list) (remove-last (cdr linked-list)))))

#|
Flip opening character to closing character
|#
(define (open-to-close character)
    (cond
        [(equal? character "(") ")"]
        [(equal? character "[") "]"]
        [else "}"]))

(display "(paren-balanced? \"({[Racket] Is} Cool)\") -> #t: ")
(paren-balanced? "({[Racket] Is} Cool)")
(display "(paren-balanced? \"({[(Hello]\") -> #f: ")
(paren-balanced? "({[(Hello]")
(display "(paren-balanced? \"Test )]}\") -> #f: ")
(paren-balanced? "Test )]}")
(display "(paren-balanced? \"({((Somethetning else....)\") -> #f: ")
(paren-balanced? "({((Somethetning else....)")
