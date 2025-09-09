//
//  viveConmigoApp.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 2/3/25.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {

  func application(_ application: UIApplication,

                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

    FirebaseApp.configure()

    return true

  }

}


@main
struct viveConmigoApp: App {
    let persistenceController = PersistenceController.shared
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject  var appState = AppState()

    var body: some Scene {
        WindowGroup {
            NavigationState()
                        .environmentObject(appState)
            //ContentView()
                //.environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
