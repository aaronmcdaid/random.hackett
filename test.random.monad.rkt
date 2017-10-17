#lang hackett

(require "random.monad.rkt") ;; to run this, you might need: "raco make random.monad.rkt  && echo && racket  test.random.monad.rkt"

(def first.prng.script
    (do
        [d1 <-  random-double ]
        (set-seed 1337)
        [i1 <- (random-integer 50 60)]
        [i2 <- (random-integer 50 60)]
        (set-seed 1337)
        [i3 <- (random-integer 50 60)]
        (set-seed 1)
        [d2 <-  random-double ]
        (pure {i1 tuple d1 tuple i2 tuple i3 tuple d2})))

(defn replicate-random : (forall [a] { Integer -> (PRNG a) -> (PRNG (List a))})
    [
        [how-many prng] (if {how-many == 0}
                            (pure nil)
                            (do [x <- prng] [xs <- (replicate-random { how-many - 1 } prng) ] (pure {x :: xs}))
                        )
    ])

(def one.dice (random-integer 1 7))

(def many.dice : (PRNG (List Integer))
    (replicate-random 100 one.dice)
)

(main (do
    { first.prng.script & run-prng & show & println }
    { many.dice                  & run-prng & show & println }
))

(def a (do
            (set-seed 1337)                 ; the default is 1, we just set it to 1337 instead here
            [i1 <- (random-integer 1 7)]    ; one roll of a dice
            [d1 <- random-double]           ; real number between 0 and 1
            (pure {i1 tuple d1})            ))

(main { a & run-prng & show & println })
