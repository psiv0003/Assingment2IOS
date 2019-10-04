//
//  HistoryDataTableViewController.swift
//  FIT3178-Week09-Lab
//
//  Created by Poornima Sivakumar on 2/10/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import Firebase
import CodableFirebase


var tempList: [SensorData] = []
class HistoryDataTableViewController: UITableViewController {

    let CELL_LOCATION = "dataCell"
    var dataList: [SensorData] = []
    
    var db: Firestore!
    
    override func viewDidLoad() {

        //Firebase auth
        var authController:  Auth
        authController = Auth.auth()
        authController.signInAnonymously() { (authResult, error) in
            guard authResult != nil else {
                fatalError("Firebase authentication failed")
            }
            
            let settings = FirestoreSettings()
            Firestore.firestore().settings = settings
            self.db = Firestore.firestore()
            super.viewDidLoad()

    }
    }


    
    func loadData(){
        //getting data from firebase and ordering it by time
        //references: https://codelabs.developers.google.com/codelabs/firebase-cloud-firestore-workshop-swift/index.html?index=..%2F..index#3
        let basicQuery = Firestore.firestore().collection("PieData").order(by: "time", descending: true)
        basicQuery.getDocuments { (snapshot, error) in
            if let error = error {
                print("Oh no! Got an error! \(error.localizedDescription)")
                return
            }
            guard let snapshot = snapshot else { return }
            let allDocuments = snapshot.documents
            for sensortDoc in allDocuments {
                
                do {
                    
                    //decoding the json and storing it in a sensor object format
                    let sData = try FirestoreDecoder().decode(SensorData.self, from: sensortDoc.data())
                    self.dataList.append(sData)
                } catch let error {
                    print(error)
                }
                
            }
          
            tempList = self.dataList
            self.tableView.reloadData()

        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dataList.removeAll()
      //tableView.reloadData()
       loadData()
    }

    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return tempList.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "cellSegue", sender: tempList[indexPath.row])
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = tableView.dequeueReusableCell(withIdentifier: CELL_LOCATION, for: indexPath) as! HistoryTableViewCell
        
        
       let loc = tempList[indexPath.row]
        
        cellData.tempReading.text = "\(loc.tempData)"
        //formatting the time
        var time  = Date(timeIntervalSince1970: TimeInterval(loc.time.seconds))
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy HH:mm"


        var fTime = dateFormatterPrint.string(from: time)
        cellData.time.text = "\(fTime)"
        var temp: String
        if (loc.tempData > 15){
            temp = "h"
        }else {
            temp = "c"
        }
        
        let randomInt = Int.random(in: 1..<6)
        let imageName = temp+"\(randomInt)"
        
        cellData.tImage.image = UIImage(named: imageName)
        
        cellData.backgroundColor = UIColor(red: CGFloat(loc.red/255), green: CGFloat(loc.green/255), blue: CGFloat(loc.blue/255), alpha: 1)

       
        
        return cellData
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "cellSegue",
            let destination = segue.destination as? HistoricalViewController
            //let blogIndex = tableView.indexPathForSelectedRow?.row
        {
            let sensor = sender as! SensorData

            destination.sensorObject = sensor
        }
    }

}
