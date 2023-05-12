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
(display "(x-intercept -3 6) -> 2: ")
(x-intercept -3 6)
#|
3. Return the area of the triangle formed by the line intersecting the x and y axis.
|#
(define (triangle-area m b)
    (abs (* (y-intercept m b) (x-intercept m b))))
(display "(triangle-area 2 6) -> 18: ")
(triangle-area 2 6)
(display "(triangle-area -1 3) -> 9): ")
(triangle-area -1 3)
(display "(triangle-area -4 -12) -> 36): ")

#|
4. Return the modadd given the lower bound (low), higher bound (high), current number (current), and how much you want
to add (addnum).
|#
(define (modadd low high current addnum)
    (define low-high-range (+ (- high low) 1))
    (define total-add (+ (- current low) addnum))
    (+ (modulo total-add low-high-range) low))
(display "(modadd 4 7 5 2) -> 7: ")
(modadd 4 7 5 2)
(display "(modadd 4 7 5 3) -> 4: ")
(modadd 4 7 5 3)
(display "(modadd 4 7 5 0) -> 5: ")
(modadd 4 7 5 0)
(display "(modadd -2 1 0 3) -> -1: ")
(modadd -2 1 0 3)
(display "(modadd 3 3 3 10) -> 3: ")
(modadd 3 3 3 10)
(display "(modadd 0 9 5 1000) -> 5: ")
(modadd 0 9 5 1000)
(display "(modadd 4 7 5 -1) -> 4: ")
(modadd 4 7 5 -1)
(display "(modadd 4 7 5 -2) -> 7: ")
(modadd 4 7 5 -2)

#|
5. return the modadd by adding the opposite of the number you wish to subtract (achieves the same effect as subtracting
that number).
|#
(define (modsub low high current subnum)
    (modadd low high current (* -1 subnum)))
(display "(modsub 4 7 5 1) -> 4: ")
(modsub 4 7 5 1)
(display "(modsub 4 7 5 2) -> 7: ")
(modsub 4 7 5 2)
(display "(modsub 4 7 6 1) -> 5: ")
(modsub 4 7 6 1)
(display "(modsub 0 9 5 1000) -> 5: ")
(modsub 0 9 5 1000)
(display "(modsub 4 7 5 0) -> 5: ")
(modsub 4 7 5 0)

#|
6. If the time is a number with the last 2 digits being minutes and first 1 or 2 digits being the hours, add a certain
amount of minutes to that time.
|#
(define (addtime time mins)
    (define old-mins (modulo time 100))
    (define old-hours (quotient time 100))
    (define new-hours (modadd 1 12 12 (+ (quotient (+ old-mins mins) 60) old-hours)))
    (define newMins (modadd 0 59 old-mins mins))
    (+ (* 100 new-hours) newMins))
(display "(addtime 130 35) -> 205: ")
(addtime 130 35)
(display "(addtime 1258 1) -> 1259: ")
(addtime 1258 1)
(display "(addtime 1258 2) -> 100: ")
(addtime 1258 2)
(displayln "year-in minutes is defined as 525600, the amount of minutes")
(define year-in-minutes 525600)
(display "(addtime 1254 year-in-minutes) -> 1254: ")
(addtime 1254 year-in-minutes)
(display "(addtime 954 3600) -> 1154: ")
(addtime 954 7200)
(display "(addtime 1254 0) -> 1254: ")
(addtime 1254 0)
