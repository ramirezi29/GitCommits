//
//  NetworkManager.swift
//  GitCommits
//
//  Created by Ivan Ramirez on 5/15/21.
//

import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    private let baseURL = "https://api.github.com"
    
    /**
     Get the user based on their GitHub user name
     
     ## Important Note ##
     The user name needs to be valid
     */
    func fetchRepos(for user: String, completion: @escaping (Result<[Repo], NetworkingError>) -> Void) {
        
        guard var url = URL(string:baseURL) else {
            completion(.failure(.badBaseURL))
            return
        }
        
        // https://api.github.com/repos/ramirezi29/cardsofoppurtunity/commits
        // https://api.github.com/users/ramirezi29/repos
        url.appendPathComponent("users")
        url.appendPathComponent(user)
        url.appendPathComponent("repos")
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        guard let builtURL = components?.url else {
            completion(.failure(.badBuiltURL))
            print("Error with built URL")
            return
        }
        
        URLSession.shared.dataTask(with: builtURL) { (data, response, error) in
            
            if let error = error {
                completion(.failure(.errorWithRequest))
                print(error.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let user = try decoder.decode([Repo].self, from: data)
                completion(.success(user))
            } catch {
                print(error.localizedDescription)
                completion(.failure(.errorWithRequest))
            }
        }.resume()
    }
    
    /**
     Get the user's avatar image'
     
     ## Important Note ##
     The user name needs to be valid
     */
    func fetchAvatar(from repo: Repo, completion: @escaping (Result<UIImage?, NetworkingError>) -> Void) {
        
        guard let url = repo.owner.avatarURL else {
            return(completion(.failure(.badBuiltURL)))
            
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let _ = error {
                completion(.failure(.errorWithRequest))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            let image = UIImage(data: data)
            completion(.success(image))
        }.resume()
    }
    
    func getRepoDetails(for githubUser: String, repoName: String, completion: @escaping (Result<[RepoCommit], NetworkingError>) -> Void) {
        
        //https://api.github.com/repos/ramirezi29/cardsofoppurtunity/commits
        //https://api.github.com/repos/ramirezi29/AlarmClock_iOS22/Commits/per_page=25
        
        // ->> https://api.github.com/repos/ramirezi29/cardsofoppurtunity/commits/per_page=25
        guard var url = URL(string:baseURL) else {
            completion(.failure(.badBaseURL))
            return
        }
        
        url.appendPathComponent("repos")
        url.appendPathComponent(githubUser)
        url.appendPathComponent(repoName)
        url.appendPathComponent("commits")
        let itemQuery = URLQueryItem(name: "per_page", value: "25")
        
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = [itemQuery]
        
        guard let builtURL = components?.url else {
            completion(.failure(.badBuiltURL))
            return
        }
        
        URLSession.shared.dataTask(with: builtURL) { data, response, error in
            if let _ = error {
                completion(.failure(.errorWithRequest))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let repoCommit = try decoder.decode([RepoCommit].self, from: data)
                
                completion(.success(repoCommit))
            } catch {
                completion(.failure(.errorWithRequest))
            }
        }.resume()
    }
    
    func fetchDetails(of user: String, completion: @escaping (Result<User, NetworkingError>) -> Void) {
        
        guard var url = URL(string: baseURL) else {
            completion(.failure(.badBaseURL))
            return
        }
        url.appendPathComponent("users")
        url.appendPathComponent(user)
        
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        guard let builtURL = components?.url else {
            completion(.failure(.badBuiltURL))
            print("Error with built URL")
            return
        }
        print("\n❤️\(builtURL.absoluteURL)\n")
        URLSession.shared.dataTask(with: builtURL) { (data, _, error) in
            
            if let error = error {
                completion(.failure(.errorWithRequest))
                print(error.localizedDescription)
                return
            }
            guard let data = data else {
                completion(.failure(.invalidData))
                print(error?.localizedDescription as Any)
                
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let user = try decoder.decode(User.self, from: data)
                completion(.success(user))
            } catch {
                print(error.localizedDescription)
                completion(.failure(.errorWithRequest))
            }
        }.resume()
    }
}

