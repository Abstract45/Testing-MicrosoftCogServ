//
//  ViewController.swift
//  Missing-Persons
//
//  Created by Miwand Najafe on 2016-04-23.
//  Copyright © 2016 Miwand Najafe. All rights reserved.
//

import UIKit
import ProjectOxfordFace

let baseUrl = "http://localhost:6069/img/"
class ViewController: UIViewController {
    
    @IBOutlet weak var imgSelected:UIImageView!
    @IBOutlet weak var collection:UICollectionView!
    let imgPicker = UIImagePickerController()
    var selectedPerson: Person?
    var hasSelectedImage = false
    
    let missingPeople =
    [
            Person(personImgURL: "person1.jpg"),
            Person(personImgURL: "person2.jpg"),
            Person(personImgURL: "person3.jpg"),
            Person(personImgURL: "person4.jpg"),
            Person(personImgURL: "person5.jpg"),
            Person(personImgURL: "person6.png")
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.dataSource = self
        collection.delegate = self
        imgPicker.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(loadPicker(_:)))
        tap.numberOfTapsRequired = 1
        imgSelected.addGestureRecognizer(tap)
    }
    
    func loadPicker(gesture:UIGestureRecognizer) {
        imgPicker.allowsEditing = true
        imgPicker.sourceType = .PhotoLibrary
        presentViewController(imgPicker, animated: true, completion: nil)
    }
    
    func showErrorAlert() {
        let alertControl = UIAlertController(title: "Select a Person", message: "Please select a missing Person and an image from your album", preferredStyle: .Alert)
        let okAction = UIAlertAction (title: "OK", style: .Cancel, handler: nil)
        alertControl.addAction(okAction)
        self.presentViewController(alertControl, animated: true, completion: nil)
    }
    
    @IBAction func checkForMatch(sender:UIButton) {
        if selectedPerson == nil || !hasSelectedImage {
            showErrorAlert()
        } else {
            if let myImg = imgSelected.image,
            let imgData = UIImageJPEGRepresentation(myImg, 0.8) {
                FaceService.instance.client.detectWithData(imgData, returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: nil, completionBlock: { (faces:[MPOFace]!, error:NSError!) in
                    var faceId:String?
                    for face in faces {
                        faceId = face.faceId
                        break
                    }
                    if faceId != nil {
                        
                        
                        FaceService.instance.client.verifyWithFirstFaceId(self.selectedPerson!.faceId, faceId2: faceId, completionBlock: { (result:MPOVerifyResult!, error:NSError!) in
                            
                            if error == nil {
                            print(result.confidence)
                            print(result.isIdentical)
                            print(result.debugDescription)
                            } else {
                                print(error.debugDescription)
                            }
                        })
                    }
                    
                })
                
            }
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.selectedPerson = missingPeople[indexPath.row]
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PersonCell
        cell.setSelected()
        
    }
    
}
extension ViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! PersonCell
        let person = missingPeople[indexPath.row]
        cell.configCell(person)
        return cell
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return missingPeople.count
    }
}
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imgSelected.image = image
        dismissViewControllerAnimated(true, completion: nil)
        if imgSelected.image != nil {
            hasSelectedImage = true
        }
    }
}