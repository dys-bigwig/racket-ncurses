#lang racket/base

(require (prefix-in ffi: "definitions.rkt"))
(require "constants.rkt")

(provide (all-from-out "constants.rkt"))
(provide (all-defined-out))

(define (fold-attrs attrs)
  (foldr bitwise-ior 0 attrs))

(define stdscr (make-parameter #f))

(define (attron #:win [win (stdscr)] . attrs)
  (ffi:wattron win (fold-attrs attrs)))

(define (addstr str
                #:win [win (stdscr)]
                #:y   [y (ffi:getcury win)]
                #:x   [x (ffi:getcurx win)]
                #:n   [n -1]
                . attrs)
  (let ([previous-attrs (fold-attrs (ffi:attr_get))])
    (parameterize ([stdscr win])
      (apply attron attrs)
      (ffi:mvwaddnstr win y x str n)
      (attr-set! previous-attrs))))

(define (addchstr str
                  #:win [win (stdscr)]
                  #:y   [y (ffi:getcury win)]
                  #:x   [x (ffi:getcurx win)]
                  . attrs)
  (let* ([attrs (fold-attrs attrs)]
         [chlist (for/list ([ch (string->list str)])
                   (bitwise-ior (char->integer ch) attrs))]) 
    (ffi:mvwaddchstr win y x (ffi:chlist->chstr chlist))))

(define (addch ch #:win [win (stdscr)]
               #:y [y (ffi:getcury win)]
               #:x [x (ffi:getcurx win)]
               . attrs)
  (let ([ch (bitwise-ior (char->integer ch)
                         (fold-attrs attrs))])
    (ffi:mvwaddch win y x ch)))

(define (getch #:win [win (stdscr)])
  (ffi:wgetch win))

(define (border #:win [win (stdscr)]
                #:ch0 [ch0 0] #:ch1 [ch1 0] #:ch2 [ch2 0] #:ch3 [ch3 0]
                #:ch4 [ch4 0] #:ch5 [ch5 0] #:ch6 [ch6 0] #:ch7 [ch7 0])
  (ffi:wborder win ch0 ch1 ch2 ch3 ch4 ch5 ch6 ch7))

(define (getmaxyx [win (stdscr)])
  (values (ffi:getmaxy win) (ffi:getmaxx win)))
(define (get-curyx win)
  (values (ffi:getcury win) (ffi:getcurx win)))

(define echo! ffi:echo)
(define noecho! ffi:noecho)

(define curs-set ffi:curs_set)
(define newwin ffi:newwin)
(define delwin ffi:delwin)
(define (refresh #:win [win (stdscr)])
  (ffi:wrefresh win))
(define keypad ffi:keypad)
(define init-pair! ffi:init_pair)
(define attr-set! ffi:attrset)
(define (color-pair n)
  (arithmetic-shift n 8))

(define (with-ncurses func
                      #:start-color? [start-color? #t])
  (stdscr (ffi:initscr))
  (when (and (ffi:has_colors) start-color?)
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
            (λ () (void (func)))
            cleanup!))))))
