//
//  NewsDetailViewController.swift
//  NewsAppUIKit
//
//  Created by Murat Can KOÇ on 7.07.2021.
//

import UIKit
import SafariServices
import Kingfisher

class NewsDetailViewController: UIViewController, ObservableObject {
    
    var articleTitle: String = ""
    var articleDescription: String = ""
    var articleImageURL: String = ""
    var articURL: String = ""
    var articleAuthor: String = ""
    var articleDateString: String = ""
    var articleContent: String = ""
    var isFavorite = false
    
    
    @IBOutlet weak var scrollViewFromSB: UIScrollView!
    @IBOutlet weak var parentViewFromSB: UIView!
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    private let authorImage: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "newspaper")
        return imageView
    }()
    private let authorLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .semibold)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    private let dateImage: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "doc.text")
        return imageView
    }()
    private let dateLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .semibold)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    private let contentLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    private let sourceButton: UIButton = {
        let button = UIButton()
        button.setTitle("News Source", for: .normal)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.layer.cornerRadius = 10
        return button
    }()
    
    public var favoriteCompletionHandler: ((Bool?) -> Void)?
    
    let favorites = [Article]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground

        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(authorImage)
        scrollView.addSubview(authorLabel)
        scrollView.addSubview(dateImage)
        scrollView.addSubview(dateLabel)
        scrollView.addSubview(contentLabel)
        scrollView.addSubview(sourceButton)
        
        imageView.kf.setImage(with: ImageResource(downloadURL: URL(string: articleImageURL)!))
        titleLabel.text = articleTitle
        descriptionLabel.text = articleDescription
        authorLabel.text = articleAuthor
        dateLabel.text = articleDateString
        contentLabel.text = articleContent
        
        
        sourceButton.addTarget(self, action: #selector(sourceButtonClicked), for: .touchUpInside)
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action,
                                          target: self,
                                          action: #selector(shareButtonClicked))
        let favoriteButton = UIBarButtonItem(image: UIImage(systemName: isFavorite ? "heart.fill" : "heart"),
                                             style: .done,
                                             target: self,
                                             action: #selector(favoriteButtonClicked))
        
        
        navigationItem.rightBarButtonItems = [favoriteButton, shareButton]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: view.bounds.size.width, height: view.bounds.size.height + 70)
        
        
        imageView.frame = CGRect(x: 20,
                                 y: 30,
                                 width: scrollView.frame.size.width-40,
                                 height: 400)
        titleLabel.frame = CGRect(x: 20,
                                  y: imageView.frame.origin.y + imageView.frame.size.height + 10,
                                  width: scrollView.frame.size.width-40,
                                  height: 80)
        
        descriptionLabel.frame = CGRect(x: 20,
                                        y: titleLabel.frame.origin.y + titleLabel.frame.size.height + 10,
                                        width: scrollView.frame.size.width-40,
                                        height: 150)
        authorImage.frame = CGRect(x: 60,
                                   y: descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height + 10,
                                   width: 20,
                                   height: 20)
        authorLabel.frame = CGRect(x: authorImage.frame.origin.x + authorImage.frame.size.width + 5,
                                   y: descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height + 10,
                                   width: 80,
                                   height: 15)
        dateImage.frame = CGRect(x: authorLabel.frame.origin.x + authorLabel.frame.size.width + 100,
                                 y: descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height + 10,
                                 width: 20,
                                 height: 20)
        dateLabel.frame = CGRect(x: dateImage.frame.origin.x + dateImage.frame.size.width + 5,
                                 y: descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height + 10,
                                 width: 80,
                                 height: 15)
        contentLabel.frame = CGRect(x: 20,
                                    y: authorImage.frame.origin.y + authorImage.frame.size.height + 10,
                                    width: scrollView.frame.size.width-40,
                                    height: 200)
        sourceButton.frame = CGRect(x: 60,
                                    y: contentLabel.frame.origin.y + contentLabel.frame.size.height + 10,
                                    width: scrollView.frame.size.width-120,
                                    height: 36)

        
        
        
        
        
        
    }
    
    @objc func shareButtonClicked() {
        guard let urlShare = URL(string: articURL) else { return }
        let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
    @objc func favoriteButtonClicked() {
        
        if isFavorite {
            
            favoriteCompletionHandler?(false)
            Helper.app.alertMessage(title: "Removed", message: "This news has been removed from favorites!")
            navigationItem.rightBarButtonItems?.first?.setBackgroundImage(UIImage(systemName: "heart"),
                                                                          for: .normal,
                                                                          barMetrics: .default)
            self.isFavorite = false
        } else {
            
            favoriteCompletionHandler?(true)
            Helper.app.alertMessage(title: "Added", message: "This news has been added to favorites!")
            navigationItem.rightBarButtonItems?.first?.setBackgroundImage(UIImage(systemName: "heart.fill"),
                                                                          for: .normal,
                                                                          barMetrics: .default)
            self.isFavorite = true
        }
    }
    
    @objc func sourceButtonClicked() {
        guard let url = URL(string: articURL ) else { return }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    
    
    

}
