QuickCheck
==========

This is library is heavily inspired by Haskell's QuickCheck library and features a much simplified implementation 
of the quickcheck function in Elm.

### How to use ###

The quickCheck function helps automate the testing of functions. Suppose you created this super duper awesome
function to add two floats which you've, very creatively, called `add`
```elm
add : Float -> Float -> Float
add x y = x + y
```    
You'd like to test your awesome function to make sure it works but you have to come up with all these tests. That's
where `quickCheck` can help.

`quickCheck` will automatically create as many test cases as you want it to create using a random generator of your
choosing and test a condition that you think should be true about your function. 

For example, adding a positive number to minus itself should yield 0. Your `add` function wouldn't really be an add
function if that weren't the case.
```elm
condition = (\x -> (add x -x ) == 0)
```
To test this condition we could generate, say, 100 test cases and, for example, make a random generator that
generates floats between 0 and 100.
```elm
numberOfCases = 100
randomGenerator = float 0 100
```

So, if we run quickCheck with our inputs we get:

```elm
> quickCheck randomGenerator numberOfCases condition
"Ok, passed 100 tests."
```


But, suppose you made a little mistake in the definition of add and wrote this really bad add function called
`badadd`

```elm
badadd : Float -> Float -> Float
badadd x y = x - y
```

If you just change the condition from using `add` to using `badadd`:
```elm
condition = (\x -> (badadd x -x ) == 0)
```

and run quickCheck, we get:
```elm
> quickCheck randomGenerator numberOfCases condition
"The following input has failed the test : 35.92545985847839"
```

uh...oh...the function failed the test... But that's great, that means that you know that the `badadd` function
has a bug and thus you know where to look. Plus you have an example input that fails the test. This narrows down
your search space and makes debugging so much easier, faster, and more fun.
