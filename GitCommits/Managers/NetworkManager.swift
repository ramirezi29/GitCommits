//
//  NetworkManager.swift
//  GitCommits
//
//  Created by Ivan Ramirez on 5/15/21.
//

import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    private let baseURL = Constants.baseURL
    
    /**
     Get the user's repository based on their GitHub user name
     - name
     - avatarURL
     - login
     
     ## Important Note ##
     The user name needs to be valid in order to fully run the fetch request.
     */
    func fetchRepos(for user: String, completion: @escaping (Result<[Repo], NetworkingError>) -> Void) {
        
        guard var url = URL(string:baseURL) else {
            completion(.failure(.badBaseURL))
            return
        }
        
        url.appendPathComponent(Constants.usersText)
        url.appendPathComponent(user)
        url.appendPathComponent(Constants.reposText)
        
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        guard let builtURL = components?.url else {
            completion(.failure(.badBuiltURL))
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
     Get the user avatar image from their GitHub account
     
     ## Note ##
     If no avatar image is found no image will be returned
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
    
    /**
     This function fetches the following details from a user's GitHub account
     - sha
     - message
     - name
     - date
     
     ## Important Note ##
     The user name needs to be valid
     */
    func getRepoDetails(for githubUser: String, repoName: String, completion: @escaping (Result<[RepoCommit], NetworkingError>) -> Void) {
        
        guard var url = URL(string:baseURL) else {
            completion(.failure(.badBaseURL))
            return
        }
        
        url.appendPathComponent(Constants.reposText)
        url.appendPathComponent(githubUser)
        url.appendPathComponent(repoName)
        url.appendPathComponent(Constants.commitsText)
        
        let itemQuery = URLQueryItem(name: Constants.perPageText, value: Constants.twentyFiveText)
        
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
        url.appendPathComponent(Constants.usersText)
        url.appendPathComponent(user)
        
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        guard let builtURL = components?.url else {
            completion(.failure(.badBuiltURL))
            return
        }
        
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

