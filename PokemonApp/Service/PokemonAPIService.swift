//
//  PokemonAPIService.swift
//  PokemonApp
//
//  Created by Vladan Randjelovic on 10.5.24..
//

import Foundation

class PokemonAPIService {
    
    func getPokemons<T: Decodable>(url: String, completion: @escaping (T?, Error?) -> Void) {
        guard let url = URL(string: url) else {
            completion(nil, NSError(domain: "URL", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                let error = NSError(domain: "HTTP", code: statusCode, userInfo: nil)
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "Data", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let decodedObject = try decoder.decode(T.self, from: data)
                completion(decodedObject, nil)
            } catch {
                completion(nil, error)
            }
        }
        
        task.resume()
    }
    
    func getPokemonDetails<T: Decodable>(url: String, model: T.Type, completion: @escaping (T) -> (), failure: @escaping(Error) -> ()) {
        
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                if let error = error {
                    failure(error)
                }
                return
            }
            do {
                let serverData = try JSONDecoder().decode(T.self, from: data)
                onMain {
                    completion(serverData)
                }
            } catch {
                failure(error)
            }
        }.resume()
    }
    
    
}

func onMain(completion: @escaping () -> Void ) {
    DispatchQueue.main.async {
        completion()
    }
}
