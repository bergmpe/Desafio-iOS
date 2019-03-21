//
//  UserDetailViewController.swift
//  Desafio iOS Williamberg
//
//  Created by berg on 19/03/19.
//  Copyright © 2019 berg. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UserDetailViewController: UIViewController {

    @IBOutlet weak var currentUserImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var biografyTextView: UITextView!
    @IBOutlet weak var followersLabels: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    
    var userLogin: String?
    var currentUser: User?
    
    //private let disposeBag = DisposeBag()
    //private var user = Variable<User?>(nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissViewController))
        rightSwipeGesture.direction = .right
        self.view.addGestureRecognizer(rightSwipeGesture)
        
        if let userImageData = currentUser?.imageData{
            currentUserImageView.image = UIImage(data: userImageData)
        }
        else{
            currentUser?.getImageData(completion: {
                userImageData in
                if let _userImageData = userImageData{
                    DispatchQueue.main.async {
                        self.currentUserImageView.image = UIImage(data: _userImageData)
                    }
                }
            })
        }
        
        guard let userLogin = currentUser?.login else { return }
        User.getDetail(userLogin: userLogin, completion: {
            _user in
            DispatchQueue.main.async {            
                self.nameLabel.text = "Name: \(_user?.name ?? "-")"
                self.companyLabel.text = "Company: \(_user?.company ?? "-")"
                self.locationLabel.text = "Location: \(_user?.location ?? "-")"
                self.biografyTextView.text = _user?.company ?? ""
                self.followersLabels.text = "Followers: \(_user?.followers ?? 0)"
                self.followingLabel.text = "Following: \(_user?.following ?? 0 )"
            }
        })
        
        biografyTextView.layer.borderColor = UIColor.lightGray.cgColor
        biografyTextView.layer.borderWidth = 1
        biografyTextView.clipsToBounds = true
        biografyTextView.layer.cornerRadius = 10
    }
    

    @IBAction func listAllRepositoriesAction(_ sender: Any) {
        self.performSegue(withIdentifier: "repositorySegue", sender: currentUser)
    }
    
    @objc func dismissViewController(){
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let repositoryViewController = segue.destination as? RepositoryViewController, let user = sender as? User else { return }
        repositoryViewController.repositoryUrl = user.repos_url
    }

}
