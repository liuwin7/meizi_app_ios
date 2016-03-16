//
//  BeautyNavigationViewController.swift
//  meinv
//
//  Created by tropsci on 16/3/15.
//  Copyright © 2016年 topsci. All rights reserved.
//

import UIKit

class BeautyNavigationViewController: UINavigationController {

    weak var centerViewController: CenterViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let mainStoryBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let beautyTableVC = mainStoryBoard.instantiateViewControllerWithIdentifier("beautiesTableViewControllerID")
        self.pushViewController(beautyTableVC, animated: true)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
