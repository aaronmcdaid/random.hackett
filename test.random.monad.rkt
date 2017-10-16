#lang hackett

(require "random.monad.rkt")

(main (do
    [x <- random-double]
    [y <- (random-integer 3 8)]
    (println (show x))
    (println (show y))
))
