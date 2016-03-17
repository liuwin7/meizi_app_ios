//
//  MeTableViewController.swift
//  meinv
//
//  Created by tropsci on 16/3/15.
//  Copyright © 2016年 topsci. All rights reserved.
//

import UIKit

class MeTableViewController: UITableViewController {

    var dataList = [String]()
    weak var centerViewController: CenterViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDataList()
        
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Private Methods
    func setupDataList() {
        dataList.append("我点过的赞")
        dataList.append("退出登录")
        dataList.append("关于")
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("me_cell_id", forIndexPath: indexPath)
        cell.textLabel?.text = dataList[indexPath.row]
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
