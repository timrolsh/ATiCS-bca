#|
Tim Rolshud, David Lee
ATiCS Period 3
5 April 2023
FSM Lab
|#

#lang racket
(define MAX_DEPTH 50)

#|
Given a state and the accept states for an FSM, return whether the current state is a final state
|#
(define/contract 
    (at-final-state? state accept-states)
    (-> any/c list? boolean?)
    (list? (member state accept-states)))

#|
Given a state, a transition from that state, and all of the transitions for the FSM, return a list
of all of the next possible states that the machine could be at. For DFAs, this list will always be
length of one, as a transition can only point to one other state. However, for NFAs, this list can
be of any size as one transition can point to multiple different states in an NFA. 
|#
(define/contract
    (next-states state transition transitions)
    (-> any/c string? list? list?)
    (define current-set (list-ref transitions 0))
    (cond  
        [(and (equal? state (list-ref current-set 0)) (equal? transition (list-ref current-set 1)))
            (cond
                [(not (list? (list-ref current-set 2))) (cons (list-ref current-set 2) null)]
                [else (list-ref current-set 2)])]
        [else (next-states state transition (cdr transitions))]))

#|
Given an element, a number of times to copy that element, and an empty list, return a list of that
element copied that number of times. Used in the map function when making recurisve calls to FSM
helper and using transitions to get to new states. 
|#
(define/contract 
    (copied-element-list element number final-list)
    (-> any/c number? list? list?)
    (cond
        [(equal? number 0) final-list]
        [else (copied-element-list element (- number 1) (cons element final-list))]))

#|
Given a list of booleans, or them all together and return the final boolean. Used after the map 
returns a list of booleans to see if any of the transitions resolved to a final state in the FSM.
|#
(define/contract 
    (or-list boolean-list)
    (-> list? boolean?)
    (cond
        [(empty? boolean-list) #f]
        [else (or (car boolean-list) (or-list (cdr boolean-list)))]))

#|
Main helper function for FSM, will work with both DFAs and NFAs. Treats a DFA as an NFA with only one
possible next state for every transition. The helper functions for this functions such as next-states
will pre-process function parameters before feeding them into this function. 
|#
(define/contract 
    (FSM-helper input-string states state transitions accept-states depth)
    (-> string? list? any/c list? list? number? boolean?)
    (cond
        [(> depth MAX_DEPTH) #f]
        [(equal? (string-length input-string) 0) (at-final-state? state accept-states)]
        [else
            (define next-state-list (next-states state (substring input-string 0 1) transitions))
            (define next-length (length next-state-list))
            (define recurse-map
                (map FSM-helper
                    (copied-element-list (substring input-string 1) next-length null)
                    (copied-element-list states next-length null)
                    next-state-list
                    (copied-element-list transitions next-length null)
                    (copied-element-list accept-states next-length null)
                    (copied-element-list (+ 1 depth) next-length null)))
            (or-list recurse-map)]))

#|
Given an input string and the five parameters of a DFA, evaluate the DFA and test if it accepts.
|#
(define/contract 
    (DFA input Sigma S s0 delta F)
    (-> string? list? list? any/c list? list? boolean?)
    (FSM-helper input S s0 delta F 0))

#|
Given an input string and the five parameters of a NFA, evaluate the NFA and test if it accepts.
|#                
(define/contract 
    (NFA input Sigma Q q0 Delta F)
    (-> string? list? list? any/c list? list? boolean?)
    (FSM-helper input Q q0 Delta F 0))


#|
TESTS
|#
(define/contract
    (DFA-tester input-string)
    (-> string? boolean?)
    (DFA input-string '("1" "0") '(q0 q1) 'q0 
        '((q0 "0" q0) (q0 "1" q1) (q1 "0" q1) (q1 "1" q1)) '(q1)))
(displayln "Testing the given DFA with various input strings:")
(display "(DFA \"00000000\") -> #f: ")
(displayln (DFA-tester "00000000"))
(display "(DFA \"00001\") -> #t: ")
(displayln (DFA-tester "00001"))
(display "(DFA \"000010101010101001\") -> #t: ")
(displayln (DFA-tester "000010101010101001"))

(define/contract
    (NFA-tester input-string)
    (-> string? boolean?)
    (NFA input-string '("a" "b") '(t1 t2 t3 t4 NA) 't1 
        '((t1 "b" (t1)) (t1 "a" (t1 t2)) (t2 "b" (t3)) (t2 "a" (NA)) (t3 "b" (NA)) (t3 "a" (t4)) 
            (t4 "a" (t4)) (t4 "b" (t4)) (NA "a" (NA)) (NA "b" (NA))) 
        '(t4)))
(displayln "Testing the given NFA with various input strings:")
(display "(NFA \"aaab\") -> #f: ")
(displayln (NFA-tester "aaab"))
(display "(NFA \"aba\") -> #t: ")
(displayln (NFA-tester "aba"))
(display "(NFA \"abaabababbaba\") -> #t: ")
(displayln (NFA-tester "abaabababbaba"))
