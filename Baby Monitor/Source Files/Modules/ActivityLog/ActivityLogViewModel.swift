//
//  ActivityLogViewModel.swift
//  Baby Monitor
//


import UIKit

protocol ActivityLogViewModelCoordinatorDelegate: class {
    
    /// This function informs coordinator about selecting show babies view action
    func didSelectShowBabies()
}

final class ActivityLogViewModel: BabyMonitorGeneralViewModelProtocol, BabyMonitorHeaderCellConfigurable, BabiesViewShowable {
    
    weak var coordinatorDelegate: ActivityLogViewModelCoordinatorDelegate?
    
    var numberOfSections: Int {
        return 1
    }
    
    func selectShowBabies() {
        coordinatorDelegate?.didSelectShowBabies()
    }
    
    func configure(cell: BabyMonitorCell, for indexPath: IndexPath) {
        cell.type = .activityLog
        //TODO: mock for now, ticket: https://netguru.atlassian.net/browse/BM-67
        cell.update(image: UIImage())
        cell.update(mainText: "Franuś was crying!")
        cell.update(secondaryText: "24 minutes ago")
    }
    
    func configure(headerCell: BabyMonitorCell, for section: Int) {
        headerCell.configureAsHeader()
        headerCell.update(mainText: "Yesterday")
    }
    
    func numberOfRows(for section: Int) -> Int {
        return 5 //TODO: mock for now, ticket: https://netguru.atlassian.net/browse/BM-67
    }
}