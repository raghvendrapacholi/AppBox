//
//  HomeInteractor.swift
//  AppBox
//
//  Created by Raghvendra on 13/10/19.
//  Copyright © 2019 com.Raghvendra-Pacholi. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol HomeInteractorInput: class {
    func fetchAppsListFromDataManager()
}

protocol HomeInteractorOutput: class{
    func didFetchAppsList(appsList : [HomeAppModel])
}
class HomeInteractor: HomeInteractorInput {
    
    var APIDataManager: AppBoxDataManagerProtocol!
    var appList : [HomeAppModel] = []
    var presenter: HomeInteractorOutput!
    
    
    func fetchAppsListFromDataManager(){
        
        if ReachabilityTest.isConnectedToNetwork(){
            APIDataManager.fetchAppData(){ (error, HomeAppModels) in
                if HomeAppModels != nil {
                    self.appList = HomeAppModels!
                    self.presenter?.didFetchAppsList(appsList: HomeAppModels!)
                    DispatchQueue.main.async {
                    self.checkAppDataExists()
                    }
                } else if let error = error {
                    print(error)
                }
            }}else{
            DispatchQueue.main.async {
                let homeAppModelArray = self.fetchAppDataFromLocaldDatabase()
                self.presenter?.didFetchAppsList(appsList: homeAppModelArray)
            }
        }
    }
    
    func saveAppDataToLocalDatabase(title: String, thumbImageUrl:NSURL){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "AppData", in: context)
        
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        
        newUser.setValue(title, forKey: "title")
        newUser.setValue(thumbImageUrl, forKey: "thumbImageUrl")
        
        DispatchQueue.main.async {
            do {
                try context.save()
                
            } catch {
                
                print("error executing save request: \(error)")
            }
        }
        
        
    }
    
    func fetchAppDataFromLocaldDatabase() -> [HomeAppModel] {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AppData")
        
        request.returnsObjectsAsFaults = false
        
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let title = data.value(forKey: "title") as! String
                let thumbImageUrl = data.value(forKey: "thumbImageUrl") as! NSURL
                appList.append(HomeAppModel(title: title, thumbImageUrl: thumbImageUrl))
            }
            
        } catch {
            
            print("error executing fetch request: \(error)")
        }
        
        return appList
    }
    
    func checkAppDataExists() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AppData")
        
        for index in 0..<appList.count{
            fetchRequest.predicate = NSPredicate(format: "title = %@", appList[index].title)
            var results: [NSManagedObject] = []
            

                do {
                    results = try context.fetch(fetchRequest)
                }
                catch {
                    print("error executing fetch request: \(error)")
                }
            
            
            if results.count == 0{
                saveAppDataToLocalDatabase(title: appList[index].title,thumbImageUrl: appList[index].thumbImageUrl)
            }
        }
    }
    
}
