//
//  FaceService.swift
//  Missing-Persons
//
//  Created by Miwand Najafe on 2016-04-23.
//  Copyright © 2016 Miwand Najafe. All rights reserved.
//

import Foundation
import ProjectOxfordFace

class FaceService {
    static let instance = FaceService()
    
    let client = MPOFaceServiceClient(subscriptionKey: "be2c767f2a1a4725903658d4809425f1")
    
}
