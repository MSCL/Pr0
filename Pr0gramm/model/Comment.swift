//
//  Comment.swift
//  Pr0gramm
//
//  Created by TodDurchSterben on 11.04.17.
//  Copyright © 2017 TodDurchSterben. All rights reserved.
//

import SwiftyJSON

class Comment {
    
    var id: Int
    var parent: Int
    var content: String
    var created: Date
    var up: Int
    var down: Int
    var confidence: Double
    var name: String
    var mark: Int
    var children: [Comment]
    var depth: Int
    
    init?(json: JSON) {
        guard let id = json["id"].int,
            let parent = json["parent"].int,
            let content = json["content"].string,
            let createdInt = json["created"].int,
            let up = json["up"].int,
            let down = json["down"].int,
            let confidence = json["confidence"].double,
            let name = json["name"].string,
            let mark = json["mark"].int
        else {
            return nil
        }
        
        self.id = id
        self.parent = parent
        self.content = content
        self.created = Date(timeIntervalSince1970: TimeInterval(createdInt))
        self.up = up
        self.down = down
        self.confidence = confidence
        self.name = name
        self.mark = mark
        self.children = []
        self.depth = 0
    }
    
}
