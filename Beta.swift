//
//  Beta.swift
//  Tapp
//
//  Created by s on 2017-07-21.
//  Copyright © 2017 Carspotter Daily. All rights reserved.
//

import Foundation
import Cocoa
import Alamofire
import SwiftyJSON

class Beta: NSViewController {
    @IBOutlet weak var User: NSTextField!
    @IBOutlet weak var Pass: NSSecureTextField!
    @IBOutlet weak var Help: NSButton!
    @IBOutlet weak var Login: NSButton!
    @IBOutlet weak var err: NSTextField!
    
    @IBAction func Login(_ sender: Any) {
        let username = self.User.stringValue
        let password = self.Pass.stringValue
        let url = URL(string: "https://carspotter.auth0.com/oauth/token?grant_type=password&audience=https://carspotter.auth0.com/api/v2/&client_id=OSMIhTAyPuOWImzIOhP293K7M1dQTYLB&client_secret=_WhnU-gyNXVgxMtl7LLhan9BEgLjQW2d_XvJcRIxPP-skREsPKzcp7YigpsozYmH&email=\(username)&password=\(password)")
        let task = Alamofire.request(url!, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                
                let data = response.result.value
                let json = JSON(data)
                print(json)
        }
    }
}
