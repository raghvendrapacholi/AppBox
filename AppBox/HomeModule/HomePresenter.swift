//
//  HomePresenter.swift
//  AppBox
//
//  Created by Raghvendra on 13/10/19.
//  Copyright © 2019 com.Raghvendra-Pacholi. All rights reserved.
//

import Foundation

protocol HomePresenterInput: HomeViewControllerOutput,HomeInteractorOutput {
    
}

class HomePresenter: HomePresenterInput {
    
    var interactor: HomeInteractorInput!
    var viewController : HomeViewControllerInput!

    func fetchAppsList(){
        interactor.fetchAppsListFromDataManager()
    }
    
    func didFetchAppsList(appsList : [HomeAppModel]){     
        viewController.receivedAppList(appsList : appsList)
    }
}

