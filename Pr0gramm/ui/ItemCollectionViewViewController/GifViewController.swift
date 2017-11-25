//
//  GifViewController.swift
//  Pr0gramm
//
//  Created by TodDurchSterben on 19.04.17.
//  Copyright © 2017 TodDurchSterben. All rights reserved.
//

import UIKit
import SwiftyGif

class GifViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var gifImage: UIImage?
    
    open override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.backgroundColor = Colors.feedBackground
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        if (self.gifImage != nil) {
            self.imageView.setGifImage(self.gifImage!, manager: SwiftyGifManager.defaultManager)
        }
    }
    
    @IBAction func tapGestureRecognizer(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
