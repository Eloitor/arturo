firstAndLastIs3?: function [n][
    if not? prime? n -> return false
    return and? -> 3 = first digits n
                -> 3 = last digits n
]

primesWithFirstAndLast3: select 1..4000 => firstAndLastIs3?

nofPrimesBelow1M: enumerate 1..1000000 => firstAndLastIs3?

loop split.every: 11 primesWithFirstAndLast3 'x ->
    print map x 's -> pad to :string s 5

print ""
print ["Found" nofPrimesBelow1M "primes starting and ending with 3 below 1000000."]