#|
Tim Rolshud
ATiCS Period 3
22 November 2022
Lab 01
|#

#lang racket

#|
function one implementation and tests
|#
(define (one m b)
  b
  )
(display "(one 2 3) -> 3: ")
(one 2 3)
(display "(one 0 0) -> 0: ")
(one 0 0)

#|
function two implementation and tests
|#
(define (two m b)
  (/ (* -1 b) m))
(display "(two 1 5) -> -5: ")
(two 1 5)
(display "(two 1 0) -> 0: ")
(two 1 0)

#|
function three implementation and tests
|#
(define (three m b )
  (abs (* b (two m b))))
(display "(three 2 6) -> 18: ")
(three 2 6)
(display "(three -5.0 -9.0) -> 16.2): ")
(three -5.0 -9.0)

#|
function modadd (four) implementation and tests
|#
(define (modadd low high current addnum)
  (+ (modulo (+ (- current low) addnum)(+(- high low) 1)) low)
  )
(display "(modadd 4 7 5 3) -> 4: ")
(modadd 4 7 5 3)
(display "(modadd -2 1 0 3) -> -1: ")
(modadd -2 1 0 3)


#|
function modsub (five) implementation and tests
This funcion is the modadd function except instead of adding you are subtracting, so you can simply call modadd with
the negative of the number that you want to add, or in this case, subtract. 
|#
(define (modsub low high current subnum)
  (modadd low high current (* -1 subnum))
  )
(display "(modsub 4 7 5 2) -> 7: ")
(modsub 4 7 5 2)

#|
function addtime (six) implementation and tests
|#
(define (addtime time mins)
  
  (define oldMins (modulo time 100)) 
  (define oldHours (quotient time 100))
  (define newHours (modadd 1 12 12 (+ (quotient (+ oldMins mins) 60) oldHours)))
  (define newMins (modadd 0 59 oldMins mins)) 
  (+ (* 100 newHours) newMins)
  )
(display "(addtime 130 35) -> 205: ")
(addtime 130 35)
(display "(addtime 1259 1) -> 100: ")
(addtime 1259 1)
(display "(addtime 1159 1) -> 1200: ")
(addtime 1159 1)
