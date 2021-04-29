/*:
[Home](Welcome) | [Previous](@previous) | [Next](@next)

## What's a Generic?

 Generics get used all throughout the Swift Language, but ultimately they boil down to a few
 fairly simple concepts.

 - Generics are Placeholders that allow logic to be reused accross different types.
 - You can use any name you want to make these *placeholders*
 - The traditional placeholder names are `T`, `U`, and `V` but it is encouraged to be more
 descriptive.
 - You can make assumptions about them if they are *constrained*
 - The most common way to constrain what type can be placed in the placeholder is by using
 a protocol
 - Any type signature can be made generic

 Okay lets take a look at the anatomy of a generic type signature. This first one will be for a
 class, struct, or enum.

 ![Generics Anatomy](GenericsAnatomy.png "Anatomy of a Swift Generic")

 Note that we call a placeholder and its constraint a generic parameter when they are
 originally declared between the angle brackets `<>`. You can have an arbitrary amount of
 generic parameters. Also note that all constraints are optional. Not as in the `Optional`
 type but rather optional in the sense it is not required to have a constraint for the generic
 parameter. You only constrain a generic when you want to make assumptions about the type
 that eventually gets passed in.

 As mentioned earlier, any type signature can be generic and that includes functions. Lets
 take a look at how a generic function signature looks.

 ![Generics Function Anatomy](GenericsFuncAnatomy.png "Anatomy of a Generic Function")

 So note that the pattern is nearly the same between the two declarations that is until you get
 to the function's parameters and its return types. So with functions, the placeholders you
 defined has to be used either in the function parameter or in the return type.
 
 ___
 
 ### Generic Functions in practice
 
 Lets take a look at a few basic generic function implementations to get our feet wet.
 
 */

// Generic Function Implementations

func describe<Thing>(_ input: Thing) -> String {
    "\(type(of: input)): \(String(describing: input))"
}

describe(12.0)

