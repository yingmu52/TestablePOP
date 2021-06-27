//
//  Service.swift
//  TestablePOP
//
//  Created by Xinyi Zhuang on 2021-06-27.
//

import Foundation

enum ServiceError: Error {
    case invalidURL
    case dataTaskError(Error)
    case decodeFailed
}

struct Item: Decodable, Equatable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.userId == rhs.userId
            && lhs.id == rhs.id
            && lhs.title == rhs.title
            && lhs.completed == rhs.completed
    }
}

protocol ServiceProtocol {
    func fetchItems(completion: @escaping ((Result<[Item], ServiceError>) -> Void))
}

final class Service: ServiceProtocol {
    func fetchItems(completion: @escaping ((Result<[Item], ServiceError>) -> Void)) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos") else {
            completion(.failure(.invalidURL))
            return
        }

        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(.dataTaskError(error)))
                return
            }
            
            guard let data = data,
                  let items = try? JSONDecoder().decode([Item].self, from: data) else {
                completion(.failure(.decodeFailed))
                return
            }
            completion(.success(items))
        }
        task.resume()
    }
}
