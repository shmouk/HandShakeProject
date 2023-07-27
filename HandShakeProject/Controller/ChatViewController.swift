//
//  ChatViewController.swift
//  HandShakeProject
//
//  Created by Марк on 15.07.23.
//

import Foundation
import UIKit

class ChatViewController: UITableViewController {
    
    let cellId = "cellId"
    lazy var usersAPI = UsersAPI()
    
    var refreshCntrl = UIRefreshControl()
    
    init() {
        super.init(style: .plain)
        usersAPI.fetchUser()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAppearanceTableView()
        setupTargets()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatsTableVeiwCell
        let user = usersAPI.users[indexPath.row]
        cell.user = user
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersAPI.users.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        64
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
            navigationController?.pushViewController(chatLogController, animated: true)
        }
    
    private func setAppearanceTableView() {
        tableView.register(ChatsTableVeiwCell.self, forCellReuseIdentifier: cellId)
        tableView.addSubviews(refreshCntrl)
    }
    
    private func setupTargets() {
        refreshCntrl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
}

extension ChatViewController {
    @objc func handleRefresh(_ sender: UIRefreshControl) {
        tableView.reloadData()

        refreshCntrl.endRefreshing()
    }
}



///= ChatLogController (collectionViewLayout: UICollectionViewFlowLayout)

