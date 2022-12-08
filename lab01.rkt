#|
Tim Rolshud
ATiCS Period 3
22 November 2022
Lab 01
|#

#lang racket

#|
1. Return the y intercept of a function given slope m and y intercept b.
|#
(define (y-intercept m b)
    b)
(display "(y-intercept 2 3) -> 3: ")
(y-intercept 2 3)
(display "(y-intercept 0 0) -> 0: ")
(y-intercept 0 0)

#|
2. Return x coordinate of x intercept of function given slope m and y intercept b.
|#
(define (x-intercept m b)
    (/ (* -1 b) m))
(display "(x-intercept 1 5) -> -5: ")
(x-intercept 1 5)
(display "(x-intercept 1 0) -> 0: ")
(x-intercept 1 0)

#|
3. Return the area of the triangle formed by the line intersecting the x and y axis.
|#
(define (line-triangle m b)
    (abs (* b (x-intercept m b))))
(display "(line-triangle 2 6) -> 18: ")
(line-triangle 2 6)
(display "(line-triangle -5.0 -9.0) -> 16.2): ")
(line-triangle -5.0 -9.0)

#|
4. Return the modadd given the lower bound (low), higher bound (high), current number (current), and how much you want
to add (addnum).
|#
(define (modadd low high current addnum)
    (+ (modulo (+ (- current low) addnum) (+ (- high low) 1)) low))
(display "(modadd 4 7 5 3) -> 4: ")
(modadd 4 7 5 3)
(display "(modadd -2 1 0 3) -> -1: ")
(modadd -2 1 0 3)

#|
5. return the modadd by adding the opposite of the number you wish to subtract (achieves the same effect as subtracting
that number).
|#
(define (modsub low high current subnum)
    (modadd low high current (* -1 subnum)))
(display "(modsub 4 7 5 2) -> 7: ")
(modsub 4 7 5 2)
(display "(modsub 4 7 6 1) -> 5: ")
(modsub 4 7 6 1)

#|
6. If the time is a number with the last 2 digits being minutes and first 1 or 2 digits being the hours, add a certain
amount of minutes to that time.
|#
(define (addtime time mins)
    (define oldMins (modulo time 100))
    (define oldHours (quotient time 100))
    (define newHours (modadd 1 12 12 (+ (quotient (+ oldMins mins) 60) oldHours)))
    (define newMins (modadd 0 59 oldMins mins))
    (+ (* 100 newHours) newMins))
(display "(addtime 130 35) -> 205: ")
(addtime 130 35)
(display "(addtime 1259 1) -> 100: ")
(addtime 1259 1)
(display "(addtime 1159 1) -> 1200: ")
(addtime 1159 1)
