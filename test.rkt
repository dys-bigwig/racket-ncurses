#lang racket
(require "api.rkt")

(define (test)
  (define-values (screen-height screen-width)
                 (getmaxyx))
  (define centre-y (quotient screen-height 2))
  (define centre-x (quotient screen-width 2))
  (define incantation "ABRACADABRA")
  (init-pair! 1 COLOR_WHITE COLOR_RED)
  (attron (bitwise-ior A_BLINK A_BOLD) #:color 1)
  (addstr "ABRACADABRA" #:y centre-y #:x (- centre-x
                                            (string-length incantation)))
  (getch))

(with-ncurses test)
