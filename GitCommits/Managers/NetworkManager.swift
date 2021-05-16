//
//  NetworkManager.swift
//  GitCommits
//
//  Created by Ivan Ramirez on 5/15/21.
//

import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    private let baseURL = "https://api.github.com/users/"
    
    /**
     Get the user based on their GitHub user name
     
     ## Important Note ##
     The user name needs to be valid
     */
    func fetchRepos(for username: String, completion: @escaping (Result<[Repo], NetworkingError>) -> Void) {
        
        guard var url = URL(string:baseURL) else {
            completion(.failure(.badBaseURL("Base URL is not valid")))
            return
        }
        // https://api.github.com/repos/ramirezi29/cardsofoppurtunity/commits
        // https://api.github.com/users/ramirezi29/repos
        url.appendPathComponent("\(username)")
        url.appendPathComponent("repos")
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        guard let builtURL = components?.url else {
            completion(.failure(.badBuiltURL("Complete URL is not valid")))
            print("Error with built URL")
            return
        }
        
        print(builtURL)
        URLSession.shared.dataTask(with: builtURL) { (data, _, error) in
            
            if let error = error {
                completion(.failure(NetworkingError.forwardedError(error)))
                print(error.localizedDescription)
                return
            }
            
//            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 400 else {
//
//
//                return
//            guard (response != nil), let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 400 else {
//                completion(.failure(NetworkingError.invalidRespone("\(response.debugDescription)")))
//                print(response.debugDescription)
//                return
//            }
            
            guard let data = data else {
                completion(.failure(.invalidData("Invalid Data")))
                print(error?.localizedDescription as Any)
               
                return
            }
            
            let decoder = JSONDecoder()
        
            do {
                let user = try decoder.decode([Repo].self, from: data)
                completion(.success(user))
                print(user.count)
            } catch {
                print(error.localizedDescription)
                completion(.failure(.forwardedError(error)))
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
            return(completion(.failure(.badBuiltURL("Check the URL"))))
           
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(.failure(.forwardedError(error)))
            return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData("The data was invalid")))
                return
            }
            
            let image = UIImage(data: data)
            completion(.success(image))
        }.resume()
    }
    
}
    

