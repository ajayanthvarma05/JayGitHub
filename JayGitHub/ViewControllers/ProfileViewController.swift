//
//  ProfileViewController.swift
//  JayGitHub
//
//  Created by jayanth on 4/21/20.
//  Copyright © 2020 jayanth. All rights reserved.
//

import UIKit

let kRepoCellIdentifier = "RepoTableCell"

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var joinDateLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var user: User?
    var allRepos: [Repo] = []
    var tableListRepos: [Repo] = []

    let dataManager = DataManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.addTextFieldShadow()
        
        //load image if cached
        profileImage.loadImage(userID: user?.login ?? "")
        
        //get user detail
        dataManager.get(user: user?.login ?? "") { [weak self] (user) in
            self?.user = user
            self?.displayUserInfo()
        }

        //get repo info
        dataManager.getRepo(user: user?.login ?? "") { [weak self] (repos) in
            guard let repos = repos else {
                return
            }
            self?.allRepos = repos
            self?.tableListRepos = repos
            self?.reloadTable()
        }
    }
    
    func displayUserInfo() {
        DispatchQueue.main.async { [weak self] in
            self?.userNameLabel.text = self?.user?.name ?? ""
            self?.emailLabel.text = self?.user?.email ?? ""
            self?.locationLabel.text = self?.user?.location ?? ""
            self?.followersLabel.text = "\(self?.user?.followers ?? 0) Followers"
            self?.followingLabel.text = "Following \(self?.user?.following ?? 0)"
            self?.joinDateLabel.text = self?.user?.joinDate()
            self?.bioLabel.text = self?.user?.bio ?? ""
            
            //load image
            guard let imageUrlString = self?.user?.avatarUrl, let imageUrl:URL = URL(string: imageUrlString) else {
                return
            }
            self?.profileImage.loadImage(withUrl: imageUrl, userID: self?.user?.login ?? "")
        }
    }
    
    func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func filterWithText(_ search: String) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            //check substring
            let filteredUsers = self?.allRepos.filter { (repo) -> Bool in
                return (repo.name?.contains(search) ?? false)
            }
            
            self?.tableListRepos.removeAll()
            self?.tableListRepos = filteredUsers ?? []
            self?.reloadTable()
        }
    }

}

//MARK: UITableViewDelegate and UITableViewDataSource
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableListRepos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let repoCell = tableView.dequeueReusableCell(withIdentifier: kRepoCellIdentifier, for: indexPath) as? RepoTableCell
        let repo = tableListRepos[indexPath.row]
        repoCell?.configureWith(repo: repo)
        return repoCell ?? UITableViewCell(style: .default, reuseIdentifier: kRepoCellIdentifier)
    }
    
}

//MARK: UITextFieldDelegate
extension ProfileViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        
        if newString == "" {
            tableListRepos.removeAll()
            tableListRepos = allRepos
            reloadTable()
        } else {
            filterWithText(newString)
        }
        return true;
    }
}


