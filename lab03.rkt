#|
Tim Rolshud
ATiCS Period 3
January 19th, 2023

This lab was formatted with raco fmt.
|#

#lang racket

(define/contract (func1 x)
    (-> number? number?)
    (+ (* x x) 2))

(define func2 (λ (x) (+ (* x x) 2)))

(define dec (λ (x) (- x 1)))

(display "(func1 2) -> 6: ")
(func1 2)
(display "(func2 2) -> 6: ")
(func2 2)
(display "(func1 0) -> 2: ")
(func1 0)
(display "(func2 0) -> 2: ")
(func2 0)
(display "(func1 -1) -> 3: ")
(func1 -1)
(display "(func2 -1) -> 3: ")
(func1 -1)
(display "(dec 1) -> 0: ")
(dec 1)
(display "(dec -1) -> -2: ")
(dec -1)


#|
Return whether each element in given list is even or not
|#
(define/contract (evens lst) 
    (-> list? list?)
    (map (λ (x) (equal? (modulo x 2) 0)) lst))

#|
Return the square of every number in the list   
|#
(define/contract (squares lst)
    (-> list? list?)
    (map (λ (x) (* x x)) lst))

#|
Return the largest element in every list
|#
(define/contract (bigs lst)
    (-> list? list?)
    (map (λ (x) (apply max x)) lst))

(display "(evens '(1 2 3 4 5)) -> '(#f #t #f #t #f): ") 
(evens '(1 2 3 4 5))
(display "(squares '(0 1 2 3 4)) -> '(0 1 4 9 16): ")
(squares '(0 1 2 3 4))
(display "(bigs '((1 3) (7 4) (1 5))) -> '(3 7 5): ")
(bigs '((1 3) (7 4) (1 5)))


#|
Evaluate an expression in reverse polish notation (rpn) or postfix notation
|#
(define/contract (eval-rpn expression stack)
    (-> list? list? number?)
    (cond
        [(null? expression) (car stack)]
        [(number? (car expression))
            (eval-rpn (cdr expression) (append stack (cons (car expression) null)))]
        [else
            (define a (list-ref stack (- (length stack) 2)))
            (define b (list-ref stack (- (length stack) 1)))
            (define result ((to-procedure (car expression)) a b))
            (eval-rpn (cdr expression) (append (drop-two-last stack) (cons result null)))]))

#|
helper method for eval-rpn
|#
(define/contract (drop-two-last lst)
    (-> list? list?)
    (reverse (cddr (reverse lst))))

#|
helper method for eval-rpn to fix type issue with operators
|#
(define/contract (to-procedure operator)
    (-> any/c procedure?)
    (cond
        [(equal? operator '+) +]
        [(equal? operator '-) -]
        [(equal? operator '*) *]
        [(equal? operator '/) /]))

(display "(eval-rpn '(3 4 5 + /) '())-> 1/3: ")
(eval-rpn '(3 4 5 + /) '())
(display "(eval-rpn '(2 5 *) '()) -> 10: ")
(eval-rpn '(2 5 *) '())

#|
api method for in-postfix
|#
(define/contract (in->postfix tokens)
    (-> list? list?)
    (infix-to-postfix-helper tokens '() '()))

#|
Main helper method for infix to postfix converter
|#
(define/contract (infix-to-postfix-helper tokens operation-stack output-queue)
    (-> list? list? list? list?)
    (cond
        ; tokens and operation stack are empty, done
        [(and (null? tokens) (null? operation-stack))
            output-queue]
        ; no tokens but still stuff on operation stack, pop from operation stack and put on 
        ; output queue
        [(and (null? tokens) (not (null? operation-stack)))
            (infix-to-postfix-helper tokens (cdr operation-stack) 
                (append output-queue (cons (car operation-stack) null)))]
        [else
            ; current token
            (define token (car tokens))
            (cond
                ; if token is a number, push it to output queue
                [(number? token)
                    (infix-to-postfix-helper (cdr tokens) operation-stack (append output-queue 
                        (cons token null)))]
                [(operator? token)
                    (cond
                        ; if token is operator and there are other operators with greater precedence 
                        ; on stack, pop operators from stack to output queue
                        [(and (> (length operation-stack) 0) (>= (precedence (car operation-stack)) 
                            (precedence token)))
                            (infix-to-postfix-helper tokens (cdr operation-stack) 
                                (append output-queue (cons (car operation-stack) null)))]
                        ; push current operator onto stack
                        [else 
                            (infix-to-postfix-helper (cdr tokens) (cons token operation-stack) 
                                output-queue)])]
                ; if token is left bracket, push to stack
                [(equal? token "(")
                    (infix-to-postfix-helper (cdr tokens) (cons token operation-stack) output-queue)]
                [(equal? token ")")
                    (cond
                        ; if its a right bracket, while there is not a left bracket at the top of 
                        ; the stack
                        [(and (> (length operation-stack) 0) (not (equal? (car operation-stack) "(")))
                            (infix-to-postfix-helper tokens (cdr operation-stack) (append output-queue
                                (cons (car operation-stack) null)))]
                        ; pop left bracket from stack and discard it
                        [else 
                            (infix-to-postfix-helper (cdr tokens) (cdr operation-stack) 
                                output-queue)])])]))

#|
returns whether the element is an operator (+ - * /)
|#
(define/contract (operator? element)
    (-> any/c boolean?)
    (or (equal? element '+) (equal? element '-) (equal? element '*) (equal? element '/)))

(define/contract (precedence operator)
    (-> any/c number?)
    (cond
        [(equal? operator '+) 1]
        [(equal? operator '-) 1]
        [(equal? operator '*) 2]
        [(equal? operator '/) 2]
        [else 0]))

#|
Evaluate an infix expression by converting it to postfix and then evaluating the postfix expression
|#
(define/contract (infix lst)
    (-> list? number?)
    (eval-rpn (in->postfix lst) '()))

(display "(in->postfix '(2 / 5)) -> '(2 5 /): ")
(in->postfix '(2 / 5))
(display "(in->postfix '(1 * 2 + 3)) -> '(1 2 * 3 +): ")
(in->postfix '(1 * 2 + 3))
(display "(in->postfix '(1 + 2 * 3)) -> '(1 2 3 * +): ")
(in->postfix '(1 + 2 * 3))
(display "(in->postfix '(1 + 2 * 3 / 4)) -> '(1 2 3 4 / * +): ")
(in->postfix '(1 + 2 * 3 / 4))
(display "(in->postfix '(2 * (3 + 4))) -> '(2 3 4 + *): ")
(in->postfix '(2 * "(" 3 + 4 ")"))
(display "(infix '(2 * (3 + 4))) -> 14: ")
(infix '(2 * "(" 3 + 4 ")"))
(display "(in->postfix '((4 - 7 + 9) * 3 - (4 + 5))) -> '(4 7 - 9 + 3 * 4 5 + - ): ")
(in->postfix '("(" 4 - 7 + 9 ")" * 3 - "(" 4 + 5 ")"))
(display "(infix '((4 - 7 + 9) * 3 - (4 + 5))) -> 9: ")
(infix '("(" 4 - 7 + 9 ")" * 3 - "(" 4 + 5 ")"))
