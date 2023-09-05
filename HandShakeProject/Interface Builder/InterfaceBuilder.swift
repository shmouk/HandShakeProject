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


class InterfaceBuilder {
    
    func createNavBar() -> UINavigationBar {
        let navBar = UINavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.barTintColor = .white
        navBar.tintColor = .colorForTitleText()
        navBar.backgroundColor = .white
        navBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        navBar.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        return navBar
    }
    
    func createView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .colorForView()
        view.layer.cornerRadius = 10
       return view
    }
    
    func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .colorForView()
        collectionView.isScrollEnabled = true
        collectionView.isPrefetchingEnabled = false
        collectionView.isSkeletonable = true
        return collectionView
    }
    
    func createTableView() -> UITableView {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .colorForView()
        tableView.isSkeletonable = true
        return tableView
    }
    
    func createSegmentControl(items: [Any]?) -> UISegmentedControl {
        let viewSC = UISegmentedControl(items: items)
        viewSC.backgroundColor = .colorForView()
        viewSC.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], for: .normal)
        viewSC.selectedSegmentIndex = 0
        viewSC.translatesAutoresizingMaskIntoConstraints = false
        viewSC.layer.cornerRadius = 10
        viewSC.layer.masksToBounds = true
        return viewSC
    }
    
    func createTextField() -> UITextField {
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
    
    func createImageView() -> RoundImageView {
        let imageView = RoundImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.isSkeletonable = true
        return imageView
    }
    
    func createTitleLabel() -> UILabel {
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
    
    func createDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .colorForDescriptionText()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .left
        label.isSkeletonable = true
        return label
    }
    
    func createButton() -> UIButton {
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
    
    func createTextView() -> UITextView {
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
    
    func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }

    func createDatePicker() -> UIDatePicker {
        let datePicker =  UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date()
    
        return datePicker
    }
}
