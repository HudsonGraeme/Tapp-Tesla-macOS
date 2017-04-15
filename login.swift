//
//  login.swift
//  Tapp
//
//  Created by Hudson Graeme on 2017-01-07.
//  Open Source
//

import Foundation
import Cocoa
import Alamofire
import SwiftyJSON
import AlamofireImage
import TeslaSwift
import ObjectMapper
import WebKit
import SwiftWebSocket
import Charts
class login: NSViewController, NSTextFieldDelegate, ChartViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Graph.noDataText = "Please Wait"
        self.outD.noDataText = "Please"
        self.inD.noDataText = "Wait"
}
    
    
    @IBOutlet weak var Graph: BarChartView!
    @IBOutlet weak var gMap: WebView!
    @IBOutlet weak var rData: NSButton! //Refresh for location and other data
    @IBOutlet weak var curl: NSTextField! //dummy textfield
    @IBOutlet weak var lat: NSTextField! //Datafield
    @IBOutlet weak var streamid: NSTextField! //dummy textfield
    @IBOutlet weak var login: NSButton! //Hidden login button
    @IBOutlet weak var carType: NSTextField! //dummy textfield
    @IBOutlet weak var imgtext: NSTextField! //dummy textfield
    @IBOutlet weak var vehimg: NSImageView! //vehicle image
    @IBOutlet weak var vehName: NSTextField! //Name & error textfield
    @IBOutlet weak var cView: NSButton! //Change View button
    @IBOutlet weak var lock: NSButton! //lock
    @IBOutlet weak var unlock: NSButton! //unlock
    @IBOutlet weak var horn: NSButton! //Horn button
    @IBOutlet weak var flash: NSButton! //Flash Lights button
    @IBOutlet weak var pano: NSButton! //Roof button
    @IBOutlet weak var tempSet: NSButton! //Set Temp and Start Climate button
    @IBOutlet weak var tempOff: NSButton! //Stop Climate button
    @IBOutlet weak var rStart: NSButton! //Remote start button
    @IBOutlet weak var email: NSTextField! //email text field
    @IBOutlet weak var password: NSSecureTextField! //password field
    @IBOutlet weak var tokenn: NSTextField! //dummy textfield
    @IBOutlet weak var vehicleidd: NSTextField! //dummy textfield
    @IBOutlet weak var summonFwd: NSButton! //Summon Forward button
    @IBOutlet weak var summonBkwd: NSButton! //Summon Backward button
    @IBOutlet weak var summonStop: NSButton! //Summon Stop button
    @IBOutlet weak var modelimg: NSImageView! //image for model: for example 85D
    @IBOutlet weak var progind: NSProgressIndicator! //The line that's between Email & Password fields
    @IBOutlet weak var outD: BarChartView! //outside degrees chart
    @IBOutlet weak var inD: BarChartView! //inside degrees chart
    @IBOutlet weak var vehModd: NSTextField!
    @IBOutlet weak var batSet: NSSlider!
    @IBOutlet weak var batSettext: NSTextField!
    @IBOutlet weak var alat: NSTextField!
    @IBOutlet weak var long: NSTextField!
    
    
    

    
    
    
    
    
    
    struct defaultsKeys {
        static let accesstoken = ""
    }
    
    
    
    
    
    func getnewimg() {
        let curr = self.curl.stringValue
        let array = ["3QTR", "ABOV", "SIDE", "REAR", "SEAT_ALTA"]
        let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
        let rdm = array[randomIndex]
        let options = self.imgtext.stringValue
        let model = self.carType.stringValue
        let url = URL(string:"https://www.tesla.com/configurator/compositor/?model=m\(model)&view=STUD_\(rdm)&size=500&options=\(options)")
        let ncurr = url?.absoluteString
        self.curl.stringValue = ncurr!
        let request = Alamofire.request(url!).responseImage { response in
            let data = response.result.value
            let defaults = UserDefaults.standard
            print(defaults.string(forKey: defaultsKeys.accesstoken))
            self.vehimg.image = data
        }
    }
    
    
    
    func getmodel() {
        let model = self.vehModd.stringValue
        let url = URL(string:"https://www.tesla.com/sites/all/modules/custom/tesla_configurator/images/web/battery/ui_option_battery_\(model)@2x.png")
        print(url)
        let request = Alamofire.request(url!).responseImage { response in
            let data = response.result.value
            self.modelimg.image = data
            self.password.isHidden = true
            self.email.isHidden = true
            self.progind.isHidden = true
        }
        
        
    }
    
                func getCharge() {
                    let token = self.tokenn.stringValue
                    let vehicleid = self.vehicleidd.stringValue
                        let headers = [
                            "Authorization": "Bearer \(token)"
                        ]
                        let url = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles/\(vehicleid)/data_request/charge_state")
                        
                        let request = Alamofire.request(url!, method: .get, parameters: [:], encoding: URLEncoding.default, headers: headers).downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                            }
                            .validate { request, response, data in
                                
                                return .success
                            }
                            .responseJSON { response in
                                
                                switch response.result {
                                    
                                case .success:
                                    print("getCharge response: \(response)")
                                    
                                    
                                    let data = response.result.value
                                    
                                        let json = JSON(data!)
                                    
                                        let chargestate = json["response"]["charging_state"]
                                        let vehMod = json["response"]["charge_limit_soc"]
                                    self.batSet.doubleValue = vehMod.doubleValue
                                        if(chargestate == "Charging") {
                                        let bCurrent = json["response"]["battery_current"]
                                        let hOn = json["response"]["battery_heater_on"]
                                        let lev = json["response"]["usable_battery_level"].doubleValue
                                        let range = json["response"]["battery_range"].doubleValue
                                        let rCurrent = json["response"]["charge_current_request"]
                                        let rCurrentMax = json["response"]["charge_current_request_max"]
                                        let cEnableReq = json["response"]["charge_enable_request"]
                                        let enAdded = json["response"]["charge_energy_added"]
                                        let dOpen = json["response"]["charge_port_door_open"]
                                        let cColour = json["response"]["charge_port_led_color"] //proper spelling
                                            let Erange = json["response"]["est_battery_range"].doubleValue
                                        print("Charge State: ", chargestate, "\r\n", "Battery Current ", bCurrent, "\r\n", "Battery Heater is ", hOn, "\r\n","Battery Percent ", lev, "\r\n", "Rated Range ", range * 1.6, "\r\n", "Requested Current", rCurrent, "\r\n", "Max Current", rCurrentMax, "\r\n", "Enable request? ", cEnableReq, "\r\n", "Energy Added ", enAdded, "\r\n", "Charge limit ", vehMod, "\r\n", "Charge Port Door ", dOpen, "\r\n", "Charge Port Colour", cColour, "\r\n", "Estimated Range ", Erange * 1.6)
                                            
                                            
                                            
                                            
                                            /*let ds = LineChartDataSet(values: lev, label: "")
                                            if(lev <= 25) {
                                                ds.colors = [NSUIColor.red]
                                            }
                                            else if(lev <= 60) {
                                                ds.colors = [NSUIColor.orange]
                                            }
                                            else {
                                                ds.colors = [NSUIColor.green]
                                            }*/
                                            
                                            
                                            let charg = Array(1..<2).map { x in return lev }
                                            
                                            let charge = charg.enumerated().map { x, y in return BarChartDataEntry(x: Double(x), y: y) }
                                            
                                            let data = BarChartData()
                                            let ds1 = BarChartDataSet(values: charge, label: "")
                                            if(lev <= 25) {
                                                ds1.colors = [NSUIColor.red]
                                            }
                                            else if(lev <= 60) {
                                            ds1.colors = [NSUIColor.orange]
                                            }
                                            else {
                                            ds1.colors = [NSUIColor.green]
                                            }
                                            data.addDataSet(ds1)
                                            self.Graph.scaleYEnabled = false
                                            self.Graph.leftAxis.axisMaximum = 100
                                            self.Graph.rightAxis.axisMaximum = 100
                                            self.Graph.leftAxis.axisMinimum = 0
                                            self.Graph.rightAxis.axisMinimum = 0
                                            self.Graph.data = data
                                            self.Graph.gridBackgroundColor = NSUIColor.darkGray
                                            self.Graph.chartDescription?.text = ""
                                            self.Graph.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
                                        
                                    }
                                        else {
                                            let lev = json["response"]["usable_battery_level"].doubleValue
                                            if(lev == 99) {
                                                let lev = 100
                                            }
                                            
                                            let charg = Array(1..<2).map { x in return lev }
                                            
                                            let charge = charg.enumerated().map { x, y in return BarChartDataEntry(x: Double(x), y: y) }
                                            
                                            let data = BarChartData()
                                            let ds1 = BarChartDataSet(values: charge, label: "")
                                            if(lev <= 25) {
                                                ds1.colors = [NSUIColor.red]
                                            }
                                            else if(lev <= 60) {
                                                ds1.colors = [NSUIColor.orange]
                                            }
                                            else {
                                                ds1.colors = [NSUIColor.green]
                                            }

                                            data.addDataSet(ds1)
                                            self.Graph.rightAxis.enabled = false
                                            self.Graph.leftAxis.axisMaximum = 100
                                            self.Graph.leftAxis.axisMinimum = 0
                                            self.Graph.data = data
                                            self.Graph.gridBackgroundColor = NSUIColor.darkGray
                                            self.Graph.chartDescription?.text = ""
                                            self.Graph.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
                                    }
                                    self.getmodel()
                                default:
                                    print("getCharge defaulted")
                                }
                                
                                
                                
                        }
                     
                        loc()
    
            }
    
    func getcardata(){ //Moving all of the other funcs here.
        let token = self.tokenn.stringValue
        let vehicleid = self.vehicleidd.stringValue
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        let url = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles/\(vehicleid)/data")
        let request = Alamofire.request(url!, method: .get, encoding: URLEncoding.default, headers: headers).downloadProgress(queue: DispatchQueue.global(qos: .utility)) {
            progress in
        }
            .validate { request, response, data in
                return .success
                
        }
            .responseJSON {
                response in
                let data = response.result.value
                let json = JSON(data)
                print("getcardata Response ", json)
                let vehMod = json["response"]["vehicle_config"]["trim_badging"].stringValue
                self.vehModd.stringValue = vehMod
                let isLocked = json["response"]["vehicle_state"]["locked"]
                if(isLocked == "1"||isLocked == "true") {
                    self.lock.isEnabled = false
                    
                }
                else {
                    self.unlock.isEnabled = false
                }
                
                
                
                
             self.getCharge()
        }
    }
                    func getClimate() {
                       
                        let token = self.tokenn.stringValue
                        let vehicleid = self.vehicleidd.stringValue
                        let headers = [
                            "Authorization": "Bearer \(token)"
                        ]
                        
                        let url = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles/\(vehicleid)/data_request/climate_state")
                        
                        let request = Alamofire.request(url!, method: .get, parameters: [:], encoding: URLEncoding.default, headers: headers).downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                            }
                            .validate { request, response, data in
                                
                                return .success
                            }
                            .responseJSON { response in
                          
                                switch response.result {
                                    
                                case .success:
                                    print("getClimate response: \(response)")
                                    
                                    
                                    let data = response.result.value
                                    if data != nil {
                                    
                                        let json = JSON(data!)
                                        let inTemp = json["response"]["inside_temp"]
                                        let outTemp = json["response"]["outside_temp"]
                                        let aOn = json["response"]["is_climate_on"]
                                        let FRon = json["response"]["seat_heater_right"]
                                        let FLon = json["response"]["seat_heater_left"]
                                        let RLon = json["response"]["seat_heater_rear_left"]
                                        let RCon = json["response"]["seat_heater_rear_center"]
                                        let RRon = json["response"]["seat_heater_rear_right"]
                                        
                                        if(aOn == "true"||aOn == "1") {
                                            self.tempSet.isEnabled = false
                                        }
                                        else {
                                            self.tempOff.isEnabled = false
                                        }
                                        let inDeg = inTemp.doubleValue
                                        let deg = Array(1..<2).map { x in return inDeg }
                                        
                                        let degc = deg.enumerated().map { x, y in return BarChartDataEntry(x: Double(x), y: y) }
                                        
                                        let data = BarChartData()
                                        let ds1 = BarChartDataSet(values: degc, label: "")
                                        if(inDeg >= 20) {
                                            ds1.colors = [NSUIColor.orange]
                                        }
                                        else if(inDeg >= 30) {
                                            ds1.colors = [NSUIColor.red]
                                        }
                                        else if(inDeg <= 5) {
                                            ds1.colors = [NSUIColor.blue]
                                        }
                                        else {
                                            ds1.colors = [NSUIColor.green]
                                        }
                                        
                                        data.addDataSet(ds1)
                                        //self.inD.scaleYEnabled = false
                                        self.inD.rightAxis.drawLabelsEnabled = false
                                        self.inD.leftAxis.axisMaximum = 40
                                        self.inD.leftAxis.axisMinimum = -30
                                        self.inD.data = data
                                        self.inD.gridBackgroundColor = NSUIColor.darkGray
                                        self.inD.chartDescription?.text = ""
                                        self.inD.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
                                    
                                        
                                    
                                        let outDeg = outTemp.doubleValue
                                        let deg1 = Array(1..<2).map { x in return outDeg }
                                        
                                        let degc1 = deg1.enumerated().map { x, y in return BarChartDataEntry(x: Double(x), y: y) }
                                        
                                        let data1 = BarChartData()
                                        let ds2 = BarChartDataSet(values: degc1, label: "")
                                        if(outDeg >= 20) {
                                            ds2.colors = [NSUIColor.orange]
                                        }
                                        else if(outDeg >= 30) {
                                            ds2.colors = [NSUIColor.red]
                                        }
                                        else if(outDeg <= 5) {
                                            ds2.colors = [NSUIColor.blue]
                                        }
                                        else if(outDeg >= 5 && outDeg <= 20){
                                            ds2.colors = [NSUIColor.green]
                                        }
                                        
                                        data1.addDataSet(ds2)
                                        self.outD.rightAxis.drawLabelsEnabled = false
                                        self.outD.leftAxis.axisMaximum = 40
                                        self.outD.leftAxis.axisMinimum = -30
                                        self.outD.data = data1
                                        self.outD.gridBackgroundColor = NSUIColor.darkGray
                                        self.outD.chartDescription?.text = ""
                                        self.outD.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
                                    
                                }
                                    self.getcardata()
                                default:
                                    print("data_request defaulted")
                                }
                       }
            }
    
    

    func getimg() {
        let options = self.imgtext.stringValue
        let model = self.carType.stringValue
        let url = URL(string:"https://www.tesla.com/configurator/compositor/?model=m\(model)&view=STUD_ABOV&size=500&options=\(options)")
        let curr = url?.absoluteString
        self.curl.stringValue = curr!
        let request = Alamofire.request(url!).responseImage { response in
            let data = response.result.value
            self.vehimg.image = data
            self.cView.isEnabled = true
            self.getClimate()
        }
    }

    
    

    func getdata(){
        
        
        let token = self.tokenn.stringValue
        let vehicleid = self.vehicleidd.stringValue
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        let url = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles/\(vehicleid)/data_request/vehicle_state")
        
        let request = Alamofire.request(url!, method: .get, parameters: [:], encoding: URLEncoding.default, headers: headers).downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
            
            }
            .validate { request, response, data in
                
                return .success
            }
            .responseJSON { response in
                
                switch response.result {
                    
                case .success:
                    let data = response.result.value
                    if data != nil {
                        
                        let json = JSON(data!)
                        self.carType.stringValue = json["response"][]["car_type"].stringValue
                        if(json["response"]["sun_roof_installed"].stringValue == "1") {
                            self.pano.isEnabled = true
                        }
                        else {
                            self.pano.isEnabled = false
                        }
                        self.getimg()
                    }
                default:
                    print("data_request defaulted")
                }
        }
    }

    
    

        func mobileacc() {
            let token = self.tokenn.stringValue
            let vehicleid = self.vehicleidd.stringValue
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
            let url = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles/\(vehicleid)/mobile_enabled")

            let request = Alamofire.request(url!, method: .get, parameters: [:], encoding: URLEncoding.default, headers: headers).downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                }
                .validate { request, response, data in
                    
                    return .success
                }
                .responseJSON { response in
                    
                    switch response.result {
                        
                    case .success:
                        let data = response.result.value
                        let json = JSON(data!)
                        print("mobileacc", json)
                        if(json["response"].stringValue == "true") {
                            self.degrees.isEnabled = true
                            self.vehName.isEnabled = true
                            self.vehName.textColor = NSColor.gray
                            self.lock.isEnabled = true
                            self.unlock.isEnabled = true
                            self.horn.isEnabled = true
                            self.flash.isEnabled = true
                            self.tempSet.isEnabled = true
                            self.tempOff.isEnabled = true
                            self.summonFwd.isEnabled = false
                            self.summonBkwd.isEnabled = false
                            self.summonStop.isEnabled = false
                            self.rData.isEnabled = true
                            
                        } else
                        {
                            print("response isn't true")
                            self.vehName.isEnabled = false
                            self.vehName.textColor = NSColor.red
                            self.vehName.stringValue = "Mobile access is disabled!"
                            self.lock.isEnabled = false
                            self.unlock.isEnabled = false
                            self.horn.isEnabled = false
                            self.flash.isEnabled = false
                            self.tempSet.isEnabled = false
                            self.tempOff.isEnabled = false
                            self.summonFwd.isEnabled = false
                            self.summonBkwd.isEnabled = false
                            self.summonStop.isEnabled = false
                            self.degrees.isEnabled = false
                            self.pano.isEnabled = false
                            self.rStart.isEnabled = false
                        }
                        self.getdata()
                    default:
                        print("everything isn't fine")
                    }
            }
    }
    
    
    
    func getvehicle() {
        let token = self.tokenn.stringValue
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        let url = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles")
        
        let request = Alamofire.request(url!, method: .get, parameters: [:], encoding: URLEncoding.default, headers: headers).downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
            
            }
            .validate { request, response, data in
                return .success
            }
            .responseJSON { response in
                
                
                switch response.result {
                    
                case .success:
                    
                    let data = response.result.value
                    if data != nil {
                        let json = JSON(data!)
                        print(json)
                        
                        self.vehicleidd.stringValue = json["response"][0]["id"].stringValue
                        self.streamid.stringValue = json["response"][0]["vehicle_id"].stringValue
                        self.vehName.textColor = NSColor.darkGray
                        self.vehName.stringValue = json["response"][0]["display_name"].stringValue
                        self.imgtext.stringValue = json["response"][0]["option_codes"].stringValue
                        if json["response"][0]["remote_start_enabled"].stringValue == "true" {
                            self.rStart.isEnabled = true
                        }
                        else {
                            self.rStart.isEnabled = false
                        }
                        let vehiclecount = json["count"]
                        self.mobileacc()
                    }
                default:
                    
                    print("vehicles defaulted")
                }
        }
        
    }

    
    func gc1() {
        let token = self.tokenn.stringValue
        let vehicleid = self.vehicleidd.stringValue
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        let url = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles/\(vehicleid)/data_request/charge_state")
        
        let request = Alamofire.request(url!, method: .get, parameters: [:], encoding: URLEncoding.default, headers: headers).downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
            }
            .validate { request, response, data in
                
                return .success
            }
            .responseJSON { response in
                
                switch response.result {
                    
                case .success:
                    print("getCharge response: \(response)")
                    
                    
                    let data = response.result.value
                    
                    let json = JSON(data!)
                    
                    let chargestate = json["response"]["charging_state"]
                    let vehMod = json["response"]["charge_limit_soc"]
                    if(chargestate == "Charging") {
                        let bCurrent = json["response"]["battery_current"]
                        let hOn = json["response"]["battery_heater_on"]
                        let lev = json["response"]["usable_battery_level"].doubleValue
                        let range = json["response"]["battery_range"].doubleValue
                        let rCurrent = json["response"]["charge_current_request"]
                        let rCurrentMax = json["response"]["charge_current_request_max"]
                        let cEnableReq = json["response"]["charge_enable_request"]
                        let enAdded = json["response"]["charge_energy_added"]
                        
                        let dOpen = json["response"]["charge_port_door_open"]
                        let cColour = json["response"]["charge_port_led_color"] //proper spelling
                        let Erange = json["response"]["est_battery_range"].doubleValue
                        
                        print("Charge State: ", chargestate, "\r\n", "Battery Current ", bCurrent, "\r\n", "Battery Heater is ", hOn, "\r\n","Battery Percent ", lev, "\r\n", "Rated Range ", range * 1.6, "\r\n", "Requested Current", rCurrent, "\r\n", "Max Current", rCurrentMax, "\r\n", "Enable request? ", cEnableReq, "\r\n", "Energy Added ", enAdded, "\r\n", "Charge limit ", vehMod, "\r\n", "Charge Port Door ", dOpen, "\r\n", "Charge Port Colour", cColour, "\r\n", "Estimated Range \(Erange * 1.6)km")
                        
                        
                        
                        
                        /*let ds = LineChartDataSet(values: lev, label: "")
                         if(lev <= 25) {
                         ds.colors = [NSUIColor.red]
                         }
                         else if(lev <= 60) {
                         ds.colors = [NSUIColor.orange]
                         }
                         else {
                         ds.colors = [NSUIColor.green]
                         }*/
                        
                        
                        let charg = Array(1..<2).map { x in return lev }
                        
                        let charge = charg.enumerated().map { x, y in return BarChartDataEntry(x: Double(x), y: y) }
                        
                        let data = BarChartData()
                        let ds1 = BarChartDataSet(values: charge, label: "")
                        if(lev <= 25) {
                            ds1.colors = [NSUIColor.red]
                        }
                        else if(lev <= 60) {
                            ds1.colors = [NSUIColor.orange]
                        }
                        else {
                            ds1.colors = [NSUIColor.green]
                        }
                        data.addDataSet(ds1)
                        self.Graph.scaleYEnabled = false
                        self.Graph.leftAxis.axisMaximum = 100
                        self.Graph.rightAxis.axisMaximum = 100
                        self.Graph.leftAxis.axisMinimum = 0
                        self.Graph.rightAxis.axisMinimum = 0
                        self.Graph.data = data
                        self.Graph.gridBackgroundColor = NSUIColor.darkGray
                        self.Graph.chartDescription?.text = ""
                        self.Graph.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
                        
                    }
                    else {
                        
                        let lev = json["response"]["usable_battery_level"].doubleValue
                        if(lev == 99) {
                            let lev = 100
                        }
                        
                        let charg = Array(1..<2).map { x in return lev }
                        
                        let charge = charg.enumerated().map { x, y in return BarChartDataEntry(x: Double(x), y: y) }
                        
                        let data = BarChartData()
                        let ds1 = BarChartDataSet(values: charge, label: "")
                        if(lev <= 25) {
                            ds1.colors = [NSUIColor.red]
                        }
                        else if(lev <= 60) {
                            ds1.colors = [NSUIColor.orange]
                        }
                        else {
                            ds1.colors = [NSUIColor.green]
                        }
                        
                        data.addDataSet(ds1)
                        self.Graph.rightAxis.enabled = false
                        self.Graph.leftAxis.axisMaximum = 100
                        self.Graph.leftAxis.axisMinimum = 0
                        self.Graph.data = data
                        self.Graph.gridBackgroundColor = NSUIColor.darkGray
                        self.Graph.chartDescription?.text = ""
                        self.Graph.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
                    }
                    self.getmodel()
                default:
                    print("getCharge defaulted")
                }
                
                
                
        }
        
        
    }

    func gc() {
        
        let token = self.tokenn.stringValue
        let vehicleid = self.vehicleidd.stringValue
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        let url = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles/\(vehicleid)/data_request/climate_state")
        
        let request = Alamofire.request(url!, method: .get, parameters: [:], encoding: URLEncoding.default, headers: headers).downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
            }
            .validate { request, response, data in
                
                return .success
            }
            .responseJSON { response in
                
                switch response.result {
                    
                case .success:
                    print("getClimate response: \(response)")
                    
                    
                    let data = response.result.value
                    if data != nil {
                        
                        let json = JSON(data!)
                        let inTemp = json["response"]["inside_temp"]
                        let outTemp = json["response"]["outside_temp"]
                        let aOn = json["response"]["is_climate_on"]
                        let FRon = json["response"]["seat_heater_right"]
                        let FLon = json["response"]["seat_heater_left"]
                        let RLon = json["response"]["seat_heater_rear_left"]
                        let RCon = json["response"]["seat_heater_rear_center"]
                        let RRon = json["response"]["seat_heater_rear_right"]
                        
                        
                        let inDeg = inTemp.doubleValue
                        let deg = Array(1..<2).map { x in return inDeg }
                        
                        let degc = deg.enumerated().map { x, y in return BarChartDataEntry(x: Double(x), y: y) }
                        
                        let data = BarChartData()
                        let ds1 = BarChartDataSet(values: degc, label: "")
                        if(inDeg >= 20) {
                            ds1.colors = [NSUIColor.orange]
                        }
                        else if(inDeg >= 30) {
                            ds1.colors = [NSUIColor.red]
                        }
                        else if(inDeg <= 5) {
                            ds1.colors = [NSUIColor.blue]
                        }
                        else {
                            ds1.colors = [NSUIColor.green]
                        }
                        
                        data.addDataSet(ds1)
                        //self.inD.scaleYEnabled = false
                        self.inD.rightAxis.drawLabelsEnabled = false
                        self.inD.leftAxis.axisMaximum = 40
                        self.inD.leftAxis.axisMinimum = -30
                        self.inD.data = data
                        self.inD.gridBackgroundColor = NSUIColor.darkGray
                        self.inD.chartDescription?.text = ""
                        self.inD.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
                        
                        
                        
                        let outDeg = outTemp.doubleValue
                        let deg1 = Array(1..<2).map { x in return outDeg }
                        
                        let degc1 = deg1.enumerated().map { x, y in return BarChartDataEntry(x: Double(x), y: y) }
                        
                        let data1 = BarChartData()
                        let ds2 = BarChartDataSet(values: degc1, label: "")
                        if(outDeg >= 20) {
                            ds2.colors = [NSUIColor.orange]
                        }
                        else if(outDeg >= 30) {
                            ds2.colors = [NSUIColor.red]
                        }
                        else if(outDeg <= 5) {
                            ds2.colors = [NSUIColor.blue]
                        }
                        else if(outDeg >= 5 && outDeg <= 20){
                            ds2.colors = [NSUIColor.green]
                        }
                        
                        data1.addDataSet(ds2)
                        self.outD.rightAxis.drawLabelsEnabled = false
                        self.outD.leftAxis.axisMaximum = 40
                        self.outD.leftAxis.axisMinimum = -30
                        self.outD.data = data1
                        self.outD.gridBackgroundColor = NSUIColor.darkGray
                        self.outD.chartDescription?.text = ""
                        self.outD.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
                        
                    }
                    self.gc1()
                default:
                    print("data_request defaulted")
                }
        }
    }
    
    

    
    
    @IBAction func login(_ sender: Any) {
        //login button pressed
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: defaultsKeys.accesstoken)
        if(token == nil||token == "") {
            print(token, " = 0")
        self.lat.isSelectable = true
        let pass = self.password.stringValue //make the strings
        let mail = self.email.stringValue
        
        if (mail == "") {
            self.vehName.textColor = NSColor.red
            self.vehName.stringValue = "Please enter your Email address"
        }
        if (pass == "") {
            self.vehName.textColor = NSColor.red
            self.vehName.stringValue = "Please enter your Password"
            
        }
        if (mail == ""&&pass == "") {
            self.vehName.textColor = NSColor.red
            self.vehName.stringValue = "Please enter your MyTesla Username and Password"
            
        }
        let url = URL(string: "https://owner-api.teslamotors.com/oauth/token?grant_type=password&client_id=81527cff06843c8634fdc09e8ac0abefb46ac849f38fe1e431c2ef2106796384&client_secret=c7257eb71a564034f9419ee651c7d0e5f7aa6bfbd18bafb5c5c033b093bb2fa3&email=\(mail)&password=\(pass)")
        let task = Alamofire.request(url!, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                
                    let data = response.result.value
                    let json = JSON(data)
                print(json)
                
                self.tokenn.stringValue = json["access_token"].stringValue
                let token = json["access_token"].stringValue
                let defaults = UserDefaults.standard
                defaults.setValue(token, forKey: defaultsKeys.accesstoken)
                defaults.synchronize()

                let status = response.response!.statusCode

                switch(status) {
                case 200:
                    self.login.isHidden = true
                    self.login.isEnabled = false
                    self.login.state = 0
                    self.getvehicle()
                    self.wakeup()
                    return
                case 400:
                    print("400 - Email or pass empty")
                    self.vehName.textColor = NSColor.red
                    self.vehName.stringValue = "Email or Password field left blank"
                case 401:
                    print("401 - Forbidden.. Email or Password incorrect")
                    self.vehName.textColor = NSColor.red
                    self.vehName.stringValue = "Invalid login info"
                case 404:
                    print("404")
                    self.vehName.textColor = NSColor.red
                    self.vehName.stringValue = "My Bad.. Contact Dev"
                case nil:
                    print("nil")
                    self.vehName.textColor = NSColor.red
                    self.vehName.stringValue = "No Wifi!"
                default:
                    print("Here is the error: \(status)")
                    self.vehName.stringValue = "Unknown error \(status)"
                    
                }
            }
        }
        else {
            print(token, "is something")
            self.tokenn.stringValue = token!
            self.login.isHidden = true
            self.login.isEnabled = false
            self.login.state = 0
            self.getvehicle()
            self.wakeup()
        }
    }

    func loc() {
        let token = self.tokenn.stringValue
        let vehicleid = self.vehicleidd.stringValue
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        let url = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles/\(vehicleid)/data_request/drive_state")
        
        let request = Alamofire.request(url!, method: .get, parameters: [:], encoding: URLEncoding.default, headers: headers).downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
            }
            .validate { request, response, data in
                
                return .success
            }
            .responseJSON { response in
                let data = response.result.value
                let json = JSON(data!)
                print(json)
                if(json["response"]["error"] == "vehicle unavailible") {
                    print(json["response"]["error"])
                    self.wakeup()
                }

                let lati = json["response"]["latitude"]
                let longi = json["response"]["longitude"]
                print(lati, longi)
                let head = json["response"]["heading"]
                let shift = json["response"]["shift_state"].stringValue
                let speed = json["response"]["speed"].doubleValue
                
                self.gMap.mainFrameURL = "https://www.google.ca/maps/place/\(lati.stringValue),\(longi.stringValue)/data=!3m1!1e3"

                print(self.gMap.mainFrameURL)
                if(shift == "") {
                    self.lat.stringValue = "Latitude: \(lati) | Longitude: \(longi) | State: Off | Heading: \(head)"
                    //print("Off: ", self.lat.stringValue)
                }
                else if(shift == "D") {
                    self.lat.stringValue = "Latitude: \(lati) | Longitude: \(longi) | Gear: Drive | Speed: \(speed)mi/h (\(speed * 1.6)km/h) | Heading: \(head)"
                    //print("D:  ", self.lat.stringValue)
                }
                else if(shift == "P") {
                    self.lat.stringValue = "Latitude: \(lati) | Longitude: \(longi) | Gear: Park | Heading: \(head)"
                    //print("Park:  ", self.lat.stringValue)
                }
                else if(shift == "R") {
                    self.lat.stringValue = "Latitude: \(lati) | Longitude: \(longi) | Gear: Reverse | Speed: \(speed)mi/h (\(speed * 1.6)km/h) | Heading: \(head)"
                    //print("R:  ", self.lat.stringValue)
                }
                else if(shift == "N") {
                    self.lat.stringValue = "Latitude: \(lati) | Longitude: \(longi) | Gear: Neutral | Speed: \(speed)mi/h (\(speed * 1.6)km/h) | Heading: \(head)"
                    //print("N:  ", self.lat.stringValue)
                }
                else {
                    self.lat.stringValue = "Latitude: \(lati) | Longitude: \(longi) | State: Off | Heading: \(head) *ERROR* Please Contact Dev"
                    //print("else:  ", self.lat.stringValue)
                }
                //print(lati, longi, shift, speed, head)
                var grabdata = Timer.scheduledTimer(timeInterval: TimeInterval(60), target: self, selector: Selector("loc"), userInfo: nil, repeats: true)
                var grabdata1 = Timer.scheduledTimer(timeInterval: TimeInterval(60), target: self, selector: Selector("gc"), userInfo: nil, repeats: true)

            }
            
    }

    func wakeup() {
            let token = self.tokenn.stringValue
            let vehicleid = self.vehicleidd.stringValue
            let headers = [
                "Authorization": "Bearer \(token)"
            ]

            let url = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles/\(vehicleid)/wake_up")
            
            let request = Alamofire.request(url!, method: .post, parameters: [:], encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                let data = response.result.value
                let json = JSON(data!)
                print("wakeup", json)
        }
    }
        @IBAction func rData(_ sender: Any) {
        loc()
        gc()
    }


    @IBAction func lock(_ sender: Any) {
        let token = self.tokenn.stringValue
        let vehicleid = self.vehicleidd.stringValue
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        let url = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles/\(vehicleid)/command/door_lock")
        
        let request = Alamofire.request(url!, method: .post, parameters: [:], encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            print(response)
            
        }
        self.lock.isEnabled = false
        self.unlock.isEnabled = true
    }
    @IBAction func unlock(_ sender: Any) {
        let token = self.tokenn.stringValue
        let vehicleid = self.vehicleidd.stringValue
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        let url = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles/\(vehicleid)/command/door_unlock")
        
        let request = Alamofire.request(url!, method: .post, parameters: [:], encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
        }
        self.lock.isEnabled = true
        self.unlock.isEnabled = false
    }
    
    @IBAction func horn(_ sender: Any) {
        let token = self.tokenn.stringValue
        let vehicleid = self.vehicleidd.stringValue
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        let url = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles/\(vehicleid)/command/honk_horn")
        
        let request = Alamofire.request(url!, method: .post, parameters: [:], encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
        }
    }
    @IBAction func flash(_ sender: Any) {
        let token = self.tokenn.stringValue
        let vehicleid = self.vehicleidd.stringValue
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        let url = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles/\(vehicleid)/command/flash_lights")
        
        let request = Alamofire.request(url!, method: .post, parameters: [:], encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            print(response)
            print(response.response?.statusCode)
        
            
        }

    }
    
    
    @IBAction func pano(_ sender: Any) {
        let token = self.tokenn.stringValue
        let vehicleid = self.vehicleidd.stringValue
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        let url = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles/\(vehicleid)/data")
        
        let request = Alamofire.request(url!, method: .get, parameters: [:], encoding: URLEncoding.default, headers: headers).downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
            }
            .validate { request, response, data in
                
                return .success
            }
            .responseJSON { response in
                let data = response.result.value
                let json = JSON(data!)
        print(json)
        
        }

           }
    
    @IBOutlet weak var degrees: NSTextField!
    @IBAction func tempSet(_ sender: Any) {
        let degreesc = degrees.doubleValue
        if(degreesc >= 28) {
            let degreesc = 28
            self.degrees.doubleValue = 28
        }
        else if(degreesc <= 15) {
            self.degrees.doubleValue = 15
            let degreesc = 15
        }
        let token = self.tokenn.stringValue
        let vehicleid = self.vehicleidd.stringValue
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        let url = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles/\(vehicleid)/command/set_temps?driver_temp=\(degreesc)&passenger_temp=\(degreesc)")
        
        let request = Alamofire.request(url!, method: .post, parameters: [:], encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            let token = self.tokenn.stringValue
            let vehicleid = self.vehicleidd.stringValue
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
            let url = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles/\(vehicleid)/command/auto_conditioning_start")
            
        let request = Alamofire.request(url!, method: .post, parameters: [:], encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            }
            self.tempSet.isEnabled = false
            self.tempOff.isEnabled = true
        }
        
    }
    
    @IBAction func tempOff(_ sender: Any) {
        let token = self.tokenn.stringValue
        let vehicleid = self.vehicleidd.stringValue
        let headers = [
            "Authorization": "Bearer \(token)"
        ]

        let url = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles/\(vehicleid)/command/auto_conditioning_stop")
        
        let request = Alamofire.request(url!, method: .post, parameters: [:], encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            self.tempOff.isEnabled = false
            self.tempSet.isEnabled = true
    }
    }
    
    @IBAction func rStart(_ sender: Any) {
        let token = self.tokenn.stringValue
        let vehicleid = self.vehicleidd.stringValue
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        let pass = self.password.stringValue
        let url = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles/\(vehicleid)/command/remote_start_drive?password=\(pass)")
        
        let request = Alamofire.request(url!, method: .post, parameters: [:], encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            
        }
    }


    
    @IBAction func summonFwd(_ sender: Any) {
        let email = self.email.stringValue // Not working at all
        let vehid = self.streamid.stringValue
        let vehhid = self.vehicleidd.stringValue
        let token = self.tokenn.stringValue
        print("Summfwd")
        let request = NSMutableURLRequest(url: URL(string:"wss://streaming.vn.teslamotors.com/connect/\(vehhid)")!)
        request.addValue("Basic \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        let ws = WebSocket(request: request as URLRequest)
        ws.allowSelfSignedSSL = true
        let send : ()->() = {
            print("send: ")
            ws.send("control:hello")
        }
        ws.event.open = {
            print("opened")
            send()
        }
        ws.event.close = { code, reason, clean in
            print("close")
        }
        ws.event.error = { error in
            print("error \(error)")
        }
        ws.event.message = { message in
            if let text = message as? String {
                print("recv: \(text)")
                
            }
        }
    }
    
    
    @IBAction func cView(_ sender: Any) {
        getnewimg()
    }
    

    
    func getData() {
        let vehid = self.vehicleidd.stringValue
        let token = self.tokenn.stringValue
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        let url = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles/\(vehid)/data")
        
        let request = Alamofire.request(url!, method: .get, parameters: [:], encoding: URLEncoding.default, headers: headers).downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
            
            }
            .validate { request, response, data in
                return .success
            }
            .responseJSON { response in
                
                
                switch response.result {
                    
                case .success:
                    let data = response.result.value
                    let json = JSON(data!)
                    
                    print(data)
                default:
                    
                    print("data defaulted")
                }
        }
        
    }
    @IBAction func batSet(_ sender: NSSlider) {
        let token = self.tokenn.stringValue
        let vehicleid = self.vehicleidd.stringValue
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        let url = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles/\(vehicleid)/command/set_charge_limit?percent=\(round(sender.doubleValue))%")!
        print(url)
        let request = Alamofire.request(url, method: .post, parameters: [:], encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            let data = response.result.value
            let json = JSON(data!)
            self.gc1()
        }
    }

    

    @IBAction func ifHeld(_ sender: Any) {
        self.email.stringValue = "-----------------@--------"
        self.password.stringValue = "-------"
        
    }
    
    @IBAction func modelimgHeld(_ sender: Any) {
        self.modelimg.image = #imageLiteral(resourceName: "ludicrous")
    }
    
    
    
    

}


