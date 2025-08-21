//
//  Coin.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 2/3/25.
//


import Foundation

struct Coin: Identifiable {
    var id: String
    var province: String
    var description: String
    var customMessage: String
    var correctAnswerMessage: String
    var incorrectAnswerMessage: String
    var prize: String
    var isCapital: Bool
    var challenge: String
}
