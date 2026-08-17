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
  static let dealDelay = 150

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

  var cardsInDeck: [SetGame.Card] {
    return model.deck
  }

  var discardedCards: [SetGame.Card] {
    return model.discardedCards
  }

  var numberOfSets: Int {
    return model.numberOfSetsOnBoard
  }

  static var minCardsOnBoard: Int {
    SetGame.minCardsOnBoard
  }
  static var numberOfCardsToDeal = 3

  func newGameTaped(){
    withAnimation{
      model = Self.createSetGame()
      withAnimation{
        dealInitialCards()
      }
    }
  }

  func cardTaped(_ card: SetGame.Card){
    model.choose(card)

    if model.hasSetSelected {
      withAnimation(.default.delay(0.5)){
        model.discardSet()
      }
    }
  }

  func shuffleTaped(){
    model.shuffleCards()
  }

  func dealInitialCards(){
    var delay = 0.3
    for _ in 0..<Self.minCardsOnBoard{
      withAnimation(.default.delay(delay)){
        model.dealCard()
      }
      delay += 0.17
    }
  }

  func deckTaped(){
    var delay = 0.0
    for _ in 0..<Self.numberOfCardsToDeal{
      withAnimation(.default.delay(delay)){
        model.dealCard()
      }
      delay += 0.17
    }
  }
}


