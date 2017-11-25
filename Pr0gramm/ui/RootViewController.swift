//
//  RootViewController.swift
//  Pr0gramm
//
//  Created by TodDurchSterben on 27.04.17.
//  Copyright © 2017 TodDurchSterben. All rights reserved.
//

import UIKit
import AKSideMenu

class RootViewController: AKSideMenu {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colors.feedBackground
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentViewController = self.storyboard?.instantiateViewController(withIdentifier: "itemNavViewController")
        ((self.contentViewController as! ItemNavigationController).viewControllers.first as! ItemCollectionViewViewController).load(withPromoted: 1) // default load with top
        self.leftMenuViewController = self.storyboard?.instantiateViewController(withIdentifier: "leftMenuViewController")
        self.delegate = self
        self.scaleContentView = false
        self.scaleMenuView = false
        self.contentViewInPortraitOffsetCenterX = 80
        self.contentViewInLandscapeOffsetCenterX = 80
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension RootViewController: AKSideMenuDelegate {}
