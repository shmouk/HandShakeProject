import UIKit

protocol NavigationBarManagerDelegate: AnyObject {
    func didTapRightButton()
    func didTapAddButton()
}

class NavigationBarManager {
    weak var delegate: NavigationBarManagerDelegate?
    
    func updateNavigationBar(for viewController: UIViewController, isLeftButtonNeeded: Bool, isRightButtonNeeded: Bool = false) {
        guard let navigationController = viewController.navigationController else {
            return
        }
        navigationController.setupNavBarAppearance()
        
        let navigationBar = navigationController.navigationBar
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"), style: .plain, target: self, action: #selector(handleRightButton))
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(handleAddEventsButton))
        
        viewController.navigationItem.leftBarButtonItems = [leftButton]
        viewController.navigationItem.rightBarButtonItem = rightButton
        viewController.navigationItem.title = viewController.title ?? ""
        
        navigationBar.isHidden = false
        viewController.navigationItem.rightBarButtonItem?.isHidden = !isRightButtonNeeded
        viewController.navigationItem.leftBarButtonItems?.first?.isHidden = !isLeftButtonNeeded
    }
    
    @objc func handleRightButton() {
        delegate?.didTapRightButton()
    }
    
    @objc func handleAddEventsButton() {
        delegate?.didTapAddButton()
    }
}

