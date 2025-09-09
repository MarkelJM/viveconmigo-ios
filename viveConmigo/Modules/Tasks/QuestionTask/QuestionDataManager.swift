//
//  QuestionDataManager.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 1/6/25.
//


import Foundation
import Combine

class QuestionAnswerDataManager {
    private let firestoreManager = QuestionAnswerFirestoreManager()
    
    func fetchQuestionAnswerById(_ id: String) -> AnyPublisher<QuestionAnswer, Error> {
        return firestoreManager.fetchQuestionAnswerById(id)
    }
}
