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

  func newGame(){
    model = Self.createSetGame()
  }

  func choose(_ card: SetGame.Card){
    model.choose(card)
  }

  func shuffleCards(){
    model.shuffleCards()
  }

  func deal3MoreCards(){
    model.deal3MoreCards()
  }
}


