//
//  ModelController.swift
//  Programm
//
//  Created by TodDurchSterben on 11.04.17.
//  Copyright © 2017 TodDurchSterben. All rights reserved.
//

import UIKit
import SDWebImage

class ItemModelController: NSObject {

    var actualItems: [Item] = []
    var navItem: UINavigationItem?
    var standartItems: [Item] = []
    
    fileprivate func setStandartItems() {
        self.actualItems = self.standartItems
    }

    func viewControllerAtIndex(_ index: Int, storyboard: UIStoryboard) -> ItemViewController? {
        // Return the data view controller for the given index.
        if (self.actualItems.count == 0 || index >= self.actualItems.count) {
            return nil
        }

        // Create a new view controller and pass suitable data.
        let itemViewController = storyboard.instantiateViewController(withIdentifier: "ItemViewController") as! ItemViewController
        itemViewController.item = self.actualItems[index]
        itemViewController.navItem = self.navItem
        return itemViewController
    }

    func indexOfViewController(_ viewController: ItemViewController) -> Int {
        return actualItems.index(of: viewController.item!) ?? NSNotFound
    }

}

extension ItemModelController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! ItemViewController)
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index -= 1
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! ItemViewController)
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        if (index == self.actualItems.count) {
            return nil
        }
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }
    
}

extension ItemModelController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.actualItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewItem", for: indexPath) as! ItemCollectionViewCell
        itemCell.setup(withItem: self.actualItems[indexPath.row])
        return itemCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var headerView = UICollectionReusableView()
        if (kind == UICollectionElementKindSectionHeader) {
            headerView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "itemCollectionViewHeader", for: indexPath)
        }
        return headerView
    }
    
}

