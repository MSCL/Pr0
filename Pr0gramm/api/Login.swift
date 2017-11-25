//
//  Login.swift
//  Pr0gramm
//
//  Created by TodDurchSterben on 27.04.17.
//  Copyright © 2017 TodDurchSterben. All rights reserved.
//

import Alamofire
import SwiftyJSON

protocol LoginDelegate {
    func onLoginFinished(success: Bool)
}

class Login {
    
    static func login(delegate: LoginDelegate, name: String, password: String) {
        let parameters: Parameters = [
            "name": name,
            "password": password
        ]
        Alamofire.request(Constants.URLLogin, method: .post, parameters: parameters).responseJSON { response in
            var success = false
            switch response.result {
            case .success(_):
                if let headerFields = response.response?.allHeaderFields as? [String: String], let url = response.request?.url {
                    let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url)
                    Alamofire.SessionManager.default.session.configuration.httpCookieStorage?.setCookies(cookies, for: URL(string: Constants.URLProtocol + Constants.URLDomain), mainDocumentURL: nil)
                    if (cookies.first != nil) {
                        if let decodedCookie = cookies.first!.value.removingPercentEncoding {
                            let idArray = decodedCookie.components(separatedBy: ",")
                            if (idArray.count >= 2 && idArray[1].range(of: "\"id\":\"") != nil) {
                                let id = idArray[1].replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "id:", with: "")
                                if (id.characters.count >= 16) {
                                    let index = id.index(id.startIndex, offsetBy: 16)
                                    let nonce = id.substring(to: index)
                                    UserDefaults.standard.set(nonce, forKey: Constants.nonce)
                                    success = true
                                }
                            }
                        }
                    }
                }
            case .failure(let error):
                Notification.showErrorMessage(withError: error)
            }
            delegate.onLoginFinished(success: success)
        }
    }
    
}
