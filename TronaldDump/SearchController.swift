//
//  SearchController.swift
//  TronaldDump
//
//  Created by Louis Loiseau-Billon on 31/10/2019.
//  Copyright © 2019 Louis Loiseau-Billon. All rights reserved.
//

import UIKit

class SearchController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    var searchResults: [Quote] = []
    let api = ApiManager()
    var query: String = ""
    let searchInput = UITextField()
    let resultsView = UITableView()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = URL(string: self.searchResults[indexPath.row].source) else { return }
        UIApplication.shared.open(url)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath) as! SearchResultCell
        cell.titleLabel.text = self.searchResults[indexPath.row].value
        cell.twitterButton.titleLabel?.text = self.searchResults[indexPath.row].source
        cell.loadView()
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchInput.delegate = self
        
        let headerTitle = UILabel()
        headerTitle.text = "Search"
        headerTitle.font = UIFont.boldSystemFont(ofSize: 35)
        
        self.view.grid(child: headerTitle, x: 0.5, y: 0.5, width: 11, height: 1)
        
        let searchBar = UIView()
        self.view.grid(child: searchBar, x: 0.5, y: 1.5, width: 11, height: 0.5)
        
        searchInput.placeholder = "Obama, Hillary Clinton ..."
        searchInput.clearButtonMode = .whileEditing
        searchInput.returnKeyType = .search
        
        searchBar.backgroundColor = UIColor(red: 0.55, green: 0.55, blue: 0.57, alpha: 0.2)
        searchBar.layer.cornerRadius = 5
        searchBar.layer.masksToBounds = true
        searchBar.grid(child: searchInput, x: 0.2, y: 0, width: 11.8, height: 12)
        
        
        self.resultsView.register(SearchResultCell.self, forCellReuseIdentifier: "searchResultCell")
        self.resultsView.delegate = self
        self.resultsView.dataSource = self
        self.resultsView.showsVerticalScrollIndicator = false
        self.resultsView.reloadData()
        
        self.view.grid(child: self.resultsView, x: 0, y: 2, width: 11.5, height: 10)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        var quotesResults: [Quote] = []
        textField.resignFirstResponder()
        api.get(url: api.baseUrl + "/search/quote?query=" + textField.text!, completion: {data in
            let results = data as! [String:Any]
            let results_embedded = results["_embedded"] as! [String: Any]
            let quotes = results_embedded["quotes"] as! [[String: Any]]
            for quote in quotes {
                let value = quote["value"] as! String
                let quoteId = quote["quote_id"] as! String
                let embedded = quote["_embedded"] as! [String: Any]
                let tags = quote["tags"] as! [String]
                let authorObj = embedded["author"] as! [[String: Any]]
                let authorName = authorObj[0]["name"] as! String
                let sourceObj = embedded["source"] as! [[String: Any]]
                let sourceUrl = sourceObj[0]["url"] as! String
                let newQuote = Quote(value: value, quote_id: quoteId, tags: tags, author: authorName, source: sourceUrl)
                quotesResults.append(newQuote)
            }
            
            DispatchQueue.main.async {
                self.searchResults = quotesResults
                
                self.resultsView.reloadData()
            }
        })
        
        return true
    }
}
