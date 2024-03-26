//
//  VersionControlService.swift
//  Shifu
//
//  Created by Baoli Zhai on 2024/4/29.
//

import Foundation

public struct RepositoryFile {
    public enum FileType: String{
        case file, dir, unknown
    }
    public let path: String
    public let downloadUrl: String?
    public let type: FileType
    init(path: String, downloadUrl: String?, type: String) {
        self.path = path
        self.downloadUrl = downloadUrl
        self.type = .init(rawValue: type) ?? .unknown
    }
    init(path: String, downloadUrl: String?, type: FileType) {
        self.path = path
        self.downloadUrl = downloadUrl
        self.type = type
    }
}

protocol VersionControlService {
    var token:String { get }
    var owner:String { get }
    var repo:String { get }
    func uploadFiles(files: [RepositoryFile], toPath path: String, completion: @escaping (Bool) -> Void)
    func downloadFiles(fromPath path: String, completion: @escaping ([RepositoryFile]) -> Void)
    func listRepositoryContents(path: String, completion: @escaping ([RepositoryFile]) -> Void)
}


public class GitHubService: VersionControlService {
    var token:String
    var owner:String
    var repo:String
    public init(owner:String, repo: String, token:String){
        self.owner = owner
        self.repo = repo
        self.token = token;
    }
    func uploadFiles(files: [RepositoryFile], toPath path: String, completion: @escaping (Bool) -> Void) {
        // Implement using GitHub API
    }
    
    func downloadFiles(fromPath path: String, completion: @escaping ([RepositoryFile]) -> Void) {
        // Implement using GitHub API
    }
    
    public func listRepositoryContents(path: String = "", completion: @escaping ([RepositoryFile]) -> Void) {
        let path = "https://api.github.com/repos/\(owner)/\(repo)/contents/\(path)"
        guard let url = URL(string: path) else {
            completion([])
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("token \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion([])
                return
            }
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    self.processItems(jsonResult, completion: completion)
                } else {
                    completion([])
                }
            } catch {
                completion([])
            }
        }
        task.resume()
        
    }
    
        
    private func processItems(_ items: [[String: Any]], completion: @escaping ([RepositoryFile]) -> Void) {
        var files = [RepositoryFile]()
        let group = DispatchGroup()
        
        for item in items {
            guard let rawType = item["type"] as? String, let type = RepositoryFile.FileType(rawValue: rawType), let path = item["path"] as? String else {
                continue
            }
            
            let file = RepositoryFile(path: path, downloadUrl: item["download_url"] as? String, type: type)
            if type == .file {
                files.append(file)
            } else if type == .dir {
                group.enter()
                listRepositoryContents(path: path){ nestedFiles in
                    files.append(contentsOf: nestedFiles)
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            completion(files)
        }
    }
}


extension String {
    func appendingPathComponent(_ component: String) -> String {
        return URL(fileURLWithPath: self).appendingPathComponent(component).absoluteString
    }
}
