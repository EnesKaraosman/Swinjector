//
//  Logger.swift
//  Example
//
//  Created by Enes Karaosman on 7.01.2024.
//

import Foundation

protocol Logger {
    func d(_ args: String...) -> Void
    func e(_ args: String...) -> Void
    func i(_ args: String...) -> Void
}

class LoggerImpl: Logger {
    init() {
        debugPrint("Logger.init")
    }
    
    func d(_ args: String...) {
        debugPrint("Logger.d [🐛]: \(args)")
    }
    
    func e(_ args: String...) {
        debugPrint("Logger.e [💥]: \(args)")
    }
    
    func i(_ args: String...) {
        debugPrint("Logger.i [📢]: \(args)")
    }
}
