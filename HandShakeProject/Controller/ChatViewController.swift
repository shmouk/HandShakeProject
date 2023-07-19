//
//  ChatViewController.swift
//  HandShakeProject
//
//  Created by Марк on 15.07.23.
//

import UIKit

class ChatViewController: UITableViewController {
    
    let cellId = "cellId"
    var friends: [Template] = [Template]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createFriendsArray()
        setAppearanceTableView()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatsTableVeiwCell
        let currentLastItem = friends[indexPath.row]
        cell.friend = currentLastItem
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        64
    }
    private func setAppearanceTableView() {
        tableView.register(ChatsTableVeiwCell.self, forCellReuseIdentifier: cellId)
        tableView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
    }

    private func createFriendsArray() {
        friends.append(Template(image: UIImage(named: "juventus.png"), nameLabel: "kostya"))
        friends.append(Template(image: UIImage(named: "juventus.png"), nameLabel: "anna"))
    }
}
