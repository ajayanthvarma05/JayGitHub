//
//  User.swift
//  JayGitHub
//
//  Created by jayanth on 4/21/20.
//  Copyright © 2020 jayanth. All rights reserved.
//

import Foundation

struct User:Codable {
    let login: String?
    let email: String?
    let name: String?
    let location: String?
    let followers: Int?
    let following: Int?
    let bio: String?
    let createdAt: String?
    let avatarUrl: String?
    let publicRepos: Int?
    
    func joinDate() -> String {
        guard let createdAt = createdAt else {
            return ""
        }
        
        return createdAt.displayableDateFrom(date: createdAt)
    }
}
 
struct Repo:Codable {
    let name: String?
    let stargazersCount: Int?
    let forks: Int?
}
