

```swift
struct ChangeIconDemo: View {
    @State var iconName:String?  = UIApplication.shared.alternateIconName {
        didSet{
            UIApplication.shared.setAlternateIconName(iconName)
        }
    }
    var body: some View {
        VStack{
            Text("Current App Icon: \(iconName ?? "Default")")
            Image(named: iconName ?? "AppIcon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.gray, lineWidth: 2)
                }
        }
        .onTapGesture {
            iconName = iconName == nil ? "Chunli" : nil
        }
        .onAppear{
            sandbox()
        }
    }
    
    func sandbox(){
        clg(Bundle.main.infoDictionary?["CFBundleIcons"])
    }
}
```
