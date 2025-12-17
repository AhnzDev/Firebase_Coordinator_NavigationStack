//
//  TestView.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 12/17/25.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        VStack {
            Text("박정민 책")
            Spacer()
                .frame(height: 8)
            BookCoverBlurView()
        }
    }
}

#Preview {
    TestView()
}

struct BookCoverBlurView: View {
    let imageURL = URL(string: "https://image.aladin.co.kr/product/19437/13/cover500/k442635512_1.jpg")!

    var body: some View {
        ZStack {
            // 🔹 Blurred Background (컨테이너 내부 전용)
            CachedAsyncImage(url: imageURL) { image in
                image
                    .resizable()
                    .scaledToFill()
            }
            .frame(height: 400)
            .clipped()
            .blur(radius: 25)
            .overlay(Color.black.opacity(0.25))

            // 🔹 Foreground Book Image
            CachedAsyncImage(url: imageURL) { image in
                image
                    .resizable()
                    .scaledToFill()
            }
            .frame(width: 200, height: 300)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 10)
        }
        .frame(height: 400)
        .clipShape(RoundedRectangle(cornerRadius: 0))
    }
}
struct CachedAsyncImage<Content: View>: View {
    let url: URL
    let content: (Image) -> Content

    var body: some View {
        AsyncImage(
            url: url,
            transaction: Transaction(animation: .easeInOut)
        ) { phase in
            switch phase {
            case .success(let image):
                content(image)
            case .failure(_):
                Color.gray.opacity(0.2)
            case .empty:
                ProgressView()
            @unknown default:
                EmptyView()
            }
        }
    }
}
