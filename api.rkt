#lang racket/base

(require (prefix-in ffi: "definitions.rkt"))
(require "constants.rkt")

(provide (all-from-out "constants.rkt"))
(provide (all-defined-out))

(define stdscr (make-parameter #f))

(define (attron #:win [win (stdscr)] . attrs)
  (ffi:wattron win (foldl (lambda (attr res)
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
  (integer->char (ffi:wgetch win)))

(define (border #:win [win (stdscr)]
                 [ch0 0] [ch1 0] [ch2 0] [ch3 0]
                 [ch4 0] [ch5 0] [ch6 0] [ch7 0])
  (ffi:wborder win ch0 ch1 ch2 ch3 ch4 ch5 ch6 ch7))

(define (getmaxyx [win (stdscr)])
  (values (ffi:getmaxy win) (ffi:getmaxx win)))
(define (get-curyx win)
  (values (ffi:getcury win) (ffi:getcurx win)))

(define (echo opt)
  (if opt
    (ffi:echo)
    (ffi:noecho)))

(define attr_get ffi:attr_get)
(define initscr ffi:initscr)
(define keypad ffi:keypad)
(define init-pair! ffi:init_pair)
(define attrset! ffi:attrset)
(define (color-pair n)
  (arithmetic-shift n 8))

(define (with-ncurses func
                      #:color? [color? #t]
                      #:echo?  [echo? #f])
  (stdscr (initscr))
  (when (and (ffi:has_colors) color?)
    (ffi:start_color))
  (unless echo?
    (ffi:noecho))
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
