//
//  AppModelWeb.swift
//  Shifu
//
//  Created by Baoli Zhai on 2021/4/7.
//

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
    private var server:GCDWebServer {
        get{
            getProperty("webServer", fallback: GCDWebServer())
        }
    }
    
    var serverURL:URL? {
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
    
    func initServer(_ path: String? = Shifu.bundle.resourceURL?.appendingPathComponent("web").relativePath, port: Int = 9338, isLocal:Bool = true) {
        if(server.isRunning){
            server.stop()
        }
        GCDWebServer.setLogLevel(4)
        self.server.delegate = delegate
        delegate.model = self
        self.server.addGETHandler(forBasePath: "/", directoryPath: path ?? Bundle.main.resourcePath!, indexFilename: "index.html", cacheAge: 0, allowRangeRequests: true)
        startServer(port: port, isLocal: isLocal)
    }
    
    var currentLanguage:String{
        return  Locale.current.languageCode ?? "en"
    }
    
    func startServer(port:Int, isLocal: Bool){
        do{
            try server.start(options:  ["BindToLocalhost": isLocal, "Port": port])
        }catch{
            print("server start error: \(error)")
        }
    }
    
    func stopServer(){
        server.stop()
    }
    
    func url(pathName string:String)->URL?{
        // url will be like "#/welcome"
        var comp = URLComponents(string: serverURL?.absoluteString.appending(string) ?? string)
        let queryItems = [URLQueryItem(name: "lancode", value: currentLanguage)];
        comp?.queryItems = queryItems
        return comp?.url
    }
}

@available(iOS 13.0, *)
class WebServerDelegate:NSObject, GCDWebUploaderDelegate {
    var model: AppModelWeb?
    let didStopPublisher = PassthroughSubject<Void, Never>()
    func webServerDidStart(_ server: GCDWebServer) {
        model?.serverURL = server.serverURL
    }
    
    func webServerDidStop(_ server: GCDWebServer) {
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
