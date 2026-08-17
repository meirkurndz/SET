//
//  ContentView.swift
//  Set
//
//  Created by Meir Kurnedz on 11/08/2026.
//

import SwiftUI

struct SetGameView: View {
  typealias Card = SetGame.Card
  @Namespace private var dealingNamespace

  @ObservedObject var viewModel: SetGameViewModel
  private let aspectRatio: CGFloat = 3/4
  private let deckWidth: CGFloat = 80
  static private let minItemCount = SetGameViewModel.minCardsOnBoard

  var body: some View {
    VStack{
      newGame
      Text("Number of sets\n on Board: \(viewModel.numberOfSets)").font(.headline)
      cards
        .padding()
      HStack{
        deck
        Spacer()
        VStack{
          shuffle
          Button("Find Set"){
            viewModel.findSetTaped()
          }
        }
        Spacer()
        discardCards
      }
      .font(.largeTitle)
      .padding()
    }
  }

  private var shuffle: some View{
    Button("Shuffle"){
      withAnimation(){
        viewModel.shuffleTaped()
      }
    }
  }

  private var newGame: some View{
    Button("New Game"){
      viewModel.newGameTaped()
    }
    .font(.largeTitle)
  }

  private var deck: some View{
    ZStack{
      ForEach(viewModel.cardsInDeck){ card in
        CardView(card: card)
          .matchedGeometryEffect(id: card.id, in: dealingNamespace)
      }
    }
    .frame(width: deckWidth, height: deckWidth / aspectRatio)
    .onAppear(){
      viewModel.dealInitialCards()
    }
    .onTapGesture{
      viewModel.deckTaped()
    }

  }

  private var discardCards: some View{
    ZStack{
      ForEach(viewModel.discardedCards){ card in
        CardView(card: card)
          .matchedGeometryEffect(id: card.id, in: dealingNamespace)
          .transition(.scale)

      }
    }
    .frame(width: deckWidth, height: deckWidth / aspectRatio)
  }

  private var cards: some View {
    AspectVGrid(viewModel.cardsOnBoard,
                aspectRatio: aspectRatio,
                minItemCount: SetGameView.minItemCount
    ){ card in
      CardView(card: card)
        .matchedGeometryEffect(id: card.id, in: dealingNamespace)
        .rotationEffect(.degrees(card.isInSet ? 360 : 0))
        .padding(4)
        .onTapGesture{
          withAnimation{
            viewModel.cardTaped(card)
          }
        }
    }
  }
}

struct CardView: View{
  let card: SetGame.Card
  var stroke: CGFloat {
    card.isSelected ? 5 : 2
  }

  var body: some View{
    let backCardColor = Color(red: 0.45, green: 0.20, blue: 0.8)

    GeometryReader{ geometry in
      ZStack{
        let base = RoundedRectangle(cornerRadius: 15)

        base.fill(.white)
        base.strokeBorder(lineWidth: stroke)

        let symbolWidth = geometry.size.width * 0.55
        let symbolHeight = geometry.size.height * 0.23

        VStack(spacing: geometry.size.height * 0.05){
          ForEach(0..<card.number, id: \.self){ _ in
            SetSymbolView(card: card)
              .frame(
                width: symbolWidth,
                height: symbolHeight
              )
          }
        }
        .opacity(card.isFaceUp ? 1 : 0)
        base.fill(backCardColor)
          .opacity(card.isFaceUp ? 0 : 1)
      }
    }
  }
}

struct SetSymbolView: View{
  let card: SetGame.Card
  var body: some View{
    symbol.foregroundColor(color)
  }

  @ViewBuilder
  private var symbol: some View{
    switch card.shape{
    case .diamond:
      styled(Rectangle())
        .aspectRatio(1, contentMode: .fit)
        .rotationEffect(.degrees(45))
        .scaleEffect(x: 1.4, y: 0.7)
    case .oval:
      styled(Capsule())
    case .wave:
      styled(RoundedRectangle(cornerRadius: 2))
    }
  }

  @ViewBuilder
  private func styled<S: Shape>(_ shape: S) -> some View{
    switch card.shading {
    case .full:
      shape.fill(color)
    case .lines:
      StripedShape(shape: shape, color: color)
    case .empty:
      shape.stroke(color, lineWidth: 3)
    }
  }

  private var color: Color{
    switch card.color{
    case .green:
        .green
    case .red:
        .red
    case .purple:
      Color(red: 0.45, green: 0.20, blue: 0.8)
    }
  }


}

struct StripedShape<S: Shape>: View {
  let shape: S
  let color: Color

  var body: some View {
    shape
      .stroke(color, lineWidth: 3)
      .overlay {
        Stripes()
          .stroke(color, lineWidth: 2)
          .clipShape(shape)
      }
  }
}

struct Stripes: Shape {
  let spacing: CGFloat = 5

  func path(in rect: CGRect) -> Path {
    var path = Path()

    var x = rect.minX

    while x <= rect.maxX {
      path.move(to: CGPoint(x: x, y: rect.minY))
      path.addLine(to: CGPoint(x: x, y: rect.maxY))

      x += spacing
    }

    return path
  }
}



#Preview {
  SetGameView(viewModel: SetGameViewModel())
}
