//
//  ContentView.swift
//  Example
//
//  Created by Enes Karaosman on 7.01.2024.
//

import SwiftUI
import Swinjector

struct ContentView: View {
    @Injected(Logger.self) private var logger
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                logger().d("Access by annotation")
            }
        }
    }
}

#Preview {
    ContentView()
}
