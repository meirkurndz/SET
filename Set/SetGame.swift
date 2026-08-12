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
  var numberOfCardsOnBoard: Int { cardsOnBoard.count }
  var numberOfSelectedCards: Int {
    cardsOnBoard.filter(){$0.isSelected}.count
  }
  let minCardsOnBoard = 9

  init(){
    deck = SetGame.createCards()
    deck.shuffle()

    cardsOnBoard = []
    for _ in 0..<minCardsOnBoard {
      if let card = deck.popLast(){
        cardsOnBoard.append(card)
      }
    }
  }



  mutating func shuffleCards(){
    cardsOnBoard.shuffle()
  }

  mutating func deal3MoreCards(){
    if(deck.count >= 3){
      for _ in 0..<3 {
        if let card = deck.popLast(){
          cardsOnBoard.append(card)
        }
      }
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

  mutating private func handleSet(){
    let indices = cardsOnBoard.indices.filter(){
      cardsOnBoard[$0].isSelected
    }
    if(isSet(cardsAt: indices)){
      replaceSet(cardsAt: indices)
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

  mutating private func replaceSet(cardsAt indices: [Int]){
    guard indices.count == 3 else {
      return
    }
    cardsOnBoard.removeAll(){$0.isSelected}

    for index in indices {
      guard cardsOnBoard.count < minCardsOnBoard
        else { break }
      guard !deck.isEmpty
        else { break }

      let newCard = deck.removeLast()
      cardsOnBoard.insert(newCard, at: index)
    }
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

  struct Card: Equatable, Identifiable, CustomDebugStringConvertible{

    let shape: ShapeType
    let color: CardColor
    let shading: Shading
    let number: Int
    var isSelected: Bool = false

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
