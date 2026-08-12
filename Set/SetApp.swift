//
//  SetApp.swift
//  Set
//
//  Created by Meir Kurnedz on 11/08/2026.
//

import SwiftUI

@main
struct SetApp: App {
  @StateObject var game = SetGameViewModel()
    var body: some Scene {
        WindowGroup {
          SetGameView(viewModel: game)
        }
    }
}
