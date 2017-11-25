//
//  ItemCollectionViewHeader.swift
//  Pr0gramm
//
//  Created by TodDurchSterben on 29.04.17.
//  Copyright © 2017 TodDurchSterben. All rights reserved.
//

import UIKit

class ItemCollectionViewHeader: UICollectionReusableView {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupUI()
    }
    
    fileprivate func setupUI() {
        self.searchBar.barTintColor = Colors.actualTheme
        self.searchBar.tintColor = Colors.actualTheme
    }
    
}
