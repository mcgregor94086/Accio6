import SwiftUI

public struct LabeledValue<T>: View {
    public let label: String
    public let value: T
    private let stringValue: String

    public init(label: String, value: T) where T: CustomStringConvertible {
        self.label = label
        self.value = value
        self.stringValue = value.description
    }

    // Special initializer for UUID
    public init(label: String, uuid: UUID) {
        self.label = label
        self.value = uuid as! T
        self.stringValue = uuid.uuidString
    }

    // Special initializer for enums
    public init<E: RawRepresentable>(label: String, enum: E)
    where E.RawValue: CustomStringConvertible {
        self.label = label
        self.value = `enum` as! T
        self.stringValue = `enum`.rawValue.description
    }

    public var body: some View {
        LabeledContent(label) {
            Text(stringValue)
        }
    }
}
