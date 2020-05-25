//
//  UIViewExtension.swift
//  JayGitHub
//
//  Created by jayanth on 4/21/20.
//  Copyright © 2020 jayanth. All rights reserved.
//

import UIKit

extension UIView {
    func addTextFieldShadow() {
        let shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.height), cornerRadius: 13)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.15
        self.layer.shadowPath = shadowPath.cgPath
        self.layer.cornerRadius = 13
    }
}
