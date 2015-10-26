//
//  MetaTableViewCell.swift
//  Score
//
//  Created by Ivy on 15/10/21.
//  Copyright © 2015年 Ivy. All rights reserved.
//

import UIKit

class MetaTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var metaLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
