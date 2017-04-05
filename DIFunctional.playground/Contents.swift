import UIKit

class Reader<E, A> {
    let g: (E) -> (A)
    init(g: @escaping (E) -> (A)) {
        self.g = g
    }
    func apply(e: E) -> A {
        return g(e)
    }
    func map<B>(f: @escaping (A) -> (B)) -> Reader<E, B> {
        return Reader<E, B>{ e in f(self.g(e)) }
    }
    func flatMap<B>(f: @escaping (A) -> Reader<E, B>) -> Reader<E, B> {
        return Reader<E, B>{ e in f(self.g(e)).g(e) }
    }
}

precedencegroup FlatMapPrecedence {
    associativity: left
}
infix operator >>= : FlatMapPrecedence
func >>=<E, A, B>(a: Reader<E, A>, f: @escaping (A) -> Reader<E, B>) -> Reader<E, B> {
    return a.flatMap(f: f)
}

func half(i: Float ) -> Reader<Float , Float> {
    return Reader{_ in i/2}
}
let f = Reader{i in i} >>= half >>= half >>= half

f.apply(e: 20) // 2.5



struct User {
    var name: String
    var age: Int
}
struct DB {
    var path: String
    func findUser(userName: String) -> User {
        // DB Select operation
        return User(name: userName, age: 29)
    }
    func updateUser(u: User) -> Void {
        // DB Update operation
        print(u.name + " in: " + path)
    }
}

struct Environment {
    var path: String
}
func updateF(userName: String, newName: String) -> Reader<Environment, Void> {
    return Reader<Environment, Void>{ env in
        let db = DB(path: env.path)
        var user = db.findUser(userName: userName)
        user.name = newName
        db.updateUser(u: user)
    }
}

let test = Environment(path: "path_to_sqlite")
let production = Environment(path: "path_to_realm")
updateF(userName: "dummy_id", newName: "Thor").apply(e: test)

updateF(userName: "dummy_id", newName: "Thor").apply(e: production)
