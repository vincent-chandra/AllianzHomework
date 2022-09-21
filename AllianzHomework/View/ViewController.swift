//
//  ViewController.swift
//  AllianzHomework
//
//  Created by Vincent on 19/09/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var stateView: UIView!
    @IBOutlet weak var stateViewLabel: UILabel!
    @IBOutlet weak var stateViewImage: UIImageView!
    
    var presenter: Presenter?
    var arrUser: [UserListItem] = []
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Github Users"
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserTableViewCell")
        
        hideKeyboardWhenTappedAround()
        emptyState()
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.searchBar.endEditing(true)
    }
    
    func tableViewState() {
        tableView.isHidden = false
        stateView.isHidden = true
    }
    
    func emptyState() {
        tableView.isHidden = true
        stateView.isHidden = false
        stateViewLabel.text = "Type to search user"
        stateViewImage.image = UIImage(systemName: "shareplay")
    }
    
    func notFoundState() {
        tableView.isHidden = true
        stateView.isHidden = false
        stateViewLabel.text = "No user found"
        stateViewImage.image = UIImage(systemName: "person.fill.xmark.rtl")
    }
    
    func limitExceedState() {
        tableView.isHidden = true
        stateView.isHidden = false
        stateViewLabel.text = "Search exceeds the limit"
        stateViewImage.image = UIImage(systemName: "xmark.bin.fill")
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUser.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
        cell.userImage.loadImage(fromURL: arrUser[indexPath.row].avatar_url)
        cell.userName.text = arrUser[indexPath.row].login
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row == arrUser.count - 5 && arrUser.count > 10){
            currentPage += 1
            if !searchBar.searchTextField.text!.isEmpty{
                Interactor.shared.getDataUser(query: searchBar.searchTextField.text ?? "", page: currentPage) { data in
                    if let dataUser = data as? UserEntity {
                        DispatchQueue.main.async {
                            self.arrUser.append(contentsOf: dataUser.items)
                            self.tableViewState()
                            self.tableView.reloadData()
                        }
                    } else if let limit = data as? LimitExceed {
                        DispatchQueue.main.async {
                            self.limitExceedState()
                            print(limit.message)
                        }
                    }
                }
            }
        }
    }
}

extension ViewController: UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.text = ""
        emptyState()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        let searchedText = searchBar.searchTextField.text?.replacingOccurrences(of: " ", with: "") ?? ""
        
        if !searchedText.isEmpty {
            Interactor.shared.getDataUser(query: searchedText, page: currentPage) { data in
                if let dataUser = data as? UserEntity {
                    DispatchQueue.main.async {
                        self.arrUser = dataUser.items
                        if self.arrUser.count == 0 {
                            self.notFoundState()
                        } else {
                            self.tableViewState()
                        }
                        self.tableView.reloadData()
                    }
                } else if let limit = data as? LimitExceed {
                    DispatchQueue.main.async {
                        self.limitExceedState()
                        print(limit.message)
                    }
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchedText = searchBar.searchTextField.text?.replacingOccurrences(of: " ", with: "") ?? ""
        
        if !searchedText.isEmpty {
            Interactor.shared.getDataUser(query: searchedText, page: currentPage) { data in
                if let dataUser = data as? UserEntity {
                    DispatchQueue.main.async {
                        self.arrUser = dataUser.items
                        if self.arrUser.count == 0 {
                            self.notFoundState()
                        } else {
                            self.tableViewState()
                        }
                        self.tableView.reloadData()
                    }
                } else if let limit = data as? LimitExceed {
                    DispatchQueue.main.async {
                        self.limitExceedState()
                        print(limit.message)
                    }
                }
            }
        }
    }
}

extension ViewController: PresenterProtocol {
    func didFinishGettingDataFromPresenter(data: Any) {
        if let dataUser = data as? UserEntity {
            self.arrUser = dataUser.items
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.layoutIfNeeded()
            }
        }
    }
}

extension UIImageView {
    func loadImage(fromURL urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        let activityView = UIActivityIndicatorView(style: .large)
        self.addSubview(activityView)
        activityView.frame = self.bounds
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        activityView.startAnimating()
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                activityView.stopAnimating()
                activityView.removeFromSuperview()
            }

            if let data = data, error == nil {
                let image = UIImage(data: data)?.jpegData(compressionQuality: 0.0)
                DispatchQueue.main.async {
                    self.image = UIImage(data: image ?? Data())
                }
            }else{
                return
            }
        }.resume()
    }
}
