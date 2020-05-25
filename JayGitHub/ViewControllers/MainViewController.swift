//
//  MainViewController.swift
//  JayGitHub
//
//  Created by jayanth on 4/21/20.
//  Copyright © 2020 jayanth. All rights reserved.
//

import UIKit

let kProfileCellIdentifier = "UserProfileTableCell"

class MainViewController: UIViewController {

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var allUsers: [User] = []
    var tableListUsers: [User] = []
    let data = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.addTextFieldShadow()
        
        // get users
        data.getAllUsers { [weak self] (users) in
            guard let users = users else {
                return
            }
            self?.allUsers = users
            self?.tableListUsers = users
            self?.reloadTable()
        }
    }

    func reloadTable(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func filterWithText(_ search: String) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            //check substring
            let filteredUsers = self?.allUsers.filter { (user) -> Bool in
                return (user.login?.contains(search) ?? false)
            }
            
            self?.tableListUsers.removeAll()
            self?.tableListUsers = filteredUsers ?? []
            self?.reloadTable()
        }
    }
}

//MARK: UITableViewDelegate and UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableListUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userProfileCell = tableView.dequeueReusableCell(withIdentifier: kProfileCellIdentifier, for: indexPath) as? UserProfileTableCell
        userProfileCell?.configureWith(user: tableListUsers[indexPath.row])
        return userProfileCell ?? UITableViewCell(style: .default, reuseIdentifier: kProfileCellIdentifier)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        newViewController.modalPresentationStyle = .fullScreen

        let user = tableListUsers[indexPath.row]

        newViewController.user = user
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
}

//MARK: UITextFieldDelegate
extension MainViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        
        if newString == "" {
            tableListUsers.removeAll()
            tableListUsers = allUsers
            reloadTable()
        } else {
            filterWithText(newString)
        }
        return true;
    }
}
