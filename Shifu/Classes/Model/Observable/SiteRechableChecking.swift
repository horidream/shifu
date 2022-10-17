//
//  SiteRechableChecking.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/10/16.
//

import Foundation

func checkWebsiteReachable(_ site: String, completion: @escaping (Bool) -> Void )->URLSessionDataTask? {
    let site = site.starts(with: "http") ? site : "https://"+site
    guard let url = URL(string: site ) else {
        completion(false)
        return nil
    }

    var request = URLRequest(url: url)
    request.timeoutInterval = 5.0

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            #if DEBUG
            print("\(error.localizedDescription)")
            #endif
            if (error as NSError).code != NSURLErrorCancelled{
                completion(false)
            }
        }
        if let httpResponse = response as? HTTPURLResponse {
            #if DEBUG
            print("statusCode: \(httpResponse.statusCode)")
            #endif
            completion(httpResponse.statusCode >= 200 && httpResponse.statusCode < 400)
        }
    }
    task.resume()
    return task
}

public class SiteRechableChecking: ObservableObject {
    public private(set) var isAvailable: Bool  {
        didSet {
            self.isChecking = false
            if isAvailable != oldValue {
                objectWillChange.send()
            }
        }
    }
    
    private(set) var sitesReachable: [Bool?]{
        didSet{
            if sitesReachable.contains(false){
                isAvailable = false
            } else if !sitesReachable.contains(nil) {
                isAvailable = sitesReachable.compactMap{ $0 }
                    .reduce(true) { partialResult, next in
                        partialResult && next
                    }
            }
            
        }
    }
    private var isChecking = false
    let sites: [String]
    private var tasks: [URLSessionDataTask?] = []
    public init(sites: [String], initValue: Bool = true) {
        self.sites = sites
        isAvailable = initValue
        sitesReachable = sites.map{_ in nil }
        check()
    }
    
    public func check(){
        sitesReachable = sites.map{_ in nil }
        tasks.forEach { task in
            task?.cancel()
        }
        isChecking = true
        for (index, site) in sites.enumerated(){
            tasks.append(checkWebsiteReachable(site) { [weak self] success in
                if self?.isChecking == true {
                    self?.sitesReachable[index] = success
                }
            })
        }
    }
}
