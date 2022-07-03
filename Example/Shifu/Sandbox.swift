//
//  Sandbox.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/3/13.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI
import Shifu
import JavaScriptCore
import Combine
import UIKit
import ShifuLottie


struct Sandbox:View{
   
    @ObservedObject private var injectObserver = Self.injectionObserver
    
    @State var text = [].attributedString()
    @StateObject var props = TweenProps()
    var body: some View {
        VStack {
            ThemePicker()
            UIText(text)
                .onTapGesture {
                    tween($props, to: [
                        \.rotationY: "180"
                    ], type: .back)
        //                    pb.image = $0.snapshot( backgroundColor: .white)
                }
                
            MyCustomShape()
                .fill(.red)
                .background(content: {
                    MyCustomShape()
                        .stroke(.white, lineWidth:
                                    5)
                })
                .aspectRatio(4.5, contentMode: .fit)
                .frame(width: 200)
            Spacer()
            SimpleMarkdownViewer(content: #"""
```swift
text = ["Hi", "Swift", "\nMay the force \nbe with you"]
    .attributedString([
        .font: UIFont.boldSystemFont(ofSize: 28),
        .foregroundColor: UIColor.lightGray,
        .paragraphStyle: with(NSMutableParagraphStyle()){ $0.alignment = .center }
        ], attributes:[
            [.foregroundColor: Theme.titlePrimary, .font: UIFont.boldSystemFont(ofSize: 96), .strokeColor: Theme.titleSecondary, .strokeWidth: NSNumber(-2)]
    ])
text.replace("Swift", with: Icons.image(.swift_fa, color: .red).attributedString([.baselineOffset: -3]))
```
"""#, css: "pre{ margin-top: 5px; }")
            .id(injectObserver.injectionNumber)
        }
        .tweenProps(props)

        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .onInjection{
            sandbox()
        }
        .onAppear{
            sandbox()
        }
    }
    
    func sandbox(){
        text = ["Hi", "Swift", "\nMay the force \nbe with you"].attributedString([.font: UIFont.boldSystemFont(ofSize: 28), .foregroundColor: UIColor.lightGray, .paragraphStyle: with(NSMutableParagraphStyle()){ $0.alignment = .center }], attributes:[
            [.foregroundColor: Theme.titlePrimary, .font: UIFont.boldSystemFont(ofSize: 96), .strokeColor: Theme.titleSecondary, .strokeWidth: NSNumber(-2)],
            nil
        ])
        text.replace("Swift", with: Icons.image(.swift_fa, color: .red).attributedString([.baselineOffset: -3]))
    }

}

extension View {
    func onTapTarget(_ callback: @escaping (Self)->Void)->some View{
        return self.onTapGesture {
            callback(self)
        }
    }
    
}
struct MyCustomShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.31081*width, y: 0.15616*height))
        path.addCurve(to: CGPoint(x: 0.28274*width, y: 0.02987*height), control1: CGPoint(x: 0.30715*width, y: 0.09466*height), control2: CGPoint(x: 0.29641*width, y: 0.04633*height))
        path.addCurve(to: CGPoint(x: 0.15872*width, y: 0), control1: CGPoint(x: 0.258*width, y: 0), control2: CGPoint(x: 0.15872*width, y: 0))
        path.addCurve(to: CGPoint(x: 0.0347*width, y: 0.02987*height), control1: CGPoint(x: 0.15872*width, y: 0), control2: CGPoint(x: 0.05945*width, y: 0))
        path.addCurve(to: CGPoint(x: 0.00664*width, y: 0.15616*height), control1: CGPoint(x: 0.02104*width, y: 0.04633*height), control2: CGPoint(x: 0.0103*width, y: 0.09466*height))
        path.addCurve(to: CGPoint(x: 0, y: 0.5*height), control1: CGPoint(x: 0, y: 0.26752*height), control2: CGPoint(x: 0, y: 0.5*height))
        path.addCurve(to: CGPoint(x: 0.00664*width, y: 0.84384*height), control1: CGPoint(x: 0, y: 0.5*height), control2: CGPoint(x: 0, y: 0.73248*height))
        path.addCurve(to: CGPoint(x: 0.0347*width, y: 0.97013*height), control1: CGPoint(x: 0.0103*width, y: 0.90534*height), control2: CGPoint(x: 0.02104*width, y: 0.95367*height))
        path.addCurve(to: CGPoint(x: 0.15872*width, y: height), control1: CGPoint(x: 0.05945*width, y: height), control2: CGPoint(x: 0.15872*width, y: height))
        path.addCurve(to: CGPoint(x: 0.28274*width, y: 0.97013*height), control1: CGPoint(x: 0.15872*width, y: height), control2: CGPoint(x: 0.258*width, y: height))
        path.addCurve(to: CGPoint(x: 0.31081*width, y: 0.84384*height), control1: CGPoint(x: 0.29641*width, y: 0.95367*height), control2: CGPoint(x: 0.30715*width, y: 0.90534*height))
        path.addCurve(to: CGPoint(x: 0.31745*width, y: 0.5*height), control1: CGPoint(x: 0.31745*width, y: 0.73248*height), control2: CGPoint(x: 0.31745*width, y: 0.5*height))
        path.addCurve(to: CGPoint(x: 0.31081*width, y: 0.15616*height), control1: CGPoint(x: 0.31745*width, y: 0.5*height), control2: CGPoint(x: 0.31742*width, y: 0.26752*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.12695*width, y: 0.71427*height))
        path.addLine(to: CGPoint(x: 0.20942*width, y: 0.50002*height))
        path.addLine(to: CGPoint(x: 0.12695*width, y: 0.28577*height))
        path.addLine(to: CGPoint(x: 0.12695*width, y: 0.71427*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.38447*width, y: 0.65018*height))
        path.addLine(to: CGPoint(x: 0.34883*width, y: 0.07092*height))
        path.addLine(to: CGPoint(x: 0.37992*width, y: 0.07092*height))
        path.addLine(to: CGPoint(x: 0.39242*width, y: 0.3335*height))
        path.addCurve(to: CGPoint(x: 0.39944*width, y: 0.49896*height), control1: CGPoint(x: 0.3956*width, y: 0.39818*height), control2: CGPoint(x: 0.39793*width, y: 0.45333*height))
        path.addLine(to: CGPoint(x: 0.40036*width, y: 0.49896*height))
        path.addCurve(to: CGPoint(x: 0.40739*width, y: 0.33445*height), control1: CGPoint(x: 0.4014*width, y: 0.46627*height), control2: CGPoint(x: 0.40376*width, y: 0.41147*height))
        path.addLine(to: CGPoint(x: 0.42032*width, y: 0.07092*height))
        path.addLine(to: CGPoint(x: 0.45142*width, y: 0.07092*height))
        path.addLine(to: CGPoint(x: 0.41533*width, y: 0.65018*height))
        path.addLine(to: CGPoint(x: 0.41533*width, y: 0.92805*height))
        path.addLine(to: CGPoint(x: 0.38445*width, y: 0.92805*height))
        path.addLine(to: CGPoint(x: 0.38445*width, y: 0.65018*height))
        path.addLine(to: CGPoint(x: 0.38447*width, y: 0.65018*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.46077*width, y: 0.90968*height))
        path.addCurve(to: CGPoint(x: 0.44737*width, y: 0.82079*height), control1: CGPoint(x: 0.4545*width, y: 0.89063*height), control2: CGPoint(x: 0.45003*width, y: 0.861*height))
        path.addCurve(to: CGPoint(x: 0.4434*width, y: 0.66039*height), control1: CGPoint(x: 0.44473*width, y: 0.78057*height), control2: CGPoint(x: 0.4434*width, y: 0.72718*height))
        path.addLine(to: CGPoint(x: 0.4434*width, y: 0.56949*height))
        path.addCurve(to: CGPoint(x: 0.44794*width, y: 0.4071*height), control1: CGPoint(x: 0.4434*width, y: 0.50211*height), control2: CGPoint(x: 0.44491*width, y: 0.4479*height))
        path.addCurve(to: CGPoint(x: 0.46213*width, y: 0.31773*height), control1: CGPoint(x: 0.45098*width, y: 0.36629*height), control2: CGPoint(x: 0.45571*width, y: 0.33643*height))
        path.addCurve(to: CGPoint(x: 0.48746*width, y: 0.28962*height), control1: CGPoint(x: 0.46856*width, y: 0.29903*height), control2: CGPoint(x: 0.477*width, y: 0.28962*height))
        path.addCurve(to: CGPoint(x: 0.5122*width, y: 0.3182*height), control1: CGPoint(x: 0.49775*width, y: 0.28962*height), control2: CGPoint(x: 0.50598*width, y: 0.29915*height))
        path.addCurve(to: CGPoint(x: 0.52582*width, y: 0.40757*height), control1: CGPoint(x: 0.51839*width, y: 0.33725*height), control2: CGPoint(x: 0.52294*width, y: 0.36712*height))
        path.addCurve(to: CGPoint(x: 0.53013*width, y: 0.56949*height), control1: CGPoint(x: 0.52869*width, y: 0.44814*height), control2: CGPoint(x: 0.53013*width, y: 0.50211*height))
        path.addLine(to: CGPoint(x: 0.53013*width, y: 0.66039*height))
        path.addCurve(to: CGPoint(x: 0.52592*width, y: 0.82126*height), control1: CGPoint(x: 0.53013*width, y: 0.72718*height), control2: CGPoint(x: 0.52872*width, y: 0.7808*height))
        path.addCurve(to: CGPoint(x: 0.51231*width, y: 0.91015*height), control1: CGPoint(x: 0.52312*width, y: 0.86182*height), control2: CGPoint(x: 0.51858*width, y: 0.89146*height))
        path.addCurve(to: CGPoint(x: 0.48678*width, y: 0.93826*height), control1: CGPoint(x: 0.50603*width, y: 0.92886*height), control2: CGPoint(x: 0.49752*width, y: 0.93826*height))
        path.addCurve(to: CGPoint(x: 0.46077*width, y: 0.90968*height), control1: CGPoint(x: 0.4757*width, y: 0.93837*height), control2: CGPoint(x: 0.46705*width, y: 0.92873*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.49595*width, y: 0.81161*height))
        path.addCurve(to: CGPoint(x: 0.49856*width, y: 0.71154*height), control1: CGPoint(x: 0.49767*width, y: 0.79116*height), control2: CGPoint(x: 0.49856*width, y: 0.75788*height))
        path.addLine(to: CGPoint(x: 0.49856*width, y: 0.51646*height))
        path.addCurve(to: CGPoint(x: 0.49595*width, y: 0.41792*height), control1: CGPoint(x: 0.49856*width, y: 0.47154*height), control2: CGPoint(x: 0.4977*width, y: 0.43861*height))
        path.addCurve(to: CGPoint(x: 0.48675*width, y: 0.38676*height), control1: CGPoint(x: 0.4942*width, y: 0.3971*height), control2: CGPoint(x: 0.49114*width, y: 0.38676*height))
        path.addCurve(to: CGPoint(x: 0.47779*width, y: 0.41792*height), control1: CGPoint(x: 0.48252*width, y: 0.38676*height), control2: CGPoint(x: 0.47951*width, y: 0.3971*height))
        path.addCurve(to: CGPoint(x: 0.47517*width, y: 0.51646*height), control1: CGPoint(x: 0.47604*width, y: 0.43873*height), control2: CGPoint(x: 0.47517*width, y: 0.47154*height))
        path.addLine(to: CGPoint(x: 0.47517*width, y: 0.71154*height))
        path.addCurve(to: CGPoint(x: 0.47768*width, y: 0.81161*height), control1: CGPoint(x: 0.47517*width, y: 0.75788*height), control2: CGPoint(x: 0.47601*width, y: 0.79127*height))
        path.addCurve(to: CGPoint(x: 0.48675*width, y: 0.8423*height), control1: CGPoint(x: 0.47935*width, y: 0.83208*height), control2: CGPoint(x: 0.48236*width, y: 0.8423*height))
        path.addCurve(to: CGPoint(x: 0.49595*width, y: 0.81161*height), control1: CGPoint(x: 0.49114*width, y: 0.8423*height), control2: CGPoint(x: 0.4942*width, y: 0.83208*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.63128*width, y: 0.92817*height))
        path.addLine(to: CGPoint(x: 0.60677*width, y: 0.92817*height))
        path.addLine(to: CGPoint(x: 0.60405*width, y: 0.8515*height))
        path.addLine(to: CGPoint(x: 0.60337*width, y: 0.8515*height))
        path.addCurve(to: CGPoint(x: 0.5734*width, y: 0.93828*height), control1: CGPoint(x: 0.59671*width, y: 0.90936*height), control2: CGPoint(x: 0.58673*width, y: 0.93828*height))
        path.addCurve(to: CGPoint(x: 0.55297*width, y: 0.89748*height), control1: CGPoint(x: 0.56418*width, y: 0.93828*height), control2: CGPoint(x: 0.55736*width, y: 0.92464*height))
        path.addCurve(to: CGPoint(x: 0.54638*width, y: 0.76977*height), control1: CGPoint(x: 0.54858*width, y: 0.8702*height), control2: CGPoint(x: 0.54638*width, y: 0.82763*height))
        path.addLine(to: CGPoint(x: 0.54638*width, y: 0.30188*height))
        path.addLine(to: CGPoint(x: 0.57771*width, y: 0.30188*height))
        path.addLine(to: CGPoint(x: 0.57771*width, y: 0.76154*height))
        path.addCurve(to: CGPoint(x: 0.57975*width, y: 0.82128*height), control1: CGPoint(x: 0.57771*width, y: 0.78953*height), control2: CGPoint(x: 0.57839*width, y: 0.8094*height))
        path.addCurve(to: CGPoint(x: 0.58657*width, y: 0.83915*height), control1: CGPoint(x: 0.58111*width, y: 0.83315*height), control2: CGPoint(x: 0.58338*width, y: 0.83915*height))
        path.addCurve(to: CGPoint(x: 0.59441*width, y: 0.82787*height), control1: CGPoint(x: 0.58929*width, y: 0.83915*height), control2: CGPoint(x: 0.5919*width, y: 0.83539*height))
        path.addCurve(to: CGPoint(x: 0.59998*width, y: 0.79929*height), control1: CGPoint(x: 0.59692*width, y: 0.82034*height), control2: CGPoint(x: 0.59875*width, y: 0.81081*height))
        path.addLine(to: CGPoint(x: 0.59998*width, y: 0.30176*height))
        path.addLine(to: CGPoint(x: 0.63128*width, y: 0.30176*height))
        path.addLine(to: CGPoint(x: 0.63128*width, y: 0.92817*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.71639*width, y: 0.18438*height))
        path.addLine(to: CGPoint(x: 0.6853*width, y: 0.18438*height))
        path.addLine(to: CGPoint(x: 0.6853*width, y: 0.92814*height))
        path.addLine(to: CGPoint(x: 0.65465*width, y: 0.92814*height))
        path.addLine(to: CGPoint(x: 0.65465*width, y: 0.18438*height))
        path.addLine(to: CGPoint(x: 0.62355*width, y: 0.18438*height))
        path.addLine(to: CGPoint(x: 0.62355*width, y: 0.07102*height))
        path.addLine(to: CGPoint(x: 0.71639*width, y: 0.07102*height))
        path.addLine(to: CGPoint(x: 0.71639*width, y: 0.18438*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.79196*width, y: 0.92817*height))
        path.addLine(to: CGPoint(x: 0.76745*width, y: 0.92817*height))
        path.addLine(to: CGPoint(x: 0.76474*width, y: 0.8515*height))
        path.addLine(to: CGPoint(x: 0.76406*width, y: 0.8515*height))
        path.addCurve(to: CGPoint(x: 0.73408*width, y: 0.93828*height), control1: CGPoint(x: 0.75739*width, y: 0.90936*height), control2: CGPoint(x: 0.74741*width, y: 0.93828*height))
        path.addCurve(to: CGPoint(x: 0.71365*width, y: 0.89748*height), control1: CGPoint(x: 0.72486*width, y: 0.93828*height), control2: CGPoint(x: 0.71804*width, y: 0.92464*height))
        path.addCurve(to: CGPoint(x: 0.70706*width, y: 0.76977*height), control1: CGPoint(x: 0.70926*width, y: 0.8702*height), control2: CGPoint(x: 0.70706*width, y: 0.82763*height))
        path.addLine(to: CGPoint(x: 0.70706*width, y: 0.30188*height))
        path.addLine(to: CGPoint(x: 0.7384*width, y: 0.30188*height))
        path.addLine(to: CGPoint(x: 0.7384*width, y: 0.76154*height))
        path.addCurve(to: CGPoint(x: 0.74043*width, y: 0.82128*height), control1: CGPoint(x: 0.7384*width, y: 0.78953*height), control2: CGPoint(x: 0.73907*width, y: 0.8094*height))
        path.addCurve(to: CGPoint(x: 0.74725*width, y: 0.83915*height), control1: CGPoint(x: 0.74179*width, y: 0.83315*height), control2: CGPoint(x: 0.74407*width, y: 0.83915*height))
        path.addCurve(to: CGPoint(x: 0.75509*width, y: 0.82787*height), control1: CGPoint(x: 0.74997*width, y: 0.83915*height), control2: CGPoint(x: 0.75258*width, y: 0.83539*height))
        path.addCurve(to: CGPoint(x: 0.76066*width, y: 0.79929*height), control1: CGPoint(x: 0.7576*width, y: 0.82034*height), control2: CGPoint(x: 0.75943*width, y: 0.81081*height))
        path.addLine(to: CGPoint(x: 0.76066*width, y: 0.30176*height))
        path.addLine(to: CGPoint(x: 0.79196*width, y: 0.30176*height))
        path.addLine(to: CGPoint(x: 0.79196*width, y: 0.92817*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.89566*width, y: 0.40194*height))
        path.addCurve(to: CGPoint(x: 0.88646*width, y: 0.31609*height), control1: CGPoint(x: 0.89375*width, y: 0.36242*height), control2: CGPoint(x: 0.89069*width, y: 0.33385*height))
        path.addCurve(to: CGPoint(x: 0.86898*width, y: 0.28952*height), control1: CGPoint(x: 0.88222*width, y: 0.29834*height), control2: CGPoint(x: 0.8764*width, y: 0.28952*height))
        path.addCurve(to: CGPoint(x: 0.85285*width, y: 0.31151*height), control1: CGPoint(x: 0.86323*width, y: 0.28952*height), control2: CGPoint(x: 0.85784*width, y: 0.29681*height))
        path.addCurve(to: CGPoint(x: 0.84128*width, y: 0.36924*height), control1: CGPoint(x: 0.84786*width, y: 0.32621*height), control2: CGPoint(x: 0.84399*width, y: 0.34537*height))
        path.addLine(to: CGPoint(x: 0.84104*width, y: 0.36924*height))
        path.addLine(to: CGPoint(x: 0.84104*width, y: 0.03928*height))
        path.addLine(to: CGPoint(x: 0.81086*width, y: 0.03928*height))
        path.addLine(to: CGPoint(x: 0.81086*width, y: 0.92804*height))
        path.addLine(to: CGPoint(x: 0.83673*width, y: 0.92804*height))
        path.addLine(to: CGPoint(x: 0.83992*width, y: 0.86877*height))
        path.addLine(to: CGPoint(x: 0.8406*width, y: 0.86877*height))
        path.addCurve(to: CGPoint(x: 0.85149*width, y: 0.91887*height), control1: CGPoint(x: 0.84303*width, y: 0.88994*height), control2: CGPoint(x: 0.84666*width, y: 0.90652*height))
        path.addCurve(to: CGPoint(x: 0.86762*width, y: 0.93721*height), control1: CGPoint(x: 0.85633*width, y: 0.9311*height), control2: CGPoint(x: 0.86171*width, y: 0.93721*height))
        path.addCurve(to: CGPoint(x: 0.891*width, y: 0.87136*height), control1: CGPoint(x: 0.8782*width, y: 0.93721*height), control2: CGPoint(x: 0.88601*width, y: 0.91523*height))
        path.addCurve(to: CGPoint(x: 0.8985*width, y: 0.66546*height), control1: CGPoint(x: 0.896*width, y: 0.82738*height), control2: CGPoint(x: 0.8985*width, y: 0.75883*height))
        path.addLine(to: CGPoint(x: 0.8985*width, y: 0.56633*height))
        path.addCurve(to: CGPoint(x: 0.89566*width, y: 0.40194*height), control1: CGPoint(x: 0.8985*width, y: 0.49636*height), control2: CGPoint(x: 0.89754*width, y: 0.44145*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.86694*width, y: 0.65746*height))
        path.addCurve(to: CGPoint(x: 0.86568*width, y: 0.7647*height), control1: CGPoint(x: 0.86694*width, y: 0.70308*height), control2: CGPoint(x: 0.86652*width, y: 0.73884*height))
        path.addCurve(to: CGPoint(x: 0.86148*width, y: 0.81985*height), control1: CGPoint(x: 0.86485*width, y: 0.79058*height), control2: CGPoint(x: 0.86346*width, y: 0.80904*height))
        path.addCurve(to: CGPoint(x: 0.85353*width, y: 0.8362*height), control1: CGPoint(x: 0.85952*width, y: 0.83079*height), control2: CGPoint(x: 0.85685*width, y: 0.8362*height))
        path.addCurve(to: CGPoint(x: 0.84637*width, y: 0.82797*height), control1: CGPoint(x: 0.85094*width, y: 0.8362*height), control2: CGPoint(x: 0.84857*width, y: 0.83349*height))
        path.addCurve(to: CGPoint(x: 0.84104*width, y: 0.80351*height), control1: CGPoint(x: 0.84418*width, y: 0.82256*height), control2: CGPoint(x: 0.8424*width, y: 0.81433*height))
        path.addLine(to: CGPoint(x: 0.84104*width, y: 0.44803*height))
        path.addCurve(to: CGPoint(x: 0.8465*width, y: 0.40617*height), control1: CGPoint(x: 0.84209*width, y: 0.43098*height), control2: CGPoint(x: 0.84392*width, y: 0.4171*height))
        path.addCurve(to: CGPoint(x: 0.85489*width, y: 0.38982*height), control1: CGPoint(x: 0.84906*width, y: 0.39523*height), control2: CGPoint(x: 0.85189*width, y: 0.38982*height))
        path.addCurve(to: CGPoint(x: 0.86226*width, y: 0.40664*height), control1: CGPoint(x: 0.85808*width, y: 0.38982*height), control2: CGPoint(x: 0.86053*width, y: 0.39547*height))
        path.addCurve(to: CGPoint(x: 0.86589*width, y: 0.46332*height), control1: CGPoint(x: 0.86401*width, y: 0.41793*height), control2: CGPoint(x: 0.86521*width, y: 0.43674*height))
        path.addCurve(to: CGPoint(x: 0.86691*width, y: 0.57668*height), control1: CGPoint(x: 0.86657*width, y: 0.48989*height), control2: CGPoint(x: 0.86691*width, y: 0.52764*height))
        path.addLine(to: CGPoint(x: 0.86691*width, y: 0.65746*height))
        path.addLine(to: CGPoint(x: 0.86694*width, y: 0.65746*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.94295*width, y: 0.69356*height))
        path.addCurve(to: CGPoint(x: 0.94374*width, y: 0.78399*height), control1: CGPoint(x: 0.94295*width, y: 0.73377*height), control2: CGPoint(x: 0.94321*width, y: 0.76388*height))
        path.addCurve(to: CGPoint(x: 0.94703*width, y: 0.82797*height), control1: CGPoint(x: 0.94426*width, y: 0.8041*height), control2: CGPoint(x: 0.94536*width, y: 0.81868*height))
        path.addCurve(to: CGPoint(x: 0.95474*width, y: 0.84172*height), control1: CGPoint(x: 0.9487*width, y: 0.83714*height), control2: CGPoint(x: 0.95126*width, y: 0.84172*height))
        path.addCurve(to: CGPoint(x: 0.96438*width, y: 0.81715*height), control1: CGPoint(x: 0.95942*width, y: 0.84172*height), control2: CGPoint(x: 0.96266*width, y: 0.83349*height))
        path.addCurve(to: CGPoint(x: 0.96723*width, y: 0.73542*height), control1: CGPoint(x: 0.96613*width, y: 0.80081*height), control2: CGPoint(x: 0.96707*width, y: 0.77353*height))
        path.addLine(to: CGPoint(x: 0.99425*width, y: 0.7426*height))
        path.addCurve(to: CGPoint(x: 0.99448*width, y: 0.76506*height), control1: CGPoint(x: 0.99441*width, y: 0.74801*height), control2: CGPoint(x: 0.99448*width, y: 0.75553*height))
        path.addCurve(to: CGPoint(x: 0.98393*width, y: 0.89476*height), control1: CGPoint(x: 0.99448*width, y: 0.82291*height), control2: CGPoint(x: 0.99096*width, y: 0.86618*height))
        path.addCurve(to: CGPoint(x: 0.95408*width, y: 0.93768*height), control1: CGPoint(x: 0.9769*width, y: 0.92334*height), control2: CGPoint(x: 0.96694*width, y: 0.93768*height))
        path.addCurve(to: CGPoint(x: 0.92163*width, y: 0.8723*height), control1: CGPoint(x: 0.93864*width, y: 0.93768*height), control2: CGPoint(x: 0.92782*width, y: 0.91592*height))
        path.addCurve(to: CGPoint(x: 0.91233*width, y: 0.67004*height), control1: CGPoint(x: 0.91541*width, y: 0.82867*height), control2: CGPoint(x: 0.91233*width, y: 0.76129*height))
        path.addLine(to: CGPoint(x: 0.91233*width, y: 0.56068*height))
        path.addCurve(to: CGPoint(x: 0.92197*width, y: 0.35478*height), control1: CGPoint(x: 0.91233*width, y: 0.46673*height), control2: CGPoint(x: 0.91554*width, y: 0.39805*height))
        path.addCurve(to: CGPoint(x: 0.955*width, y: 0.28987*height), control1: CGPoint(x: 0.9284*width, y: 0.31151*height), control2: CGPoint(x: 0.9394*width, y: 0.28987*height))
        path.addCurve(to: CGPoint(x: 0.97975*width, y: 0.31644*height), control1: CGPoint(x: 0.96574*width, y: 0.28987*height), control2: CGPoint(x: 0.974*width, y: 0.29869*height))
        path.addCurve(to: CGPoint(x: 0.9919*width, y: 0.39923*height), control1: CGPoint(x: 0.98549*width, y: 0.3342*height), control2: CGPoint(x: 0.98954*width, y: 0.36172*height))
        path.addCurve(to: CGPoint(x: 0.99542*width, y: 0.55456*height), control1: CGPoint(x: 0.99425*width, y: 0.43674*height), control2: CGPoint(x: 0.99542*width, y: 0.48848*height))
        path.addLine(to: CGPoint(x: 0.99542*width, y: 0.66181*height))
        path.addLine(to: CGPoint(x: 0.94295*width, y: 0.66181*height))
        path.addLine(to: CGPoint(x: 0.94295*width, y: 0.69356*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.94692*width, y: 0.39841*height))
        path.addCurve(to: CGPoint(x: 0.94374*width, y: 0.4418*height), control1: CGPoint(x: 0.94533*width, y: 0.40722*height), control2: CGPoint(x: 0.94429*width, y: 0.42169*height))
        path.addCurve(to: CGPoint(x: 0.94295*width, y: 0.53329*height), control1: CGPoint(x: 0.94321*width, y: 0.4619*height), control2: CGPoint(x: 0.94295*width, y: 0.49236*height))
        path.addLine(to: CGPoint(x: 0.94295*width, y: 0.5782*height))
        path.addLine(to: CGPoint(x: 0.96587*width, y: 0.5782*height))
        path.addLine(to: CGPoint(x: 0.96587*width, y: 0.53329*height))
        path.addCurve(to: CGPoint(x: 0.96496*width, y: 0.4418*height), control1: CGPoint(x: 0.96587*width, y: 0.49307*height), control2: CGPoint(x: 0.96556*width, y: 0.46261*height))
        path.addCurve(to: CGPoint(x: 0.96166*width, y: 0.39782*height), control1: CGPoint(x: 0.96435*width, y: 0.42098*height), control2: CGPoint(x: 0.96326*width, y: 0.4064*height))
        path.addCurve(to: CGPoint(x: 0.95429*width, y: 0.385*height), control1: CGPoint(x: 0.96007*width, y: 0.38935*height), control2: CGPoint(x: 0.95761*width, y: 0.385*height))
        path.addCurve(to: CGPoint(x: 0.94692*width, y: 0.39841*height), control1: CGPoint(x: 0.95095*width, y: 0.38512*height), control2: CGPoint(x: 0.94849*width, y: 0.38959*height))
        path.closeSubpath()
        return path
    }
}
