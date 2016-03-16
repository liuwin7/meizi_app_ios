//
//  LoginViewController.swift
//  meinv
//
//  Created by tropsci on 16/3/16.
//  Copyright © 2016年 topsci. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import Argo
import IQKeyboardManagerSwift

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    var manager: Manager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "登录"
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.timeoutIntervalForRequest = 10
        self.manager = Manager(configuration: config)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.sharedManager().enable = false
    }
    
    // MARK: - IBAction
    
    @IBAction func cancelLoginAction(sender: UIBarButtonItem) {
        IQKeyboardManager.sharedManager().resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func loginAction(sender: UIButton) {
        guard let username = usernameTextField.text , password = userPasswordTextField.text else {
            let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
            hud.mode = .Text
            hud.labelText = "用户名或密码不能为空"
            hud.hide(true, afterDelay: 0.3)
            return
        }
        let parameters = [
            "username":username,
            "password":password
        ]
        
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        self.manager.request(.POST, "http://192.168.7.14:5000/login", parameters: parameters, encoding: .JSON).responseJSON { (response) -> Void in
            guard let value = response.result.value else {
                return
            }
            let result:RequestResult = Argo.decode(value)!
            switch result.code {
            case .IncorrectUsernameOrPassword:
                hud.mode = .Text
                hud.labelText = result.desc
                hud.hide(true, afterDelay: 0.5)
            default:
                if let userInfo = result.userInfo {
                    NSUserDefaults.standardUserDefaults().userNickname = userInfo.userNickname
                    NSUserDefaults.standardUserDefaults().userUUID = userInfo.userUUID
                    NSUserDefaults.standardUserDefaults().username = userInfo.username
                }
                hud.hide(true)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
        }
    }
    
}
