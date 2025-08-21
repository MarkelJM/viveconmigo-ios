//
//  LanguageAvailable.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 28/5/25.
//


import Foundation

struct LanguageAvailable: Identifiable, Codable {
    var id: String  // Este será el nombre del idioma (por ejemplo, "Español", "Euskera")
    
    // Inicializador desde Firestore
    init(id: String) {
        self.id = id
    }
}
