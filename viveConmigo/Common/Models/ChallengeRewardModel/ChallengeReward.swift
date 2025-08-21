//
//  ChallengeReward.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 28/5/25.
//


import Foundation
import FirebaseFirestore

struct ChallengeReward: Identifiable, Codable {
    var id: String
    var abstract: String
    var activityID: String
    var activityType: String
    var challenge: String
    var challengeTitle: String
    var location: Coordinates
    var correctAnswerMessage: String
    var prizeImage: String
    var province: String
    var tasksAmount: Int
}


