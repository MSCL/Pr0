//
//  Constants.swift
//  Pr0gramm
//
//  Created by TodDurchSterben on 10.04.17.
//  Copyright © 2017 TodDurchSterben. All rights reserved.
//

class Constants {
    
    static let URLProtocol = "https://"
    static let URLDomain = "pr0gramm.com"

    // Download
    static let URLGetItems = URLProtocol + URLDomain + "/api/items/get?flags=%d&promoted=%d"
    static let URLGetSearchItems = URLProtocol + URLDomain + "/api/items/get?flags=%d&promoted=%d&tags=%@"
    static let URLGetItemsOlder = URLProtocol + URLDomain + "/api/items/get?&flags=%d&promoted=%d&older=%d"
    static let URLGetSearchItemsOlder = URLProtocol + URLDomain + "/api/items/get?&flags=%d&promoted=%d&older=%d&tags=%@"
    static let URLThumb = URLProtocol + "thumb." + URLDomain + "/%@"
    static let URLItemInfo = URLProtocol + URLDomain + "/api/items/info?itemId=%d"
    static let URLImage = URLProtocol + "img." + URLDomain + "/%@"
    static let URLImageFullsize = URLProtocol + "full." + URLDomain + "/%@"
    static let URLGif = URLProtocol + "img." + URLDomain + "/%@"
    static let URLVideo = URLProtocol + "vid." + URLDomain + "/%@"
    
    // Login
    static let URLLogin = URLProtocol + URLDomain + "/api/user/login"
    
    // Upload
    static let URLVoteItem = URLProtocol + URLDomain + "/api/items/vote"
    static let URLVoteTag = URLProtocol + URLDomain + "/api/tags/vote"
    
    // UserDefaults
    static let nonce = "nonce"
    
}
