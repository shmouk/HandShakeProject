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

