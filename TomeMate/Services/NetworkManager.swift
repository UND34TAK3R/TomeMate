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
<<<<<<< HEAD
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
            
=======
    func fetchSpells(query: String, page: Int = 1, pageSize: Int = 10, completion: @escaping (Result<PaginatedSpells, Error>) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/spells?name=\(encodedQuery)&page=\(page)&page_size=\(pageSize)") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error { DispatchQueue.main.async { completion(.failure(error)) }; return }
            guard let data = data else { return }
            do {
                let decoded = try JSONDecoder().decode(PaginatedSpells.self, from: data)
                DispatchQueue.main.async { completion(.success(decoded)) }
            } catch {
                print("Decode error:", error)
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }.resume()
    }
    
    func fetchSpell(id: String) async throws -> SpellModel {
        guard let url = URL(string: "\(baseURL)/spells/\(id)") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(SpellModel.self, from: data)
    }
    
    // MARK: - CREATURES
    func fetchCreatures(query: String, page: Int = 1, pageSize: Int = 10, completion: @escaping (Result<PaginatedCreatures, Error>) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/creatures?q=\(encodedQuery)&page=\(page)&page_size=\(pageSize)") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error { DispatchQueue.main.async { completion(.failure(error)) }; return }
            guard let data = data else { return }
            do {
                let decoded = try JSONDecoder().decode(PaginatedCreatures.self, from: data)
                DispatchQueue.main.async { completion(.success(decoded)) }
            } catch {
                print("Decode error:", error)
                DispatchQueue.main.async { completion(.failure(error)) }
            }
>>>>>>> 5d27657d6188f90f8e73648ea20374fbb40dc312
        }.resume()
    }
    
    // MARK: - ITEMS
<<<<<<< HEAD
    func fetchItems(query: String, completion: @escaping (Result<[ItemModel], Error>) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/items?q=\(encodedQuery)") else {
=======
    func fetchItems(query: String, page: Int = 1, pageSize: Int = 10, completion: @escaping (Result<PaginatedItems, Error>) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/items?q=\(encodedQuery)&page=\(page)&page_size=\(pageSize)") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error { DispatchQueue.main.async { completion(.failure(error)) }; return }
            guard let data = data else { return }
            do {
                let decoded = try JSONDecoder().decode(PaginatedItems.self, from: data)
                DispatchQueue.main.async { completion(.success(decoded)) }
            } catch {
                print("Decode error:", error)
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }.resume()
    }
    
    //MARK: - CLASSES
    func fetchClasses(query: String, completion:@escaping (Result<[ClassesModel], Error>) -> Void){
        guard let url = URL(string: "\(baseURL)/classes") else {
            return
        }
        
        fetch(url: url, completion: completion)
    }
    func fetchSubClasses(query: String, completion:@escaping (Result<[SubclassModel], Error>) -> Void){
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/subclasses?className=\(encodedQuery)") else {
>>>>>>> 5d27657d6188f90f8e73648ea20374fbb40dc312
            return
        }
        
        fetch(url: url, completion: completion)
    }
    
<<<<<<< HEAD
=======
    //MARK: - RACES
    func fetchRaces(query: String, completion:@escaping (Result<[RaceModel], Error>) -> Void){
        guard let url = URL(string: "\(baseURL)/races") else {
            return
        }
        
        fetch(url: url, completion: completion)
    }
    func fetchSubraces(query: String, completion:@escaping (Result<[SubraceModel], Error>) -> Void){
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/subraces?raceName=\(encodedQuery)") else {
            return
        }
        
        fetch(url: url, completion: completion)
    }
    
    //MARK: BACKGROUNDS
    func fetchBackgrounds(completion:@escaping(Result<[BackgroundModel], Error>)->Void){
        let url = URL(string: "\(baseURL)/backgrounds")!
        fetch(url: url, completion: completion)
    }
    
    //MARK: SKILLS
    func fetchSkills(completion:@escaping(Result<[SkillsModel], Error>)->Void){
        let url = URL(string: "\(baseURL)/skills")!
        fetch(url: url, completion: completion)
    }
    
    //MARK: LABGUAGES
    func fetchLanguages(completion:@escaping(Result<[LanguageModel], Error>) ->Void){
        let url = URL(string: "\(baseURL)/languages")!
        fetch(url: url, completion: completion)
    }
    
    // MARK: FETCH FUNCTION
>>>>>>> 5d27657d6188f90f8e73648ea20374fbb40dc312
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
<<<<<<< HEAD
=======


struct PaginatedSpells: Decodable {
    let total_pages: Int
    let data: [SpellModel]
}

struct PaginatedItems: Decodable {
    let total_pages: Int
    let data: [ItemModel]
}

struct PaginatedCreatures: Decodable {
    let total_pages: Int
    let data: [CreatureModel]
}
>>>>>>> 5d27657d6188f90f8e73648ea20374fbb40dc312
