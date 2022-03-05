//
//  Network Helper.swift
//  MovieDB
//
//  Created by Damir Yackupov on 04.03.2022.
//

import Foundation

enum NetworkError: Error {
    case wrongURL
    case dataIsEmpty
    case decodeIsFail
}

final class NetworkHelper {
    
    private func baseRequest<T: Decodable>(url: String, completion: @escaping (Result<T, Error>) -> Void) {
        
        guard let url = URL(string: url) else {
            completion(.failure(NetworkError.wrongURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.dataIsEmpty))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let decodedModel = try decoder.decode(T.self, from: data)
                    completion(.success(decodedModel))
            } catch {
                    completion(.failure(NetworkError.decodeIsFail))
                    print(error)
            }
            
        }.resume()
    }
    
    func requestMovies(with url: String, and completion: @escaping (Result<MovieModel, Error>) -> Void) {
       
        let url = url
        self.baseRequest(url: url, completion: completion)
    }
    
}
