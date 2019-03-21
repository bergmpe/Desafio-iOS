//
//  RepositoryViewController.swift
//  Desafio iOS Williamberg
//
//  Created by berg on 20/03/19.
//  Copyright © 2019 berg. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RepositoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let repositoryCellIdentifier = "repositoryCellIdentifier"
    
    var repositoryUrl: String?
    private let disposeBag = DisposeBag()
    private var repositories = Variable([Repository]())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let _repositoryUrl = repositoryUrl else{
            return
        }
        ViewUtil.showLoading(text: "Loading. . .", parent: self.view)
        Repository.list( repositoryUrl: _repositoryUrl, completion: {
            repositories, errorMessage  in
            DispatchQueue.main.async {
                ViewUtil.hideLoading(parent: self.view)
                if let _errorMessage = errorMessage{
                    ViewUtil.showAlert(title: "ERRO", message: _errorMessage, viewController: self)
                }
                else if let _repositories = repositories{
                    self.repositories.value = _repositories
                }
            }
        })
        
        repositories.asObservable().bind(to: tableView.rx.items){
            tableView, index, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: self.repositoryCellIdentifier) as! RepositoryTableViewCell
            cell.configure(for: item)
            return cell
            }.disposed(by: disposeBag)
        
        self.title = "Repositories"
        
    }

}
