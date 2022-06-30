
```swift
let bounds = UIScreen.main.bounds.offsetBy(dx: -UIScreen.main.bounds.width/2, dy: -UIScreen.main.bounds.height/2).insetBy(dx: 0, dy: 68)

struct OnEnterFrameDemo:View{
    @State var isEnterFrameActive = true
    @StateObject var ballGroup = Balls()
    var body: some View{
        
        ZStack{
            ForEach(ballGroup.balls, id: \.self){ b in
                ZStack{
                    Circle()
                        .frame(height: 200)
                        .foregroundColor(b.color)
                    Circle()
                        .frame(width: 50, height: 30)
                        .scaleEffect(x: 2)
                        .rotationEffect(.degrees(-42))
                        .foregroundColor(.white)
                        .offset(x:-50, y:-50)
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                        .offset(x:-75, y:-10)
                }
                .scaleEffect(b.size / 200)
                .offset(x: b.position.x, y: b.position.y)
                
            }
            Rectangle()
                .fill(.black)
                .frame(width: UIScreen.main.bounds.width, height:  300)
                .offset(y: 544)
        }
        .onTapGesture {
            ballGroup.balls.filter{ $0.isStill }.forEach { b in
                b.v = .random(in: .zero.insetBy(dx: -30, dy: -30))
            }
        }
        .onEnterFrame(isActive: isEnterFrameActive) { f in
            ballGroup.balls.forEach { b in
                b.update()
            }
            balls.updatedCount += 1
        }
        .padding(50)
    }
}

class Balls: ObservableObject{
    @Published var balls = (0..<100).map{_ in Ball(size: .random(in: 40...70), position: CGPoint.random(in: CGRect(-UIScreen.main.bounds.width/2, -UIScreen.main.bounds.height/2, UIScreen.main.bounds.width, 500 ) ), v: CGPoint.random(in: CGRect(-20, -2, 40, 4) ), bounds: bounds) }
    @Published var updatedCount = 0
}

class Ball: ObservableObject, Hashable, Identifiable{
    static func == (lhs: Ball, rhs: Ball) -> Bool {
        lhs.id == rhs.id
    }
    
    let id = UUID()
    let g: CGFloat = 0.4
    let damp: CGFloat = 0.9
    let size: CGFloat
    @Published var position:CGPoint
    @Published var rotation:Double = 0
    var color: Color = .random.opacity(0.8)
    var v: CGPoint
    let bounds: CGRect
    init(size: CGFloat, position: CGPoint, v: CGPoint, bounds: CGRect) {
        self.size = size
        self.position = position
        self.v = v
        self.bounds = bounds
    }
    
    var isStill:Bool = true
    
    func update(){
        v += CGPoint(0, g)
        position += v
        
        if position.x - size/2 < bounds.minX {
            position = CGPoint(bounds.minX + size/2 , position.y)
            v = CGPoint(-v.x * damp, v.y)
        }
        if position.x + size/2 > bounds.maxX {
            position = CGPoint(bounds.maxX - size/2, position.y)
            v = CGPoint(-v.x * damp, v.y)
        }
        // upper bound
        if position.y - size/2 < bounds.minY - 400{
            position = CGPoint(position.x, bounds.minY - 400 + size/2)
            v = CGPoint(v.x, -v.y * damp)
        }
        if position.y + size/2 > bounds.maxY {
            position = CGPoint(position.x, bounds.maxY - size/2)
            v = CGPoint(v.x * damp, -v.y * damp)
        }
        rotation += v.x
        if(v.distance() < 5 && (position.y + size/2 + 50 >= bounds.maxY)){
            isStill = true
        }else{
            isStill = false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


```
