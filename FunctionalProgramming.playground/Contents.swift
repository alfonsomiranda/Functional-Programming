import UIKit


let values = [2.0,4.0,5.0,7.0]

var squares: [Double] = []

for value in values {
    squares.append(value*value)
}

let squares2 = values.map { (value: Double) -> Double in
    return value * value
}

let squares3 = values.map {$0 * $0}


let valuesWithNil = [2.0, nil, 4.0,5.0, nil,7.0]
let squaresWithNil = valuesWithNil.flatMap {$0}.map {$0 * $0}


//  Filter

var filterWithoutSugar: [Double] = []

for value: Double in values {
    if value.truncatingRemainder(dividingBy: 2) == 0 {
        filterWithoutSugar.append(value)
    }
}

let filterWithSugar = values.filter {$0.truncatingRemainder(dividingBy: 2) == 0}


// Reduce

var sum = Double(0)

for value in values {
    sum = sum + value
}

let sum2 = values.reduce(0) {$0 + $1}


// Sort

let sorted = values.sorted {$0 > $1}
















enum Maybe<T> {
    case Just(T)
    case Nothing
}

extension Maybe {
    func map<U> (f: (T) -> (U)) -> Maybe<U> {
        switch self {
        case .Just(let x):
            return .Just(f(x))
        case .Nothing:
            return .Nothing
        }
    }
    
    static func flatten(result: Maybe<Maybe<T>>) -> Maybe<T> {
        switch result {
        case .Just(let v):
            return v
        case .Nothing:
            return .Nothing
        }
    }
    
    func flatMap<U> (f: (T) -> Maybe<U>) -> Maybe<U> {
        switch self {
        case .Just(let v):
            return f(v)
        case .Nothing:
            return .Nothing
        }
    }
}

precedencegroup FlatMapPrecedence {
    associativity: left
}
infix operator >>= : FlatMapPrecedence

func >>=<T, U>(a: Maybe<T>, f: (T) -> Maybe<U>) -> Maybe<U> {
    return a.flatMap(f: f)
}

let j = Maybe.Just(3)

j.map {$0 * 3}

func half(a: Int) -> Maybe<Int> {
    return a % 2 == 0 ? Maybe.Just(a / 2) : Maybe.Nothing
}

Maybe.Just(20).flatMap {half(a: $0)}

print(Maybe.Just(20).flatMap {half(a: $0)}.flatMap {half(a: $0)}.map {half(a: $0)})


Maybe.Just(20) >>= half
