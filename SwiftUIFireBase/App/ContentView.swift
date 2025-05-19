//
//  ContentView.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 4/30/25.
//

import SwiftUI


struct ContentView: View {
    @EnvironmentObject private var navPathFinder: NavigationPathFinder
    @State private var currentTab: Tab = .home
    @State private var path: NavigationPath = .init()
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        NavigationStack(path: $navPathFinder.path) {
            ZStack(alignment: .bottom) {
                TabView(selection: $currentTab) {
                    HomeView()
                        .tag(Tab.home)
                    
                    Text("게시판뷰")
                        .tag(Tab.forum)
                    
                    Text("스터디뷰")
                        .tag(Tab.study)
                    
                    Text("프로필뷰")
                        .tag(Tab.profile)
                }
                
                CustomTabBar(currentTab: $currentTab)
                    
            }
            .navigationDestination(for: ViewOption.self) { option in
                option.view()
            }
        }
    }
}


struct HomeView: View {
    @EnvironmentObject private var navPathFinder: NavigationPathFinder
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(ChampionModel.mockChampions) { champion in
                    Button {
                        navPathFinder.addPath(option: .homeFirst(champion: champion))
                    }label: {
                        HomeRowView(champion: champion)
                    }
                }.tint(.primary)
            }
           
            } .padding()
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
                        .foregroundStyle(.black)
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

struct HomeRowDestinationView: View {
    @EnvironmentObject private var navPathFinder: NavigationPathFinder
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
            Button {
                navPathFinder.addPath(option: .homeSecond(champion: champion))
            } label: {
                Text("스킨 사기")
                    .font(.title)
                    .bold()
            }
        }
    }
}

struct HomeSkinBuyView: View {
    @EnvironmentObject private var navPathFinder: NavigationPathFinder
    let champion: ChampionModel
    
    var body: some View {
        VStack(spacing: 30) {
            Text(champion.name).font(.largeTitle).bold() + Text ("스킨을 사시겠어요")
            
            Button {
                navPathFinder.popToRoot()
            } label: {
                Text("스킨사기 진짜로")
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(NavigationPathFinder.shared)
}
