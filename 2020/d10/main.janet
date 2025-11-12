(def adapters (seq [line :iterate (file/read stdin :line)]
                (scan-number (string/trim line))))

(def sorted-adapters (sorted adapters))
(array/insert sorted-adapters 0 0)
(array/push sorted-adapters (+ (last sorted-adapters) 3))

(defn part1
  [xs]
  (var three-count 0)
  (var one-count 0)
  (eachp [i val] (slice xs 1)
    (def prev (xs i))
    (def diff (- val (xs i)))
    (cond
      (= diff 1) (++ one-count)
      (= diff 3) (++ three-count)))
  (* three-count one-count))

(defn part2
  [xs]
  (def perms @[1])
  (for i 1 (length xs)
    (put perms i 0)
    (loop [j :in (reverse (range i))
           :while (<= (- (xs i) (xs j)) 3)]
      (put perms i (+ (perms i) (perms j)))))
  (last perms))


(print "Part 1: " (part1 sorted-adapters))
(print "Part 2: " (part2 sorted-adapters))
