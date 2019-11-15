//
//  SearchController.swift
//  TronaldDump
//
//  Created by Louis Loiseau-Billon on 31/10/2019.
//  Copyright © 2019 Louis Loiseau-Billon. All rights reserved.
//

import UIKit

class SearchController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let api = ApiManager()
        
        let headerTitle = UILabel()
        headerTitle.text = "Search"
        headerTitle.font = UIFont.boldSystemFont(ofSize: 35)
        
        self.view.grid(child: headerTitle, x: 0.5, y: 0.5, width: 11, height: 1)
        
        let searchBar = UIView()
        self.view.grid(child: searchBar, x: 0.5, y: 1.5, width: 11, height: 0.5)
        let searchInput = UITextField()
        searchInput.placeholder = "Obama, Hillary Clinton ..."
        
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
//        let image = UIImage(named: "search-icon.png")
//        imageView.image = image
        
//        searchInput.leftView = imageView
//        searchInput.leftViewMode = .always
        searchInput.clearButtonMode = .whileEditing
        searchInput.returnKeyType = .search
        searchBar.backgroundColor = UIColor(red: 0.55, green: 0.55, blue: 0.57, alpha: 0.2)
        searchBar.layer.cornerRadius = 5
        searchBar.layer.masksToBounds = true
        searchBar.grid(child: searchInput, x: 0.2, y: 0, width: 11.8, height: 12)
        
        let resultsView = UITableView()
//        resultsView.dataSource = UserDefaults.standard.array(forKey: "favorites_quotes") as! UITableViewDataSource
        
        self.view.grid(child: resultsView, x: 0.5, y: 2, width: 12, height: 10.5)
    }


}

