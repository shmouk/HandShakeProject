import Foundation

class Bindable<T> {
    typealias Listener = (T) -> Void
    private var listner: Listener?
    
    func bind(_ listener: Listener?) {
        self.listner = listener
        
    }
    
    var value: T {
        didSet {
            listner?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
}
