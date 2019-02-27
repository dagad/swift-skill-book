//
//  ProtocolPractice.swift
//  SwiftSkillBook
//
//  Created by dagad on 27/02/2019.
//  Copyright © 2019 dagad. All rights reserved.
//


/**
 Protocol Practice
 https://academy.realm.io/kr/posts/doios-natasha-murashev-protocol-oriented-mvvm/
 */

import Foundation
import UIKit

/**
 UITableViewCell을 설정할 때 생길 수 있는 가장 흔한 안좋은 상황을 MVVM + Protocol을 이용해 해결하는 방법
 */


// 아래와 같이 셀의 각 컨트롤들을 설정하는 메소드가 비대해질 수 있다.
class SwitchWithTextTableViewCell: UITableViewCell {
    func configure(
        title: String,
        titleFont: UIFont,
        titleColor: UIColor,
        switchOn: Bool,
        switchColor: UIColor = .black,
        onSwitchToggleHandler: onSwitchTogglerHandlerType? = nil)
    {
        // Configure views here
    }
}

// 첫번째라 가장 단순한 접근법으로는 프로토콜을 만들어 각 프로퍼티에 설정값에 기본값을 지정해 줄 수 있는 방법이 있다.
protocol SwitchWithTextCellProtocol {
    var title: String { get }
    var titleFont: UIFont { get }
    var titleColor: UIColor { get }

    var switchOn: Bool { get }
    var switchColor: UIColor { get }

    func onSwitchToggleOn(on: Bool)
}

extension SwitchWithTextCellProtocol {
    var switchColor: UIColor {
        return .purpleColor()
    }
}

// 위와 같은 접근법으로는 아래와 같이 간단하게 셀을 설정할 수 있다.
class SwitchWithTextTableViewCell: UITableViewCell {
    func configure(withDelegate delegate: SwitchWithTextCellProtocol)
    {
        // Configure views here
    }
}

// 위와 같은 방법을 사용했을 때 셀의 뷰모델은 아래와 같을 수 있다.
struct MinionModeViewModel: SwitchWithTextCellProtocol {
    var title = "Minion Mode!!!"
    var switchOn = true

    var switchColor: UIColor {
        return .yellowColor()
    }

    func onSwitchToggleOn(on: Bool) {
        if on {
            print("The Minions are here to stay!")
        } else {
            print("The Minions went out to play!")
        }
    }
}

// 애플의 패턴의 착안하여 프로퍼티에 세팅되어야 하는 값을 따로 dataSource로 분리할 수 있다.
protocol SwitchWithTextCellDataSource {
    var title: String { get }
    var switchOn: Bool { get }
    var switchColor: UIColor { get }
    var textColor: UIColor { get }
    var font: UIFont { get }
}

protocol SwitchWithTextCellDelegate {
    func onSwitchToggleOn(on: Bool)
}

// 실제 셀에서는 delegate패턴을 아래와 같이 사용할 수 있다.
class SwitchWithTextTableViewCell: UITableViewCell {
    private var delegate: SwitchWithTextCellDelegate?
    func configure(withDataSource dataSource: SwitchWithTextCellDataSource, delegate: SwitchWithTextCellDelegate?)
    {
        self.delegate = delegate
        // Configure views here
    }
}

struct MinionModeViewModel: SwitchWithTextCellDataSource {
    var title = "Minion Mode!!!"
    var switchOn = true
}

extension MinionModeViewModel: SwitchWithTextCellDelegate {
    var switchColor: UIColor {
        return .yellowColor()
    }

    func onSwitchToggleOn(on: Bool) {
        if on {
            print("The Minions are here to stay!")
        } else {
            print("The Minions went out to play!")
        }
    }
}

// 최종적으로 뷰컨트롤러에서는 아래와 같이 사용할 수 있다.
let viewModel = MinionModeViewModel()
cell.configure(withDataSource: viewModel, delegate: viewModel)
return cell
