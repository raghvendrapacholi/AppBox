//
//  AppBoxList.swift
//  AppBox
//
//  Created by Raghvendra on 13/10/19.
//  Copyright © 2019 com.Raghvendra-Pacholi. All rights reserved.
//

import Foundation

class AppBoxList {
    
    static let sharedInstance = AppBoxList()
    
    func configure(_ viewController: HomeViewController) {
        let APIDataManager = AppBoxDataManager()
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        viewController.presenter = presenter
        presenter.interactor = interactor
        interactor.APIDataManager = APIDataManager
        
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
}
