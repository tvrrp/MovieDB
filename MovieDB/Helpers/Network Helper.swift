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

    var dataTasks: [URLSessionDataTask] = []

    private func baseRequest<T: Decodable>(url: String, completion: @escaping (Result<T, Error>) -> Void) {


        guard let url = URL(string: url) else {
            completion(.failure(NetworkError.wrongURL))
            return
        }

        if dataTasks.firstIndex(where: { task in
            return task.originalRequest?.url == url
        }) != nil {
            return
        }

        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            
          //  print("Data task: \(data)")
            
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
        }
        dataTask.resume()
        dataTasks.append(dataTask)
    }

    func requestMovies(with url: String, and completion: @escaping (Result<MovieModel, Error>) -> Void) {

        let url = url
        self.baseRequest(url: url, completion: completion)
    }
    
    func requestMoviePost(with url: String, and completion: @escaping (Result<MoviePost, Error>) -> Void) {

        let url = url
        self.baseRequest(url: url, completion: completion)
    }
    
    func cancelRequestMovies(with url: String) {

        guard let url = URL(string: url) else {return}
        
        guard let dataTaskIndex = dataTasks.firstIndex(where: { task in
            task.originalRequest?.url == url
        }) else {
            return
        }
      
      let dataTask = dataTasks[dataTaskIndex]

      dataTask.cancel()
      dataTasks.remove(at: dataTaskIndex)
    }

}
