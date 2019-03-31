//
//  ViewController.swift
//  Desafio iOS Williamberg
//
//  Created by berg on 19/03/19.
//  Copyright © 2019 berg. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBarButton: UIBarButtonItem!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBarTopConstraint: NSLayoutConstraint!
    let userCellIdentifier = "userCellId"
    
    let disposeBag = DisposeBag()
    var users = Variable([User]())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ViewUtil.showLoading(text: "Loading. . .", parent: self.view)
        User.list( completion: {
            users, errorMessage  in
            DispatchQueue.main.async {
                ViewUtil.hideLoading(parent: self.view)
                if let _errorMessage = errorMessage{
                    ViewUtil.showAlert(title: "ERRO", message: _errorMessage, viewController: self)
                }
                else if let _users = users{
                    self.users.value = _users
                }
            }
        })
        
        users.asObservable().bind(to: tableView.rx.items(cellIdentifier: userCellIdentifier, cellType: UserTableViewCell.self)){
            row, item, cell in
            cell.configure(for: item)
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(User.self).subscribe(onNext: {
            user in
            self.performSegue(withIdentifier: "detailUserSegue", sender: user)
        }).disposed(by: disposeBag)
        
        
//        tableView.rx.willDisplayCell.subscribe(onNext: {
//            cell, indexPath in
//            if indexPath.section == self.tableView.numberOfSections - 1 &&
//                indexPath.row == self.tableView.numberOfRows(inSection: indexPath.section) - 1{
//                //this is the last cell
//                ViewUtil.showLoading(text: "Loading. . .", parent: self.view)
//                User.list( completion: {
//                    users, errorMessage  in
//                    DispatchQueue.main.async {
//                        ViewUtil.hideLoading(parent: self.view)
//                        if let _errorMessage = errorMessage{
//                            ViewUtil.showAlert(title: "ERROR", message: _errorMessage, viewController: self)
//                        }else if let _users = users{
//                            self.users.value.append(contentsOf: _users)
//                        }
//                    }
//                })
//            }
//        }).disposed(by: disposeBag)
        
        searchBar.showsCancelButton = true
        searchBarButton.rx.tap.bind{
            self.toggleSearchBar()
        }.disposed(by: disposeBag)
        
        searchBar.rx.text
        .throttle( 0.8, scheduler: MainScheduler.instance)
        .subscribe(onNext: {
            text in
            if let searchText = text{
                ViewUtil.showLoading(text: "Searching. . .", parent: self.view)
                if searchText.isEmpty{
                    ViewUtil.hideLoading(parent: self.view)
                }
                else{
                    User.search(userName: searchText.lowercased() , completion: {
                        users, errorMessage in
                        DispatchQueue.main.async {
                            ViewUtil.hideLoading(parent: self.view)
                            if let _errorMessage = errorMessage{
                                ViewUtil.showAlert(title: "ERRO", message: _errorMessage, viewController: self)
                            }
                            else if let _users = users{
                                self.users.value = _users
                            }
                        }
                    })
                }
            }
        }).disposed(by: disposeBag)
        
        searchBar.rx.cancelButtonClicked.bind{
            self.view.endEditing(true)
            self.toggleSearchBar()
        }.disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked.bind{
            self.view.endEditing(true)
            self.toggleSearchBar()
        }.disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let userDetailViewController = segue.destination as? UserDetailViewController, let user = sender as? User else { return }
        userDetailViewController.currentUser = user
    }
    
    func toggleSearchBar(){
        //if the searchBar is visible.
        if searchBarTopConstraint.constant == 0{
            //hides the searchBar
            searchBarTopConstraint.constant = -searchBar.frame.height
        }
        else{
            searchBar.becomeFirstResponder()
            searchBarTopConstraint.constant = 0
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }

}

