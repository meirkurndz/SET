//
//  SetGameViewModel.swift
//  Set
//
//  Created by Meir Kurnedz on 11/08/2026.
//

import SwiftUI
import Combine

class SetGameViewModel: ObservableObject {

  @Published private var model: SetGame
  static var Game = SetGameViewModel()

  init(){
    model = Self.createSetGame()
  }

  private static func createSetGame() -> SetGame {
    return SetGame()
  }

  var cards: [SetGame.Card]{
    model.deck
  }

  var cardsOnBoard: [SetGame.Card]{
    model.cardsOnBoard
  }

  func newGameTaped(){
    model = Self.createSetGame()
  }

  func cardTaped(_ card: SetGame.Card){
    model.choose(card)
  }

  func shuffleTaped(){
    model.shuffleCards()
  }

  func dealCardsTaped(){
    model.dealMoreCards()
  }
}


