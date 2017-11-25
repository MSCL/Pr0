//
//  ItemRootViewController.swift
//  Pr0gramm
//
//  Created by TodDurchSterben on 11.04.17.
//  Copyright © 2017 TodDurchSterben. All rights reserved.
//

import UIKit
import JTSImageViewController
import ABMediaView

class ItemRootViewController: UIViewController {

    fileprivate var pageViewController: UIPageViewController?
    var itemModelController: ItemModelController?
    var actualItemIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Configure the page view controller and add it as a child view controller.
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageViewController?.delegate = self
        let startingViewController: ItemViewController = (self.itemModelController?.viewControllerAtIndex(actualItemIndex, storyboard: self.storyboard!)!)!
        let viewControllers = [startingViewController]
        self.pageViewController?.setViewControllers(viewControllers, direction: .forward, animated: false, completion: {done in })
        self.pageViewController?.dataSource = self.itemModelController
        self.addChildViewController(self.pageViewController!)
        self.view.addSubview(self.pageViewController!.view)
        self.pageViewController?.didMove(toParentViewController: self)
        
        self.setupUI()
    }
    
    fileprivate func setupUI() {
        self.view.backgroundColor = Colors.feedBackground
        let buttonFullsize = UIBarButtonItem(image: #imageLiteral(resourceName: "fullsizeWhite"), style: .plain, target: self, action: #selector(self.buttonFullsizeAction))
        self.navigationItem.setRightBarButtonItems([buttonFullsize], animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Button Actions
    
    func buttonFullsizeAction() {
      let currentViewController = self.pageViewController?.viewControllers?[0] as! ItemViewController
        if (currentViewController.item!.image.hasSuffix("gif")) {
            self.showFullsizeGif(viewController: currentViewController)
        } else if (currentViewController.item!.image.hasSuffix("mp4")) {
            self.showFullsizeVideo(viewController: currentViewController)
        } else {
            self.showFullsizeImage(viewController: currentViewController)
        }
    }
    
    fileprivate func showFullsizeGif(viewController: ItemViewController) {
        if (viewController.getMediaView() != nil) {
            let gifViewController = self.storyboard?.instantiateViewController(withIdentifier: "gifViewController") as! GifViewController
            gifViewController.gifImage = viewController.getMediaView()!.gifImage
            self.present(gifViewController, animated: true, completion: nil)
        }
    }
    
    fileprivate func showFullsizeVideo(viewController: ItemViewController) {
        if (viewController.getMediaView() != nil) {
            let mediaView = ABMediaView(mediaView: viewController.getMediaView())
            mediaView?.delegate = self
            mediaView?.backgroundColor = Colors.feedBackground
            viewController.resetMediaView()
            (ABMediaView.sharedManager() as! ABMediaView).present(mediaView)
        }
    }
    
    fileprivate func showFullsizeImage(viewController: ItemViewController) {
        if (viewController.getMediaView() != nil) {
            let imageInfo = JTSImageInfo()
            if (viewController.item?.fullsize != "") {
                imageInfo.placeholderImage = viewController.getMediaView()!.image
                imageInfo.imageURL = URL(string: String(format: Constants.URLImageFullsize, (viewController.item?.fullsize)!))
            } else {
                imageInfo.image = viewController.getMediaView()!.image
            }
            let imageViewController = JTSImageViewController(imageInfo: imageInfo, mode: .image, backgroundStyle: .blurred)
            imageViewController?.show(from: viewController, transition: .fromOffscreen)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { (_) in
            NotificationCenter.default.post(name: .ABMediaViewWillRotate, object: nil)
        }, completion: { (_) in
            NotificationCenter.default.post(name: .ABMediaViewDidRotate, object: nil)
        })
    }
    
}

extension ItemRootViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, spineLocationFor orientation: UIInterfaceOrientation) -> UIPageViewControllerSpineLocation {
        if (orientation == .portrait) || (orientation == .portraitUpsideDown) || (UIDevice.current.userInterfaceIdiom == .phone) {
            // In portrait orientation or on iPhone: Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to true, so set it to false here.
            let currentViewController = (self.pageViewController?.viewControllers?[0])!
            let viewControllers = [currentViewController]
            self.pageViewController?.setViewControllers(viewControllers, direction: .forward, animated: true, completion: {done in })
            self.pageViewController?.isDoubleSided = false
            return .min
        }
        
        // In landscape orientation: Set set the spine location to "mid" and the page view controller's view controllers array to contain two view controllers. If the current page is even, set it to contain the current and next view controllers; if it is odd, set the array to contain the previous and current view controllers.
        let currentViewController = self.pageViewController!.viewControllers?[0] as! ItemViewController
        var viewControllers: [UIViewController]
        let indexOfCurrentViewController = self.itemModelController!.indexOfViewController(currentViewController)
        if (indexOfCurrentViewController == 0) || (indexOfCurrentViewController % 2 == 0) {
            let nextViewController = self.itemModelController?.pageViewController(self.pageViewController!, viewControllerAfter: currentViewController)
            viewControllers = [currentViewController, nextViewController!]
        } else {
            let previousViewController = self.itemModelController!.pageViewController(self.pageViewController!, viewControllerBefore: currentViewController)
            viewControllers = [previousViewController!, currentViewController]
        }
        self.pageViewController?.setViewControllers(viewControllers, direction: .forward, animated: true, completion: {done in })
        
        return .mid
    }
    
}

extension ItemRootViewController: ABMediaViewDelegate {
    
    func mediaViewWillPresent(_ mediaView: ABMediaView!) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func mediaViewWillDismiss(_ mediaView: ABMediaView!) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func mediaViewDidFail(toPlayVideo mediaView: ABMediaView!) {
        // happens after a certain watched videos (20 ?) -> restart the app TODO
        Notification.showErrorMessage(withString: Strings.errorLoadingVideoString)
    }
    
}
