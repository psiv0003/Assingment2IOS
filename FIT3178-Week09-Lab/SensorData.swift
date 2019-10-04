//
//  SensorData.swift
//  FIT3178-Week09-Lab
//
//  Created by Poornima Sivakumar on 1/10/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase

struct SensorData : Codable {
   
    //private var dateFormatter: DateFormatter

    let red : Double
    let blue : Double
    let green : Double
    let tempData : Double
    let time: Timestamp
   
    
  

}

//references: https://github.com/alickbass/CodableFirebase
extension Timestamp: TimestampType {}
