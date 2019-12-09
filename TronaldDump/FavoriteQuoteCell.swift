//
//  FavoriteQuoteCell.swift
//  TronaldDump
//
//  Created by Louis Loiseau-Billon on 09/12/2019.
//  Copyright © 2019 Louis Loiseau-Billon. All rights reserved.
//

import Foundation
import UIKit

class FavoriteQuoteCell: UITableViewCell {
    var titleLabel: UILabel = UILabel()
    let screenWidth = UIScreen.main.bounds.width
    
    func loadView() {
        titleLabel.frame = CGRect(
            x: (screenWidth / 12) * 0.75,
            y: 0,
            width: screenWidth * 0.85   ,
            height: self.frame.height
        )
    
        contentView.addSubview(titleLabel)
    }
}
