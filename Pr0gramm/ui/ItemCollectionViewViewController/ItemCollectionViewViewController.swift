//
//  ItemCollectionViewViewController.swift
//  Pr0gramm
//
//  Created by TodDurchSterben on 10.04.17.
//  Copyright © 2017 TodDurchSterben. All rights reserved.
//

import UIKit
import UIScrollView_InfiniteScroll

class ItemCollectionViewViewController : UIViewController {
    
    @IBOutlet var itemCollectionView: UICollectionView!
    @IBOutlet weak var buttonFilter: UIBarButtonItem!
    fileprivate var refreshControl:UIRefreshControl?
    fileprivate var itemModelController = ItemModelController()
    fileprivate var oldestItem: Item?
    fileprivate var actualLoading = false
    fileprivate var reload = false
    fileprivate var promoted = 1 // 1 = top 0 = neu -> default is top
    fileprivate var searchQuery: String?
    fileprivate var previousSearchTextLength = 0
    fileprivate var searchLoad = false
    var flag = 1
    var activityIndicatorNavigationBar: UIActivityIndicatorView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    func load(withPromoted promoted: Int) {
        self.promoted = promoted
        if (self.promoted == 1) {
            self.navigationItem.title = Strings.top
        } else {
            self.navigationItem.title = Strings.new
        }
        self.loadData()
    }
    
    fileprivate func setupUI() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = Colors.actualTheme
        self.itemCollectionView.backgroundColor = Colors.feedBackground
        self.itemCollectionView.dataSource = self.itemModelController
        self.addRefreshControl()
        self.addInfinitScroll()
        self.addActivityIndicator()
    }
    
    fileprivate func addActivityIndicator() {
        self.activityIndicatorNavigationBar = UIActivityIndicatorView.init(activityIndicatorStyle: .white)
        self.activityIndicatorNavigationBar.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        self.activityIndicatorNavigationBar.hidesWhenStopped = true
        let barButton = UIBarButtonItem.init(customView: self.activityIndicatorNavigationBar)
        self.navigationItem.leftBarButtonItems?.append(barButton)
    }
    
    fileprivate func addRefreshControl() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(self.reloadData), for: .valueChanged)
        self.refreshControl?.tintColor = Colors.actualTheme
        self.itemCollectionView.refreshControl = self.refreshControl
    }
    
    fileprivate func addInfinitScroll() {
        self.itemCollectionView.addInfiniteScroll { (collectionView) -> Void in
            collectionView.performBatchUpdates({ () -> Void in
                self.loadData(older: true)
            }, completion: { (finished) -> Void in
                collectionView.finishInfiniteScroll()
            });
        }
        self.itemCollectionView.infiniteScrollTriggerOffset = 500
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.color = Colors.actualTheme
        self.itemCollectionView.infiniteScrollIndicatorView = activityIndicator
    }
    
    func loadData() {
        self.refreshControl?.beginRefreshing()
        self.reloadData()
    }
    
    func reloadData() {
        self.reload = true
        self.loadData(older: false)
    }
    
    fileprivate func loadData(older: Bool) {
        if (!actualLoading) {
            self.actualLoading = true
            if (older && self.oldestItem != nil) { // load when possible older data
                var older = 0
                if (self.promoted == 1) {
                    older = self.oldestItem!.promoted
                } else {
                    older = self.oldestItem!.id
                }
                if (self.searchQuery == nil) {
                    Download.downloadItemsOlder(delegate: self, flag: self.flag, promoted: self.promoted, older: older)
                } else {
                    self.searchLoad = true
                    Download.downloadSearchItemsOlder(delegate: self, flag: self.flag, promoted: self.promoted, older: older, query: self.searchQuery!)
                }
            } else {
                if (self.searchQuery == nil) {
                    Download.downloadItems(delegate: self, flag: self.flag, promoted: self.promoted)
                } else {
                    self.searchLoad = true
                    Download.downloadSearchItems(delegate: self, flag: self.flag, promoted: self.promoted, query: self.searchQuery!)
                }
            }
        }
    }
    
    // MARK: - Storyboard Delegate
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showItem") {
            let destination = segue.destination as! ItemRootViewController
            self.itemModelController.navItem = destination.navigationItem
            destination.itemModelController = self.itemModelController
            let selectedCell = sender as! ItemCollectionViewCell
            let indexPath = self.itemCollectionView.indexPath(for: selectedCell)
            destination.actualItemIndex = indexPath!.row
        } else if (segue.identifier == "showPopover") {
            let popoverViewController = segue.destination as! PopoverViewController
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
            popoverViewController.popoverPresentationController!.delegate = self
            popoverViewController.setup(withFlag: self.flag, itemCollectionViewViewController: self)
        }
    }
    
}

extension ItemCollectionViewViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
}

extension ItemCollectionViewViewController: UICollectionViewDelegate {}

extension ItemCollectionViewViewController: DownloadDelegateItem {
    
    func onDownloadFinished(items: [Item]) {
        if (items.count != 0 || self.searchLoad) {
            if (self.searchLoad == false) {
                self.itemModelController.standartItems = items
            }
            self.searchLoad = false
            if (self.reload) {
                self.reload = false
                self.itemModelController.actualItems = items
                
                var indexPathsDelete = [IndexPath]()
                for i in 0..<self.itemCollectionView.numberOfItems(inSection: 0) {
                    indexPathsDelete.append(IndexPath(item: i, section: 0))
                }
                var indexPathsInsert = [IndexPath]()
                for i in 0..<items.count {
                    indexPathsInsert.append(IndexPath(item: i, section: 0))
                }
                self.itemCollectionView.performBatchUpdates({ () -> Void in
                    self.itemCollectionView.deleteItems(at: indexPathsDelete)
                    self.itemCollectionView.insertItems(at: indexPathsInsert)
                }, completion: nil)
                self.itemCollectionView.setContentOffset(CGPoint(x: 0, y: 44) , animated: false) // hide search bar
            } else {
                self.itemModelController.actualItems.append(contentsOf: items)
                
                let firstNewItemIndex = self.itemCollectionView.numberOfItems(inSection: 0)
                var indexPathsInsert = [IndexPath]()
                for i in firstNewItemIndex..<firstNewItemIndex+items.count {
                    indexPathsInsert.append(IndexPath(item: i, section: 0))
                }
                self.itemCollectionView.insertItems(at: indexPathsInsert)
            }
            if (items.count != 0) {
                self.oldestItem = items.last
            }
        }
        self.refreshControl?.endRefreshing()
        self.activityIndicatorNavigationBar.stopAnimating()
        self.actualLoading = false
    }
    
}

extension ItemCollectionViewViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchQuery = searchBar.text
        self.activityIndicatorNavigationBar.startAnimating()
        self.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText == "") {
            self.searchQuery = nil
            if (previousSearchTextLength > 1) {
                self.reload = true
                self.onDownloadFinished(items: self.itemModelController.standartItems)
            }
        }
        previousSearchTextLength = searchText.characters.count
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.itemCollectionView.refreshControl = nil
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.itemCollectionView.refreshControl = self.refreshControl
    }
    
}
