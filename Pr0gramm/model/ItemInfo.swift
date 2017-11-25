//
//  ItemInfo.swift
//  Pr0gramm
//
//  Created by TodDurchSterben on 11.04.17.
//  Copyright © 2017 TodDurchSterben. All rights reserved.
//

import SwiftyJSON

class ItemInfo {
    
    var tags: [Tag]
    var comments: [Comment]
    var ts: Int
    var cache: String
    var rt: Int
    var qc: Int
    
    init?(json: JSON) {
        guard let ts = json["ts"].int,
            let cache = json["cache"].string,
            let rt = json["rt"].int,
            let qc = json["qc"].int
            else {
                return nil
        }
        var tags = [Tag]()
        for (_, subJson):(String, JSON) in json["tags"] {
            tags.append(Tag(json: subJson)!)
        }
        tags.sort(by: {$0.confidence > $1.confidence})
        var comments = [Comment]()
        for (_, subJson):(String, JSON) in json["comments"] {
            comments.append(Comment(json: subJson)!)
        }
        comments.sort(by: {$0.confidence > $1.confidence})
        
        func flatOrder(comments: [Comment], depth: Int, flatOrderedComments: inout [Comment]) {
            for comment in comments {
                comment.depth = depth
                flatOrderedComments.append(comment)
                flatOrder(comments: comment.children, depth: depth + 1, flatOrderedComments: &flatOrderedComments)
            }
        }
        
        func insertInComments(comment: Comment, comments: inout [Comment]) -> Bool {
            for i in 0..<comments.count {
                if (comments[i].id == comment.parent) {
                    comments[i].children.append(comment)
                    return true
                } else if (insertInComments(comment: comment, comments: &comments[i].children)) {
                    return true
                }
            }
            return false
        }
        
        func orderComments(comments: [Comment]) -> [Comment] {
            var comments = comments
            var orderedComments: [Comment] = []
            for comment in comments {
                if (comment.parent == 0) {
                    orderedComments.append(comment)
                }
            }
            while comments.count != 0 {
                for i in 0..<comments.count {
                    if (comments[i].parent == 0) {
                        comments.remove(at: i)
                        break
                    } else {
                        if (insertInComments(comment: comments[i], comments: &orderedComments)) {
                            comments.remove(at: i)
                            break
                        }
                    }
                }
            }
            var flatOrderedComments: [Comment] = []
            flatOrder(comments: orderedComments, depth: 0, flatOrderedComments: &flatOrderedComments)
            return flatOrderedComments
        }
        
        self.tags = tags
        self.comments = orderComments(comments: comments)
        self.ts = ts
        self.cache = cache
        self.rt = rt
        self.qc = qc
    }
    
}
