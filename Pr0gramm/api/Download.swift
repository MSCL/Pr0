//
//  Download.swift
//  Pr0gramm
//
//  Created by TodDurchSterben on 10.04.17.
//  Copyright © 2017 TodDurchSterben. All rights reserved.
//

import Alamofire
import SwiftyJSON

protocol DownloadDelegateItem {
    func onDownloadFinished(items: [Item])
}

protocol DownloadDelegateItemInfo {
    func onDownloadFinished(itemInfo: ItemInfo?)
}

protocol DownloadDelegateGif {
    func onDownloadFinished(gifData: Data?)
}

class Download {
    
    static fileprivate func responseDataItem(delegate: DownloadDelegateItem, response: Alamofire.DataResponse<Any> ) {
        var dataItems = [Item]()
        switch response.result {
        case .success(let value):
            let json = JSON(value)
            for (_, subJson):(String, JSON) in json["items"] {
                if let item = Item(json: subJson) {
                    dataItems.append(item)
                }
            }
        case .failure(let error):
            Notification.showErrorMessage(withError: error)
        }
        delegate.onDownloadFinished(items: dataItems)
    }
    
    static func downloadItems(delegate: DownloadDelegateItem, flag: Int, promoted: Int) {
        Alamofire.request(String(format: Constants.URLGetItems, flag, promoted)).responseJSON { response in
            self.responseDataItem(delegate: delegate, response: response)
        }
    }
    
    static func downloadItemsOlder(delegate: DownloadDelegateItem, flag: Int, promoted: Int, older: Int) {
        Alamofire.request(String(format: Constants.URLGetItemsOlder, flag, promoted, older)).responseJSON { response in
            self.responseDataItem(delegate: delegate, response: response)
        }
    }
    
    static func downloadItemInfo(delegate: DownloadDelegateItemInfo, id: Int) {
        Alamofire.request(String(format: Constants.URLItemInfo, id)).responseJSON { response in
            var itemInfo:ItemInfo? = nil
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                itemInfo = ItemInfo(json: json)
            case .failure(let error):
                Notification.showErrorMessage(withError: error)
            }
            delegate.onDownloadFinished(itemInfo: itemInfo)
        }
    }
    
    static func downloadGif(delegate: DownloadDelegateGif, gif: String) {
        Alamofire.request(String(format: Constants.URLGif, gif)).responseData { response in
            var gifData:Data? = nil
            switch response.result {
            case .success(let value):
                gifData =  value
            case .failure(let error):
                Notification.showErrorMessage(withError: error)
            }
            delegate.onDownloadFinished(gifData: gifData)
        }
    }
    
    static func downloadSearchItems(delegate: DownloadDelegateItem, flag: Int, promoted: Int, query: String) {
        
        Alamofire.request(String(format: Constants.URLGetSearchItems, flag, promoted, self.customEncoding(query: query))).responseJSON { response in
            self.responseDataItem(delegate: delegate, response: response)
        }
    }
    
    static func downloadSearchItemsOlder(delegate: DownloadDelegateItem, flag: Int, promoted: Int, older: Int, query: String) {
        Alamofire.request(String(format: Constants.URLGetSearchItemsOlder, flag, promoted, older, self.customEncoding(query: query))).responseJSON { response in
            self.responseDataItem(delegate: delegate, response: response)
        }
    }
    
    static fileprivate func customEncoding(query: String) -> String {
        var encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if (encodedQuery == nil) {
            encodedQuery = ""
        }
        encodedQuery = encodedQuery?.replacingOccurrences(of: "%20", with: "+")
        return encodedQuery!
    }
    
}
