import Random (..)
import QuickCheck (..)
import Text (..)

-- This should always return True no matter what
condition = (\x -> x == x)

randomGenerator = float 0 1

numberOfTestCases = 100

main = asText <| quickCheck randomGenerator numberOfTestCases condition
