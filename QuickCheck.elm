module QuickCheck where

{-| Simplified QuickCheck implementation in Elm.

# QuickCheck
@docs quickCheck

-}

import Random (Generator, list, generate, initialSeed)
import List (map, filter, length, head)

{-| Generates a list of test cases from a list generator.
-}
generateTestCases : Generator (List a) -> List a
generateTestCases listGenerator =
  fst <| generate listGenerator (initialSeed 1)

{-| Constructs a case result tuple of the form (input, booleanResult)
The boolean result is true if the input passes the testing condition
and it is false if the input fails the testing condition

    constructCaseResultPair testingCondition input

Example:
    constructCaseResultPair (\x -> (x + 1) == x ) 4 == (4, False)
-}
constructCaseResultPair : (a -> Bool) -> a -> (a, Bool)
constructCaseResultPair testingCondition input =
  (input, testingCondition input)


{-| Filter all the failing cases from a list of case result tuples

Example:
    filterFailingCases [(3, True), (4, False), (5, False)] ==
      [(4, False), (5, False)]

-}
filterFailingCases : List (a, Bool) -> List (a, Bool)
filterFailingCases caseResultPairList =
  filter (\x -> (snd x) == False) caseResultPairList

{-| Constructs the success string. This is to be invoked only if all tests
have passed.
-}
constructSuccessString : Int -> String
constructSuccessString numberOfCases =
  "Ok, passed " ++ (toString numberOfCases) ++ " tests."


{-| Constructs the failing string. This is to be invoked only if the case
is a failing case. The function does not check if the case actually fails!
-}
constructFailingString : (a, Bool) -> String
constructFailingString failingCase =
  "The following input has failed the test : " ++ (toString <| fst failingCase)


{-| Constructs the test result string. This is the function you'd like to
invoke. It takes a list of case result tuples and checks if there are any
failing cases. If there are, it constructs a failing string out of the first
failing case it finds. Else, it constructs a success string.
-}
constructTestResultString : Int -> List (a, Bool) -> String
constructTestResultString numberOfCases caseResultPairList =
  let failingCases  = filterFailingCases caseResultPairList
  in
    if failingCases == []
    then constructSuccessString numberOfCases
    else constructFailingString <| head failingCases

{-| Generates a given number amount of test cases using a given random
generator and applies a given test condition to the generated test cases
to check if the testing condition is true. The obvious limitations of this
approach is that, since it relies on probabilities and random generation,
it can only hit so much from the test space. Also, it is only as smart as
the number generator it is given, as such, don't expect it to magically
shoot for edge cases.

Currently, it has an additional limitation of always constructing the same
tests each time and thus running the same test twice yields the same results.
This is due to the fact that it always uses the same seed for random generation.

    quickCheck randomGenerator numberOfCases testingCondition

Example:

    successfulCondition = (\x -> x == x)
    failingCondition = (\x -> (x + 1) == x)

    numberOfCases = 100
    randomGenerator = float 0 1

    quickCheck randomGenerator numberOfCases successfulCondition ==
      "Ok, passed 100 tests."

    quickCheck randomGenerator numberOfCases failingCondition ==
      "The following input has failed the test : 0.35925459858478387"

-}
quickCheck : Generator a -> Int -> (a -> Bool) -> String
quickCheck randomGenerator numberOfCases testingCondition =
    let listGenerator = list numberOfCases <| randomGenerator
        testCases = generateTestCases listGenerator
        caseResultPairList =
          map (constructCaseResultPair testingCondition) testCases
    in constructTestResultString numberOfCases caseResultPairList
