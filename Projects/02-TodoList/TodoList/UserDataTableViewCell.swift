//
//  UserDataTableViewCell.swift
//  TodoList
//
//  Created by Nuntaporn on 6/23/2560 BE.
//  Copyright © 2560 AKKHARAWAT CHAYAPIWAT. All rights reserved.
//

import UIKit

class UserDataTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
