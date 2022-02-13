# ColorThemeManagerDemo

```swift
import Shifu
import SwiftUI

struct ColorThemeManagerDemo:View{
    @EnvironmentObject var colorManager: ColorSchemeMananger
    @ObservedObject private var injectObserver = Self.injectionObserver
    var body: some View{
        VStack{
            Picker("", selection: $colorManager.colorScheme){
                Text("Light").tag(ColorSchemeMananger.ColorScheme.light)
                Text("Dark").tag(ColorSchemeMananger.ColorScheme.dark)
                Text("System").tag(ColorSchemeMananger.ColorScheme.unspecified)
            }
            .pickerStyle(.segmented)
            .padding()

            Image(systemName: "helm")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .padding()
                .background(Color.yellow)
                .cornerRadius(15)
                .padding()
        }
    }
}
```
