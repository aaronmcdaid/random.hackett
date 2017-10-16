#lang hackett

(require (only-in racket/base all-from-out for-syntax module submod))

(module shared hackett)

(provide random-integer random-double)

(module untyped racket/base
  (require hackett/private/util/require

           (prefix-in hackett: (combine-in hackett hackett/demo/pict (submod ".." shared)))
           (postfix-in - (combine-in 2htdp/universe pict racket/base racket/match racket/promise))

           (only-in hackett ∀ : -> Integer Double IO Unit)
           (only-in hackett/private/prim io unsafe-run-io!)
           hackett/private/prim/type-provide
           threading)

  (provide (typed-out
            [random-integer : {Integer -> Integer -> (IO Integer)}]
            [random-double : (IO Double)]
            ))

  (define ((random-integer low) high)
    (io (λ- (rw) ((hackett:tuple rw) (random- (force- low) (force- high))))))

  (define random-double
    (io (λ- (rw) ((hackett:tuple rw) (real->double-flonum- (random-))))))

)

(require (for-syntax racket/base)
         syntax/parse/define

         (submod "." shared)
         (submod "." untyped))

