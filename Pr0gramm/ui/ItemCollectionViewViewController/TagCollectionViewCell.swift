//
//  TagCollectionViewCell.swift
//  Pr0gramm
//
//  Created by TodDurchSterben on 11.04.17.
//  Copyright © 2017 TodDurchSterben. All rights reserved.
//

import UIKit

class TagCollectionViewCell : UICollectionViewCell {
    
    
    @IBOutlet weak var labelTag: UILabel!
    @IBOutlet weak var buttonPlusTag: UIButton!
    @IBOutlet weak var buttonMinusTag: UIButton!
    fileprivate var myTag: Tag?
    fileprivate let tagColor = Colors.grey200
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupUI()
    }
    
    fileprivate func setupUI() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 6
        self.backgroundColor = Colors.tagCollectionViewCellBackground
        self.labelTag.textColor = tagColor
        self.buttonPlusTag.tintColor = tagColor
        self.buttonMinusTag.tintColor = tagColor
    }
    
    func setup(withTag tag: Tag) {
        self.myTag = tag
        self.labelTag.text = self.myTag?.tag
    }
    
    // MARK: - Button Actions
    
    @IBAction func buttonPlusTag(_ sender: Any) {
        if (self.buttonPlusTag.isSelected) {
            self.voteItem(vote: 0, buttonsOn: [], buttonsOff: [self.buttonPlusTag])
        } else {
            self.voteItem(vote: 1, buttonsOn: [self.buttonPlusTag], buttonsOff: [self.buttonMinusTag])
        }
    }
    
    @IBAction func buttonMinusTag(_ sender: Any) {
        if (self.buttonMinusTag.isSelected) {
            self.voteItem(vote: 0, buttonsOn: [], buttonsOff: [self.buttonMinusTag])
        } else {
            self.voteItem(vote: -1, buttonsOn: [self.buttonMinusTag], buttonsOff: [self.buttonPlusTag])
        }
    }
    
    func voteItem(vote: Int, buttonsOn: [UIButton], buttonsOff: [UIButton]) {
        if (self.myTag != nil) {
            if let nonce = UserDefaults.standard.string(forKey: Constants.nonce) {
                Upload.voteTag(delegate: self, id: self.myTag!.id, vote: vote, nonce: nonce, buttonsOn: buttonsOn, buttonsOff: buttonsOff)
            }
        }
    }
    
}

extension TagCollectionViewCell: UploadDelegate {
    
    func onUploadFinished(success: Bool, buttonsOn: [UIButton], buttonsOff: [UIButton]) {
        if (success) {
            for button in buttonsOn {
                button.tintColor = Colors.actualTheme
                button.isSelected = true
            }
            for button in buttonsOff {
                button.tintColor = self.tagColor
                button.isSelected = false
            }
        }
    }
    
}
