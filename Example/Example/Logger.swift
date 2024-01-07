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
        d("Logger.init")
    }
    
    var prefix: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss.SSS"
        let timestamp = dateFormatter.string(from: Date())
        return timestamp
    }
    
    func d(_ args: String...) {
        debugPrint("\(prefix) d [🐛]: \(args)")
    }
    
    func e(_ args: String...) {
        debugPrint("\(prefix) e [💥]: \(args)")
    }
    
    func i(_ args: String...) {
        debugPrint("\(prefix) i [📢]: \(args)")
    }
}
