//
//  UIView + Extension.swift
//  HandShakeProject
//
//  Created by Марк on 14.07.23.
//

import UIKit

typealias UserCompletion = (Result<(UIImage, String), Error>) -> Void
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
}

extension Int {
    func convertTimestampToDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        let date = Date(timeIntervalSince1970: TimeInterval(self) ?? 0)
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
    static func colorForStroke() -> UIColor {
        return #colorLiteral(red: 0.8117647059, green: 0.8549019608, blue: 0.9254901961, alpha: 1)
    }
    static func colorForButton() -> UIColor {
        return #colorLiteral(red: 0.6117647059, green: 0.7254901961, blue: 0.8196078431, alpha: 1)
    }
    static func colorForView() -> UIColor {
        return #colorLiteral(red: 0.8823529412, green: 0.9019607843, blue: 0.937254902, alpha: 1)
    }
    static func colorForTitleText() -> UIColor {
        return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    static func colorForDescriptionText() -> UIColor {
        return #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    }
}
// button  9CB9D1 tint CFDAEC view e1e6ef
