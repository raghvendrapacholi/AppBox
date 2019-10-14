//
//  HomeViewController.swift
//  AppBox
//
//  Created by Raghvendra on 13/10/19.
//  Copyright © 2019 com.Raghvendra-Pacholi. All rights reserved.
//

import UIKit
import SDWebImage

protocol HomeViewControllerOutput: class {
    func fetchAppsList()
}

protocol HomeViewControllerInput: class {
    func receivedAppList(appsList : [HomeAppModel])
}

var vSpinner : UIView?

class HomeViewController: UIViewController,HomeViewControllerInput {
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    var presenter: HomeViewControllerOutput!
    
    
    var appList: [HomeAppModel] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        AppBoxList.sharedInstance.configure(self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAppList()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    func getAppList(){
        self.showActivityIndicator(onView: self.view)
        presenter.fetchAppsList()
    }
    
    func receivedAppList(appsList : [HomeAppModel]) {
        self.appList = appsList
        DispatchQueue.main.async {
            self.homeCollectionView.reloadData()
            self.removeSpinner()
        }
        
    }
    
    
}

extension UIViewController {
    func showActivityIndicator(onView : UIView) {
        let activityIndicatorView = UIView.init(frame: onView.bounds)
        activityIndicatorView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = activityIndicatorView.center
        
        DispatchQueue.main.async {
            activityIndicatorView.addSubview(ai)
            onView.addSubview(activityIndicatorView)
        }
        
        vSpinner = activityIndicatorView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}

extension HomeViewController: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return AppItemCell(collectionView, cellForItemAt: indexPath as NSIndexPath)
        
    }
    
    func AppItemCell(_ collectionView: UICollectionView, cellForItemAt indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AppCell", for: indexPath as IndexPath) as! AppCollectionViewCell
        
        cell.appImage.sd_setImage(with: appList[indexPath.row].thumbImageUrl as URL, completed: nil)
        cell.appImage.layer.borderColor = UIColor.lightGray.cgColor
        cell.appImage.layer.borderWidth = 1
        cell.appName.text = appList[indexPath.row].title
        return cell
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var itemSize: CGSize
        let length = (UIScreen.main.bounds.width) / 3 - 1
        itemSize = CGSize(width: length, height: 180)
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
}
