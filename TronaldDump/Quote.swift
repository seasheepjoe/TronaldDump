//
//  Quote.swift
//  TronaldDump
//
//  Created by Louis Loiseau-Billon on 08/11/2019.
//  Copyright © 2019 Louis Loiseau-Billon. All rights reserved.
//

import Foundation

class Quote: Codable {
    var value: String = ""
    var quote_id: String = ""
    var tags: [String] = []
    var author: String = "Donald Trump"
    var source: String = ""
    
    init(value: String, quote_id: String, tags: [String], author: String, source: String) {
        self.value = value
        self.quote_id = quote_id
        self.tags = tags
        self.author = author
        self.source = source
    }
    
}
