//
//  MainViewController.swift
//  meinv
//
//  Created by tropsci on 16/3/15.
//  Copyright © 2016年 topsci. All rights reserved.
//

import UIKit
import pop
import QuartzCore
import SnapKit

class CenterViewController: UIViewController {
    
    var leftViewController: MeTableViewController!
    @IBOutlet weak var rootViewController: BeautyNavigationViewController!
    @IBOutlet var centerTapGest: UITapGestureRecognizer!
    var left: NSLayoutConstraint!
    static let width: CGFloat = {
        return UIScreen.mainScreen().bounds.width - 120
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let meStoryboard = UIStoryboard(name: "Me", bundle: NSBundle.mainBundle())
        leftViewController = meStoryboard.instantiateViewControllerWithIdentifier("meTableViewStoryboardID") as! MeTableViewController
        view.addSubview(leftViewController.view)
        left = NSLayoutConstraint(item: leftViewController.view, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: -CenterViewController.width)
        leftViewController.view.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(CenterViewController.width)
            make.top.equalTo(view)
            make.left.equalTo(left.constant)
            make.bottom.equalTo(view)
        }
        
        leftViewController.centerViewController = self
        rootViewController.centerViewController = self
        
        centerTapGest.enabled = false
        rootViewController.view.addGestureRecognizer(centerTapGest)
        
        self.addChildViewController(rootViewController)
        self.view.addSubview(rootViewController.view)
        rootViewController.view.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(leftViewController.view.snp_trailing).offset(0)
            make.width.equalTo(UIScreen.mainScreen().bounds.size.width)
            make.top.equalTo(view)
            make.bottom.equalTo(view)
        }
    }
    
    @IBAction func tapRootViewControllerAction(sender: UITapGestureRecognizer) {
        self.dismissLeftViewController()
        sender.enabled = !sender.enabled
    }
    
    func dismissLeftViewController() {
        
        leftViewController.view.snp_updateConstraints { (make) -> Void in
            make.width.equalTo(CenterViewController.width)
            make.top.equalTo(view)
            make.left.equalTo(-CenterViewController.width)
            make.bottom.equalTo(view)
        }
        
        leftViewController.removeFromParentViewController()
    }
    
    func showLeftViewController() {
        
        self.addChildViewController(leftViewController)
        leftViewController.view.snp_updateConstraints { (make) -> Void in
            make.width.equalTo(CenterViewController.width)
            make.top.equalTo(view)
            make.left.equalTo(0)
            make.bottom.equalTo(view)
        }
        centerTapGest.enabled = true
    }
    
}
