//
//  AspectVGrid.swift
//  SC-A1
//
//  Created by Meir Kurnedz on 11/08/2026.
//

import SwiftUI

struct AspectVGrid<Item: Identifiable, ItemView: View>: View {
  var items: [Item]
  var aspectRatio: CGFloat = 1.0
  var minItemCount: Int
  var content: (Item) -> ItemView

  init(_ items: [Item],
       aspectRatio: CGFloat,
       minItemCount: Int = 1,
       @ViewBuilder content: @escaping (Item) -> ItemView){
    self.items = items
    self.aspectRatio = aspectRatio
    self.minItemCount = minItemCount
    self.content = content
  }


  var body: some View {
    GeometryReader { geometry in
      let layoutCount = max(items.count, minItemCount)
      let gridItemSize = gridItemWidthThatFits(
        count: layoutCount,
        size: geometry.size,
        atAspectRatio: aspectRatio
      )
      LazyVGrid(columns:
                  [
                    GridItem(
                    .adaptive(minimum: gridItemSize),
                    spacing: 0
                    )
                  ],
                spacing: 0){
        ForEach(items){ item in
          content(item)
            .aspectRatio(aspectRatio, contentMode: .fit)
        }
      }
    }

  }

  func gridItemWidthThatFits(
    count: Int,
    size: CGSize,
    atAspectRatio aspectRatio: CGFloat
  ) -> CGFloat {
    let count = CGFloat(count)
    var columnCount = 1.0;
    repeat{

      let width = size.width / columnCount
      let height = width / aspectRatio

      let rowCount = (count / columnCount).rounded(.up)
      if rowCount * height < size.height{
        return (size.width / columnCount).rounded(.down)
      }
      columnCount += 1
    }while columnCount < count
    return min(size.width / count, size.height * aspectRatio).rounded(.down)
  }

}

