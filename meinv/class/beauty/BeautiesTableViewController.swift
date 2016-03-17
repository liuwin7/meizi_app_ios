//
//  BeautiesTableViewController.swift
//  meinv
//
//  Created by tropsci on 16/3/14.
//  Copyright © 2016年 topsci. All rights reserved.
//

import UIKit
import Alamofire
import Argo
import MBProgressHUD
import SDWebImage
import DZNEmptyDataSet

class BeautiesTableViewController: UITableViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var meBarButtonItem: UIBarButtonItem!
    
    var request: Request?
    var hud:     MBProgressHUD?
    var beautyList: [Beauty]!
    var types : [String]!
    var displayState: BeautyTableDisplayState!
    var manager: Manager!
    
    var beautyType: String! {
        didSet {
            
            self.title = NSLocalizedString(beautyType, comment:beautyType)
            var parameters = [
                "type": beautyType,
            ]
            if let uuid = NSUserDefaults.standardUserDefaults().userUUID {
                parameters["user_uuid"] = uuid
            }
            request = self.manager.request(.POST, GlobalConstant.kAPI_Beauties, parameters:parameters , encoding: .JSON).responseJSON { (response) -> Void in
                guard let value = response.result.value else {
                    self.hud?.mode = .Text
                    self.hud?.labelText = NSLocalizedString("Network Error", comment: "Network Error")
                    self.hud?.hide(true, afterDelay: 1.5)
                    self.displayState = .errorStete
                    self.tableView.reloadData()
                    self.request = nil
                    return
                }
                let result:RequestResult = Argo.decode(value)!
                switch result.code {
                case .NoError:
                    self.hud?.labelText = ""
                    self.hud?.hide(true, afterDelay: 0.25)
                    self.beautyList = result.beauties!
                    self.displayState = .emptyState
                    self.tableView.reloadData()
                case .InvalidType:
                    self.hud?.mode = .Text
                    self.hud?.labelText = result.desc
                    self.hud?.hide(true, afterDelay: 1.0)
                    self.beautyList = []
                    self.displayState = .errorStete
                    self.tableView.reloadData()
                default:
                    self.hud?.mode = .Text
                    self.hud?.labelText = "未知的错误类型"
                    self.hud?.hide(true, afterDelay: 1.0)
                    self.displayState = .errorStete
                }
                self.request = nil
            }
        }
    }
    
    @IBAction func showMeAction(sender: UIBarButtonItem) {
        
        guard let beautyNavigationController = self.navigationController as? BeautyNavigationViewController else {
            print("Error")
            return
        }
        
        guard let center = beautyNavigationController.centerViewController else {
            print("Error")
            return
        }
        center.showLeftViewController()
    }

    
    @IBAction func changeTheme(sender: UIBarButtonItem) {
        
        if self.request != nil {
            let alertView = UIAlertView(title: NSLocalizedString("Alert", comment: "Alert"),
                message: NSLocalizedString("Please Waitting...", comment: "Please Waitting..."),
                delegate: nil,
                cancelButtonTitle: nil,
                otherButtonTitles: NSLocalizedString("OK", comment: "OK"))
            alertView.show()
            return
        }
        
        self.hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        
        self.request = self.manager.request(.POST, GlobalConstant.kAPI_Types, parameters:nil , encoding: .JSON).responseJSON { (response) -> Void in
            guard let value = response.result.value else {
                self.hud?.mode = .Text
                self.hud?.labelText = NSLocalizedString("Network Error", comment: "Network Error")
                self.hud?.hide(true, afterDelay: 0.5)
                self.request = nil
                return
            }
            let result:RequestResult = Argo.decode(value)!
            switch result.code {
            case .InvalidType:
                self.hud?.mode = .Text
                self.hud?.labelText = result.desc
                self.hud?.hide(true, afterDelay: 0.5)
            case .NoError:
                self.hud?.hide(true, afterDelay: 0.25)
                
                let actionSheet = UIActionSheet(title: NSLocalizedString("Change Theme", comment: "Change Theme"),
                    delegate: self,
                    cancelButtonTitle: NSLocalizedString("Cancel", comment: "Cancel"),
                    destructiveButtonTitle: nil
                )
                self.types = result.types!
                for type in self.types {
                    actionSheet.addButtonWithTitle(NSLocalizedString(type, comment: type))
                }
                actionSheet.showInView(self.view)
                
            default:
                self.hud?.mode = .Text
                self.hud?.labelText = "未知的错误类型"
                self.hud?.hide(true, afterDelay: 1.0)
                self.displayState = .errorStete
            }
            
            self.request = nil
        }
    }
    
    // MARK: - UIViewController
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let request = request {
            request.cancel()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let nickname = NSUserDefaults.standardUserDefaults().userNickname {
            self.meBarButtonItem.title = nickname
        }
        
        if request != nil && self.hud == nil {
            self.hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.timeoutIntervalForRequest = 10
        self.manager = Manager(configuration: config)
        
        self.beautyList = []
        self.beautyType = "qingxin"
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        tableView.tableHeaderView = UIView()
        
        displayState = .emptyState
        
    }
    
    func updateNickname() {
        if let nickname = NSUserDefaults.standardUserDefaults().userNickname {
            self.meBarButtonItem.title = nickname
        }
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beautyList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("beauty_cell_id", forIndexPath: indexPath) as! BeautyTableViewCell
        cell.beautyModel = beautyList[indexPath.row]
        cell.favoriteDelegate = self
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let beauty = self.beautyList[indexPath.row]
        return CGFloat(beauty.height) + 8 * 2 + 21
    }
    
}


