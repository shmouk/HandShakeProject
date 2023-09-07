import UIKit
import SkeletonView

class RoundImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }
}

class RoundedCellDecorator {
    static func roundCorners(orientation: UIRectCorner = [.allCorners], for cell: UITableViewCell, cornerRadius: CGFloat) {
        var maskPath = UIBezierPath()
        
        maskPath = UIBezierPath(roundedRect: cell.bounds,
                                byRoundingCorners: orientation,
                                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        
        cell.layer.mask = maskLayer
    }
}


final class InterfaceBuilder {
    
    static func createNavBar() -> UINavigationBar {
        let navBar = UINavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.barTintColor = .white
        navBar.tintColor = .colorForTitleText()
        navBar.backgroundColor = .white
        navBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        navBar.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        return navBar
    }
    
    static func createView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .colorForView()
        view.layer.cornerRadius = 10
        return view
    }
    
    static func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        //        collectionView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        collectionView.backgroundColor = .colorForView()
        collectionView.isScrollEnabled = true
        collectionView.isPrefetchingEnabled = false
        collectionView.isSkeletonable = true
        return collectionView
    }
    
    static func createTableView() -> UITableView {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .colorForView()
        tableView.isSkeletonable = true
        return tableView
    }
    
    static func createSegmentControl(items: [Any]?) -> UISegmentedControl {
        let viewSC = UISegmentedControl(items: items)
        viewSC.backgroundColor = .colorForView()
        viewSC.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], for: .normal)
        viewSC.selectedSegmentIndex = 0
        viewSC.translatesAutoresizingMaskIntoConstraints = false
        viewSC.layer.cornerRadius = 10
        viewSC.layer.masksToBounds = true
        return viewSC
    }
    
    static func createTextField() -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.layer.borderColor = UIColor.colorForStroke().cgColor
        textField.borderStyle = .line
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        
        let leftPaddingView = UIView(frame: CGRect(x: 8, y: 0, width: 10, height: 40))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        
        return textField
    }
    
    static func createImageView() -> RoundImageView {
        let imageView = RoundImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.isSkeletonable = true
        return imageView
    }
    
    static func createTitleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .colorForTitleText()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        label.isSkeletonable = true
        return label
    }
    
    static func createDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .colorForDescriptionText()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.isSkeletonable = true
        return label
    }
    
    static func createButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .colorForButton()
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowRadius = 10
        button.tintColor = .colorForTitleText()
        button.setTitleColor(.colorForTitleText(), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.isSkeletonable = true
        return button
    }
    
    static func createTextView() -> UITextView {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .white
        textView.textColor = .black
        textView.layer.cornerRadius = 10
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textAlignment = .left
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        textView.text = "Input text"
        textView.isScrollEnabled = false
        textView.isEditable = false
        //        textView.textContainer.lineBreakMode = .byWordWrapping
        return textView
    }
    
    static func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }
    
    static func createDatePicker() -> UIDatePicker {
        let datePicker =  UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date()
        return datePicker
    }
    
    static func createProgressView() -> UIProgressView {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progress = 0.0
        progressView.progressTintColor = .colorForTitleText()
        return progressView
    }
    
    static func createBlurView() -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: .systemChromeMaterialLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        return blurView
    }
}
