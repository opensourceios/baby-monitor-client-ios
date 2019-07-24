//
//  OldOnboardingContinuableViewController.swift
//  Baby Monitor
//

import UIKit
import RxSwift

final class OldOnboardingContinuableViewController: TypedViewController<ImageOnboardingView> {
    
    private let viewModel: OldOnboardingContinuableViewModel
    private let disposeBag = DisposeBag()
    
    init(role: ImageOnboardingView.Role, viewModel: OldOnboardingContinuableViewModel) {
        self.viewModel = viewModel
        super.init(viewMaker: ImageOnboardingView(role: role))
        
        rxSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func rxSetup() {
        customView.nextButtonObservable.subscribe(onNext: { [weak self] _ in
            self?.viewModel.selectNext()
        }).disposed(by: disposeBag)
    }
}