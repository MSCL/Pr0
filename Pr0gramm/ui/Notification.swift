//
//  Notification.swift
//  Pr0gramm
//
//  Created by TodDurchSterben on 12.04.17.
//  Copyright © 2017 TodDurchSterben. All rights reserved.
//

import SwiftMessages

class Notification {
    
    static func showErrorMessage(withError error: Error?) {
        let messageView = MessageView.viewFromNib(layout: .StatusLine)
        messageView.configureTheme(.error)
        messageView.configureContent(title: Strings.error, body: (error?.localizedDescription)!)
        SwiftMessages.show(view: messageView)
    }
    
    static func showErrorMessage(withString errorString: String) {
        let messageView = MessageView.viewFromNib(layout: .StatusLine)
        messageView.configureTheme(.error)
        messageView.configureContent(title: Strings.error, body: errorString)
        SwiftMessages.show(view: messageView)
    }
    
}
