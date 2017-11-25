//
//  LeftMenuViewController.swift
//  Pr0gramm
//
//  Created by TodDurchSterben on 27.04.17.
//  Copyright © 2017 TodDurchSterben. All rights reserved.
//

import UIKit

class LeftMenuViewController: UIViewController {
    
    fileprivate var actualShownIndex = 0
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    fileprivate func setupUI() {
        self.view.backgroundColor = Colors.actualTheme
        self.tableView.separatorColor = Colors.white
        self.tableView.tableFooterView = UIView(frame: CGRect.zero) // only seperators for "real" cells
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension LeftMenuViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuCell = tableView.dequeueReusableCell(withIdentifier: "tableViewMenu", for: indexPath) as! MenuTableViewCell
        switch indexPath.row {
        case 0:
            menuCell.setup(withTitle: Strings.top)
        case 1:
            menuCell.setup(withTitle: Strings.new)
        case 2:
            menuCell.setup(withTitle: "Login")
        default:
            break
        }
        return menuCell
    }
    
}

extension LeftMenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (self.actualShownIndex != indexPath.row) {
            switch indexPath.row {
            case 0:
                let topNavigationController = (self.storyboard!.instantiateViewController(withIdentifier: "itemNavViewController") as! ItemNavigationController)
                (topNavigationController.viewControllers.first as! ItemCollectionViewViewController).load(withPromoted: 1)
                self.sideMenuViewController?.setContentViewController(topNavigationController , animated: true)
            case 1:
                let newNavigationController = (self.storyboard!.instantiateViewController(withIdentifier: "itemNavViewController") as! ItemNavigationController)
                (newNavigationController.viewControllers.first as! ItemCollectionViewViewController).load(withPromoted: 0)
                self.sideMenuViewController?.setContentViewController(newNavigationController , animated: true)
            case 2:
                Login.login(delegate: self, name: "Schwuchtel", password: "Schwuchtel") // TODO
            default:
                break
            }
        }
        self.sideMenuViewController?.hideMenuViewController()
        self.actualShownIndex = indexPath.row
    }
    
}

extension LeftMenuViewController: LoginDelegate {
    
    func onLoginFinished(success: Bool) {
        
    }
    
}
