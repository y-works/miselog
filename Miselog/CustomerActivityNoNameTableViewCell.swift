//
//  CustomerActivityNoNameTableViewCell.swift
//  Miselog
//
//  Created by 成田裕之 on 2017/06/19.
//  Copyright © 2017年 Hiroyuki Narita. All rights reserved.
//

import UIKit

class CustomerActivityNoNameTableViewCell: UITableViewCell {

    @IBOutlet weak var labelActivityMemo: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
