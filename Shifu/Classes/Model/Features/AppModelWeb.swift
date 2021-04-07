//
//  AppModelWeb.swift
//  Shifu
//
//  Created by Baoli Zhai on 2021/4/7.
//

import GCDWebServer



public protocol AppModelWeb{
    
}

@available(iOS 13.0, *)
public extension AppModelWeb where Self: AppModelBase{
    private var server:GCDWebServer {
        get{
            getProperty("webServer", fallback: GCDWebServer())
        }
    }
    
    var serverURL:URL? {
        return delegate.serverURL
    }
    
    private var delegate:WebServerDelegate {
        get{
            getProperty("webServerDelegate", fallback: WebServerDelegate())
        }
    }
    
    func initServer(_ path: String = "/web", port: Int = 9338, isLocal:Bool = true) {
        let folderPath = Bundle.main.resourcePath?.appending(path)
        GCDWebServer.setLogLevel(4)
        server.delegate = delegate
        server.addGETHandler(forBasePath: "/", directoryPath: folderPath!, indexFilename: "index.html", cacheAge: 0, allowRangeRequests: true)
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
class WebServerDelegate:NSObject, GCDWebUploaderDelegate, ObservableObject {
    var serverURL:URL?
    func webServerDidStart(_ server: GCDWebServer) {
        objectWillChange.send()
        serverURL = server.serverURL
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
