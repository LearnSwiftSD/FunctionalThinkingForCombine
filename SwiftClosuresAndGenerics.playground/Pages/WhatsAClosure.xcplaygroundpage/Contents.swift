/*:
 [Home](Welcome) | [Previous](@previous) | [Next](@next)
 
 ## What's a Closure?

 Well according to the [Swift Programming Guide](https://docs.swift.org/swift-book/LanguageGuide/Closures.html),
 *"Closures are self-contained blocks of functionality that can be passed around and used in your code."* The
 guide also mentions a couple of scenarios where it may or may not capture. However, most developers think of
 the following example as a closure.
 
 ![Common Closure](ClosureExample.png "Example of a Common Closure")
 
 If we really want to get technical, the above example is not really a closure. For those of you who are nerdy like
 me, you probably want to know the technical definition which diverges a bit from the Swift definition.
 
 ___
     
 _To "properly" qualify as a closure, the function, irrelevant of syntax needs to enclose upon (also known
 as capturing) at least one free variable within its lexical environment. This narrow definition is also known as a
 **Lexical Closure**. These Lexical Closures are said to be equivilent to what we know as Objects._
 
 ___
 
 ### A Practical Definition
 
 With all those technicalities aside, you'll find most devs more practically defining a closure as:
 
 1. Inline (sometimes called anonymous) function contained between `{  }`
 2. Doesn't use the `func` keyword
 3. Uses distinct capture syntax and capabilities
 4. Can use shorthand argument notation (`$0`, `$1`, `$2`, etc.)
 5. Can be passed around and stored like a variable

 To be fair normal `func` keyword using functions can also be stored and passed around like a variable, its just
 that they seem to be less known or used in that capacity. In fact they share the same type signature pattern and
 apart from a few distinct capabilities "normal" functions and closures are essentially the same.
 
 ___
 
 ### Let's discuss Closures Type Signatures

 ![Closure Signature](ClosureSignature.png "Anatomy of a Closure Signature")
 
 How do we read this??? 🤷‍♂️
 
 It **all** breaks down to 2 things:
 - **Inputs**: Represented by anything in the parentheses `(Inputs)`
 - **Outputs**: Represented by anything after the Arrow `-> Outputs`
 
 When building these, both the Inputs and the Outputs can be any type of your choosing. The way you read it
 outloud is, "The type takes an *Input* and returns an *Output* ". For example if we had the following:
 
     let someClosureType: (String, Int) -> Int
 
 We would read this as "someClosureType takes a `String` and an `Int` and returns an `Int`."
 
 ___
 
 ### Let's discuss Explicit Closures Implementations
 
 ![Explicit Closure](ExplicitClosure.png "Anatomy of an Explicit Closure")
 
 */

typealias TypeA = Int
typealias TypeB = Int
typealias TypeC = Bool

var closure: (_ inputA: TypeA, _ inputB: TypeB) -> TypeC

extension TypeA {

    func getC(from inputB: TypeB) -> TypeC {
        self.isMultiple(of: inputB)
    }

}

closure = { (inputA: TypeA, inputB: TypeB) -> TypeC in return inputA.getC(from: inputB) }

PGAssertTrue(closure(30, 15))

func number(_ inputA: TypeA, isGreaterThan inputB: TypeB) -> TypeC {
    inputA > inputB
}

PGAssertTrue(number(14, isGreaterThan: 3))

PGAssertEqualTypes(closure, number(_:isGreaterThan:))

PGAssertFalse(closure(14, 3))

closure = number(_:isGreaterThan:)

PGAssertTrue(closure(3, 2))

/*: ___
 
 ### Let's discuss Implicit Closure Implementations

 This next example is the same closure, but this time Swift's type inference will be applied and we'll be using
 shorthand arguments to strip away a lot of the noise.
 
 ![Implicit Closure](ImplicitClosure.png "Anatomy of an Implicit Closure")
 
 These shorthand (sometimes called anonymous) arguments might look odd or even foreign but none the less
 they do follow a standard that can be found in Shell scripting called *positional arguments*. Given how
 pervasive scripting is amongst developers, shorthand argument notation is considered to be common
 knowledge to some people's dismay.
 
 ### Understanding Shorthand Argument Notation
 
 The best way that I can come to describe it is to think of it like:
 
 1. Your arguments are now an ordered list
 
 `let arguments = [FirstArg, SecondArg, ThirdArg]`
 
 2. To access them, you'll need to subscript the arguments list
 
 `let firstArgument = arguments[0]`
 
 3. Instead of referencing the arguments list, you replace it with a `$` and you remove the brackets
 
 `let firstArgument = $0`
 
 The other thing to keep in mind is that the `Type`s of the elements (parameters) are the same as what were
 passed in, which would make this a heterogenous list but types are known at compile time so you don't have to
 worry about type safety.
 
 Let's try it out.
 */

// Implicit Closure Implementations

closure = { inputA, inputB in return inputA.getC(from: inputB) }

PGAssertTrue(closure(12, 2))

closure = { $0.getC(from: $1) }

PGAssertTrue(closure(12, 2))

closure = { _, _ in return false }

PGAssertFalse(closure(2, 12))

/*: ___
 
 ### Let's discuss Capture Lists
 
 One of the advantages that closures have over normal functions is that you have greater control in how things are captured.
 
 *Q. What is capturing?*
 
 *A. It's when a function refers to a constant or variable that is defined outside of itself.*
 
 ![Closure Capture List](CaptureList.png "Anatomy of a Closure's Capture List")
 
 
 */

// Capture List Implementations

class SomeClass { }

let stronglyHeld = SomeClass()

var weaklyHeld = SomeClass()

var notHeldAtAll: SomeClass? = SomeClass()

