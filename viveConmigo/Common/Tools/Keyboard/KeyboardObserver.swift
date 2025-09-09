//
//  KeyboardObserver.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 2/3/25.
//


import SwiftUI
import Combine

//dismiss de keyboard
final class KeyboardObserver: ObservableObject {
    @Published var keyboardHeight: CGFloat = 0

    private var cancellable: AnyCancellable?

    init() {
        cancellable = NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)
            .merge(with: NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification))
            .compactMap { notification in
                notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            }
            .map { rect in
                rect.origin.y == UIScreen.main.bounds.height ? 0 : rect.height
            }
            .assign(to: \.keyboardHeight, on: self)
    }
}
