//
//  User.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 2/3/25.
//


import Foundation

enum Avatar: String, Codable, CaseIterable, Identifiable {
    case boy = "personajeOso"
    case girl = "personajeArbol"

    var id: String { self.rawValue }
}

/*
enum Province: String, Codable, CaseIterable, Identifiable {
    case guipuzcoa = "Guipúzcoa"
    case vizcaya = "Vizcaya"
    case alava = "Álava"
    case other = "Other"
    
    var id: String { self.rawValue }
}
 */

enum Province: String, Codable, CaseIterable, Identifiable {
    case CiudadMadrid = "Madrid ciudad"
    case ComunidadMadrid = "Comunidad de Madrid"
    case Esapaña = "España"
    case other = "Otro"
    
    var id: String { self.rawValue }
}

struct User: Identifiable, Codable {
    var id: String
    var email: String
    var firstName: String
    var lastName: String
    var birthDate: Date
    var postalCode: String
    var city: String
    var province: Province
    var avatar: Avatar
    var spotIDs: [String]
    var specialRewards: [String: String]
    var challenges: [String: [String]]
}

