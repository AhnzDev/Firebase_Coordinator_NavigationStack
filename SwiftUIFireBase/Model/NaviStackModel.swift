//
//  NaviStackModel.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 5/9/25.
//

import Foundation


struct ChampionModel: Identifiable, Hashable {
    let id = UUID().uuidString
    let name: String
    let dialogue: String
    let imageURL: String
}

extension ChampionModel {
    static let mockChampions: [ChampionModel] = [
        ChampionModel(name: "아트록스", dialogue: "종말을 내려주마.", imageURL: "https://ddragon.leagueoflegends.com/cdn/img/champion/splash/Aatrox_0.jpg"),
        ChampionModel(name: "아리", dialogue: "똑똑한 여우는 절대 잡히지 않거든.", imageURL: "https://ddragon.leagueoflegends.com/cdn/img/champion/splash/Ahri_7.jpg"),
        ChampionModel(name: "애쉬", dialogue: "계속 나아가야 해.", imageURL: "https://ddragon.leagueoflegends.com/cdn/img/champion/splash/Ashe_9.jpg"),
        ChampionModel(name: "다이애나", dialogue: "밤이 오면 달이 떠오르지.", imageURL: "https://ddragon.leagueoflegends.com/cdn/img/champion/splash/Diana_2.jpg"),
        ChampionModel(name: "카이사", dialogue: "이게 바로 내 존재의 이유다!", imageURL: "https://ddragon.leagueoflegends.com/cdn/img/champion/splash/Kaisa_1.jpg"),
        ChampionModel(name: "케일", dialogue: "날 두려워하라", imageURL: "https://ddragon.leagueoflegends.com/cdn/img/champion/splash/Kayle_1.jpg"),
        ChampionModel(name: "룰루", dialogue: "보라색 맛났어!", imageURL: "https://ddragon.leagueoflegends.com/cdn/img/champion/splash/Lulu_3.jpg"),
        ChampionModel(name: "라이즈", dialogue: "대상혁", imageURL: "https://ddragon.leagueoflegends.com/cdn/img/champion/splash/Ryze_3.jpg"),
        ChampionModel(name: "자르반", dialogue: "내 의지로, 여기서 끝을 보겠노라!", imageURL: "https://ddragon.leagueoflegends.com/cdn/img/champion/splash/JarvanIV_9.jpg"),
    ]
}
