//
//  BeautyTableViewCell.swift
//  meinv
//
//  Created by tropsci on 16/3/14.
//  Copyright © 2016年 topsci. All rights reserved.
//

import UIKit

protocol BeautyTableViewCellProtocol {
    func favorite(beauty: Beauty, completedBlock:(Bool) -> Void) ->Void
}

class BeautyTableViewCell: UITableViewCell {

    @IBOutlet weak var beautyImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var favoriteDelegate: BeautyTableViewCellProtocol?
    
    var beautyModel: Beauty! {
        didSet {
            let url = NSURL(string: beautyModel.url)
            beautyImageView.sd_setImageWithURL(url!)

            self.titleLabel.text = beautyModel.name
            
            self.favoriteButton.selected = beautyModel.favorited
            
            self.setNeedsLayout()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
        self.titleLabel.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    @IBAction func favoriteAction(sender: UIButton) {
        favoriteDelegate?.favorite(beautyModel, completedBlock: { (success) -> Void in
            if success {
                self.favoriteButton.selected = true
                self.setNeedsLayout()
            }
        })
    }
}
