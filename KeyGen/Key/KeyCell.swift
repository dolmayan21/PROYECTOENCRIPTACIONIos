//
//  KeyCell.swift
//  KeyGen
//
//  Created by Alejandro Leon Del Villar on 09/02/20.
//  Copyright © 2020 Alejandro Leon Del Villar. All rights reserved.
//

import UIKit

class KeyCell: UICollectionViewCell {
    
    @IBOutlet private weak var valueLabel: UILabel?

    func update(withValue value: String) {
        valueLabel?.text = value
        valueLabel?.sizeToFit()
        clipsToBounds = false
    }
    
}
