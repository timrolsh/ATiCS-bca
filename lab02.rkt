#lang racket

#|
Return the nth element of the list. The list is 0 indexed (list[0] returns first element in the list. If index is out
of bounds, return null. Recursion base case: n = 0, return the car of the current node.
|#
(define (get-element list n) (cond ((null? list) null) ((equal? 0 n) (car list)) (else (get-element (cdr list) (- n 1)))))
