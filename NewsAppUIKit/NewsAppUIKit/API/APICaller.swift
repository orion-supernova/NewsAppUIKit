//
//  APICaller.swift
//  NewsAppUIKit
//
//  Created by Murat Can KOÇ on 7.07.2021.
//

import Foundation


final class APICaller {
    static let shared = APICaller()
    
    enum Constants {
        static let url = URL(string: "https://newsapi.org/v2/everything?q=Apple&from=2021-09-07&sortBy=popularity&apiKey=81cf661cf8f946209469ea9009855b46")
        static let baseURLString = "https://newsapi.org/v2/everything?"
        static let searchURLStringDefault = "q="
        static let urlBeforeDate = "&from="
        static let urlDate = "2021-09-07"
        static let urlRestBeforeAPI = "&sortBy=popularity"
        static let apiKeyString = "&apiKey=81cf661cf8f946209469ea9009855b46"
    }
    
    private init() {}
    
    
    func getNews(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = Constants.url else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(NewsResponse.self, from: data)
                    print(result.articles.count)
                    completion(.success(result.articles))
                } catch  {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
        
    }
    func search(with query: String, completion: @escaping (Result<[Article], Error>) -> Void) {
        
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let urlString = Constants.baseURLString + Constants.searchURLStringDefault + query + Constants.urlBeforeDate + Constants.urlDate + Constants.urlRestBeforeAPI + Constants.apiKeyString
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(NewsResponse.self, from: data)
                    print(result.articles.count)
                    completion(.success(result.articles))
                } catch  {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }

}
