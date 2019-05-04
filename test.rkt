#lang rackjure
(require ncurses)

(define (test)
  (define-values (screen-height screen-width) (getmaxyx))
  (define the-string "ABRACADABRA")
  (define centre-y (quotient screen-height 2))
  (define centre-x (- (quotient screen-width 2) (string-length the-string)))
  (addchstr the-string #:y centre-y #:x centre-x #:atr A_UNDERLINE)
  (getch))

(with-ncurses test)
