//
//  RepoTableCell.swift
//  JayGitHub
//
//  Created by jayanth on 4/21/20.
//  Copyright © 2020 jayanth. All rights reserved.
//

import UIKit

class RepoTableCell: UITableViewCell {

    @IBOutlet weak var repoNAmeLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureWith(repo: Repo?) {
        repoNAmeLabel.text = repo?.name ?? ""
        forksLabel.text = "\(repo?.forks ?? 0) Forks"
        starsLabel.text = "\(repo?.forks ?? 0) Stars"

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
