//
//  APICaller.swift
//  NewsAppUIKit
//
//  Created by Murat Can KOÇ on 7.07.2021.
//

import Foundation


final class APICaller {
    static let shared = APICaller()
    
    var lastMonth: String = ""
    
    
    // MARK- Untouched API URL for fetch example "https://newsapi.org/v2/everything?q=Apple&from=2021-09-07&sortBy=popularity&apiKey=81cf661cf8f946209469ea9009855b46"
    enum Constants {
        static let defaultUrl = URL(string: defaultUrlBeforeDate + defaultUrlDate + defaultUrlAfterDate)
        static let defaultUrlBeforeDate = "https://newsapi.org/v2/everything?q=Apple&from="
        static let defaultUrlDate = "2021-09-07"
        static let defaultUrlAfterDate = "&sortBy=popularity&apiKey=81cf661cf8f946209469ea9009855b46"
        static let baseURLString = "https://newsapi.org/v2/everything?"
        static let searchURLStringDefault = "q="
        static let searchUrlBeforeDate = "&from="
        static let searchUrlDate = "2021-09-07"
        static let searchUrlRestBeforeAPI = "&sortBy=popularity"
        static let searchUrlApiKeyString = "&apiKey=81cf661cf8f946209469ea9009855b46"
    }
    
    private init() {
        getLastMonth()
    }
    func getLastMonth() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        let dateString = formatter.string(from:date ?? Date())
        self.lastMonth = dateString
    }
    
    func getNews(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = Constants.defaultUrl else { return }
        
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
        
        let queryParam = query.replacingOccurrences(of: " ", with: "")
        
        let urlString = Constants.baseURLString + Constants.searchURLStringDefault + queryParam + Constants.searchUrlBeforeDate + lastMonth + Constants.searchUrlRestBeforeAPI + Constants.searchUrlApiKeyString
        
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
