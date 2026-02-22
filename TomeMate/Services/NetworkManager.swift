//
//  NetworkManager.swift
//  TomeMate
//
//  Created by NRD on 21/02/2026.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    private let baseURL = "http://127.0.0.1:8000"
    
    // MARK: - SPELLS
    func fetchSpells(query: String, completion: @escaping (Result<[SpellModel], Error>) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/spells?name=\(encodedQuery)") else {
            return
        }
        
        fetch(url: url, completion: completion)
    }
    
    // MARK: - CREATURES
    func fetchCreatures(by id: String, completion: @escaping (Result<CreatureModel, Error>) -> Void) {
        guard let encodedID = id.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
              let url = URL(string: "\(baseURL)/creatures/\(encodedID)") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoded = try JSONDecoder().decode(CreatureModel.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decoded))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            
        }.resume()
    }
    
    // MARK: - ITEMS
    func fetchItems(query: String, completion: @escaping (Result<[ItemModel], Error>) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/items?q=\(encodedQuery)") else {
            return
        }
        
        fetch(url: url, completion: completion)
    }
    
    private func fetch<T: Decodable>(url: URL, completion: @escaping (Result<[T], Error>) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoded = try JSONDecoder().decode([T].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decoded))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            
        }.resume()
    }
}
