//
//  ItemViewController.swift
//  Pr0gramm
//
//  Created by TodDurchSterben on 11.04.17.
//  Copyright © 2017 TodDurchSterben. All rights reserved.
//

import UIKit
import ABMediaView

class ItemViewController: UITableViewController {
    
    var item: Item?
    var itemInfo: ItemInfo?
    var navItem: UINavigationItem?
    fileprivate var buttonFullsize: UIBarButtonItem?
    var itemCell: ItemTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.reloadData() // TODO nur im wlan ansonsten in viewwillappear
    }
    
    fileprivate func setupUI() {
        self.addRefreshControl()
        self.buttonFullsize = self.navItem?.rightBarButtonItems?[0]
        self.view.backgroundColor = Colors.feedBackground
    }
    
    fileprivate func addRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.reloadData), for: .valueChanged)
        refreshControl.tintColor = Colors.actualTheme
        self.tableView.refreshControl = refreshControl
    }
    
    func reloadData() {
        self.tableView.reloadData() // update? TODO
        Download.downloadItemInfo(delegate: self, id: self.item!.id)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.resetMediaView()
    }
    
    func resetMediaView() {
        if (self.item!.image.hasSuffix("mp4")) {
            if (self.getItemCell() != nil) {
                self.getItemCell()?.resetMediaView()
            }
        }
    }
    
    func getMediaView() -> ABMediaView? {
        if (self.getItemCell() != nil) {
            return self.getItemCell()?.mediaView
        }
        return nil
    }
    
    fileprivate func getItemCell() -> ItemTableViewCell? {
        if (self.tableView.numberOfSections > 0 && self.tableView.numberOfRows(inSection: 0) > 0) {
            return self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ItemTableViewCell
        }
        return nil
    }
    
    fileprivate func showItemInfo() {
        self.tableView.reloadData() // update? TODO
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.itemInfo != nil) {
            return self.itemInfo!.comments.count + 1
        } else if (self.item != nil){
            return 1
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let itemCell = tableView.dequeueReusableCell(withIdentifier: "tableViewComment1", for: indexPath) as! ItemTableViewCell
            if (self.item != nil) {
                itemCell.setup(withItem: self.item!)
            }
            if (self.itemInfo != nil) {
                itemCell.setup(withItemInfo: self.itemInfo!)
            }
            return itemCell
        } else {
            let commentCell = tableView.dequeueReusableCell(withIdentifier: "tableViewComment2", for: indexPath) as! CommentTableViewCell
            if (self.itemInfo != nil) {
                // commentCell.setup(withComment: self.itemInfo!.comments[indexPath.row], op: self.item?.user == self.itemInfo?.comments[indexPath.row].name)
            }
            return commentCell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            // TODO erst nach neuladen umstellen
            return CGFloat(self.item!.height) * self.calculateScaleFactor(width: tableView.frame.width) + self.stuffHeight()
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    fileprivate func calculateScaleFactor(width: CGFloat) -> CGFloat {
        return width / CGFloat(self.item!.width)
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return tableView.frame.width + self.stuffHeight()
        } else {
            return tableView.estimatedRowHeight
        }
    }
    
    fileprivate func stuffHeight() -> CGFloat {
        let spacing = 16
        let buttonPlusHeight = 30
        let buttonNewHeight = 35
        let textFielCommentHeight = 35
        
        return CGFloat(spacing + buttonPlusHeight + spacing + buttonNewHeight + spacing + textFielCommentHeight + spacing)
    }
    
}

extension ItemViewController: DownloadDelegateItemInfo {
    
    func onDownloadFinished(itemInfo: ItemInfo?) {
        if (itemInfo != nil) {
            self.itemInfo = itemInfo
            self.showItemInfo()
        }
        self.tableView.refreshControl?.endRefreshing()
    }
    
}
