#lang racket
(require "api.rkt")

(define (test)
  (define-values (screen-height screen-width)
                 (getmaxyx))
  (define-values (centre-y centre-x)
                 (values (quotient screen-height 2)
                         (quotient screen-width 2)))
  (init-pair! 1 COLOR_WHITE COLOR_RED)
  (addch #\Y (color-pair 1) A_BOLD #:y centre-y
                                   #:x (sub1 centre-x))
  (getch))

(with-ncurses test)
