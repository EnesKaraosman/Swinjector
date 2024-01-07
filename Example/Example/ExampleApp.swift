//
//  ExampleApp.swift
//  Example
//
//  Created by Enes Karaosman on 7.01.2024.
//

import SwiftUI
import Swinjector

@main
struct ExampleApp: App {
    
    init( ) {
        GetIt.I.registerLazySingleton(Logger.self) {
            LoggerImpl()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
