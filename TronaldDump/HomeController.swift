//
//  HomeController.swift
//  TronaldDump
//
//  Created by Louis Loiseau-Billon on 31/10/2019.
//  Copyright © 2019 Louis Loiseau-Billon. All rights reserved.
//

import UIKit
import WebKit

class HomeController: UIViewController, WKUIDelegate {
    
    var randomQuoteWV = WKWebView()
    let store = UserDefaults.standard
    var randomQuoteID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let webConfiguration = WKWebViewConfiguration()
        randomQuoteWV = WKWebView(frame: .zero, configuration: webConfiguration)
        randomQuoteWV.uiDelegate = self
        self.view.grid(child: randomQuoteWV, x: 0.5, y: 6.5, width: 11, height: 3)
        let api = ApiManager()
        let headerTitle = UILabel()
        headerTitle.text = "Home"
        headerTitle.font = UIFont.boldSystemFont(ofSize: 35)
        
        self.view.grid(child: headerTitle, x: 0.5, y: 0.5, width: 11, height: 1)
        
        let randomMemeView = UIImageView()
        self.view.grid(child: randomMemeView, x: 0.5, y: 1.5, width: 11, height: 5)
        
        api.getRandomMeme(completion: { (data, quoteID) in
            let randomMemeImage = UIImage(data: data)
            api.getQuoteById(quote_id: quoteID, completion: { quote in
                let data: Quote = quote
                api.get(url: "https://publish.twitter.com/oembed?url=" + quote.source, completion: { data in
                    let json = data as! [String:Any]
                    let blockquote = json["html"] as! String
                    print(blockquote)
                    DispatchQueue.main.async {
                        self.randomQuoteID = quoteID
                        randomMemeView.image = randomMemeImage
                        let quoteUrl = URL(string: "https://publish.twitter.com/oembed?url=" + quote.source)
                        self.randomQuoteWV.loadHTMLString("<html><body><div style='width: 100vw'" + blockquote + "</body></html>", baseURL: quoteUrl)
                    }
                })
            })
        })
        
        let favButton: UIButton = UIButton()
        favButton.setTitle("Add to favorites", for: .normal)
        favButton.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        favButton.backgroundColor = UIColor(red: 0.55, green: 0.55, blue: 0.57, alpha: 0.2)
        favButton.addTarget(self, action: #selector(addFav), for: .touchUpInside)
        self.view.grid(child: favButton, x: 0.5, y: 9.5, width: 11, height: 1)
    }

    @objc func addFav(_ sender: UIButton) {
        var favsQuotes = store.array(forKey: "favorites_quotes") as? [String]
        if favsQuotes != nil {
            if favsQuotes!.contains(self.randomQuoteID) == false {
                favsQuotes!.append(self.randomQuoteID)
            }
        } else {
            favsQuotes = [self.randomQuoteID]
        }
        store.set(favsQuotes, forKey: "favorites_quotes")
    }

}

