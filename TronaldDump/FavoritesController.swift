//
//  FavoritesController.swift
//  TronaldDump
//
//  Created by Louis Loiseau-Billon on 28/11/2019.
//  Copyright © 2019 Louis Loiseau-Billon. All rights reserved.
//

import Foundation
import UIKit

class FavoritesController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    var favsQuotes: [Quote] = []
    let favsView = UITableView()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favsQuotes.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = URL(string: self.favsQuotes[indexPath.row].source) else { return }
        UIApplication.shared.open(url)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath) as! SearchResultCell
        cell.titleLabel.text = self.favsQuotes[indexPath.row].value
        cell.twitterButton.titleLabel?.text = self.favsQuotes[indexPath.row].source
        cell.loadView()
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let headerTitle = UILabel()
        headerTitle.text = "Favorites"
        headerTitle.font = UIFont.boldSystemFont(ofSize: 35)
        
        self.favsView.register(SearchResultCell.self, forCellReuseIdentifier: "searchResultCell")
        self.favsView.delegate = self
        self.favsView.dataSource = self
        self.favsView.showsVerticalScrollIndicator = false
        self.favsView.reloadData()
        
        self.view.grid(child: headerTitle, x: 0.5, y: 0.5, width: 11, height: 1)
        self.view.grid(child: self.favsView, x: 0, y: 2, width: 11.5, height: 10)
    }
}
