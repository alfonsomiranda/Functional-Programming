//: Playground - noun: a place where people can play

import UIKit

enum Result<T> {
    case value(T)
    case error(NSError)
}

extension Result {
    func map<U>(f: (T) -> (U)) -> Result<U> {
        switch self {
        case let .value(value):
            return Result<U>.value(f(value))
        case let .error(error):
            return Result<U>.error(error)
        }
    }
    
    func flatMap<U>(f: (T) -> (Result<U>)) -> Result<U> {
        return Result.flatten(result: self.map(f: f))
    }
    
    static func flatten<T> (result: Result<Result<T>>) -> Result<T> {
        switch result {
        case let .value(innerResult):
            return innerResult
        case let .error(error):
            return Result<T>.error(error)
        }
    }
}

func dataWithContentsOfFile(file: URL, encoding: String.Encoding) -> Result<Data> {
    let data: Data
    
    do {
        data = try Data(contentsOf: file, options: .alwaysMapped)
        return .value(data)
    } catch {
        let nsError = error as NSError
        return .error(nsError)
    }
}

let path = Bundle.main.url(forResource: "infoo", withExtension: "txt")
if let path = path {
    let upperString = dataWithContentsOfFile(file: path, encoding: .utf8).map { String(data: $0, encoding: .utf8)! }.map {$0.uppercased() }
}
