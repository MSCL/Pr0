//
//  Upload.swift
//  Pr0gramm
//
//  Created by TodDurchSterben on 31.05.17.
//  Copyright © 2017 TodDurchSterben. All rights reserved.
//

import Alamofire
import SwiftyJSON

protocol UploadDelegate {
    func onUploadFinished(success: Bool, buttonsOn: [UIButton], buttonsOff: [UIButton])
}

class Upload {
    
    static fileprivate func vote(delegate: UploadDelegate, url: String, id: Int, vote: Int, nonce: String, buttonsOn: [UIButton], buttonsOff: [UIButton]) {
        let parameters: Parameters = [
            "id": id,
            "vote": vote,
            "_nonce": nonce
        ]
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { response in
            var success = false
            switch response.result {
            case .success(_):
                success = true
            case .failure(let error):
                Notification.showErrorMessage(withError: error)
            }
            delegate.onUploadFinished(success: success, buttonsOn: buttonsOn, buttonsOff: buttonsOff)
        }
    }
    
    static func voteItem(delegate: UploadDelegate, id: Int, vote: Int, nonce: String, buttonsOn: [UIButton], buttonsOff: [UIButton]) {
        self.vote(delegate: delegate, url: Constants.URLVoteItem, id: id, vote: vote, nonce: nonce, buttonsOn: buttonsOn, buttonsOff: buttonsOff)
    }
    
    static func voteTag(delegate: UploadDelegate, id: Int, vote: Int, nonce: String, buttonsOn: [UIButton], buttonsOff: [UIButton]) {
        self.vote(delegate: delegate, url: Constants.URLVoteTag, id: id, vote: vote, nonce: nonce, buttonsOn: buttonsOn, buttonsOff: buttonsOff)
    }
    
}
