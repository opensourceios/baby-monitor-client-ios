//
//  ServerCoordinator.swift
//  Baby Monitor
//

import Foundation

final class ServerCoordinator: Coordinator {
    init(_ navigationController: UINavigationController, appDependencies: AppDependencies) {
        self.navigationController = navigationController
        self.appDependencies = appDependencies
        setupParentSettingsCoordinator()
    }
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var appDependencies: AppDependencies
    var onEnding: (() -> Void)?
    
    private weak var parentSettingsCoordinator: SettingsCoordinator?
    private var isAudioServiceErrorAlreadyShown = false
    
    func start() {
        showServerView()
    }
    
    private func showServerView() {
        let viewModel = ServerViewModel(serverService: appDependencies.serverService)
        let serverViewController = ServerViewController(viewModel: viewModel)
        viewModel.onAudioRecordServiceError = { [unowned self] in
            guard !self.isAudioServiceErrorAlreadyShown else {
                return
            }
            self.isAudioServiceErrorAlreadyShown = true
            let message = Localizable.Server.audioRecordError
            AlertPresenter.showDefaultAlert(title: nil, message: message, onViewController: serverViewController)
        }
        viewModel.settingsTap?.subscribe(onNext: { [unowned self] in
            self.parentSettingsCoordinator?.start()
        })
        .disposed(by: viewModel.bag)
        self.navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.pushViewController(serverViewController, animated: true)
    }
    
    private func setupParentSettingsCoordinator() {
        let parentSettingsCoordinator = SettingsCoordinator(navigationController, appDependencies: appDependencies)
        childCoordinators.append(parentSettingsCoordinator)
        parentSettingsCoordinator.onEnding = { [unowned self] in
            switch UserDefaults.appMode {
            case .none:
                self.onEnding?()
            case .baby:
                if let coordinator = self.parentSettingsCoordinator {
                    self.remove(coordinator)
                }
                self.setupParentSettingsCoordinator()
            case .parent:
                break
            }
        }
        self.parentSettingsCoordinator = parentSettingsCoordinator
    }
}
