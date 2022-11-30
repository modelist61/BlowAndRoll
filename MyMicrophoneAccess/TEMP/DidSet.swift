import Combine

@propertyWrapper
class DidSet<Value> {
    private var val: Value
    private let subject: CurrentValueSubject<Value, Never>

    init(wrappedValue value: Value) {
        val = value
        subject = CurrentValueSubject(value)
        wrappedValue = value
    }

    var wrappedValue: Value {
        get { val }
        set {
            val = newValue
            subject.send(val)
        }
    }

    public var projectedValue: CurrentValueSubject<Value, Never> {
        // swiftlint:disable implicit_getter
        get { subject }
    }
}
