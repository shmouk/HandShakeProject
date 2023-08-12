import UIKit

var greeting = "Hello, playground"



class Message: NSObject {
    var fromId: String
    var toId: String
    var name: String
    var timeStamp: Int
    var text: String
    var image: UIImage?
    
    init(fromId: String = "", toId: String = "", name: String = "", timeStamp: Int = 0, text: String = "", image: UIImage? = nil) {
        self.fromId = fromId
        self.toId = toId
        self.name = name
        self.timeStamp = timeStamp
        self.text = text
        self.image = image
    }
}

let messages = [Message(fromId: "111", toId: "222"),
                Message(fromId: "222", toId: "111"),
                Message(fromId: "222", toId: "333"),
                Message(fromId: "111", toId: "333"),
                Message(fromId: "333", toId: "111"),
                Message(fromId: "222", toId: "333"),
                Message(fromId: "333", toId: "111")]

let currentUserId = "333"
let partnerUserId = "222"
var resMessages = [Message]()

var messagesDict = [String: [Message]]()

    DispatchQueue.global().async {
        let filteredMessages = messages.filter { message in
            return (message.fromId == currentUserId && message.toId == partnerUserId) || (message.fromId == partnerUserId && message.toId == currentUserId)
}
        DispatchQueue.main.async {
               resMessages = filteredMessages
               messagesDict[partnerUserId] = filteredMessages
               print("Number of messages in resMessages: \(resMessages.count)")
               print("Number of messages in messagesDict: \(messagesDict.count)")
           }
       }

class ViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private let sectionTitles = ["Section 1", "Section 2"]
    private let section1Data = ["Item 1", "Item 2", "Item 3"]
    private let section2Data = ["Item A", "Item B", "Item C"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return section1Data.count
        } else {
            return section2Data.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if indexPath.section == 0 {
            cell.textLabel?.text = section1Data[indexPath.row]
        } else {
            cell.textLabel?.text = section2Data[indexPath.row]
        }
        
        return cell
    }
}
