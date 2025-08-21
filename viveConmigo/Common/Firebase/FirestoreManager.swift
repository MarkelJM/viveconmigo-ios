//
//  FirestoreManager.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 2/3/25.
//



import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

class FirestoreManager {
    private let db = Firestore.firestore()
    private let auth = Auth.auth()
    
    func updateSpecialRewardsForUser(_ rewards: [String: String]) -> AnyPublisher<Void, Error> {
            guard let userID = Auth.auth().currentUser?.uid else {
                return Fail(error: NSError(domain: "User not logged in", code: 401, userInfo: nil))
                    .eraseToAnyPublisher()
            }
            
            return Future<Void, Error> { promise in
                self.db.collection("users").document(userID).updateData([
                    "specialRewards": rewards
                ]) { error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
                    }
                }
            }
            .eraseToAnyPublisher()
        }
    
    // Create user profile in Firestore
    func createUserProfile(user: User) -> AnyPublisher<Void, Error> {
        Future { promise in
            guard let uid = self.auth.currentUser?.uid else {
                promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID not found"])))
                return
            }
            
            let userData = user.toFirestoreData()
            
            self.db.collection("users").document(uid).setData(userData) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // Fetch user profile from Firestore
    func fetchUserProfile() -> AnyPublisher<User, Error> {
        Future { promise in
            guard let uid = self.auth.currentUser?.uid else {
                promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID not found"])))
                return
            }
            
            self.db.collection("users").document(uid).getDocument { document, error in
                if let error = error {
                    promise(.failure(error))
                } else if let document = document, document.exists {
                    let data = document.data() ?? [:]
                    if let user = User(from: data) {
                        promise(.success(user))
                    } else {
                        promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode user"])))
                    }
                } else {
                    promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    /*
    func updateUserTaskIDs(taskID: String, challenge: String) -> AnyPublisher<Void, Error> {
        Future { promise in
            guard let uid = self.auth.currentUser?.uid else {
                promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID not found"])))
                return
            }

            let userRef = self.db.collection("users").document(uid)
            userRef.getDocument { document, error in
                if let error = error {
                    promise(.failure(error))
                } else if let document = document, document.exists {
                    var data = document.data() ?? [:]
                    
                    // Actualizar el campo "challenges" en Firestore
                    var challenges = data["challenges"] as? [String: [String]] ?? [:]
                    if challenges[challenge] != nil {
                        challenges[challenge]?.append(taskID)
                    } else {
                        challenges[challenge] = [taskID]
                    }

                    data["challenges"] = challenges

                    userRef.setData(data) { error in
                        if let error = error {
                            promise(.failure(error))
                        } else {
                            promise(.success(()))
                        }
                    }
                } else {
                    promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])))
                }
            }
        }
        .eraseToAnyPublisher()
    }
     */
    
    func updateUserTaskIDs(taskID: String, challenge: String) -> AnyPublisher<Void, Error> {
        guard let userID = Auth.auth().currentUser?.uid else {
            return Fail(error: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user ID found"])).eraseToAnyPublisher()
        }

        let userRef = db.collection("users").document(userID)
        
        return Future { promise in
            userRef.updateData([
                "challengeEuskadi.\(challenge)": FieldValue.arrayUnion([taskID])
            ]) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    // Actualizar spotIDs completados por el usuario
    func updateUserSpotIDs(spotID: String) -> AnyPublisher<Void, Error> {
        Future { promise in
            guard let uid = self.auth.currentUser?.uid else {
                promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID not found"])))
                return
            }

            let userRef = self.db.collection("users").document(uid)
            userRef.getDocument { document, error in
                if let error = error {
                    promise(.failure(error))
                } else if let document = document, document.exists {
                    var data = document.data() ?? [:]

                    // Actualizar el campo "spotIDs" en Firestore
                    var spotIDs = data["spotIDs"] as? [String] ?? []
                    if !spotIDs.contains(spotID) {
                        spotIDs.append(spotID)
                    }

                    data["spotIDs"] = spotIDs

                    userRef.setData(data) { error in
                        if let error = error {
                            promise(.failure(error))
                        } else {
                            promise(.success(()))
                        }
                    }
                } else {
                    promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // Register new user with FirebaseAuth
    func registerUser(email: String, password: String) -> AnyPublisher<Void, Error> {
        Future { promise in
            self.auth.createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // Send email verification
    func sendEmailVerification() -> AnyPublisher<Void, Error> {
        Future { promise in
            self.auth.currentUser?.sendEmailVerification { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // Check email verification status
    func checkEmailVerification() -> AnyPublisher<Bool, Error> {
        Future { promise in
            self.auth.currentUser?.reload { error in
                if let error = error {
                    promise(.failure(error))
                } else if let isVerified = self.auth.currentUser?.isEmailVerified {
                    promise(.success(isVerified))
                } else {
                    promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to check email verification"])))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // Login user with FirebaseAuth
    func loginUser(email: String, password: String) -> AnyPublisher<Void, Error> {
        Future { promise in
            self.auth.signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func updateUserProfile(user: User) -> AnyPublisher<Void, Error> {
        Future { promise in
            guard let uid = self.auth.currentUser?.uid else {
                promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID not found"])))
                return
            }

            let userData = user.toFirestoreData() // Asegúrate de que el método 'toFirestoreData' esté implementado en tu modelo de usuario

            self.db.collection("users").document(uid).setData(userData) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // Método para restablecer la contraseña
    func resetPassword(email: String) -> AnyPublisher<Void, Error> {
        Future { promise in
            self.auth.sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func updateUserChallenges(user: User) -> AnyPublisher<Void, Error> {
        Future { promise in
            guard let uid = self.auth.currentUser?.uid else {
                promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID not found"])))
                return
            }
            
            let userRef = self.db.collection("users").document(uid)
            userRef.getDocument { document, error in
                if let error = error {
                    promise(.failure(error))
                } else if let document = document, document.exists {
                    var data = document.data() ?? [:]
                    
                    // Actualizar el campo "challenges" en Firestore
                    data["challengeEuskadi"] = user.challenges
                    
                    userRef.setData(data) { error in
                        if let error = error {
                            promise(.failure(error))
                        } else {
                            promise(.success(()))
                        }
                    }
                } else {
                    promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func addSpecialRewardToUser(rewardID: String) -> AnyPublisher<Void, Error> {
        Future { promise in
            guard let uid = self.auth.currentUser?.uid else {
                promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID not found"])))
                return
            }

            let userRef = self.db.collection("users").document(uid)

            userRef.getDocument { document, error in
                if let error = error {
                    promise(.failure(error))
                } else if let document = document, document.exists {
                    var data = document.data() ?? [:]
                    
                    // Obtener los premios especiales actuales
                    var specialRewards = data["specialRewards"] as? [String] ?? []
                    
                    // Añadir el nuevo rewardID si no existe ya
                    if !specialRewards.contains(rewardID) {
                        specialRewards.append(rewardID)
                    }
                    
                    // Actualizar el documento de usuario con el array actualizado de specialRewards
                    data["specialRewards"] = specialRewards

                    userRef.setData(data) { error in
                        if let error = error {
                            promise(.failure(error))
                        } else {
                            promise(.success(()))
                        }
                    }
                } else {
                    promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
