//
//  HomView.swift
//  Firebase_Coordinator_NavigationStack
//
//  Created by Jihoon on 5/10/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(ChampionModel.mockChampions) { champion in
                        NavigationLink(value: champion) {
                            HomeRowView(champion: champion)
                        }
                        .tint(.primary)
                    }
                }
                .padding(.bottom, 50)
            }
            .navigationDestination(for: ChampionModel.self) { champion in
                HomeRowDestinationView(champion: champion)
            }
        }
    }
}

struct HomeRowView: View {
    let champion: ChampionModel
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Circle()
                    .frame(width: 30, height: 30)
                
                VStack(alignment: .leading) {
                    Text(champion.name)
                        .font(.headline)
                    Text(champion.dialogue)
                        .font(.body)
                    AsyncImage(url: URL(string: champion.imageURL)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 320, height: 190)
                }
            }
            .padding()
            
            Divider()
        }
    }
}
#Preview {
    HomeView()
}
struct HomeRowDestinationView: View {
    let champion: ChampionModel
    var body: some View {
        VStack(spacing: 20) {
            AsyncImage(url: URL(string: champion.imageURL)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 320, height: 190)
            Text(champion.name)
                .font(.largeTitle)
            
            NavigationLink(value: champion.name) {
                Text("스킨 사기")
                    .font(.title)
                    .bold()
            }
        }
        .navigationDestination(for: String.self) { name in
            Text(name).font(.largeTitle).bold() + Text(" 스킨을 사시겠어요?")
        }
    }
}
