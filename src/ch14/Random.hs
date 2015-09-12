import System.Random

BadRandoms :: RandomGen g => g -> (Int, Int)
twoBadRandoms gen = (fst $ randomIO gen, fst $ randomIO gen)
