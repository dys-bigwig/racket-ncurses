#lang racket
(require ncurses)

(define (test)
  (noecho!)
  (curs-set 0)
  (border)
  (define-values (screen-height screen-width)
    (getmaxyx))
  (init-pair! 1 COLOR_WHITE COLOR_RED)
  (let ([ch (getch)])
  (addstr (format "YOU PRESSED ~a!" ch)
          
            (color-pair 1) A_BOLD A_UNDERLINE
            #:y (quotient screen-height 2)
            #:x (quotient (- screen-width
                             (string-length "YOU PRESSED ~a!"))
                          2)))
  (define foowin (newwin 10 10 4 4))
  (addstr "WIZARDS" #:win foowin)
  (refresh)
  (getch #:win foowin)
  (delwin foowin))

(with-ncurses test)
