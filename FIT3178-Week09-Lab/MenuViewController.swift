//
//  MenuViewController.swift
//  FIT3178-Week09-Lab
//
//  Created by Poornima Sivakumar on 3/10/19.
//  Copyright © 2019 Monash University. All rights reserved.
//


//ICONS

//https://icons8.com/icon/12023/new
//https://icons8.com/icon/set/past/ios
import UIKit

class MenuViewController: UIViewController {

    var pastGrad: CAGradientLayer!
    var latest: CAGradientLayer!


    @IBOutlet weak var pastData: UIView!
    @IBOutlet weak var currentUpdates: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // createGradientLayer()
        addShadow()
    }

  
    //references: https://www.appcoda.com/cagradientlayer/
    func createGradientLayer() {
        pastGrad = CAGradientLayer()
        pastGrad.frame = self.pastData.bounds
        pastGrad.colors = [UIColor.blue.cgColor, UIColor.white.cgColor]
        self.pastData.layer.addSublayer(pastGrad)
        
        latest = CAGradientLayer()
        latest.frame = self.currentUpdates.bounds
        latest.colors = [UIColor.blue.cgColor, UIColor.white.cgColor]
        self.currentUpdates.layer.addSublayer(latest)
    }
    
    //references: https://stackoverflow.com/questions/51095450/how-to-apply-card-view-cornerradius-shadow-like-ios-appstore-in-swift-4
    func addShadow(){
        
        pastData.layer.cornerRadius = 20.0
        pastData.layer.shadowColor = UIColor.gray.cgColor
        pastData.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        pastData.layer.shadowRadius = 12.0
        pastData.layer.shadowOpacity = 0.7
        
        currentUpdates.layer.cornerRadius = 20.0
        currentUpdates.layer.shadowColor = UIColor.gray.cgColor
        currentUpdates.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        currentUpdates.layer.shadowRadius = 12.0
        currentUpdates.layer.shadowOpacity = 0.7
    }
    

}
