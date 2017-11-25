//
//  Colors.swift
//  Pr0gramm
//
//  Created by TodDurchSterben on 12.04.17.
//  Copyright © 2017 TodDurchSterben. All rights reserved.
//

import UIKit

class Colors {
    
    static let red500 = UIColor(rgb: 0xe51c23)
    static let green500 = UIColor(rgb: 0x259b24)
    static let blackTransparent = UIColor(rgb: 0x8000)
    static let white = UIColor(rgb: 0xffffff)
    static let grey200 = UIColor(rgb: 0xeeeeee)
    static let grey700 = UIColor(rgb: 0x616161)
    static let grey800 = UIColor(rgb: 0x424242)
    static let blueGrey500 = UIColor(rgb: 0x607d8b)
    
    static let benisPositiv = Colors.red500
    static let benisNegativ = Colors.green500
    
    static let messageTextReceived = UIColor.darkText
    static let messageTextSend = Colors.grey700
    
    static let inputBackground = UIColor(rgb: 0x1B1E1F)
    static let commentLine = UIColor(rgb: 0x2A2E31)
    static let commentSelectedBackground = UIColor(rgb: 0x222226)
    
    static let tagCollectionViewCellBackground = UIColor(red: 42, green: 46, blue: 48)
    
    static let feedBackground = UIColor(rgb: 0x161618)
    static let secondaryBackground = UIColor(rgb: 0x515158)
    static let senondaryBackgroundBlack = UIColor(rgb: 0x282828)
    
    // user colors
    static let fliesentischbesitzer = UIColor(rgb: 0x6C432B)
    static let neuschwuchtel = UIColor(rgb: 0xe108e9)
    static let schwuchtel = UIColor(rgb: 0xffffff)
    static let altschwuchtel = UIColor(rgb: 0x5bb91c)
    static let moderator = UIColor(rgb: 0x008FFF)
    static let administrator = UIColor(rgb: 0xff9900)
    static let lebendeLegende = UIColor(rgb: 0x1cb992)
    static let gesperrt = UIColor(rgb: 0x444444)
    static let pr0mium = UIColor(rgb: 0x1cb992)
    static let wichtler = UIColor(rgb: 0xd23c22)
    
    static func getColor(mark: Int) -> UIColor {
        var color = UIColor()
        switch mark {
        case 0: // schwuchtel
            color = Colors.schwuchtel
        case 1: // neuschwuchtel
            color = Colors.neuschwuchtel
        case 2: // altschwuchtel
            color = Colors.altschwuchtel
        case 3: // administrator
            color = Colors.administrator
        case 4: // gesperrt
            color = Colors.gesperrt
        case 5: // moderator
            color = Colors.moderator
        case 6: // fliese
            color = Colors.fliesentischbesitzer
        case 7: // lebende legende
            color = Colors.lebendeLegende
        case 8: // wichtler?
            color = Colors.wichtler
        case 9: // edler spender = pr0mium?
            color = Colors.pr0mium
        default:
            color = Colors.schwuchtel
        }
        return color
    }
    
    // app theme colors
    static let olive = UIColor(rgb: 0xb0ad05)
    static let oliveDark = UIColor(rgb: 0x797703)
    
    static let orange = UIColor(rgb: 0xee4d2e)
    static let orangeDark = UIColor(rgb: 0xb33924)
    
    static let green = UIColor(rgb: 0x1db992)
    static let greenDark = UIColor(rgb: 0x137e64)
    
    static let pink = UIColor(rgb: 0xff0082)
    static let pinkDark = UIColor(rgb: 0xb7005d)
    
    static let blue = UIColor(rgb: 0x008fff)
    static let blueDark = UIColor(rgb: 0x0067b6)
    
    static let black = UIColor(rgb: 0x303030)
    static let blackDark = UIColor(rgb: 0x202020)
    
    static var actualTheme = Colors.green
    static var actualThemeDark = Colors.greenDark
    
}

// hex init
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init( red: (rgb >> 16) & 0xFF, green: (rgb >> 8) & 0xFF, blue: rgb & 0xFF)
    }
}
