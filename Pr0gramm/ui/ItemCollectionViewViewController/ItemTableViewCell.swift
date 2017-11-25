//
//  ItemTableViewCell
//  Pr0gramm
//
//  Created by TodDurchSterben on 06.08.17.
//  Copyright © 2017 TodDurchSterben. All rights reserved.
//

import UIKit
import ABMediaView
import SDWebImage
import SwiftyGif

class ItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mediaView: ABMediaView!
    @IBOutlet weak var buttonPlusItem: UIButton!
    @IBOutlet weak var buttonMinusItem: UIButton!
    @IBOutlet weak var labelBenis: UILabel!
    @IBOutlet weak var buttonFavouriteItem: UIButton!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelUser: UILabel!
    @IBOutlet weak var imageViewUserDot: UIImageView!
    @IBOutlet weak var buttonNewTag: UIButton!
    @IBOutlet weak var collectionViewTag: UICollectionView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var textFieldComment: UITextField!
    var navItem: UINavigationItem?
    fileprivate let myTextColor = UIColor.lightText
    fileprivate var item: Item?
    fileprivate var itemInfo: ItemInfo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupUI()
    }
    
    fileprivate func setupUI() {
        self.buttonNewTag.setTitleColor(Colors.actualTheme, for: .normal)
        self.buttonPlusItem.tintColor = self.myTextColor
        self.buttonMinusItem.tintColor = self.myTextColor
        self.buttonFavouriteItem.tintColor = self.myTextColor
        self.labelBenis.textColor = self.myTextColor
        self.labelTime.textColor = self.myTextColor
        self.labelUser.textColor = self.myTextColor
        self.createMediaView()
        self.activityIndicatorView.color = Colors.actualTheme
        self.imageViewUserDot.layer.masksToBounds = true
        self.imageViewUserDot.layer.cornerRadius = self.imageViewUserDot.bounds.width / 2
        self.textFieldComment.backgroundColor = Colors.inputBackground
        let attributedString = NSAttributedString(string: Strings.comment, attributes: [NSForegroundColorAttributeName:self.myTextColor])
        self.textFieldComment.attributedPlaceholder = attributedString
        self.textFieldComment.textColor = self.myTextColor
    }
    
    fileprivate func createMediaView() {
        self.mediaView.themeColor = Colors.actualTheme
        self.mediaView.showTrack = true
        self.mediaView.allowLooping = true
        self.mediaView.contentMode = .scaleAspectFit
        self.mediaView.backgroundColor = UIColor.clear
        self.mediaView.delegate = self
    }
    
    func setup(withItem item: Item) {
        self.item = item
        
        let thumbImage = SDImageCache.shared().imageFromCache(forKey: String(format: Constants.URLThumb, self.item!.thumb))
        self.mediaView.contentMode = .scaleAspectFit
        self.mediaView.image = thumbImage
        if (self.item!.image.hasSuffix("gif")) {
            self.activityIndicatorView.startAnimating()
            Download.downloadGif(delegate: self, gif: self.item!.image)
        } else if (self.item!.image.hasSuffix("mp4")) {
            self.setMediaViewVideoURL(withThumbImage: thumbImage)
        } else {
            self.activityIndicatorView.startAnimating()
            self.mediaView.sd_setImage(with: URL(string: String(format: Constants.URLImage, self.item!.image)), placeholderImage: thumbImage, options: SDWebImageOptions(rawValue: 0), completed: { (_, error, _, _) in
                if (error != nil) {
                    self.mediaView.contentMode = .center
                    self.mediaView.image = #imageLiteral(resourceName: "loadingError")
                    Notification.showErrorMessage(withError: error)
                }
                self.activityIndicatorView.stopAnimating()
            })
        }
        self.labelUser.text = self.item!.user
        self.labelTime.text = Strings.calculateTimeString(withDate: self.item!.created)
        if (self.showBenis()) {
            self.labelBenis.text = String(self.item!.up - self.item!.down)
        }
        // circle imageUserDot
        self.imageViewUserDot.backgroundColor = Colors.getColor(mark: self.item!.mark)
        self.imageViewUserDot.isHidden = false
    }
    
    func setup(withItemInfo itemInfo: ItemInfo) {
        self.itemInfo = itemInfo
        self.collectionViewTag.reloadData() // update? TODO
    }
    
    fileprivate func setMediaViewVideoURL(withThumbImage thumbImage: UIImage?) {
        if (thumbImage != nil) {
            self.mediaView.setVideoURL(String(format: Constants.URLVideo, self.item!.image), withThumbnailImage: thumbImage)
        } else {
            self.mediaView.setVideoURL(String(format: Constants.URLVideo, self.item!.image), withThumbnailURL: String(format: Constants.URLThumb, self.item!.thumb))
        }
    }
    
    fileprivate func showBenis() -> Bool {
        let intervalDate = Date(timeIntervalSince1970:Date().timeIntervalSince1970 - self.item!.created.timeIntervalSince1970)
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .day, .month, .year, .weekOfMonth], from: intervalDate)
        let years = components.year! - 1970
        let months = components.month! - 1
        let weeks = components.weekOfMonth! - 1
        let days = components.day! - 1
        let hours = components.hour! - 1
        return years >= 1 || months >= 1 || weeks >= 1 || days >= 1 || hours >= 1
    }
    
    func resetMediaView() {
        self.mediaView.resetMediaInView()
        let thumbImage = SDImageCache.shared().imageFromCache(forKey: String(format: Constants.URLThumb, self.item!.thumb))
        self.setMediaViewVideoURL(withThumbImage: thumbImage)
    }
    
    // MARK: - Button Actions
    
    @IBAction func buttonPlusItem(_ sender: Any) {
        if (self.buttonPlusItem.isSelected) {
            self.voteItem(vote: 0, buttonsOn: [], buttonsOff: [self.buttonPlusItem, self.buttonFavouriteItem])
        } else {
            self.voteItem(vote: 1, buttonsOn: [self.buttonPlusItem], buttonsOff: [self.buttonMinusItem])
        }
    }
    
    @IBAction func buttonMinusItem(_ sender: Any) {
        if (self.buttonMinusItem.isSelected) {
            self.voteItem(vote: 0, buttonsOn: [], buttonsOff: [self.buttonMinusItem])
        } else {
            self.voteItem(vote: -1, buttonsOn: [self.buttonMinusItem], buttonsOff: [self.buttonPlusItem, self.buttonFavouriteItem])
        }
    }
    
    @IBAction func buttonFavouriteItem(_ sender: Any) {
        if (self.buttonFavouriteItem.isSelected) {
            self.voteItem(vote: 1, buttonsOn: [], buttonsOff: [self.buttonFavouriteItem])
        } else {
            self.voteItem(vote: 1, buttonsOn: [self.buttonFavouriteItem, self.buttonPlusItem], buttonsOff: [self.buttonMinusItem])
        }
    }
    
    func voteItem(vote: Int, buttonsOn: [UIButton], buttonsOff: [UIButton]) {
        if (self.item != nil) {
            if let nonce = UserDefaults.standard.string(forKey: Constants.nonce) {
                Upload.voteItem(delegate: self, id: self.item!.id, vote: vote, nonce: nonce, buttonsOn: buttonsOn, buttonsOff: buttonsOff)
            }
        }
    }
    
    @IBAction func buttonNewTag(_ sender: Any) {
        
    }
    
}

