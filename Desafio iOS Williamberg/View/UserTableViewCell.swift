//
//  UserTableViewCell.swift
//  Desafio iOS Williamberg
//
//  Created by berg on 19/03/19.
//  Copyright © 2019 berg. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.contentMode = .scaleAspectFit
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    func configure(for user: User){
        loginLabel.text = user.login
        userImageView.image = UIImage(named: "userPlaceholder")
        user.getImageData(completion: {
            imageData in
            if let _imageData = imageData{
                DispatchQueue.main.async {
                    self.userImageView.image = UIImage(data: _imageData)
                }
            }
        })
    }

}
