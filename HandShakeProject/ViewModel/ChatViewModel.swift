//
//  ChatViewModel.swift
//  HandShakeProject
//
//  Created by Марк on 29.07.23.
//

import Foundation
import UIKit

class ChatViewModel {
    
    var nameText = Bindable("")
    var messageText = Bindable("")
    var profileImage = Bindable(UIImage())
    lazy var chatAPI = ChatAPI()
    
    func setViews() {

    }
}
