//
//  ContentView.swift
//  Set
//
//  Created by Meir Kurnedz on 11/08/2026.
//

import SwiftUI

struct SetGameView: View {
  @ObservedObject var viewModel: SetGameViewModel
  private let aspectRatio: CGFloat = 3/4


  var body: some View {
    VStack{
      Button("New Game"){
        viewModel.newGameTaped()
      }
        .font(.largeTitle)
      cards.animation(.default, value: viewModel.cardsOnBoard)
        .padding()
      HStack{
        Button("Deal Cards"){
          viewModel.dealCardsTaped()
        }
        Spacer()
        Button("Shuffle"){
          viewModel.shuffleTaped()
        }
      }
      .font(.largeTitle)
      .padding()
    }
  }

  private var cards: some View {
    AspectVGrid(viewModel.cardsOnBoard, aspectRatio: aspectRatio){
      card in
      CardView(card: card)
        .padding(4)
        .onTapGesture{
          viewModel.cardTaped(card)
        }
    }
    .foregroundColor(Color.black)
  }
}

struct CardView: View{
  let card: SetGame.Card
  var stroke: CGFloat {
    card.isSelected ? 5 : 2
  }

  var body: some View{
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
        Color(red: 0.55, green: 0.20, blue: 0.60)
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
