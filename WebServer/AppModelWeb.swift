//
//  AppModelWeb.swift
//  Shifu
//
//  Created by Baoli Zhai on 2021/4/7.
//

import Shifu
import GCDWebServer
import Combine


public protocol AppModelWeb{
    var serverURL:URL? { get set }
}

private struct Keys {
    static var serverURLKey = "serverURLKey"
}
@available(iOS 13.0, *)
public extension AppModelWeb where Self: AppModelBase, Self: ObservableObject, Self.ObjectWillChangePublisher == ObservableObjectPublisher{
    public var server:GCDWebServer {
        get{
            getProperty("webServer", fallback: GCDWebServer())
        }
    }
    
    public var serverIsReady:Bool{
        serverURL != nil
    }
    
    public var serverURL:URL? {
        get {
            objc_getAssociatedObject(self, &Keys.serverURLKey) as? URL
        }
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objectWillChange.send()
                objc_setAssociatedObject(self, &Keys.serverURLKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        
    }
    
    private var delegate:WebServerDelegate {
        get{
            getProperty("webServerDelegate", fallback: WebServerDelegate())
        }
    }
    
    public func initServer() {
        GCDWebServer.setLogLevel(4)
        self.server.delegate = delegate
        delegate.model = self
    }
    
    public func useStatic(_ path: String? = Shifu.bundle.resourceURL?.appendingPathComponent("web").relativePath){
        if let path = path?.url?.relativePath {
            self.server.addGETHandler(forBasePath: "/", directoryPath: path, indexFilename: "index.html", cacheAge: 0, allowRangeRequests: true)
        }
    }
    
    public var currentLanguage:String{
        return  Locale.current.languageCode ?? "en"
    }
    
    public func startServer(port:Int = 9338, isLocal: Bool = false){
        do{
            if(server.isRunning){
                server.stop()
            }
            try server.start(options:  [
                "BindToLocalhost": isLocal,
                "Port": port,
                GCDWebServerOption_AutomaticallySuspendInBackground: false
            ])
            
        }catch{
            print("server start error: \(error)")
        }
    }
    
    public func stopServer(){
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.server.stop()
        }
    }
    
    func handle(method: String, path: String, handler: @escaping (GCDWebServerDataRequest)->GCDWebServerDataResponse){
        
        server.addHandler(forMethod: method, pathRegex: path, request: GCDWebServerDataRequest.self) { req, done in
            if let req = req as? GCDWebServerDataRequest{
                done(handler(req))
            }else {
                let res = GCDWebServerResponse()
                res.statusCode = 400
                done(res)
            }
        }
    }
    
    func get(_ path: String, _ handler: @escaping (GCDWebServerDataRequest)->GCDWebServerDataResponse) {
        handle(method: "GET", path: path, handler: handler)
    }
    
    func post(_ path: String, _ handler: @escaping (GCDWebServerDataRequest)->GCDWebServerDataResponse) {
        handle(method: "POST", path: path, handler: handler)
    }
    
//    public func url(pathName string:String)->URL?{
//        // url will be like "#/welcome"
//        var comp = URLComponents(string: serverURL?.absoluteString.appending(string) ?? string)
//        let queryItems = [URLQueryItem(name: "lancode", value: currentLanguage)];
//        comp?.queryItems = queryItems
//        return comp?.url
//    }
}

@available(iOS 14.0, *)
class WebServerDelegate:NSObject, GCDWebUploaderDelegate {
    var model: AppModelWeb?
    let didStopPublisher = PassthroughSubject<Void, Never>()
    func webServerDidStart(_ server: GCDWebServer) {
        model?.serverURL = server.serverURL
    }
    
    func webServerDidStop(_ server: GCDWebServer) {
        model?.serverURL = nil
        didStopPublisher.send()
    }
    
    func webServerDidCompleteBonjourRegistration(_ server: GCDWebServer) {

    }
    func webUploader(_: GCDWebUploader, didUploadFileAtPath path: String) {
        print("[UPLOAD] \(path)")
    }
    
    func webUploader(_: GCDWebUploader, didDownloadFileAtPath path: String) {
        print("[DOWNLOAD] \(path)")
    }
    
    func webUploader(_: GCDWebUploader, didMoveItemFromPath fromPath: String, toPath: String) {
        print("[MOVE] \(fromPath) -> \(toPath)")
    }
    
    func webUploader(_: GCDWebUploader, didCreateDirectoryAtPath path: String) {
        print("[CREATE] \(path)")
    }
    
    func webUploader(_: GCDWebUploader, didDeleteItemAtPath path: String) {
        print("[DELETE] \(path)")
    }
}


public extension GCDWebServerResponse {
    static let res404 = GCDWebServerDataResponse(statusCode: 404)
    public static func text(_ text:String)->GCDWebServerDataResponse{
        GCDWebServerDataResponse(text: text) ?? res404
    }
    public static func json(_ object: Any)->GCDWebServerDataResponse{
        GCDWebServerDataResponse(jsonObject: object) ?? res404
    }
    public static func html(_ html: String)->GCDWebServerDataResponse{
        GCDWebServerDataResponse(html: html) ?? res404
    }
    public static func render(_ path: String, variables:[String: String] = [:])->GCDWebServerDataResponse{
        if let path = path.url?.relativePath{
            return GCDWebServerDataResponse(htmlTemplate: path , variables: variables) ?? res404
        } else {
            return res404
        }
    }
}
