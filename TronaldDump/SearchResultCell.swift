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
    var cellTitle: String = ""

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
