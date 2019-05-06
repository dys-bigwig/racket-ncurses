#lang racket/base

(require (prefix-in ffi: "definitions.rkt"))
(require "constants.rkt")

(provide (all-from-out "constants.rkt"))
(provide (all-defined-out))

(define stdscr (make-parameter #f))

(define (attron . attrs)
  (ffi:attron (foldl (lambda (attr res)
                       (bitwise-ior attr res))
                     0
                     attrs)))

(define (addstr str #:win [win (stdscr)]
                    #:y [y (ffi:getcury win)]
                    #:x [x (ffi:getcurx win)]
                    #:n [n -1])
  (ffi:mvwaddnstr win y x str n))

(define (get-cursor-y [win (stdscr)])
  (ffi:getcury win))

(define (get-cursor-x [win (stdscr)])
  (ffi:getcurx win))

(define (addchstr str
                  #:win [win (stdscr)]
                  #:y [y (ffi:getcury win)]
                  #:x [x (ffi:getcurx win)]
                  . attrs)
  (let ([chlist (map (lambda (ch)
                       (foldl (lambda (attr res)
                                (bitwise-ior attr
                                             res))
                              (char->integer ch)
                              attrs))
                     (string->list str))]) 
    (ffi:mvwaddchstr win y x (ffi:chlist->chstr chlist))))

(define (addch ch #:win [win (stdscr)]
                  #:y [y (ffi:getcury win)]
                  #:x [x (ffi:getcurx win)]
                  . attrs)
  (let ([ch (foldl (lambda (attr res)
                     (bitwise-ior attr
                                  res))
                   (char->integer ch)
                   attrs)])
    (ffi:mvwaddch win y x ch)))

(define (getch [win (stdscr)])
  (ffi:wgetch win))

; (define addch
;   (case-lambda
;     [(win ch)
;      (let ([ch (char->integer ch)])
;        (ffi:waddch win ch))]
;     [(win ch attr)
;      (let ([ch (char->integer ch)])
;        (ffi:waddch win (bitwise-ior ch attr)))]
;     [(win y x ch)
;      (let ([ch (char->integer ch)])
;        (ffi:mvwaddch win y x (bitwise-ior ch A_NORMAL)))]
;     [(win y x ch attr)
;      (let ([ch (char->integer ch)])
;        (ffi:mvwaddch win y x (bitwise-ior ch attr)))]))

;  (define rkt_addstr
;    (case-lambda
;      [(str) (addstr str)]
;      [(str attr)
;       (attron attr)
;       (addstr str)
;       (attroff attr)]
;      [(y x str) (mvaddstr y x str)]
;      [(y x str attr)
;       (attron attr)
;       (mvaddstr y x str)
;       (attroff attr)]))
;
;  (define rkt_waddstr
;    (case-lambda
;      [(win str) (waddstr str)]
;      [(win str attr)
;       (attron attr)
;       (waddstr win str)
;       (attroff attr)]
;      [(win y x str) (mvwaddstr win y x str)]
;      [(win y x str attr)
;       (wattron win attr)
;       (mvwaddstr win y x str)
;       (wattroff win attr)]))
;

(define (border [ch0 0] [ch1 0] [ch2 0] [ch3 0]
                [ch4 0] [ch5 0] [ch6 0] [ch7 0])
  (ffi:border ch0 ch1 ch2 ch3 ch4 ch5 ch6 ch7))

(define (getmaxyx [win (stdscr)])
  (values (ffi:getmaxy win) (ffi:getmaxx win)))
(define (get-curyx win)
  (values (ffi:getcury win) (ffi:getcurx win)))

(define attr_get ffi:attr_get)
(define initscr ffi:initscr)
(define keypad ffi:keypad)
(define init-pair! ffi:init_pair)
(define attrset! ffi:attrset)
(define (color-pair n)
  (arithmetic-shift n 8))

(define (with-ncurses func
                      #:color [color #t])
  (stdscr (initscr))
  (when (and (ffi:has_colors) color)
    (ffi:start_color))
  (define init? #t)
  (define (cleanup!)
    (when init?
      (ffi:endwin)
      (set! init? #f)))
  (call-with-exception-handler
    (lambda (exn)
      (cleanup!)
      exn)
    (lambda ()
      (call-with-continuation-barrier
        (lambda ()
          (dynamic-wind
            void
            (lambda () (void (func)))
            cleanup!))))))
