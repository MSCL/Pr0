//
//  MenuTableViewCell.swift
//  Pr0gramm
//
//  Created by TodDurchSterben on 27.04.17.
//  Copyright © 2017 TodDurchSterben. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    fileprivate var title: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupUI()
    }
    
    fileprivate func setupUI() {
        
    }
    
    func setup(withTitle title: String) {
        self.title = title
        self.labelTitle.text = self.title
    }
    
}
