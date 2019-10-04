//
//  ImageViewController.swift
//  FIT3178-Week09-Lab
//
//  Created by Poornima Sivakumar on 22/9/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import Firebase
import CodableFirebase

class ImageViewController: UIViewController,UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
  //https://stackoverflow.com/questions/37488343/create-an-array-of-uicolor-in-swift
    var uiColorArray = [UIColor]()
    @IBOutlet weak var tempBtnTxt: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var stickerBtn: UIButton!
    var db: Firestore!
    var temp: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var authController:  Auth
        authController = Auth.auth()
        authController.signInAnonymously() { (authResult, error) in
            guard authResult != nil else {
                fatalError("Firebase authentication failed")
            }
    
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
            self.db = Firestore.firestore()
          
           
            }
        self.uiColorArray.append(UIColor.blue)
        self.uiColorArray.append(UIColor.black)
        self.uiColorArray.append(UIColor.brown)
        self.uiColorArray.append(UIColor.red)
        self.uiColorArray.append(UIColor.yellow)
        self.uiColorArray.append(UIColor.cyan)
        self.uiColorArray.append(UIColor.darkGray)
        self.uiColorArray.append(UIColor.green)
        self.uiColorArray.append(UIColor.magenta)
        self.uiColorArray.append(UIColor.orange)
        self.uiColorArray.append(UIColor.purple)
        self.uiColorArray.append(UIColor.white)

    }
    

    
  
    //https://www.hackingwithswift.com/example-code/media/uiimagewritetosavedphotosalbum-how-to-write-to-the-ios-photo-album
    //https://stackoverflow.com/questions/31582222/how-to-take-screenshot-of-a-uiview-in-swift
    @IBAction func save(_ sender: Any) {
        //saving the image to photo gallery
        updateBtn.isHidden = true
        UIGraphicsBeginImageContextWithOptions(mainView.bounds.size, false, UIScreen.main.scale)
        view.drawHierarchy(in: CGRect(origin: .zero, size: mainView.bounds.size), afterScreenUpdates: true)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(screenshot!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        updateBtn.isHidden = false

    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
  
    @IBAction func tempButton(_ sender: UIButton) {
        //chainging the color of the temp text on click
        var selectedColor = uiColorArray.randomElement()
        tempBtnTxt.setTitleColor(selectedColor, for: UIControl.State.normal)
        
    }
    @IBAction func update(_ sender: Any) {
        //updating the image with the data from the firestore db
        
        //showing the sticker btn only after the firebase data is updated
        stickerBtn.isHidden = false
        
        let citiesRef = db.collection("PieData")
        let data = citiesRef.order(by: "time", descending: true).limit(to: 1)
        data.getDocuments { (document, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
               
                for document in document!.documents {
                    do {
                       
                        let sData = try FirestoreDecoder().decode(SensorData.self, from: document.data())
                        print(sData.tempData)
                        if(sData.tempData >= 15){
                            self.temp = "h"
                        }else if(sData.tempData < 15){
                            self.temp = "c"
                        }
                        print(sData.red)
                        let red = round(sData.red)
                        let blue = round(sData.blue)
                        let green = round(sData.green)
                        //setting an overlay from the color sensors
                        let overlay: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.imageView.frame.size.width, height: self.imageView.frame.size.height))
                        overlay.backgroundColor = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 0.2)
                        self.imageView.addSubview(overlay)
                       //setting temp
                        self.tempBtnTxt.setTitle("\(sData.tempData) C", for: UIControl.State.normal)
                    } catch let error {
                        print(error)
                    }
                   
                }
            
        }
        }
        
    }
    
   
    @IBAction func addSticker(_ sender: UIButton) {
        //generating a random image based on the temp
        let randomInt = Int.random(in: 1..<6)
        let imageName = temp+"\(randomInt)"
        let image2 = UIImage(named: imageName)
        (sender as AnyObject).setImage(image2, for: UIControl.State.normal)

    }
    
    @IBAction func photoSelect(_ sender: Any) {
        let controller = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            controller.sourceType = .camera
        } else {
            controller.sourceType = .photoLibrary
        }
        
        controller.allowsEditing = false
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
        
    }
 

    

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            imageView.image = pickedImage
           
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        displayMessage("There was an error in getting the image", "Error")
    }
    
    func displayMessage(_ message: String,_ title: String) {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,
                                                handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }


}