closure = { [s = stronglyHeld, weak w = weaklyHeld, unowned u = notHeldAtAll] _, _ in
    describe(s).printed()
    describe(w).printed()
    describe(u).printed()
    return true
}

//notHeldAtAll = nil
//PGAssertNil(notHeldAtAll)

//weaklyHeld = nil
//PGAssertNil(weaklyHeld)

closure(1, 1)


/*: ___
 
 ### Functions versus Closures
 
 We mentioned earlier that functions and closures are basically the same except for a few small details.
 
 - Standard functions have implicit capture of self
 - Standard functions can only capture strongly
 
 This isn't all the bad unless you start passing functions around like first class citizens of the language. There are
 a few things we have to keep an eye out for in these scenarios. Lets take a look.
 
 */

// Class Method Implementations

class Example {
    
    var count: Int = 0
    
    //self Strongly
    func increment() -> Int {
        count += 1
        return count
    }
    
    var weakIncrement: () -> Int {
        return { [weak self] in
            guard let self = self else { return 0 }
            self.count += 1
            return self.count
        }
    }
    
}

var exmplIncr: () -> Int

var example: Example? = Example()


exmplIncr = example?.weakIncrement ?? { 0xDEADBEEF }

exmplIncr()

example = nil

exmplIncr()

PGAssertNil(example)

/*: ___
 
 ### What is this Auto closure thingy?
 
 Autoclosure is an atribute that can be applied to closures in the for of `@autoclosure`.  You really don't come
 across it too often but it's still nice to know what it does so it doesn't throw you in for a loop.
 
 It basically enables late (or just in time rather) evaluation. Essentially you can provide an expression of function
 and it won't be evaluated until the very moment that it's needed which is great for certain scenarios. This comes in
 handy for a lot of utility or helper functions which is why you end up finding it used alot in assertions, testing
 methods and other utilities.
 
 Let's try it out.
 
 */

// @autoclosure Implementations
func autoFunction<T>(_ evaluate: @autoclosure () -> T ) {
    "Start".printed()
    describe(evaluate()).printed()
    "Finish".printed()
}

func getNumber() -> Int {
    "Executed".printed()
    return 12
}

autoFunction(getNumber())


/*: ___
 
 ### To @escaping or to withoutActuallyEscaping...
 
 So there are actually a lot of seasoned developers out there that still aren't able to describe what an escaping
 function is. It's actually a really simple concept that boils down to scope. Does the work of the function get
 down inside of the scope that it is passed into or does it get passed somewhere else where the work can be
 done at a later time? If you can answer that, then you can say if it escapes or not.
 
 */

// @escaping and withoutActuallyEscaping implementations

func closureAssigner(_ value: @escaping (TypeA, TypeB) -> TypeC) {
    closure = value
}


closureAssigner { $0.getC(from: $1) }

PGAssertTrue(closure(4, 2))

func evaluateWithSixAndTwo(_ value: ((TypeA, TypeB) -> TypeC)? = nil) -> TypeC {
    guard let value = value else { return false }
    return value(6, 2)
}

func nonEscaping(_ evaluate: (TypeA, TypeB) -> TypeC) -> TypeC {
    return  withoutActuallyEscaping(evaluate) { evaluateWithSixAndTwo($0) }
}

PGAssertTrue(nonEscaping { $0.getC(from: $1) })

describe(closureAssigner).printed()

/*: ___
 
 ### Closures composed of Closures?
 
 So we showed a little bit of higher ordered functions, but that's only the begining. Remember that closures
 are full blown types and they can be a part of another closures input and or output. Think of them like the structs
 that you build and how they are often composed of other structs like `Int`s, `Array`s (which is composed of
 other structs), `String`s which contains `Chars` and so forth. The composition realy depends on the use
 case, and it can get interesting to read some times but we can decompose them by their inputs and outputs.

 */

// Closures as inputs and outputs implementations

typealias TypeD = Int

//var 🧐: (TypeA, TypeB, @escaping (TypeA, TypeB) -> TypeC) -> (TypeA, TypeB, TypeD) -> TypeA

var 🧐: (
    TypeA, //Input 1
    TypeB, //Input 2
    @escaping ( //Input 3
        TypeA, //Input3.1
        TypeB // Input3.2
    ) -> TypeC // 3.O1

// This is output
) -> (
    TypeA,
    TypeB,
    TypeD
) -> TypeA

🧐 = { valueA, valueB, evaluator in
    return { anotherA, anotherB, anotherD in
        if evaluator(valueA, valueB) {
            return anotherA + anotherB + anotherD
        } else {
            return anotherA - anotherB - anotherD
        }
    }
}

func functionVersion(
    valueA: TypeA,
    valueB: TypeB ,
    evaluator: @escaping (TypeA, TypeB) -> TypeC
) -> (TypeA, TypeB, TypeD) -> TypeA {
    return { anotherA, anotherB, anotherD in
        if evaluator(valueA, valueB) {
            return anotherA + anotherB + anotherD
        } else {
            return anotherA - anotherB - anotherD
        }
    }
}

PGAssertEqual(🧐(6, 2, { $0.getC(from: $1) })(1,2,3), 6)
PGAssertEqual(🧐(6, 5, { $0.getC(from: $1) })(1,2,3), -4)

struct Person {
    let name: String
    let age: Int
    let hobby: String
}

let constructor: (@escaping (String, Int, String) -> Person) -> (String) -> (Int) -> (String) -> Person

constructor = { initializer in { name in { age in { hobby in initializer(name, age, hobby) } } } }

let personConstruct = constructor(Person.init)

describe(personConstruct("Stephen")(21)("Teaching Swift")).printed()


//: [Next](@next)
