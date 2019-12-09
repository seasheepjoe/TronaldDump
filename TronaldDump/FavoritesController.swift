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
    let store = UserDefaults.standard
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteQuoteCell", for: indexPath) as! FavoriteQuoteCell
        cell.titleLabel.text = self.favsQuotes[indexPath.row].value
        cell.loadView()
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            var favs = store.array(forKey: "favorites_quotes") as! [String]
            let current = favsQuotes[indexPath.row].toString()
            if let index = favs.index(of: current!) {
                favs.remove(at: index)
                store.set(favs, forKey: "favorites_quotes")
                self.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let headerTitle = UILabel()
        headerTitle.text = "Favorites"
        headerTitle.font = UIFont.boldSystemFont(ofSize: 35)
        self.view.grid(child: headerTitle, x: 0.5, y: 0.5, width: 11, height: 1)
        
        self.favsView.register(FavoriteQuoteCell.self, forCellReuseIdentifier: "favoriteQuoteCell")
        self.favsView.delegate = self
        self.favsView.dataSource = self
        self.favsView.showsVerticalScrollIndicator = false
        self.favsView.reloadData()
        let favs = store.array(forKey: "favorites_quotes") as! [String]
        for item in favs {
            favsQuotes.append(item.toQuote()!)
        }
        self.view.grid(child: self.favsView, x: 0, y: 1.5, width: 11.5, height: 10)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.reloadData()
    }
    
    func reloadData() {
        let favs = store.array(forKey: "favorites_quotes") as! [String]
        favsQuotes = []
        for item in favs {
            favsQuotes.append(item.toQuote()!)
        }
        self.favsView.reloadData()
    }
}
