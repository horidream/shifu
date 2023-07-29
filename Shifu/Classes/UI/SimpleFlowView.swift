//
//  SimpleFlowView.swift
//  Shifu
//
//  Created by Baoli Zhai on 2023/7/29.
//

import SwiftUI

public struct SimpleFlowView<Element: Hashable, Content:View>: View {
    let data: [Element]
    let viewFactory: (Element)->Content
    let sizeFunc: (Element)->CGFloat
    let spacing: (CGFloat, CGFloat)
    
    public init(data: [Element], @ViewBuilder content: @escaping (Element)-> Content, width: @escaping (Element)->CGFloat, spacing: (horizontal: CGFloat, vertical: CGFloat) = (8,8)) {
        self.data = data
        self.viewFactory = content
        self.sizeFunc = width
        self.spacing = spacing
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            LazyVStack(alignment: .center, spacing: self.spacing.1 ) {
                ForEach(self.computeRows(in: width), id: \.self) { rowElements in
                    HStack(spacing: self.spacing.0) {
                        ForEach(rowElements, id: \.self) { element in
                            viewFactory(element)
                            
                        }
                    }
                }
            }
        }
    }
    
    func computeRows(in width: CGFloat) -> [[Element]] {
        var rows: [[Element]] = [[]]
        var currentRow = 0
        var remainingWidth = width
        
        for text in self.data {
            // compute the width of the next element
            //            let elementWidth = text.widthOfString(usingFont: .systemFont(ofSize: 17)) + 2 * (self.padding + self.spacing)
            let elementWidth = sizeFunc(text) + spacing.0 * 2
            
            if remainingWidth - elementWidth >= 0 {
                // it fits, add to the same row
                rows[currentRow].append(text)
                remainingWidth -= elementWidth
            } else {
                // it doesn't fit, add to the next row
                currentRow += 1
                rows.append([text])
                remainingWidth = width - elementWidth
            }
        }
        return rows
    }
}


public struct SimpleFlowText: View{
    @Binding var items:[String]
    var onTap:(String)->Void
    
    public init(items: Binding<[String]>, onTap: @escaping (String) -> Void) {
        self._items = items
        self.onTap = onTap
    }
    
    public var body: some View{
        SimpleFlowView(
            data: items,
            content:{ text in
                Text(text)
                    .font(.system(size: 18))
                    .padding(12)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .onTapGesture{
                        onTap(text)
                    }
                
            },
            width: {text in
                text.widthOfString(usingFont: .systemFont(ofSize: 18)) + 12 * 2
            })
    }
}

extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}
