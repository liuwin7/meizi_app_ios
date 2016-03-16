//
//  RegisterViewController.swift
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

class RegisterViewController: UIViewController {

    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var conformPasswordTextField: UITextField!
    
    var manager: Manager!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "注册"
        
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
    
    // MARK: - IBActions
    
    @IBAction func registerAction(sender: UIButton) {
        guard let username = usernameTextField.text,
            nickname = usernameTextField.text,
            password = passwordTextField.text,
            conformPassword = conformPasswordTextField.text else {
                let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
                hud.mode = .Text
                hud.labelText = "用户名、昵称、密码、确认密码，不能为空"
                hud.hide(true, afterDelay: 0.25)
                return
        }
        
        var desc: String = ""
        if password.characters.count < 6 {
            desc = "密码长度小于六位"
        }
        if password != conformPassword {
            desc = "密码和确认密码不一致"
        }
        
        if desc.characters.count > 0 {
            let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
            hud.mode = .Text
            hud.labelText = desc
            hud.hide(true, afterDelay: 0.25)
            return
        }
        
        
        let parameters = ["username": username, "password": password, "nickname":nickname]
        
        let hud = MBProgressHUD.showHUDAddedTo(view , animated: true)
        hud.mode = .Text
        hud.labelText = "正在注册"
        self.manager.request(.POST, "http://192.168.7.14:5000/register", parameters: parameters, encoding: .JSON).responseJSON { (response) -> Void in
            guard let value = response.result.value else {
                hud.labelText = NSLocalizedString("Network Error", comment: "Network Error")
                hud.hide(true, afterDelay: 0.5)
                return
            }
            let result:RequestResult = Argo.decode(value)!
            switch result.code {
            case .InvalidUsername:
                hud.labelText = "无效的用户名"
            case .UsernameHasBeenUsed:
                hud.labelText = "用户名已经被人占用"
            case .InvalidPassword:
                hud.labelText = "密码无效"
            default:
                hud.labelText = "注册成功，请登录"
                self.navigationController?.popViewControllerAnimated(true)
            }
            hud.hide(true, afterDelay: 0.5)
        }
    }
}
