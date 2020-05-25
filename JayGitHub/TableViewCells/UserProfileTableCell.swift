//
//  UserProfileTableCell.swift
//  JayGitHub
//
//  Created by jayanth on 4/21/20.
//  Copyright © 2020 jayanth. All rights reserved.
//

import UIKit

class UserProfileTableCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var repoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureWith(user: User?) {
        userNameLabel.text = user?.login ?? ""
        
        if let repo = user?.publicRepos {
            repoLabel.text = "Repo: \(repo)"
        }
        
        //load image
        guard let imageUrlString = user?.avatarUrl, let imageUrl:URL = URL(string: imageUrlString) else {
            return
        }
        profileImage.loadImage(withUrl: imageUrl, userID: user?.login ?? "")
        
    }
    
    override func prepareForReuse() {
        profileImage.image = nil
        repoLabel.text = "Repo:#"
        userNameLabel.text = ""
    }
    

}
