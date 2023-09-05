//
//  UIView + Extension.swift
//  HandShakeProject
//
//  Created by Марк on 14.07.23.
//

import UIKit

typealias UserCompletion = (Result<User, Error>) -> Void
typealias UserInfoCompletion = (Result<(UIImage, String), Error>) -> Void
typealias MessagesCompletion = (Result<[Message], Error>) -> Void
typealias MessageCompletion = (Result<Message, Error>) -> Void
typealias ResultCompletion = (Result<String, Error>) -> Void
typealias VoidCompletion = (Result<Void, Error>) -> Void

extension String {
    func size(constrainedToWidth width: CGFloat) -> CGSize {
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        let rect = self.boundingRect(with: maxSize, options: options, attributes: attributes, context: nil)
        return CGSize(width: ceil(rect.width), height: ceil(rect.height))
    }
    
    func calculateLabelSize(for text: String?, font: UIFont = .systemFont(ofSize: 16), maxSize: CGSize) -> CGSize {
        guard let text = text else { return CGSize() }
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let maxSize = CGSize(width: maxSize.width, height: CGFloat.greatestFiniteMagnitude)
        let boundingRect = text.boundingRect(with: maxSize,
                                             options: options,
                                             attributes: attributes,
                                             context: nil)
        
        return CGSize(width: ceil(boundingRect.width), height: ceil(boundingRect.height))
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
    func calculateCellHeight(withText text: String, cellWidth: CGFloat) -> CGSize {
        let twoThirdsScreenWidth = cellWidth * 2 / 3
        var size = text.size(constrainedToWidth: twoThirdsScreenWidth)

        if size.width > twoThirdsScreenWidth {
            size.width = twoThirdsScreenWidth
            return size
        } else {
            return size
//            return UIFont.systemFont(ofSize: 16).lineHeight
        }
    }
    
    func calculateWidth(textView: UITextView) -> CGSize {
        let twoThirdsScreenWidth = (2/3) * frame.width
        guard let text = textView.text else { return .zero }
        if text.size(constrainedToWidth: twoThirdsScreenWidth).width > twoThirdsScreenWidth {
            textView.textContainer.size = CGSize(width: twoThirdsScreenWidth, height: CGFloat.greatestFiniteMagnitude)
             return textView.contentSize
        }
        return CGSize(width: twoThirdsScreenWidth, height: CGFloat.greatestFiniteMagnitude)
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
// button  9CB9D1 tint CFDAEC view e1e6ef
