{-# OPTIONS_GHC -Wall #-}
module HW01 where

-- Exercise 1 -----------------------------------------

-- Get the last digit from a number
lastDigit :: Integer -> Integer
lastDigit = read.(:"").last.show

-- Drop the last digit from a number
dropLastDigit :: Integer -> Integer
dropLastDigit ds =
  let ds' = init.show $ ds
  in if not.null $ ds'
     then read ds'
     else 0

-- Exercise 2 -----------------------------------------

toRevDigits :: Integer -> [Integer]
toRevDigits i | i  > 0 = map (read.(:[])) . reverse . show $ i
toRevDigits _ = []

toDigits :: Integer -> [Integer]
toDigits = reverse . toRevDigits

-- Exercise 3 -----------------------------------------

-- Double every second number in a list starting on the left.
doubleEveryOther :: [Integer] -> [Integer]
doubleEveryOther ns = zipWith (*) ns $ cycle [1,2]

-- Exercise 4 -----------------------------------------

-- Calculate the sum of all the digits in every Integer.
sumDigits :: [Integer] -> Integer
sumDigits = sum . concatMap toDigits

-- Exercise 5 -----------------------------------------

-- Validate a credit card number using the above functions.
luhn :: Integer -> Bool
luhn ns = (==) 0 .(`mod` 10).sumDigits.doubleEveryOther $ shiftedNs
  where shiftedNs = lastDigit ns : toDigits ( dropLastDigit ns)

-- Exercise 6 -----------------------------------------

-- Towers of Hanoi for three pegs
type Peg = String
type Move = (Peg, Peg)

hanoi :: Integer -> Peg -> Peg -> Peg -> [Move]
hanoi = undefined
