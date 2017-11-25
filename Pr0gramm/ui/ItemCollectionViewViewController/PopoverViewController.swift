//
//  PopoverViewController.swift
//  Pr0gramm
//
//  Created by TodDurchSterben on 13.05.17.
//  Copyright © 2017 TodDurchSterben. All rights reserved.
//

import UIKit
import BEMCheckBox

class PopoverViewController: UITableViewController {
    
    @IBOutlet weak var checkBoxSFW: BEMCheckBox!
    @IBOutlet weak var checkBoxNSFW: BEMCheckBox!
    @IBOutlet weak var checkBoxNSFL: BEMCheckBox!
    fileprivate var itemCollectionViewViewController: ItemCollectionViewViewController?
    fileprivate var flag = 9 // TODO?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setup(withFlag flag: Int, itemCollectionViewViewController: ItemCollectionViewViewController) {
        self.itemCollectionViewViewController = itemCollectionViewViewController
        self.flag = flag
    }
    
    fileprivate func setupUI() {
        self.checkBoxSFW.boxType = .square
        self.checkBoxNSFW.boxType = .square
        self.checkBoxNSFL.boxType = .square
        self.checkBoxSFW.onTintColor = Colors.actualTheme
        self.checkBoxNSFW.onTintColor = Colors.actualTheme
        self.checkBoxNSFL.onTintColor = Colors.actualTheme
        self.checkBoxSFW.onCheckColor = Colors.actualTheme
        self.checkBoxNSFW.onCheckColor = Colors.actualTheme
        self.checkBoxNSFL.onCheckColor = Colors.actualTheme
        
        switch self.flag {
        case 2:
            self.checkBoxNSFW.setOn(true, animated: false)
            break
        case 4:
            self.checkBoxNSFL.setOn(true, animated: false)
            break
        case 6:
            self.checkBoxNSFW.setOn(true, animated: false)
            self.checkBoxNSFL.setOn(true, animated: false)
            break
        case 9:
            self.checkBoxSFW.setOn(true, animated: false)
            break
        case 11:
            self.checkBoxSFW.setOn(true, animated: false)
            self.checkBoxNSFW.setOn(true, animated: false)
            break
        case 13:
            self.checkBoxSFW.setOn(true, animated: false)
            self.checkBoxNSFL.setOn(true, animated: false)
            break
        case 15:
            self.checkBoxSFW.setOn(true, animated: false)
            self.checkBoxNSFW.setOn(true, animated: false)
            self.checkBoxNSFL.setOn(true, animated: false)
            break
        default:
            self.checkBoxSFW.setOn(true, animated: false)
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.checkBoxSFW.setOn(!self.checkBoxSFW.on, animated: true)
            break
        case 1:
            self.checkBoxNSFW.setOn(!self.checkBoxNSFW.on, animated: true)
            break
        case 2:
            self.checkBoxNSFL.setOn(!self.checkBoxNSFL.on, animated: true)
            break
        default:
            self.checkBoxSFW.setOn(!self.checkBoxSFW.on, animated: true)
            break
        }
        self.setFlag()
        self.setButtonTitle()
        self.executeFilter()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    fileprivate func setFlag() {
        if (self.checkBoxSFW.on) {
            // sfw true
            if (self.checkBoxNSFW.on) {
                // nsfw true
                if (self.checkBoxNSFL.on) {
                    //nsfl true
                    self.flag = 15
                } else {
                    // nsfl false
                    self.flag = 11
                }
            } else {
                // nsfw false
                if (self.checkBoxNSFL.on) {
                    // nsfl true
                    self.flag = 13
                } else {
                    // nsfl false
                    self.flag = 9
                }
            }
        } else {
            // sfw false
            if (self.checkBoxNSFW.on) {
                // nsfw true
                if (self.checkBoxNSFL.on) {
                    //nsfl true
                    self.flag = 6
                } else {
                    // nsfl false
                    self.flag = 2
                }
            } else {
                // nsfw false
                if (self.checkBoxNSFL.on) {
                    // nsfl true
                    self.flag = 4
                } else {
                    // nsfl false
                    self.flag = 9
                }
            }
        }
    }
    
    fileprivate func setButtonTitle() {
        var buttonTitle = ""
        switch self.flag {
        case 2:
            buttonTitle = Strings.nsfw
            break
        case 4:
            buttonTitle = Strings.nsfl
            break
        case 6:
            buttonTitle = Strings.nsfw_nsfl
            break
        case 9:
            buttonTitle = Strings.sfw
            break
        case 11:
            buttonTitle = Strings.sfw_nsfw
            break
        case 13:
            buttonTitle = Strings.sfw_nsfl
            break
        case 15:
            buttonTitle = Strings.all
            break
        default:
            buttonTitle = Strings.sfw
            break
        }
        itemCollectionViewViewController?.buttonFilter.title = buttonTitle
    }
    
    fileprivate func executeFilter() {
        self.itemCollectionViewViewController?.flag = self.flag
    self.itemCollectionViewViewController?.activityIndicatorNavigationBar?.startAnimating()
        self.itemCollectionViewViewController?.loadData()
    }
    
}

extension PopoverViewController: BEMCheckBoxDelegate {}
