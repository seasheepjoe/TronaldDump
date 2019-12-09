//
//  HomeController.swift
//  TronaldDump
//
//  Created by Louis Loiseau-Billon on 31/10/2019.
//  Copyright © 2019 Louis Loiseau-Billon. All rights reserved.
//

import UIKit
import WebKit

typealias JSONDictionary = [String : Any]

class HomeController: UIViewController, WKUIDelegate {
    
    var randomQuoteWV = WKWebView()
    let store = UserDefaults.standard
    var randomQuote: Quote?

    override func viewDidLoad() {
        super.viewDidLoad()
        let webConfiguration = WKWebViewConfiguration()
        randomQuoteWV = WKWebView(frame: .zero, configuration: webConfiguration)
        randomQuoteWV.uiDelegate = self
        self.view.grid(child: randomQuoteWV, x: 0.5, y: 6.5, width: 11, height: 4)
        let api = ApiManager()
        let header = UIView()
        self.view.grid(child: header, x: 0.5, y: 0.5, width: 11, height: 1)
        let headerTitle = UILabel()
        headerTitle.text = "Home"
        headerTitle.font = UIFont.boldSystemFont(ofSize: 35)
        
        let favButton: UIButton = UIButton()
        favButton.addTarget(self, action: #selector(addFav), for: .touchUpInside)
        
        header.grid(child: favButton, x: 10.5, y: 2.5, width: 1, height: 5)
        header.grid(child: headerTitle, x: 0, y: 0, width: 11, height: 12)
        
        let randomMemeView = UIImageView()
        self.view.grid(child: randomMemeView, x: 0.5, y: 1.5, width: 11, height: 5)
        
        api.getRandomMeme(completion: { (data, quoteID) in
            let randomMemeImage = UIImage(data: data)
            api.getQuoteById(quote_id: quoteID, completion: { quote in
                api.get(url: "https://publish.twitter.com/oembed?url=" + quote.source + "&align=center", completion: { data in
                    let json = data as! [String:Any]
                    let blockquote = json["html"] as! String
                    DispatchQueue.main.async {
                        self.randomQuote = quote
                        favButton.setImage(UIImage(named: self.getFavImage()), for: .normal)
                        randomMemeView.image = randomMemeImage
                        let quoteUrl = URL(string: "https://publish.twitter.com/oembed?url=" + quote.source)
                        self.randomQuoteWV.loadHTMLString("<meta name='viewport' content='initial-scale=1.0'/>" + blockquote, baseURL: quoteUrl)
                    }
                })
            })
        })
    }

    @objc func addFav(_ sender: UIButton) {
        var favsQuotes = store.array(forKey: "favorites_quotes") as? [String]
        if favsQuotes != nil {
            if favsQuotes!.contains(self.randomQuote!.toString()!) == false {
                favsQuotes!.append(self.randomQuote!.toString()!)
                sender.setImage(UIImage(named: "StarFull"), for: .normal)
            } else {
                sender.setImage(UIImage(named: "StarEmpty"), for: .normal)
                if let index = favsQuotes!.index(of: self.randomQuote!.toString()!) {
                    favsQuotes!.remove(at: index)
                }
            }
        } else {
            favsQuotes = [self.randomQuote!.toString()] as! [String]
            sender.setImage(UIImage(named: "StarFull"), for: .normal) as! [String]
        }
        store.set(favsQuotes, forKey: "favorites_quotes")
    }
    
    func getFavImage() -> String {
        let favsQuotes = store.array(forKey: "favorites_quotes") as? [String]
        if favsQuotes != nil {
            for (index, item) in favsQuotes!.enumerated() {
                let selectedQuote = item.toQuote()
                if selectedQuote?.quote_id == self.randomQuote?.quote_id {
                    return "StarFull"
                } else {
                    return "StarEmpty"
                }
            }
        } else {
            return "StarEmpty"
        }
        return "StarEmpty"
    }
}
