//
//  RepositoryTableViewCell.swift
//  Desafio iOS Williamberg
//
//  Created by berg on 20/03/19.
//  Copyright © 2019 berg. All rights reserved.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var watchLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(for repository: Repository){
        nameLabel.text = "Name: \(repository.name ?? "-")"
        starLabel.text = "Star: \(repository.stargazers_count ?? 0)"
        watchLabel.text = "Watchers: \(repository.watchers_count ?? 0)"
        languageLabel.text = "Language: \(repository.language ?? "-")"
    }

}
