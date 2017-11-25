//
//  ItemCollectionViewCell.swift
//  Pr0gramm
//
//  Created by TodDurchSterben on 10.04.17.
//  Copyright © 2017 TodDurchSterben. All rights reserved.
//

import UIKit
import SDWebImage

class ItemCollectionViewCell : UICollectionViewCell {
    
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    fileprivate var item: Item?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupUI()
    }
    
    fileprivate func setupUI() {
        self.activityIndicatorView.color = Colors.actualTheme
    }
    
    func setup(withItem item: Item) {
        self.item = item
        self.activityIndicatorView.startAnimating()
        self.thumbImage.sd_setImage(with: URL(string: String(format: Constants.URLThumb, self.item!.thumb)), completed: { (_, error, _, _) in
            if (error != nil) {
                self.thumbImage.contentMode = .center
                self.thumbImage.image = #imageLiteral(resourceName: "loadingError")
                Notification.showErrorMessage(withError: error)
            } else {
                self.thumbImage.contentMode = .scaleAspectFit
            }
            self.activityIndicatorView.stopAnimating()
        })
    }
}
