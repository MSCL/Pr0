//
//  ItemNavigationController
//  Pr0gramm
//
//  Created by TodDurchSterben on 27.04.17.
//  Copyright © 2017 TodDurchSterben. All rights reserved.
//

import UIKit

class ItemNavigationController: UINavigationController {
    
    open override var prefersStatusBarHidden: Bool {
        return navigationController?.isNavigationBarHidden ?? false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