func PGAssertEqualType<A, B>(_ a: A, _ b: B, line: UInt = #line) {
    switch type(of: a) == type(of: b) {
    case true:
        print("✅", "\(line):", #function, "passed")
    case false:
        print("❌", "\(line):", #function, "Type \(describe(a)) is not \(describe(b))")
    }
}

PGAssertEqualType(12, "18")

/*:
 ___
 
 ### Let's discuss generic constraints

 As mentioned earlier you can make assumptions about the generic if it is constrained to a protocol (or less common a class). The idea is
 to constrain the generic only as specific as needed for the behavior to be accomplished. Why? Because the more constrained it is, the
 less things the generic function or type can operate on.
 
 */

// Constrained Generic Implementations

func PGAssertEqual<T: Equatable>(_ a: T , _ b: T, line: UInt = #line) {
    switch a == b {
        case true:
            print("✅", "\(line):", #function, "passed")
        case false:
            print("❌", "\(line):", #function, "\(describe(a)) is not equal to \(describe(b))")
    }
}

PGAssertEqual(16, 16)


/*:
 ___
 
 ### Lets Discuss Generic Types
 
 Not only do functions have the ability to be generic, but other types do as well. `enum`s, `struct`s, `class`es, and if you squint your
 eye's a bit even `protocol`s have the ability to be generic. We see them all over the place in the Swift Standard library. It is very
 common to see generic types in functional style code, especially given what they help to facilitate; identical behavior across a variety of
 types.
 
 We're going to take inspiration from the Swift Standard Library and look at one of the types which is used to help make SwiftUI possible.
 It's currently marked as private, but there is a proposal under review to make a public version of it accessible. It's called the
 `Either<Left, Right>` type.
 */

// Generic Type Implementations

enum Either<Left, Right> {
    
    case left(Left)
    case right(Right)
    
}

var eitherExamp: Either<Int, Double>

eitherExamp = .right(12.0)
eitherExamp = .left(12)

enum LetterGrade: String {
    case a = "A"
    case b = "B"
    case c = "C"
    case d = "D"
    case f = "F"
}

struct Percentage: ExpressibleByFloatLiteral {

    let rawValue: Double
    
    init(floatLiteral value: Double) {
        self.rawValue = value
    }

}

var studentGrade: Either<LetterGrade, Percentage> = .right(90.0)

studentGrade = .left(.a)


/*:
 ___
 
 ### Extending Generic Types
 
 Much of the power that comes from generic types actually come from the extension that you can make on them. It almost feels like giving
 them super powers, but hardly any one talks about how to do this. If we're going to understand and use Combine effectively we're going to
 need to know how to weild the almighty `where` clause. When using `where` clauses in extensions these are known as constrained
 extensions. You can think of these as extensions that only work in special cases. The `where` clause describes those special cases.
 
 Let's dive into a simple generic extension
 
 */

// Generic Extension Implementations

extension Either: CustomStringConvertible where
    Left: CustomStringConvertible,
    Right: CustomStringConvertible {
    
    var description: String {
        switch self {
        case let .left(subject):
            return subject.description
        case let .right(subject):
            return subject.description
        }
    }
    
}

extension LetterGrade: CustomStringConvertible {
    public var description: String {
        "Grade \(rawValue)"
    }
}

extension Percentage: CustomStringConvertible {
    public var description: String {
        "\(rawValue) %"
    }
}

studentGrade.description

/*:
 ___
 
 ### Generic Type Aliases
 
 That's right! Even typealiases can be generic. They help to peel away complexity as different peices of the puzzle become available. For
 instance you can define an `UnfailingResult<T>` by aliasing a `Result<T, Never>` which removes a generic parameter from
 having to be filled by the caller. They would now only have to worry about the `T` in this equation. This is a very flexible and powerful
 Swift feature and it even allows us to extend off of these aliases. Let take a look
 */

// Generic Type Alias Implementations

// Either<Int, Int>

typealias EitherSame<T> = Either<T, T>

let example: EitherSame = .left("")

typealias EitherStringConvertable = EitherSame<CustomStringConvertible>

extension EitherStringConvertable {
    func print() {
        switch self {
        case let .left(subject):
            Swift.print(subject.description)
        case let .right(subject):
            Swift.print(subject.description)
        }
    }
}

var anotherStudentGrade: EitherStringConvertable = .right(Percentage(floatLiteral: 63.9))

anotherStudentGrade.print()

/*:
 ___
 
 ### Generic Protocols???
 
 In life if you want to have some fun, you really need to throw an `associatedtype` into the mix. Not only is it the secret ingredient to
 life, but it's also the thing that makes `protocol`s generic. While I think **LifeSpice** would have been an awesome name for these,
 the Swift community simply refers to these as protocols with associated types or *PAT*s. You can think of the associated type as a
 placeholder, essentially the counterpart to the generic's parameter. You can plug in as many `associatedtype`s as you want
 aaaaaand they abide by the same rules as generic parameters in that they can be constrained.
 */

// Generic Protocol (PATs) Implementations

protocol Translatable {
    
    associatedtype TranslatedType
    
    var translated: TranslatedType { get }
    
}

extension Either where
    Left: Translatable,
    Left.TranslatedType == Right {
    
    var value: Right {
        switch self {
        case let .left(subject):
            return subject.translated
        case let .right(subject):
            return subject
        }
    }

}

extension Either where
    Right: Translatable,
    Right.TranslatedType == Left {
    
    var value: Left {
        switch self {
        case let .left(subject):
            return subject
        case let .right(subject):
            return subject.translated
        }
    }
    
}

protocol Commutable: Translatable where
    TranslatedType: Translatable,
    TranslatedType.TranslatedType == Self {
}

extension Either where
    Left: Commutable,
    Left.TranslatedType == Right {
    
    var valueLeft: Left {
        switch self {
        case let .left(subject):
            return subject
        case let .right(subject):
            return subject.translated
        }
    }
    
    var valueRight: Right {
        switch self {
        case let .left(subject):
            return subject.translated
        case let .right(subject):
            return subject
        }
    }
    
}

extension LetterGrade: Commutable {
    
    var translated: Percentage {
        switch self {
        case .a:
            return 100.00
        case .b:
            return 90.00
        case .c:
            return 80.00
        case .d:
            return 70.00
        case .f:
            return 60.00
        }
    }
    
}

extension Percentage: Commutable {
    
    var translated: LetterGrade {
        switch self.rawValue {
        case let x where x >= 100 :
            return .a
        case 90..<100:
            return .b
        case 80..<90:
            return .c
        case 70..<80:
            return .d
        default:
            return .f
        }
    }
    
}

studentGrade.valueRight

/*:
 ___
 
 ### Contextually Constrained Extensions
 
 Yes you can go deeper into the rabit hole 🙃. Sometimes the `where` clause on the generic extension is not enough to express the
 context you need to define a specified behavior. This is where *contextual where clauses* come to the rescue. So essentially they allow
 you to pull in the pre-existing generic context into an added layer of specificity via another `where` clause. Yes an "Inception" of where
 clauses or you can basically think of them as nested where clauses.
 
 */

// Contextual `where` clause implementation

extension Either where
    Left: Commutable,
    Left.TranslatedType == Right {
    
    func percentage() -> Percentage where Left == Percentage {
        valueLeft
    }
    
    func percentage() -> Percentage where Right == Percentage {
        valueRight
    }
    
    func letterGrade() -> LetterGrade where Left == LetterGrade {
        valueLeft
    }
    
    func letterGrade() -> LetterGrade where Right == LetterGrade {
        valueRight
    }
    
}

studentGrade.percentage()

studentGrade.letterGrade()

/*:
 ___
 
 ### Pulling it all together
 
 Okay so we're going to put all of these concepts to work in the following example and sprinkle a small dose of our prior session on
 closures into the mix. You're going to see that things may even start looking almost `Combine`-like and that's because `Combine` is
 built from the ground up using a lot of these principles. Let's take a look.
 */

// Integrated Implementations

typealias SideEffect<Input> = (Input) -> Void

typealias Transform<Input, Output> = (Input) -> Output

typealias EitherSideEffect<T> = EitherSame<SideEffect<T>>

typealias EitherTransform<Input, Output> = EitherSame<Transform<Input, Output>>

extension Either where Left == Right {
    
    var value: Left {
        switch self {
        case let .left(val):
            return val
        case let .right(val):
            return val
        }
    }
    
    func sideEffect<T>(_ input: T) where Left == SideEffect<T> {
        value(input)
    }
    
    func transform<Input, Output>(
        _ input: Input
    ) -> Output where
        Left == Transform<Input, Output>  {
        
        value(input)
    }
    
}

let eitherSideEffect: EitherSideEffect<String> = .left { print($0) }

eitherSideEffect.sideEffect("Im putting in my own inputs :)")

let addition: Transform<(Int, Int), Int> = { $0.0 + $0.1 }

let subtraction: Transform<(Int, Int), Int> = { $0.0 - $0.1 }

var addOrSubtract: EitherTransform<(Int, Int), Int> = .right(subtraction)

addOrSubtract.transform((4, 3))

addOrSubtract = .left(addition)

addOrSubtract.transform((3, 6))

/*:

 ___
 [Home](Welcome) | [Previous](@previous) | [Next](@next)
 */

