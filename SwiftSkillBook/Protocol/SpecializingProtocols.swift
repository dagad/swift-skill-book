//
//  SpecializingProtocols.swift
//  SwiftSkillBook
//
//  Created by dagad on 19/12/2018.
//  Copyright © 2018 dagad. All rights reserved.
//


/**
 - 12월 19일
 - Specializing Protocols in Swift

 프로토콜은 스위프트의 핵심 부분을 차지하고 있다. 그럴수밖에 없는 것이 언어 자체가 프로토콜 지향 방식으로 설계되어 있고,
 표준 라이브러리가 POP 방식으로 설계되어 있다. 그렇기에 스위프트의 새로운 기능이 나올 때마다 프로토콜과 관련되어 있다는 것은 놀라운 일이 아니다.
 */


//Inheritance

/*
 아래와 같은 프로토콜의 상속을 통해 공유해야될 프로퍼티나 메소드에 대해서는 중복코드 작성을 피할 수 있다.
 */

import UIKit

protocol User {
    var id: UUID { get }
    var name: String { get }
}

extension AnonymousUser: User {}
extension Member: User {}
extension Admin: User {}

/*
 추가적으로 만약 AnonymousUser는 모르게 Member, Admin 에만 추가 기능을 넣고 싶다면 어떻게 해야할까?
 */

protocol AuthenticatedUser: User {
    var accessToken: AccessToken { get }
}

extension Member: AuthenticatedUser {}
extension Admin: AuthenticatedUser {}


/*
 위와 같이 한다면 AnonymousUser는 모르게 원하는 기능을 구분지을 수 있다.
 그리고 아래와 같이 사용할 수 있다.
 */

class DataLoader {
    func load(from endpoint: ProtectedEndpoint,
              onBehalfOf user: AuthenticatedUser,
              then: @escaping (Result<Data>) -> Void) {
        // Since 'AuthenticatedUser' inherits from 'User', we
        // get full access to all properties from both protocols.
        let request = makeRequest(for: endpoint,
        userID: user.id,
        accessToken: user.accessToken)

        ...
    }
}

//Specialization

/*
 아래와 같은 Component 프로토콜이 있다고 가정해보자.
 */
protocol Component {
    associatedtype Container
    func add(to container: Container)
}

/*
 Component프로토콜의 Container타입을 UIView로 제약하고, UIView인 경우에만 추가적인 기능을 추가하고자 할때는
 where를 사용해 제약할 수 있다.
 */

protocol ViewComponent: Component where Container: UIView {
    associatedtype View: UIView
    var view: View { get }
}

extension ViewComponent {
    func add(to container: Container) {
        container.addSubview(view)
    }
}

// 위와 같은 protocol 은 아래와 같이 사용할 수 있다.

class myView: UIView {

}

// protocol에서 선언한 associated type은 구현부에서 typealias로 정의해주어야 한다.
extension myView: ViewComponent {
    typealias View = UIView
    typealias Container = UIView

    var view: UIView {
        return UIView()
    }
}

//Composition

/*
 아래와 같은 Protocol을 정의했다고 가정해보자.
 그리고 만약 Operation에 있는 기능 중 일부분만 구현해서 사용하고 싶은 경우가 있는 경우에는 어떻게 해야 할까?
 */
protocol Operation {
    associatedtype Input
    associatedtype Output

    func prepare()
    func cancel()
    func perform(with input: Input,
                 then handler: @escaping (Output) -> Void)
}

// 해답은 애플의 표준 라이브러리에서 영감을 받을 수 있다
typealias Codable = Decodable & Encodable


// Operation의 각 기능을 분리해 독립된 3개의 프로토콜로 분리한다.
protocol Preparable {
    func prepare()
}

protocol Cancellable {
    func cancel()
}

protocol Performable {
    associatedtype Input
    associatedtype Output

    func perform(with input: Input,
                 then handler: @escaping (Output) -> Void)
}

// 그리고 표준 라이브러리와 동일하게 3개로 나뉘어진 프로토콜을 합쳐 기존 프로토콜을 사용하는 부분에서 그대로 사용할 수 있게 할 수 있다.
typealias Operation = Preparable & Cancellable & Performable

// 그리고 나뉘어진 각 3개의 프로토콜을 원하는 곳에서 사용할 수 있다.
extension Sequence where Element == Cancellable {
    func cancelAll() {
        forEach { $0.cancel() }
    }
}
