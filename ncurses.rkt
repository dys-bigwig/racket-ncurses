(module ncurses racket/base
  (require "curses-ffi.rkt")

  (define addch 
    (case-lambda
      [(ch)
       (let ([ch (char->integer ch)])
         (curses:addch ch))]
      [(ch attr)
       (let ([ch (char->integer ch)])
         (curses:addch (bitwise-ior ch attr)))]
      [(y x ch)
       (let ([ch (char->integer ch)])
         (curses:mvaddch y x (bitwise-ior ch A_NORMAL)))]
      [(y x ch attr) 
       (let ([ch (char->integer ch)])
         (curses:mvaddch y x (bitwise-ior ch attr)))]))

  (define getch
    (case-lambda
      [() (curses:getch)]
      [(win) (curses:wgetch win)]))

  ;  (define rkt_waddch
  ;    (case-lambda
  ;      [(win ch)
  ;       (let ([ch (char->integer ch)])
  ;         (waddch win ch))]
  ;      [(win ch attr)
  ;       (let ([ch (char->integer ch)])
  ;         (waddch win (bitwise-ior ch attr)))]
  ;      [(win y x ch)
  ;       (let ([ch (char->integer ch)])
  ;         (mvwaddch win y x (bitwise-ior ch A_NORMAL)))]
  ;      [(win y x ch attr)
  ;       (let ([ch (char->integer ch)])
  ;         (mvwaddch win y x (bitwise-ior ch attr)))]))
  ;
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
  ;  (define (add_border [ch0 0] [ch1 0] [ch2 0] [ch3 0]
  ;                      [ch4 0] [ch5 0] [ch6 0] [ch7 0])
  ;    (border ch0 ch1 ch2 ch3 ch4 ch5 ch6 ch7))
  ;
  ;  (define (getmaxyx win)
  ;    (values (getmaxy win) (getmaxx win)))

  (define addstr curses:addstr)
  (define attrset curses:attrset)
  (define initscr curses:initscr)
  (define endwin curses:endwin)

  (define (with-ncurses func)
    (define stdscr (initscr))
    (define init? #t)
    (define (cleanup!)
      (when init?
        (endwin)
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

  (define (test)
    (initscr)
    (for ([atr (in-cycle `(,A_REVERSE ,A_NORMAL))]
          [ch (string->list "ABRACADABRA")])
      (addch ch atr))
    (getch)
    (endwin))

  (with-ncurses test)
  )
