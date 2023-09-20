//
//  BaseViewController.swift
//  Movies
//
//  Created by Владислав Баранкевич on 20.09.2023.
//

import UIKit
import Combine

class BaseViewController<VM: ViewModel>: UIViewController {
    // MARK: - Properties
    private let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
    var viewModel: VM
    var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    init(viewModel: VM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIView lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onViewDidLoad()

        viewModel.isLoadingPublisher
            .sink { [weak self] isLoading in
                isLoading ? self?.showLoadingView() : self?.hideLoadingView()
            }
            .store(in: &cancellables)

        viewModel.errorPublisher
            .sink { [weak self] error in
                guard let self = self else {
                    return
                }
                notificationFeedbackGenerator.prepare()
                notificationFeedbackGenerator.notificationOccurred(.error)
                self.presentAlert(title: Localization.error,
                                  message: error.localizedDescription,
                                  actionTitle: Localization.ok)
            }
            .store(in: &cancellables)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.onViewWillAppear()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.onViewDidAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.onViewWillDisappear()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.onViewDidDisappear()
    }

    // MARK: - Public methods
    func showLoadingView() {
        let windowView = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        if let loadingView = windowView?.viewWithTag(LoadingView.tagValue) as? LoadingView {
            loadingView.isLoading = true
        } else {
            let loadingView = LoadingView(frame: UIScreen.main.bounds)
            windowView?.addSubview(loadingView)
            loadingView.isLoading = true
        }
    }

    func hideLoadingView() {
        let windowView = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        windowView?.viewWithTag(LoadingView.tagValue)?.removeFromSuperview()
    }

    // MARK: - Deinit
    deinit {
        debugPrint("deinit of ", String(describing: self))
    }
}

// MARK: - Private extension
private extension BaseViewController {
    func presentAlert(title: String, message: String, actionTitle: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: actionTitle, style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
}

// MARK: - Constants
private enum Constants {
    static let largeFontSize: CGFloat = 30
    static let regularFontSize: CGFloat = 17
}

