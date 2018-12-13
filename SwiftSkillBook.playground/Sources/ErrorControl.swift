import Foundation
import UIKit

/**
 - 12월 13일
 -


 */

func loadImage(named name: String,
               tintedWith color: UIColor,
               resizedTo size: CGSize) -> UIImage? {
    guard let baseImage = UIImage(named: name) else {
        return nil
    }

    guard let tintedImage = tint(baseImage, with: color) else {
        return nil
    }

    return resize(tintedImage, to: size)
}

func tint(_ baseImage: UIImage, with: UIColor) -> UIImage? {
    return nil
}

func
