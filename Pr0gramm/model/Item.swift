//
//  Item.swift
//  Pr0gramm
//
//  Created by TodDurchSterben on 10.04.17.
//  Copyright © 2017 TodDurchSterben. All rights reserved.
//

import SwiftyJSON

class Item {
    
    var audio: Bool
    var created: Date
    var down: Int
    var flags: Int
    var fullsize: String
    var height: Int
    var id: Int
    var image: String
    var mark: Int
    var promoted: Int
    var source: String
    var thumb: String
    var up: Int
    var user: String
    var width: Int
 
    init?(json: JSON) {
        guard let audioInt = json["audio"].int,
            let createdInt = json["created"].int,
            let down = json["down"].int,
            let flags = json["flags"].int,
            let fullsize = json["fullsize"].string,
            let height = json["height"].int,
            let id = json["id"].int,
            let image = json["image"].string,
            let mark = json["mark"].int,
            let promoted = json["promoted"].int,
            let source = json["source"].string,
            let thumb = json["thumb"].string,
            let up = json["up"].int,
            let user = json["user"].string,
            let width = json["width"].int
        else {
            return nil
        }
        
        self.audio = audioInt != 0
        self.created = Date(timeIntervalSince1970: TimeInterval(createdInt))
        self.down = down
        self.flags = flags
        self.fullsize = fullsize
        self.height = height
        self.id = id
        self.image = image
        self.mark = mark
        self.promoted = promoted
        self.source = source
        self.thumb = thumb
        self.up = up
        self.user = user
        self.width = width
    }
    
}

extension Item: Equatable { }

func ==(lhs: Item, rhs: Item) -> Bool {
    return lhs === rhs
}
