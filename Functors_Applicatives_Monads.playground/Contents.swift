//: Playground - noun: a place where people can play

import UIKit

//  Functors


func countCharacters(string: String) -> Int {
    return string.characters.count
}

let name: String? = "NSCoders_mad"

let a = name.map( countCharacters )


//  Applicatives

extension Optional {
    func apply<U>(f: ((Wrapped) -> U)?) -> U? {
        if let f = f {
            return self.map(f)
        } else {
            return nil
        }
    }
}

let function: ((String) -> Int)? = countCharacters

let b = name.apply(f: function)


//  Monads

func countCharactersIfNotEmpty(string: String) -> Int? {
    if string.isEmpty {
        return nil
    } else {
        return string.characters.count
    }
}

let name2: String? = ""
let c = name2.flatMap(countCharactersIfNotEmpty)
