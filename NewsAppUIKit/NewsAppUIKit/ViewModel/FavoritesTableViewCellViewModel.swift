//
//  FavoritesTableViewCellViewModel.swift
//  NewsAppUIKit
//
//  Created by Murat Can KOÇ on 8.07.2021.
//

import Foundation

class FavoritesTableViewCellViewModel {
    
    let articleTitle: String
    let articleDescription: String
    let articleImageURL: URL?
    var articleImageData: Data?
    let articleAuthor: String?
    let articleDateString: String?
    let articleContent: String?
    var isArticleInFavorites: Bool?
    
    init(articleTitle: String,
         articleDescription: String,
         articleImageURL: URL?,
         articleAuthor: String?,
         articleDateString: String?,
         articleContent: String?,
         isArticleInFavorites: Bool?) {
        self.articleTitle = articleTitle
        self.articleDescription = articleDescription
        self.articleImageURL = articleImageURL
        self.articleAuthor = articleAuthor
        self.articleDateString = articleDateString
        self.articleContent = articleContent
        self.isArticleInFavorites = isArticleInFavorites
    }
    
}
