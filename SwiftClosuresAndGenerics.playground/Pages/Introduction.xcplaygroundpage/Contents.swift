/*:
[Home](Welcome) | [Previous](@previous) | [Next](@next)

## Why Closures & Generics
 
 **Combine Operators**
 
 Here is probably one of the most common and simple of the Combine Operators, *Map*.
 
 ![Combine Map Operator](CombineMapOperator.png "Combine Map Operator")
 
 So why closures and generics? Well just look at the type signature of that operator. It's
 chalked full of generics like `T` and `Output` and `Self` 🧐. Thes letters and outputs
 might as well be **∆ 𝚵 𝚺 𝚹 𝚷** 🤷‍♂️. Then the very next thing we see is the parameter, which
 says transform and then `@escaping (Output) -> T`. That there is what we call
 closure syntax 😳.
 
 Closures and generics are basically the vocabulary of the language that Combine speaks in.
 Having a high degree of comfort in it will get us a long way towards thinking in Combine. To
 set a goal for ourselves, we want to be comfortable with looking at the following and being
 able to know exactly what's going on.
 
 */
typealias 🤯<A, B, C, D> = ((A, B, C) -> D) -> (A) -> (B) -> (C) -> D
/*:
 If you've never seen anything like that before, don't worry. And yes, this is indeed a
 useful piece of code with real word use cases. I assure you, it is not purely academic or
 expiremental. In fact, in some laguages it's used every time you construct something. It'll
 make sense after we break this down piece by piece.
 
 ___
 [Home](Welcome) | [Previous](@previous) | [Next](@next)
*/
