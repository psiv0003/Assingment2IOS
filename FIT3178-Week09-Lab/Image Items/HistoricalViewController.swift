//
//  HistoricalViewController.swift
//  FIT3178-Week09-Lab
//
//  Created by Poornima Sivakumar on 3/10/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit

class HistoricalViewController: UIViewController,UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    var sensorObject: SensorData?
    var uiColorArray = [UIColor]()
    @IBOutlet weak var tempText: UIButton!
     var temp: String!
    @IBOutlet weak var upadteBtnTxt: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var stickerBtnTxt: UIButton!
    @IBOutlet weak var tempTxt: UIButton!
    
    @IBOutlet weak var mainView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
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


    @IBAction func savePhoto(_ sender: Any) {
        upadteBtnTxt.isHidden = true
        UIGraphicsBeginImageContextWithOptions(mainView.bounds.size, false, UIScreen.main.scale)
        view.drawHierarchy(in: CGRect(origin: .zero, size: mainView.bounds.size), afterScreenUpdates: true)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(screenshot!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        upadteBtnTxt.isHidden = false
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
    
    @IBAction func selectPhoto(_ sender: Any) {
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
    
    @IBAction func updateTempColor(_ sender: Any) {
        var selectedColor = uiColorArray.randomElement()
        tempTxt.setTitleColor(selectedColor, for: UIControl.State.normal)
    }
    
    @IBAction func updatePhoto(_ sender: Any) {
        stickerBtnTxt.isHidden = false
        
        let red = round(sensorObject!.red)
        let blue = round(sensorObject!.blue)
        let green = round(sensorObject!.green)
        let overlay: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.imageView.frame.size.width, height: self.imageView.frame.size.height))
        overlay.backgroundColor = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 0.2)
        self.imageView.addSubview(overlay)
        
        self.tempTxt.setTitle("\(sensorObject!.tempData) C", for: UIControl.State.normal)
        if(sensorObject!.tempData >= 15){
            self.temp = "h"
        }else if(sensorObject!.tempData < 15){
            self.temp = "c"
        }
 
    }
    
    
    @IBAction func updateSticker(_ sender: Any) {
        let randomInt = Int.random(in: 1..<6)
        let imageName = temp+"\(randomInt)"
        let image2 = UIImage(named: imageName)
        (sender as AnyObject).setImage(image2, for: UIControl.State.normal)
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
