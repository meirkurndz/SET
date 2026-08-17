//
//  SetGame.swift
//  Set
//
//  Created by Meir Kurnedz on 11/08/2026.
//

import Foundation


struct SetGame{

  private(set) var deck: [Card]
  private(set) var cardsOnBoard: [Card]
  private(set) var discardedCards: [Card]
  var numberOfCardsOnBoard: Int { cardsOnBoard.count }
  var numberOfSelectedCards: Int {
    cardsOnBoard.filter {$0.isSelected}.count
  }
  var numberOfSetsOnBoard: Int {
    countNumberOfSets()
  }
  var numberOfSetsFound: Int {
    discardedCards.count / 3
  }
  var selectedCardsIndices: [Int]{
    cardsOnBoard.indices.filter { cardsOnBoard[$0].isSelected }
  }
  var hasSetSelected: Bool {
    cardsOnBoard.filter { $0.isInSet }.count == 3
  }

  static let minCardsOnBoard = 9

  init(){
    deck = SetGame.createCards()
    deck.shuffle()
    discardedCards = []
    cardsOnBoard = []
  }



  mutating func shuffleCards(){
    cardsOnBoard.shuffle()
  }

  mutating func dealCard(){
    if let card = drawCard(){
      cardsOnBoard.append(card)
    }
  }

  mutating func choose(_ card: Card){
    if let index = cardsOnBoard.firstIndex(of: card){
      cardsOnBoard[index].isSelected.toggle()

      if numberOfSelectedCards == 3 {
        handleSet()
      } else if numberOfSelectedCards == 4 {
        unSelectAllCards()
        cardsOnBoard[index].isSelected.toggle()
      }
    }
  }

  private func countNumberOfSets() -> Int {
    var count = 0
    for first in 0..<cardsOnBoard.count {
      for second in (first + 1)..<cardsOnBoard.count {
        for third in (second + 1)..<cardsOnBoard.count {
          if isSet(cardsAt: [first, second, third]) {
            count += 1
          }
        }
      }
    }
    return count
  }

  mutating private func handleSet(){
    let indices = selectedCardsIndices
    if(isSet(cardsAt: indices)){
      for index in indices{
        cardsOnBoard[index].isInSet.toggle()
      }
    }
  }

  mutating func discardSet(){
    let indices = selectedCardsIndices
    guard indices.count == 3 else {
      return
    }

    let cardsToDiscard = indices.map { index in
      var card = cardsOnBoard[index]
      card.isInSet = true
      card.isSelected = false
      return card
    }

    discardedCards.append(contentsOf: cardsToDiscard)

    for index in indices.sorted(by: >){
      cardsOnBoard.remove(at: index)
    }

    guard cardsOnBoard.count < SetGame.minCardsOnBoard else { return }

    for index in indices.sorted(){
      guard let newCard = drawCard()
      else { break }
      cardsOnBoard.insert(newCard, at: index)
    }
  }

  private func isSet(cardsAt indices: [Int]) -> Bool {
    guard indices.count == 3 else {
      return false
    }

    let card1 = cardsOnBoard[indices[0]]
    let card2 = cardsOnBoard[indices[1]]
    let card3 = cardsOnBoard[indices[2]]

    return isValidSetFiled(card1.color, card2.color, card3.color) &&
    isValidSetFiled(card1.shape, card2.shape, card3.shape) &&
    isValidSetFiled(card1.number, card2.number, card3.number) &&
    isValidSetFiled(card1.shading, card2.shading, card3.shading)
  }

  private func isValidSetFiled<T: Equatable>(_ first: T, _ second: T, _ third: T)
  -> Bool {
    let allTheSame = first == second &&
    second == third
    let allDifferent = first != second &&
    second != third &&
    third != first
    return allTheSame || allDifferent
  }

  mutating private func unSelectAllCards(){
    for index in cardsOnBoard.indices{
      cardsOnBoard[index].isSelected = false
    }
  }

  private static func createCards() -> [Card] {
    var cards:[Card] = []
    for shape in ShapeType.allCases {
      for color in CardColor.allCases {
        for shading in Shading.allCases {
          for numberOfShapes in 1...3 {
            cards.append(Card(
              shape: shape,
              color: color,
              shading: shading,
              number: numberOfShapes,
              id: "\(shape)-\(color)-\(shading)-\(numberOfShapes)"
            ))
          }
        }
      }
    }
    return cards
  }

  mutating private func drawCard() -> Card? {
    guard var card = deck.popLast() else {
      return nil
    }
    card.isFaceUp = true
    return card
  }

  struct Card: Hashable, Equatable, Identifiable, CustomDebugStringConvertible{

    let shape: ShapeType
    let color: CardColor
    let shading: Shading
    let number: Int
    var isSelected: Bool = false
    var isFaceUp: Bool = false
    var isInSet: Bool = false

    let id: String
    var debugDescription: String {
      "\(shape) \(color) \(shading) \(number)"
    }

  }

  enum ShapeType: CaseIterable {
    case diamond
    case oval
    case wave
  }

  enum CardColor: CaseIterable{
    case red
    case green
    case purple
  }

  enum Shading: CaseIterable{
    case full
    case lines
    case empty
  }

}
