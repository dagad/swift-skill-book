import Foundation
import UIKit

/**
 - 12월 13일
 - Using errors as control flow in Swift
 */

func tint(_ baseImage: UIImage, with: UIColor) -> UIImage? {
    return nil
}

func resize(_ sourceImage: UIImage, to: CGSize) -> UIImage? {
    return nil
}

/*
 아래와 같이 이미지를 번들에서 가져오는 함수가 있다고 가정해보자.
 나쁘지 않은 코드지만, 결과적으로는 런타임 에러가 발생할 가능성이 있는
 nil을 리턴하게 된다. 그리고 optional type을 리턴하게 되서 unwrapping을 call side에서
 또 해야되는 문제가 있다. 게다가 nil이 리턴되게 되면 어떤 상황에 의한 것인지 직관적으로 유추하기 어렵다.
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

// 위와 같은 이슈는 아래와 같이 개선이 가능하다.

enum ImageError: Error {
    case missing
    case failedToTint
    case failedToResize
    case failedToCreateContext
    case failedToRenderImage
    //...
}

// 각 내부 함수들은 처리하는 기능에 맞는 에러를 리턴하도록 처리하고

func tint2(_ baseImage: UIImage, with color: UIColor) throws -> UIImage {
    let tintImage = tint(baseImage, with: color)
    guard let image = tintImage else {
        throw ImageError.failedToTint
    }

    return image
}

func resize2(_ sourceImage: UIImage, to size: CGSize) throws-> UIImage {
    let resizeImage = resize(sourceImage, to: size)
    guard let image = resizeImage else {
        throw ImageError.failedToResize
    }

    return image
}

private func loadImage(named name: String) throws -> UIImage {
    guard let image = UIImage(named: name) else {
        throw ImageError.missing
    }

    return image
}

// 각 내부 함수들을 감싸고 있는 함수에서는 이런식으로 처리를 해주게 되면 어떤 기능에 대한 에러가 발생했는지 유추하기 쉽다.
func loadImage(named name: String, tintedWith color: UIColor, resizedTo size: CGSize) throws -> UIImage {
    var image = try loadImage(named: name)
    image = try tint2(image, with: color)
    return try resize2(image, to: size)
}

// 호출하는 쪽에서는 error를 처리하는 방법들 중 상황에 맞는 방법을 선택해서 구현할 수 있다.

let optionalImage = try? loadImage(
    named: "Decoration",
    tintedWith: .black,
    resizedTo: CGSize(width: 10, height: 10))


func callSide() {
    do {
        let newImage: UIImage
        newImage = try loadImage(named: "Decoration",
                                 tintedWith: .black,
                                 resizedTo: CGSize(width: 10, height: 10))
    } catch ImageError.failedToResize {
        print("Failed To Resize")
    } catch {
        print("\(error)")
    }
}


//let optionalIma1ge = try? loadImage(
//    named: "Decoration",
//    tintedWith: .brandColor,
//    resizedTo: decorationSize
//)
