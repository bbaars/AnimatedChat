//
//  AnimatedChatApp.swift
//  AnimatedChat
//
//  Created by Brandon Baars on 7/6/21.
//

import SwiftUI

@main
struct AnimatedChatApp: App {
    static var messages: [Message] {
        var m = [Message]()
        for i in 0..<99 {
            m.append(.init(id: i, from: .fake, message: "\(i): Are you sure you want to go see that movie?", wasSentFromMe: i % 2 == 0))
        }

        return m
    }

    var body: some Scene {
        WindowGroup {
            ContentView(user: .fake, messages: AnimatedChatApp.messages)
        }
    }
}
