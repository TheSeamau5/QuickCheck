import Random (..)
import QuickCheck (..)
import Text (..)

add x y = x + y

condition = (\x -> (add x -x) == 0)

randomGenerator = float 0 100

numberOfCases = 100

main = asText <| quickCheck randomGenerator numberOfCases condition
