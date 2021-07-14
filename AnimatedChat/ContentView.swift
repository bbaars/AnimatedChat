//
//  ContentView.swift
//  AnimatedChat
//
//  Created by Brandon Baars on 7/6/21.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
    typealias UIViewType = UIVisualEffectView

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: .dark)
    }
}

struct ContentView: View {
    let user: User
    let messages: [Message]

    @State private var headerFrame: CGRect = .zero

    var body: some View {
        ZStack(alignment: .top) {
            ZStack(alignment: .bottom) {
                HStack {
                    Image(user.image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 44, height: 44)
                        .clipShape(Circle())

                    VStack(alignment: .leading) {
                        Text(user.name)
                            .bold()
                            .foregroundColor(.white)
                        Text("Active 10 min ago")
                            .foregroundColor(.white)
                            .font(.caption)
                    }

                    Spacer()

                    Image(systemName: "phone.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.messagePurple)
                        .padding(.horizontal)

                    Image(systemName: "video.fill")
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(Color.messagePurple)
                        .frame(width: 20, height: 20)
                }.padding(.horizontal)
                .padding(.bottom, 6)
            }
            .padding(.top, 45)
            .background(BlurView())
            .background(GeometryGetter(rect: $headerFrame))
            .zIndex(1)

            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(messages, id: \.id) { i in
                        MessageView(message: i)
                            .id(i.id)
                    }
                    .offset(x: 0, y: headerFrame.maxY)
                    .padding([.horizontal, .top])
                    .padding(.bottom, headerFrame.maxY + 25)
                }
                .padding(.bottom, 6)
                .onAppear {
                    proxy.scrollTo(messages.last?.id ?? 0)
                }
            }
        }.edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(user: .fake, messages: AnimatedChatApp.messages)
    }
}
