//
//  DatesEvent.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 2/3/25.
//


import Foundation

struct DateEvent: Identifiable {
    var id: String
    var province: String
    var question: String
    var options: [String]
    var correctAnswer: [String]
    var customMessage: String
    var correctAnswerMessage: String
    var incorrectAnswerMessage: String
    var isCapital: Bool
    var challenge: String
    var informationDetail: String
}
