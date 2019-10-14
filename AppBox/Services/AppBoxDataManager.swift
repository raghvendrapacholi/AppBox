//
//  AppBoxDataManager.swift
//  AppBox
//
//  Created by Raghvendra on 13/10/19.
//  Copyright © 2019 com.Raghvendra-Pacholi. All rights reserved.
//

import Foundation

protocol AppBoxDataManagerProtocol: class {
    func fetchAppData(closure: @escaping(NSError?, [HomeAppModel]?) -> Void) -> Void
}

class AppBoxDataManager: AppBoxDataManagerProtocol{
    
    
    func fetchAppData(closure: @escaping(NSError?, [HomeAppModel]?) -> Void) -> Void{
        let myUrl = URL(string: "https://itunes.apple.com/us/rss/newfreeapplications/limit=2/json")!
        let request = URLRequest(url: myUrl)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                print("Error fetching photos: \(String(describing: error))")
                closure(error as NSError?, nil)
            }
            do{
                let resultsDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : AnyObject] ?? [:]
                guard let feedDictionary = resultsDictionary["feed"] as? NSDictionary else {return}
                guard let AppsListArray = feedDictionary["entry"] as? [NSDictionary] else {return}
                
                let AppsList: [HomeAppModel] = AppsListArray.map({ (AppsListDictionary) -> HomeAppModel in
                    let appNameDictionary = AppsListDictionary["im:name"] as? NSDictionary ?? [:]
                    let appName = appNameDictionary["label"] as? String ?? ""
                    let appImageDictionaryArray = AppsListDictionary["im:image"] as? [NSDictionary] ?? []
                    let appImageObject = appImageDictionaryArray[2]
                    let appImage = appImageObject["label"] as? String ?? ""
                    
                    let homeAppModel = HomeAppModel(title: appName, thumbImageUrl: NSURL(string: appImage)!)
                    
                    return homeAppModel
                    
                })
                
                closure(nil, AppsList)
                
                
            } catch let error as NSError {
                print("Error parsing JSON: \(error)")
                closure(error, nil)
                return
            }
            
        }
        task.resume()
    }
}
