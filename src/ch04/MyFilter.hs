
filterOdds :: [Int] -> [Int]

filterOdds (x:xs) | odd x     = x : filterOdds xs
                  | otherwise = filterOdds xs
filterOdds _                  = []

