//
//  Grid.swift
//  TronaldDump
//
//  Created by Louis Loiseau-Billon on 08/11/2019.
//  Copyright © 2019 Louis Loiseau-Billon. All rights reserved.
//
import UIKit

extension UIView {
    func grid(child: UIView, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        child.frame = CGRect (
            x: (self.frame.maxX / 12) * x,
            y: (self.frame.maxY / 12) * y,
            width: (self.frame.width / 12) * width,
            height: (self.frame.height / 12) * height
        )
        
        self.addSubview(child)
    }
}
