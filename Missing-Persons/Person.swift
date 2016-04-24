//
//  Person.swift
//  Missing-Persons
//
//  Created by Miwand Najafe on 2016-04-23.
//  Copyright © 2016 Miwand Najafe. All rights reserved.
//

import UIKit
import ProjectOxfordFace

class Person {
    var faceId:String?
    var personImg:UIImage?
    var personImgURL:String?
    
    
    init(personImgURL:String) {
        self.personImgURL = personImgURL
    }
    
    func downloadFaceId() {
        if let img = personImg,
            imgData = UIImageJPEGRepresentation(img, 0.8) {
            FaceService.instance.client.detectWithData(imgData, returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: nil, completionBlock: { (faces: [MPOFace]!, error: NSError!) in
                if error == nil {
                    var faceId:String?
                    for face in faces {
                        faceId = face.faceId
                        print("FaceId: \(faceId)")
                        break
                    }
                    self.faceId = faceId
                }
            })
        }
    }
}
