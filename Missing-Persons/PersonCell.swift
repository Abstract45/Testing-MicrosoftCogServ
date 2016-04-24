//
//  PersonCell.swift
//  Missing-Persons
//
//  Created by Miwand Najafe on 2016-04-23.
//  Copyright © 2016 Miwand Najafe. All rights reserved.
//

import UIKit

class PersonCell: UICollectionViewCell {
    
    @IBOutlet weak var personImg: UIImageView!
    var person: Person!
    
    func setSelected() {
        personImg.layer.borderWidth = 2.0
        personImg.layer.borderColor = UIColor.whiteColor().CGColor
        
        self.person.downloadFaceId()
    }
    
    func deSelected() {
        personImg.layer.borderWidth = 0
    }
    
    func configCell(person:Person) {
        self.person = person
        if let url = NSURL(string: baseUrl + person.personImgURL!) {
            downloadImage(url)
        } else {
            print("error: url is bad")
        }
    }
    
    func downloadImage(url:NSURL) {
        getDataFromURL(url) { (data, response, error) in
            dispatch_async(dispatch_get_main_queue(), {
               guard let data = data where error == nil else {return}
                self.personImg.image = UIImage(data: data)
                self.person.personImg = self.personImg.image
            })
        }
    }
    
    func getDataFromURL(url:NSURL, completion:(data:NSData?, response:NSURLResponse?, error:NSError?)-> ()) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
        }.resume()
    }
}
