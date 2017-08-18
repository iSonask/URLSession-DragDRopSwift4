//
//  CustomInstaCell.swift
//  beta5Xcode
//
//  Created by Akash on 18/08/17.
//  Copyright © 2017 Akash. All rights reserved.
//

import UIKit

class CustomInstaCell: UICollectionViewCell {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .red
        layer.cornerRadius = 15
        layer.masksToBounds = true
    }
}

