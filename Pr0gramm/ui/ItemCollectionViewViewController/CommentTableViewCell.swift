//
//  CommentTableViewCell.swift
//  Pr0gramm
//
//  Created by TodDurchSterben on 13.04.17.
//  Copyright © 2017 TodDurchSterben. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelComment: UILabel!
    @IBOutlet weak var labelOp: UILabel!
    @IBOutlet weak var labelUser: UILabel!
    @IBOutlet weak var imageViewUserDot: UIImageView!
    @IBOutlet weak var labelBenis: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var buttonClipboard: UIButton!
    @IBOutlet weak var buttonFavourite: UIButton!
    @IBOutlet weak var buttonShare: UIButton!
    @IBOutlet weak var buttonPlusComment: UIButton!
    @IBOutlet weak var buttonMinusComment: UIButton!
    @IBOutlet weak var labelOpWidth: NSLayoutConstraint!
    @IBOutlet weak var labelUserLeadingToLabelOP: NSLayoutConstraint!
    @IBOutlet weak var viewLeadingToSuperview: NSLayoutConstraint!
    @IBOutlet weak var viewLine: UIView!
    fileprivate var comment: Comment?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupUI()
    }
    
    fileprivate func setupUI() {
        self.labelOp.layer.masksToBounds = true
        self.labelOp.layer.cornerRadius = 3
        self.labelOp.backgroundColor = Colors.actualTheme
        self.labelOp.textColor = Colors.white
        self.labelUser.textColor = Colors.grey200
        self.labelBenis.textColor = Colors.grey200
        self.labelTime.textColor = Colors.grey200
        self.labelComment.textColor = Colors.white
        self.buttonClipboard.tintColor = UIColor.darkGray
        self.buttonFavourite.tintColor = UIColor.darkGray
        self.buttonShare.tintColor = Colors.actualTheme
        self.buttonPlusComment.tintColor = UIColor.darkGray
        self.buttonMinusComment.tintColor = UIColor.darkGray
        self.imageViewUserDot.layer.masksToBounds = true
        self.imageViewUserDot.layer.cornerRadius = self.imageViewUserDot.bounds.width / 2
        self.viewLine.backgroundColor = Colors.commentLine
    }
    
    func setup(withComment comment: Comment, op: Bool) {
        self.comment = comment
        self.labelUser.text = self.comment?.name
        var pointsString = ""
        if (self.comment!.up - self.comment!.down == 1 || self.comment!.up - self.comment!.down == -1) {
            pointsString = Strings.point
        } else {
            pointsString = Strings.points
        }
        self.labelBenis.text = String(self.comment!.up - self.comment!.down) + " " + pointsString
        self.labelTime.text = Strings.calculateTimeString(withDate: self.comment!.created)
        self.labelComment.text = self.comment!.content
        // circle imageUserDot
        self.imageViewUserDot.backgroundColor = Colors.getColor(mark: self.comment!.mark)
        if (!op) { // show/hide op label
            self.labelOpWidth.constant = CGFloat(0)
            self.labelUserLeadingToLabelOP.constant = CGFloat(0)
        } else {
            self.labelOpWidth.constant = CGFloat(20)
            self.labelUserLeadingToLabelOP.constant = CGFloat(4)
        }
        self.addLines()
    }
    
    fileprivate func addLines() {
        for view in self.contentView.subviews { // remove lines -> because of deque resuable view cells
            if view.isMember(of: UIView.self) && !view.isEqual(self.viewLine) {
                view.removeFromSuperview()
            }
        }
        // add lines
        self.viewLeadingToSuperview.constant = CGFloat(self.comment!.depth * 8 - 8)
        if (self.comment!.depth >= 2) {
            for i in 0..<self.comment!.depth-1 {
                //create line for each depth
                let newViewLine = UIView()
                newViewLine.backgroundColor = Colors.commentLine
                newViewLine.frame = CGRect(x: i * 8, y: 0, width: 1, height: 2000)
                self.contentView.addSubview(newViewLine)
            }
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func buttonFavourite(_ sender: Any) {
        
    }
    
    @IBAction func buttonShare(_ sender: Any) {
        
    }
    
    @IBAction func buttonPlusComment(_ sender: Any) {
        
    }
    
    @IBAction func buttonMinusComment(_ sender: Any) {
        
    }
    
    @IBAction func buttonClipboard(_ sender: Any) {
        
    }
    
    
}