extension ItemTableViewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.itemInfo != nil) {
            return self.itemInfo!.tags.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewTag", for: indexPath) as! TagCollectionViewCell
        if (self.itemInfo != nil) {
            cell.setup(withTag: self.itemInfo!.tags[indexPath.row])
        }
        return cell
    }
    
}

extension ItemTableViewCell: UICollectionViewDelegate {}

extension ItemTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let labelSize = self.itemInfo!.tags[indexPath.row].tag.size(attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 11.0)])
        let spacing = CGFloat(6)
        let calculatedWidth = spacing + labelSize.width + spacing + self.buttonPlusItem.frame.size.width + spacing/2 + self.buttonMinusItem.frame.size.width + spacing
        return CGSize(width: calculatedWidth, height: self.collectionViewTag.frame.size.height)
    }
    
}

extension ItemTableViewCell: DownloadDelegateGif {
    
    func onDownloadFinished(gifData: Data?) {
        if (gifData != nil) {
            self.mediaView.setGifImage(UIImage(gifData: gifData!), manager: SwiftyGifManager.defaultManager)
            self.mediaView.contentMode = .scaleAspectFit
        } else {
            self.mediaView.contentMode = .center
            self.mediaView.image = #imageLiteral(resourceName: "loadingError")
        }
        self.activityIndicatorView.stopAnimating()
    }
    
}

extension ItemTableViewCell: UploadDelegate {
    
    func onUploadFinished(success: Bool, buttonsOn: [UIButton], buttonsOff: [UIButton]) {
        if (success) {
            for button in buttonsOn {
                button.tintColor = Colors.actualTheme
                button.isSelected = true
            }
            for button in buttonsOff {
                button.tintColor = self.myTextColor
                button.isSelected = false
            }
        }
    }
    
}

extension ItemTableViewCell: ABMediaViewDelegate {
    
    func mediaViewDidFail(toPlayVideo mediaView: ABMediaView!) {
        Notification.showErrorMessage(withString: Strings.errorLoadingVideoString)
    }
    
}
