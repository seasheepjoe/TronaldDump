//
//  QuoteCell.swift
//  TronaldDump
//
//  Created by Louis Loiseau-Billon on 25/11/2019.
//  Copyright © 2019 Louis Loiseau-Billon. All rights reserved.
//
import Foundation
import UIKit

class SearchResultCell: UITableViewCell {
    var titleLabel: UILabel = UILabel()
    var twitterButton: UIButton = UIButton()
    let screenWidth = UIScreen.main.bounds.width
    
    func loadView() {
        let logoImage = UIImage(named: "TwitterLogo")
        twitterButton.setImage(logoImage, for: .normal)
        twitterButton.imageView?.contentMode = .scaleAspectFit
        titleLabel.frame = CGRect(
            x: (screenWidth / 12) * 0.75,
            y: 0,
            width: screenWidth * 0.7,
            height: self.frame.height
        )
        twitterButton.frame = CGRect(
            x: (screenWidth * 0.7) + (screenWidth / 12) * 0.75,
            y: 0,
            width: screenWidth * 0.3,
            height: self.frame.height
        )
        contentView.addSubview(titleLabel)
        contentView.addSubview(twitterButton)
    }
}
