import UIKit

typealias UserCompletion = (Result<User, Error>) -> Void
typealias UserInfoCompletion = (Result<(UIImage, String), Error>) -> Void
typealias MessagesCompletion = (Result<[Message], Error>) -> Void
typealias MessageCompletion = (Result<Message, Error>) -> Void
typealias ResultCompletion = (Result<String, Error>) -> Void
typealias VoidCompletion = (Result<Void, Error>) -> Void

extension UILabel {
    func calculateSize() -> CGSize {
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font: self.font]
        let textRect = self.text?.boundingRect(with: maxSize, options: options, attributes: attributes, context: nil)
        
        return textRect?.size ?? CGSize.zero
    }
}

extension Int {
    func convertTimestampToDate(timeStyle: DateFormatter.Style = .short) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = timeStyle
        if timeStyle == .medium {
            dateFormatter.dateFormat = "dd MMM yyyy"
        }
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        return dateFormatter.string(from: date)

    }
}

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            self.addSubview($0)
        }
    }
}

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach {
            self.addArrangedSubview($0)
        }
    }
}

extension UIColor {
    static func getColorFromDeadlineState(_ index: Int) -> UIColor {
        switch index {
        case 0:
            return #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        case 1:
            return #colorLiteral(red: 0.5023933686, green: 0.9254901961, blue: 0.4543034453, alpha: 1)
        case 2:
            return #colorLiteral(red: 0.9254901961, green: 0.6084639762, blue: 0, alpha: 1)
        case 3:
            return #colorLiteral(red: 0.9254901961, green: 0.2064778552, blue: 0.234777142, alpha: 1)
        default:
            return . white
        }
    }
    static func colorForStroke() -> UIColor {
        return #colorLiteral(red: 0.8117647059, green: 0.8549019608, blue: 0.9254901961, alpha: 1)
    }
    static func colorForButton() -> UIColor {
        return #colorLiteral(red: 0.6117647059, green: 0.7254901961, blue: 0.8196078431, alpha: 1)
    }
    static func colorForView() -> UIColor {
        return #colorLiteral(red: 0.8823529412, green: 0.9019607843, blue: 0.937254902, alpha: 1)
    }
    static func colorForSubview() -> UIColor {
        return #colorLiteral(red: 0.8274509804, green: 0.8431372549, blue: 0.8823529412, alpha: 1)
    }
    static func colorForTitleText() -> UIColor {
        return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    static func colorForDescriptionText() -> UIColor {
        return #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    }
}

extension UIViewController {

    private static var loadingViewKey: UInt8 = 0
    
    func showLoadingView() {
        
        guard let _ = objc_getAssociatedObject(self, &UIViewController.loadingViewKey) as? LoadingView else {
            let loadingView = LoadingView(frame: view.bounds)
            view.addSubview(loadingView)
            
            objc_setAssociatedObject(self, &UIViewController.loadingViewKey, loadingView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            return
        }
    }
    
    func hideLoadingView() {
        if let loadingView = objc_getAssociatedObject(self, &UIViewController.loadingViewKey) as? LoadingView {
            loadingView.removeFromSuperview()
            
            objc_setAssociatedObject(self, &UIViewController.loadingViewKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension UIViewController {
    func customTableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let totalRows = tableView.numberOfRows(inSection: indexPath.section)
        var orientation: UIRectCorner = []
        
        if indexPath.row == 0 {
            orientation = [.topLeft, .topRight]
        }
        if indexPath.row == totalRows - 1 {
            orientation = [.bottomLeft, .bottomRight]
        }
        if totalRows == 1 {
            orientation = [.allCorners]
        }
        RoundedCellDecorator.roundCorners(orientation: orientation, for: cell, cornerRadius: 10.0)
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}





