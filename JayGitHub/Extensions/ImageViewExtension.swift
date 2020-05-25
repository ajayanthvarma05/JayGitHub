//
//  ImageViewExtension.swift
//  JayGitHub
//
//  Created by jayanth on 4/21/20.
//  Copyright © 2020 jayanth. All rights reserved.
//

import UIKit

extension UIImageView {
    func loadImage(withUrl url: URL? = nil, userID: String) {
        DispatchQueue.global().async { [weak self] in
            if let data = UserDefaults.standard.value(forKeyPath: userID) as? Data {
                //load from cache if exists
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async { [weak self] in
                        self?.image = image
                    }
                }
            } else {
                guard let url = url else { return }

                do {
                    //download image
                    let imageData = try? Data(contentsOf: url)
                    guard let imgData = imageData else {
                        return
                    }
                    UserDefaults.standard.setValue(imageData, forKeyPath: userID)
                    UserDefaults.standard.synchronize()
                    if let image = UIImage(data: imgData) {
                        DispatchQueue.main.async {
                            self?.image = image
                        }
                    }
                } catch  {
                    print("cannot load image from url")
                }
            }
        }
    }
}
