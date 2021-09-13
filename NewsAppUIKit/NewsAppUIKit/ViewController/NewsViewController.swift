//
//  NewsViewController.swift
//  NewsAppUIKit
//
//  Created by Murat Can KOÇ on 7.07.2021.
//

import UIKit


class NewsViewController: UIViewController {
    
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.tableFooterView = UIView()
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return table
    }()
    
    private let searchVC = UISearchController(searchResultsController: nil)
    
    private var models = [NewsTableViewCellModel]()
    private var articles = [Article]()
    
    var favoriteArticlesData = [Data]()
    var favoriteArticles = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        setupTableView()
        
        view.backgroundColor = .systemBackground
        title = "News"
        
        fetchNews()
        createSearchBar()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
    }
    private func createSearchBar() {
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    private func fetchNews() {
        APICaller.shared.getNews { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.models = articles.compactMap({
                    NewsTableViewCellModel(articleTitle: $0.title, articleDescription: $0.articleDescription, articleImageURL: URL(string: $0.urlToImage ?? ""), articleAuthor: $0.author, articleDateString: $0.dateString, articleContent: $0.content, isArticleInFavorites: $0.isFavorite)
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}



extension NewsViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else { fatalError() }
        cell.configure(with: models[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        guard let detailVC = UIStoryboard(name: "NewsDetailStoryboard", bundle: nil).instantiateViewController(identifier: "detailVC") as? NewsDetailViewControllerWithStoryboard else { return }
//        self.navigationController?.pushViewController(detailVC, animated: true)

        let article = articles[indexPath.row]
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
                let defaults = UserDefaults.standard
                
                if let favoriteDatas = defaults.object(forKey: "FavoritesData") as? [Data] {
                    let decoder = JSONDecoder()
                    for item in favoriteDatas {
                        if let favoriteArticle = try? decoder.decode(Article.self, from: item) {
                            self.favoriteArticles.append(favoriteArticle)
                            print(favoriteArticle)
                            vc.isFavorite = true
                        }
                    }
                }
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(newFavorite) {
                    self.favoriteArticlesData.append(encoded)
                    defaults.set(self.favoriteArticlesData, forKey: "FavoritesData")
                    print(self.favoriteArticlesData.count)
                }
            } else {
                
            }
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        
        APICaller.shared.search(with: text) { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.models = articles.compactMap({
                    NewsTableViewCellModel(articleTitle: $0.title, articleDescription: $0.articleDescription, articleImageURL: URL(string: $0.urlToImage ?? ""), articleAuthor: $0.author, articleDateString: $0.dateString, articleContent: $0.content, isArticleInFavorites: $0.isFavorite)
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.searchVC.dismiss(animated: true, completion: nil)
                }
            case .failure(let error):
                print(error)
            }
        }
        print(text)
    }
    
    
}
