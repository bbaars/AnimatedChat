//
//  MessageView.swift
//  AnimatedChat
//
//  Created by Brandon Baars on 7/7/21.
//

import SwiftUI

extension Color {
    static let messageGray = Color(#colorLiteral(red: 0.7058823529, green: 0.7058823529, blue: 0.737254902, alpha: 1))
    static let messagePurple = Color(#colorLiteral(red: 0.5882352941, green: 0.1333333333, blue: 0.9843137255, alpha: 1))
}

struct User {
    let name: String
    let image: String

    static var fake: User {
        .init(name: "Greg", image: "person2")
    }
}

struct Message: Identifiable {
    let id: Int

    let from: User
    let message: String
    let wasSentFromMe: Bool

    static var fake: Message {
        .init(id: 1,
              from: .fake,
              message: "Are you free tomorrow at 2?",
              wasSentFromMe: true)
    }
}

struct MessageView: View {
    let message: Message

    @State private var frame: CGRect = .zero

    var avatarIcon: some View {
        Image(message.from.image)
            .resizable()
            .scaledToFill()
            .clipShape(Circle())
            .frame(width: 28, height: 28)
    }

//    rgb(34, 148, 251) <-- Blue
//    rgb(150, 34, 251) <-- Purple

    func getBackgroundColor(currentFrame: CGRect) -> Color {
        let screenHeight = UIScreen.main.bounds.size.height
        let currentY = currentFrame.minY

        // normalize (x – min(x)) / (max(x) – min(x))
        print("Current Y: \(currentFrame.minY)")
        print("Screen Height:  \(screenHeight)")
        
        let normalize = (currentY) / (screenHeight)
        let maxNormal = min(1, max(0, normalize))

        print(maxNormal)

        return .init(UIColor(red: (34 + 116 * (1 - maxNormal)) / 255,
                             green: (148 - 114 * (1 - maxNormal)) / 255,
                             blue: 251/255,
                             alpha: 1.0))
    }

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                if !message.wasSentFromMe {
                    avatarIcon
                }

                if (message.wasSentFromMe) {
                    Spacer()
                }

                Text("\(frame.minY)")
                    .padding(.horizontal)
                    .padding(.vertical, 6)
                    .foregroundColor(.white)
                    .background(message.wasSentFromMe
                                    ? getBackgroundColor(currentFrame: frame)
                                    : Color.messageGray)
                    .cornerRadius(20)
                    .background(GeometryGetter(rect: $frame))

                if message.wasSentFromMe {
                    avatarIcon
                }

                if !message.wasSentFromMe {
                    Spacer()
                }
            }
        }
    }
}

struct GeometryGetter: View {
    @Binding var rect: CGRect

    var body: some View {
        GeometryReader { geometry in
            AnyView(Color.clear)
                .preference(key: RectanglePreferenceKey.self, value: geometry.frame(in: .global))
        }.onPreferenceChange(RectanglePreferenceKey.self) { (value) in
            self.rect = value
        }
    }
}

struct RectanglePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero

    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(message: .fake)
//            .previewLayout(.sizeThatFits)
            .previewDisplayName("Sent from me")
            .padding()

        MessageView(message: .init(
                        id: 1,
                        from: .fake,
                        message: "Yes that's good",
                        wasSentFromMe: false))
//            .previewLayout(.sizeThatFits)
            .previewDisplayName("Sent from the other user")
            .padding()
    }
}