extension BeautiesTableViewController {
    enum BeautyTableDisplayState: Int {
        case emptyState
        case errorStete
    }
}


// MARK: - DZNEmptyDataSetDelegate, DZNEmptyDataSetSource
extension BeautiesTableViewController: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let state:BeautyTableDisplayState = displayState
        var description:NSAttributedString!
        switch state {
        case .emptyState:
            description = NSAttributedString(string: "一大波妹子正在向你奔袭^_^")
        case .errorStete:
            description = NSAttributedString(string: "妹子跑丢了/(ㄒoㄒ)/~~")
        }
        return description
    }
    
    func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
        return NSAttributedString(string: "重新🔍妹子")
    }
    
    func spaceHeightForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
        return 40
    }
    
    func emptyDataSet(scrollView: UIScrollView!, didTapButton button: UIButton!) {
        self.hud = MBProgressHUD.showHUDAddedTo(view, animated: true)

        let type = self.beautyType
        self.beautyType = type
    }
}

// MARK: - UIActionSheetDelegate

extension BeautiesTableViewController: UIActionSheetDelegate {
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0 {
            return
        }
        let type = self.types[buttonIndex - 1]
        self.beautyType = type
    }
}

// MARK: - BeautyTableViewCellProtocol

extension BeautiesTableViewController : BeautyTableViewCellProtocol {
    func favorite(beauty: Beauty, completedBlock: (Bool) -> Void) {
        let uuid = NSUserDefaults.standardUserDefaults().userUUID
        guard let user_uuid = uuid else {
            // alert user to login
            let alert = UIAlertController(title: "提示", message: "登录之后，才可以点赞哟😊", preferredStyle: .Alert)
            let loginAction = UIAlertAction(title: "去登录", style:.Destructive, handler: { (action) -> Void in
                // jump to login
                self.performSegueWithIdentifier("show_login_segue_id", sender: self)
            })
            let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
            alert.addAction(loginAction)
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
            completedBlock(false)
            return
        }

        if request != nil {
            // alert waiting
            let alertController = UIAlertController(title: "提示", message: "请稍后", preferredStyle: .Alert)
            let alertAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
            alertController.addAction(alertAction)
        }
        let params:[String: String] = ["user_uuid": user_uuid, "beauty_uuid": "\(beauty.beautyID)"]
        request = self.manager.request(.POST, GlobalConstant.kAPI_Favorite, parameters: params, encoding: .JSON).responseJSON( completionHandler: { (response) -> Void in
            guard let value = response.result.value else {
                self.request = nil
                return
            }
            self.request = nil
            let result:RequestResult = Argo.decode(value)!
            switch result.code {
            case .NoError:
                
                completedBlock(true)
            default:
                completedBlock(false)
            }
        })
    }
}
