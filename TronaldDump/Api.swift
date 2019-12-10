//
//  Api.swift
//  TronaldDump
//
//  Created by Louis Loiseau-Billon on 31/10/2019.
//  Copyright © 2019 Louis Loiseau-Billon. All rights reserved.
//

import Foundation

class ApiManager: NSObject {
    let baseUrl: String = "https://api.tronalddump.io"
    
    func get(url: String, completion: @escaping (Any) -> Void) {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.addValue("application/hal+json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) { data, response, err in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                completion(json)
            } catch let error as NSError {
                print(error)
            }
            
        }.resume()
    }
    
    func getRandomQuote(completion: @escaping (Quote) -> Void) {
        
        self.get(url: baseUrl + "/random/quote", completion: { data in
            
            let results = data as! [String:Any]
            
            let value = results["value"] as! String
            let quote_id = results["quote_id"] as! String
            let embedded = results["_embedded"] as! [String: Any]
            let tags = results["tags"] as! [String]
            let authorObj = embedded["author"] as! [[String: Any]]
            let authorName = authorObj[0]["name"] as! String
            let sourceObj = embedded["source"] as! [[String: Any]]
            let sourceUrl = sourceObj[0]["url"] as! String
                
            let quote = Quote(
                value: value,
                quote_id: quote_id,
                tags: tags,
                author: authorName,
                source: sourceUrl
            )
            
            completion(quote)
        })
        
    }
    
    func getRandomMeme(completion: @escaping (Data, String) -> Void) {
        var request = URLRequest(url: URL(string: baseUrl + "/random/meme")!)
        request.httpMethod = "GET"
        request.addValue("image/jpeg", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) { data, response, err in
            do {
                var quote_id: String = ""
                if let httpResponse = response as? HTTPURLResponse {
                    if let tronald_quote_id = httpResponse.allHeaderFields["tronald-quote-id"] as? String {
                        quote_id = tronald_quote_id
                    }
                }
                completion(data!, quote_id)
            } catch let error as NSError {
                print(error)
            }
            
        }.resume()
    }
    
    func getQuoteById(quote_id: String, completion: @escaping (Quote) -> Void) {
        self.get(url: baseUrl + "/quote/" + quote_id, completion: { data in
            
            let results = data as! [String:Any]
            
            let value = results["value"] as! String
            let quote_id = results["quote_id"] as! String
            let embedded = results["_embedded"] as! [String: Any]
            let tags = results["tags"] as! [String]
            let authorObj = embedded["author"] as! [[String: Any]]
            let authorName = authorObj[0]["name"] as! String
            let sourceObj = embedded["source"] as! [[String: Any]]
            let sourceUrl = sourceObj[0]["url"] as! String
            
            let quote = Quote(
                value: value,
                quote_id: quote_id,
                tags: tags,
                author: authorName,
                source: sourceUrl
            )
            
            completion(quote)
        })
    }
    
    func login(email: String, password: String, completion: @escaping (Any) -> Void) {
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let credentials: [String: Any] = ["email": email, "password": password]
        let jsonCredentials = try? JSONSerialization.data(withJSONObject: credentials)
        var request = URLRequest(url: URL(string: "http://edu2.shareyourtime.fr/api/auth")!)
        request.httpMethod = "POST"
        request.httpBody = jsonCredentials
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                completion(json)
            } catch let error as NSError {
                print(error)
            }
            
            }.resume()
    }
}
