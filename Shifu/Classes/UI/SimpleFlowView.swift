//
//  SimpleFlowView.swift
//  Shifu
//
//  Created by Baoli Zhai on 2023/7/29.
//

import SwiftUI


public struct SimpleFlowView<Element: Hashable, Content:View>: View {
    class RowsCache: ObservableObject {
        @Published var lastRows: [[Element]]?
        var lastHash: Int?
    }
    @StateObject private var cache = RowsCache()
    @Binding var data: [Element]
    let viewFactory: (Element)->Content
    let sizeFunc: (Element)->CGSize
    let spacing: (CGFloat, CGFloat)
    
    @State var contentHeight: CGFloat = 200
    public init(data: Binding<[Element]>, @ViewBuilder content: @escaping (Element)-> Content, size: @escaping (Element)->CGSize, spacing: (horizontal: CGFloat, vertical: CGFloat) = (8,8)) {
        self._data = data
        self.viewFactory = content
        self.sizeFunc = size
        self.spacing = spacing
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let rows = self.computeRows(in: width)
            LazyVStack(alignment: .center, spacing: self.spacing.1 ) {
                ForEach(rows, id: \.self) { rowElements in
                    HStack(spacing: self.spacing.0) {
                        ForEach(rowElements, id: \.self) { element in
                            viewFactory(element)
                            
                        }
                    }
                }
            }
        }
        .frame(height: contentHeight)
    }
    
    func computeRows(in width: CGFloat) -> [[Element]] {
        var hasher = Hasher()
        hasher.combine(width)
        hasher.combine(data)
        let currentHash = hasher.finalize()
        if let lastRows = cache.lastRows, currentHash == cache.lastHash {
            return lastRows
        }
        
        var rows: [[Element]] = [[]]
        var currentRow = 0
        var remainingWidth = width
        var currentRowHeight:CGFloat = 0
        var contentHeight:CGFloat = 0;
        var rowHeights:[CGFloat] = []
        for text in self.data {
            let size = sizeFunc(text)
            let elementWidth = size.width + spacing.0 * 2
            let elementHeight = size.height + spacing.1 * 2;
            if remainingWidth - elementWidth >= 0 {
                if(currentRowHeight < elementHeight){
                    currentRowHeight = elementHeight
                }
                // it fits, add to the same row
                rows[currentRow].append(text)
                remainingWidth -= elementWidth
            } else {
                // it doesn't fit, add to the next row
                currentRow += 1
                rows.append([text])
                remainingWidth = width - elementWidth
                contentHeight += currentRowHeight
                rowHeights.append(currentRowHeight)
                currentRowHeight = elementHeight
            }
        }
        contentHeight += currentRowHeight
        rowHeights.append(currentRowHeight)
        delay(0){
            self.contentHeight = contentHeight
        }
        
        cache.lastHash = currentHash
        cache.lastRows = rows
        return rows
    }
}


public struct SimpleFlowText: View{
    public class Config{
        var fontSize:CGFloat = 15
        var padding:CGFloat = 12
        var cornerRadius:CGFloat = 10
    }
    @Binding var items:[String]
    var config = Config()
    var onTap:(String)->Void
    var onLongPress:((String)->Void)?
    public init(items: Binding<[String]>, onTap: @escaping (String) -> Void, onLongPress: ((String) -> Void)? = nil ){
        self._items = items
        self.onTap = onTap
        self.onLongPress = onLongPress
    }
    
    public var body: some View{
        SimpleFlowView(
            data: $items,
            content:{ text in
                Text(text)
                    .font(.system(size: config.fontSize))
                    .padding(config.padding)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(config.cornerRadius)
                    .onTapGesture{
                        onTap(text)
                    }
                    .onLongPressGesture {
                        onLongPress?(text)
                    }
                
            },
            size: {text in
                return text.sizeOfString(usingFont: .systemFont(ofSize: config.fontSize)).extends(config.padding + 4, config.padding + 4)
            })
    }
}

extension String {
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
}
