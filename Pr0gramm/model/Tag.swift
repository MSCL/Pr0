//
//  Tag.swift
//  Pr0gramm
//
//  Created by TodDurchSterben on 11.04.17.
//  Copyright © 2017 TodDurchSterben. All rights reserved.
//

import SwiftyJSON

class Tag {
    
    var id: Int
    var confidence: Double
    var tag: String
    
    init?(json: JSON) {
        guard let id = json["id"].int,
            let confidence = json["confidence"].double,
            let tag = json["tag"].string
        else {
            return nil
        }
        
        self.id = id
        self.confidence = confidence
        self.tag = tag
        
    }
    
}
