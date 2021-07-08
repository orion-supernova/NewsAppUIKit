//
//  FavoritesViewController.swift
//  NewsAppUIKit
//
//  Created by Murat Can KOÇ on 7.07.2021.
//

import UIKit

class FavoritesViewController: UIViewController {

    private let tableView: UITableView = {
        let table = UITableView()
        table.tableFooterView = UIView()
        table.register(FavoritesTableViewCell.self, forCellReuseIdentifier: FavoritesTableViewCell.identifier)
        return table
    }()
    
    private var viewModels = [FavoritesTableViewCellViewModel]()
    private var articles = [Article]()
    
    var favoriteArticles = [Article]()
    
    let defaults = UserDefaults.standard
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        setupTableView()
        
        view.backgroundColor = .orange
        title = "Favorites"
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchNews()
        print(favoriteArticles.count)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    private func fetchNews() {
        self.favoriteArticles.removeAll()
        if let favoriteDatas = defaults.object(forKey: "FavoritesData") as? [Data] {
            let decoder = JSONDecoder()
            for item in favoriteDatas {
                if let favoriteArticle = try? decoder.decode(Article.self, from: item) {
                    self.favoriteArticles.append(favoriteArticle)
                    print(favoriteArticle)
                    self.viewModels = favoriteArticles.compactMap({
                        FavoritesTableViewCellViewModel(articleTitle: $0.title, articleDescription: $0.articleDescription, articleImageURL: URL(string: $0.urlToImage ?? ""), articleAuthor: $0.author, articleDateString: $0.dateString, articleContent: $0.content, isArticleInFavorites: $0.isFavorite)
                    })
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                }
            }
        }
        
    }
}



extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesTableViewCell.identifier, for: indexPath) as? FavoritesTableViewCell else { fatalError() }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = favoriteArticles[indexPath.row]
        let vc = NewsDetailViewController()
        
        vc.articleTitle = article.title
        vc.articleDescription = article.articleDescription
        vc.articleImageURL = article.urlToImage ?? ""
        vc.articleAuthor = article.author ?? ""
        vc.articleContent = article.content
        vc.articURL = article.url
        vc.articleDateString = article.dateString ?? ""
        vc.isFavorite = article.isFavorite ?? false
        
        vc.favoriteCompletionHandler = { bool in
            if bool == true {
                let newFavorite = article
                let userDefaults = UserDefaults.standard
                self.favoriteArticles = userDefaults.object(forKey: "Favorites") as? [Article] ?? []
                self.favoriteArticles.append(newFavorite)
                userDefaults.set(self.favoriteArticles, forKey: "Favorites")
            } else {
                let userDefaults = UserDefaults.standard
                self.favoriteArticles = userDefaults.object(forKey: "Favorites") as? [Article] ?? []
                self.favoriteArticles.removeAll()
                userDefaults.set(self.favoriteArticles, forKey: "Favorites")
            }
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    

    
    
}
