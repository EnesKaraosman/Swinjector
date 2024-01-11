//
//  Annotations.swift
//
//
//  Created by Enes Karaosman on 7.01.2024.
//

import Foundation

/// Get registered service type by annotation
@propertyWrapper public struct Injected<T> {

    private let dependency: () -> T

    /// Pass service type to be resolved
    public init(_ serviceType: T.Type) {
        assert(GetIt.I.isRegistered(serviceType), "\(serviceType) is not registered to GetIt")
        dependency = { GetIt.I(serviceType)! }
    }

    /// Manages the wrapped dependency.
    public var wrappedValue: () -> T {
        get { return dependency }
    }
}
