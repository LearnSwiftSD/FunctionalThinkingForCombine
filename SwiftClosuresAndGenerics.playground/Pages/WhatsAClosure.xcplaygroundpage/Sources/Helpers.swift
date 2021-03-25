import Foundation

public func referenceCounter<T: AnyObject>(
    for object: T
) -> () -> UInt {
    return { [weak instance = object] () -> UInt in
        
        guard let u = instance else {
            print("Class: \(String(describing: T.self)) | Deallocated")
            return 0
        }
        
        let unownedCount = _getUnownedRetainCount(u)
        let weakCount = (_getWeakRetainCount(u) - 1) // Remove one to disregard this tool
        let strongCount = _getRetainCount(u)
        
        print(
            "Class: \(String(describing: T.self))", "|",
            "Strong: \(strongCount)", "|",
            "Weak: \(weakCount)", "|",
            "Unowned: \(unownedCount)"
        )
        
        return strongCount
    }
}

public func describe<T>(_ input: T) -> String {
    "\(type(of: input)): \(String(describing: input))"
}

public extension String {
    
    func printed() { print(self) }
    
}

public func PGAssertEqualTypes<A, B>(_ a: A , _ b: B, line: UInt = #line) {
    switch type(of: a) == type(of: b) {
        case true:
            print("✅", "\(line):", #function, "passed")
        case false:
            print("❌", "\(line):", #function, "Type \(describe(a)) is not \(describe(b))")
    }
}

public func PGAssertEqual<T: Equatable>(_ a: T , _ b: T, line: UInt = #line) {
    switch a == b {
        case true:
            print("✅", "\(line):", #function, "passed")
        case false:
            print("❌", "\(line):", #function, "\(describe(a)) is not equal to \(describe(b))")
    }
}

public func PGAssertTrue(_ a: @autoclosure () -> Bool , line: UInt = #line) {
    switch a() == true {
        case true:
            print("✅", "\(line):", #function, "passed")
        case false:
            print("❌", "\(line):", #function, "Expression did not evaluate to true")
    }
}

public func PGAssertFalse(_ a: @autoclosure () -> Bool , line: UInt = #line) {
    switch a() == false {
        case true:
            print("✅", "\(line):", #function, "passed")
        case false:
            print("❌", "\(line):", #function, "Expression did not evaluate to true")
    }
}

public func PGAssertNil<T>(_ a: T? , line: UInt = #line) {
    switch a {
        case .none:
            print("✅", "\(line):", #function, "passed")
        case .some:
            print("❌", "\(line):", #function, "\(describe(a)) did not evaluate to Nil")
    }
}

public func PGAssertNotNil<T>(_ a: T? , line: UInt = #line) {
    switch a {
        case .some:
            print("✅", "\(line):", #function, "passed")
        case .none:
            print("❌", "\(line):", #function, "\(describe(a)) did not produce a non-nil value")
    }
}

public enum EpicFailure: Error { case boom }

public typealias ExampleResult = Result<String, EpicFailure>


public extension Sequence {
    
    func zip<T: Sequence>(with sequence: T) -> Zip2Sequence<Self, T> {
        Swift.zip(self, sequence)
    }
    
    func flatZip<T: Sequence, U: Sequence, V: Sequence>(with sequence: V) -> [(T.Element, U.Element, V.Element)] where Self == Zip2Sequence<T, U> {
        zip(with: sequence).map { tAndU, v in (tAndU.0, tAndU.1, v) }
    }
    
}
