//
//  GithubUserTableViewCell.swift
//  WhoToFollow
//
//  Created by AKKHARAWAT CHAYAPIWAT on 6/20/17.
//  Copyright © 2017 AKKHARAWAT CHAYAPIWAT. All rights reserved.
//

import UIKit
import AlamofireImage

class GithubUserTableViewCell: UITableViewCell {

	static let cellIdentifier = "GITHUB_USER_TABLE_VIEW_CELL"
	
	@IBOutlet weak var avatarImageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var followButton: UIButton!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	override func prepareForReuse() {
		self.avatarImageView.image = nil
	}
	
	func configureCellWithModel(_ model: GithubUser){
		if let avatarURLStr = model.avatarUrl,
			let avatarURL = URL(string: avatarURLStr) {
			self.avatarImageView.af_setImage(withURL: avatarURL)
		}else{
			self.avatarImageView.image = nil
		}
		
		nameLabel.text = model.login
	}
}
