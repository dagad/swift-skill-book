//
//  NavigationInSwift.swift
//  SwiftSkillBook
//
//  Created by dagad on 02/01/2019.
//  Copyright © 2019 dagad. All rights reserved.
//

/**
 - 1월 2일
 - Navigtaion in Swift

 
 */

//import UIKit
//
//class ImageDetailViewController: UIViewController {
//    init(image: UIImage) {
//
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//class ImageListViewController: UITableViewController {
//
//    var images: [UIImage] = []
//
//    override func tableView(_ tableView: UITableView,
//                            didSelectRowAt indexPath: IndexPath) {
//        let image = images[indexPath.row]
//        let detailVC = ImageDetailViewController(image: image)
//        navigationController?.pushViewController(detailVC, animated: true)
//    }
//}
//
//
//protocol OnboardingViewControllerDelegate: AnyObject {
//    func onboardingViewControllerNextButtonTapped(
//        _ viewController: OnboardingViewController
//    )
//}
//
//class OnboardingViewController: UIViewController {
//    weak var delegate: OnboardingViewControllerDelegate?
//
//    private func handleNextButtonTap() {
//        delegate?.onboardingViewControllerNextButtonTapped(self)
//    }
//}
//
//
//class OnboardingCoordinator: OnboardingViewControllerDelegate {
//    weak var delegate: OnboardingCoordinatorDelegate?
//
//    private let navigationController: UINavigationController
//    private var nextPageIndex = 0
//
//    // MARK: - Initializer
//
//    init(navigationController: UINavigationController) {
//        self.navigationController = navigationController
//    }
//
//    // MARK: - API
//
//    func activate() {
//        goToNextPageOrFinish()
//    }
//
//    // MARK: - OnboardingViewControllerDelegate
//
//    func onboardingViewControllerNextButtonTapped(
//        _ viewController: OnboardingViewController) {
//        goToNextPageOrFinish()
//    }
//
//    // MARK: - Private
//
//    private func goToNextPageOrFinish() {
//        // We use an enum to store all content for a given onboarding page
//        guard let page = OnboardingPage(rawValue: nextPageIndex) else {
//            delegate?.onboardingCoordinatorDidFinish(self)
//            return
//        }
//
//        let nextVC = OnboardingViewController(page: page)
//        nextVC.delegate = self
//        navigationController.pushViewController(nextVC, animated: true)
//
//        nextPageIndex += 1
//    }
//}
//
//
//protocol Navigator {
//    associatedtype Destination
//
//    func navigate(to destination: Destination)
//}
//
//class LoginNavigator: Navigator {
//    // Here we define a set of supported destinations using an
//    // enum, and we can also use associated values to add support
//    // for passing arguments from one screen to another.
//    enum Destination {
//        case loginCompleted(user: User)
//        case forgotPassword
//        case signup
//    }
//
//    // In most cases it's totally safe to make this a strong
//    // reference, but in some situations it could end up
//    // causing a retain cycle, so better be safe than sorry :)
//    private weak var navigationController: UINavigationController?
//
//    // MARK: - Initializer
//
//    init(navigationController: UINavigationController) {
//        self.navigationController = navigationController
//    }
//
//    // MARK: - Navigator
//
//    func navigate(to destination: Destination) {
//        let viewController = makeViewController(for: destination)
//        navigationController?.pushViewController(viewController, animated: true)
//    }
//
//    // MARK: - Private
//
//    private func makeViewController(for destination: Destination) -> UIViewController {
//        switch destination {
//        case .loginCompleted(let user):
//            return WelcomeViewController(user: user)
//        case .forgotPassword:
//            return PasswordResetViewController()
//        case .signup:
//            return SignUpViewController()
//        }
//    }
//}
//
//class LoginViewController: UIViewController {
//    private let navigator: LoginNavigator
//
//    init(navigator: LoginNavigator) {
//        self.navigator = navigator
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    private func handleLoginButtonTap() {
//        performLogin { [weak self] result in
//            switch result {
//            case .success(let user):
//                self?.navigator.navigate(to: .loginCompleted(user: user))
//            case .failure(let error):
//                self?.show(error)
//            }
//        }
//    }
//
//    private func handleForgotPasswordButtonTap() {
//        navigator.navigate(to: .forgotPassword)
//    }
//
//    private func handleSignUpButtonTap() {
//        navigator.navigate(to: .signup)
//    }
//}
//
//class LoginNavigator: Navigator {
//    private weak var navigationController: UINavigationController?
//    private let viewControllerFactory: LoginViewControllerFactory
//
//    init(navigationController: UINavigationController,
//         viewControllerFactory: LoginViewControllerFactory) {
//        self.navigationController = navigationController
//        self.viewControllerFactory = viewControllerFactory
//    }
//
//    func navigate(to destination: Destination) {
//        let viewController = makeViewController(for: destination)
//        navigationController?.pushViewController(viewController, animated: true)
//    }
//
//    private func makeViewController(for destination: Destination) -> UIViewController {
//        switch destination {
//        case .loginCompleted(let user):
//            return viewControllerFactory.makeWelcomeViewController(forUser: user)
//        case .forgotPassword:
//            return viewControllerFactory.makePasswordResetViewController()
//        case .signup:
//            return viewControllerFactory.makeSignUpViewController()
//        }
//    }
//}
