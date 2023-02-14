//
//  Extensions.swift
//  MyRecipesSwiftUI
//
//  Created by Serhii Krotkykh on 21.02.2023.
//
import UIKit

extension String {
    func height(for width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: [.usesLineFragmentOrigin, .usesFontLeading],
                                            attributes: [NSAttributedString.Key.font: font],
                                            context: nil)
        return boundingBox.height
    }
}

extension UIImage {
    func height(for width: CGFloat) -> CGFloat {
        let size = self.size
        return size.height * width / size.width
    }
}
