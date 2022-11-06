import Shifu

public class ShifuWebServer{
    public static var version = 1.0
}

private let _clg = Shifu.clg(prefix: "🔎")
func clg(file: String = #file, line: Int = #line,  _ args: Any...){
    if let fn = file.url?.filename{
        _clg(args + ["(\(fn):\(line))"])
    }
}
