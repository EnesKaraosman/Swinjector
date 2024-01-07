//
//  Annotations.swift
//
//
//  Created by Enes Karaosman on 7.01.2024.
//

import Foundation

@propertyWrapper public struct Injected<T> {

    private var dependency: () -> T

    public init(_ serviceType: T.Type) {
        assert(GetIt.I.isRegistered(serviceType), "\(serviceType) is not registered to GetIt")
        dependency = { GetIt.I(serviceType)! }
    }

    /// Manages the wrapped dependency.
    public var wrappedValue: () -> T {
        get { return dependency }
        mutating set { dependency = newValue }
    }

    /// Unwraps the property wrapper granting access to the resolve/reset function.
    public var projectedValue: Injected<T> {
        get { return self }
        mutating set { self = newValue }
    }
}
