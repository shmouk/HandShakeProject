import Foundation

class One {
    var i = 1
}

class Two {
    let one = One()
    lazy var x = one.i
}

