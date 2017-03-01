//
//  QKLocationManger.swift
//  SWeChat
//
//  Created by ChiCo on 17/2/27.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit
import INTULocationManager

let LocationInstance = QKLocationManger.sharedInstance

private let kDefaultCoordinateValue: Float = -1.00

class QKLocationManger: NSObject {
    class var sharedInstance : QKLocationManger {
        struct Static {
            static let instance : QKLocationManger = QKLocationManger()
        }
        return Static.instance
    }
    
    var address: String = ""
    var city: String = ""
    var street: String = ""
    var latitude: NSNumber = NSNumber.init(value: kDefaultCoordinateValue as Float)
    var longitude: NSNumber = NSNumber.init(value: kDefaultCoordinateValue as Float)
    var currentLocation: CLLocation!
    var locationService: CLLocationManager!
    var geocoder: CLGeocoder!
    
    fileprivate override init() {
        self.locationService = CLLocationManager()
        self.geocoder = CLGeocoder()
        super.init()
    }
    
    func startLocation(_ success:@escaping (Void) ->Void, failure:@escaping (Void) -> Void) {
        let manger = INTULocationManager.sharedInstance()
        manger.requestLocation(withDesiredAccuracy: .city, timeout: 10, delayUntilAuthorized: true) { (currentLocation, achievedAccuracy, status) in
            switch status {
            case .success:
                self.currentLocation = currentLocation
                self.latitude = NSNumber.init(value: (currentLocation?.coordinate.latitude)! as Double)
                self.longitude = NSNumber.init(value: (currentLocation?.coordinate.longitude)! as Double)
                self.locationService.delegate = self
                self.locationService.startUpdatingLocation()
                success()
                break
            case .timedOut:
                QKAlertView_show("Location request timed out. Current Location:\(currentLocation)")
                failure()
                break
            default:
                QKAlertView_show(self.getLocationErrorDescription(status))
                failure()
                break
            }
            
        }
    }
    
    func getLocationErrorDescription(_ status: INTULocationStatus) -> String {
        if status == .servicesNotDetermined {
            return "Error: User has not responded to the permissions alert."
        }
        if status == .servicesDenied {
            return "Error: User has denied this app permissions to access device location"
        }
        
        if status == .servicesRestricted {
            return "Error: User is restricted from using location services by a usage policy"
        }
        
        if status == .servicesDisabled {
            return "Error: Location services are turned off for all apps on this device."
        }
        
        return "An unknown errow occurred.\n(Are you using IOS Simulator with location set to 'None'?"
        
    }
    
    func resetLocation() {
        self.address = ""
        self.city = ""
        self.street = ""
        self.latitude = NSNumber.init(value: kDefaultCoordinateValue as Float)
        self.longitude = NSNumber.init(value: kDefaultCoordinateValue as Float)
    }
    
    func updateLocation(_ userLocation: CLLocation) {
        if (userLocation.horizontalAccuracy > 0) {
            self.locationService.stopUpdatingLocation()
            return
        }
        self.latitude = NSNumber.init(value: userLocation.coordinate.latitude as Double)
        self.longitude = NSNumber.init(value: userLocation.coordinate.longitude as Double)
        
        if !self.geocoder.isGeocoding {
            self.geocoder.reverseGeocodeLocation(userLocation, completionHandler: { (placemarks, error) in
                if let error = error {
                    log.error("reverse geodcode fail: \(error.localizedDescription)")
                    return
                }
                
                if let placemarks = placemarks , placemarks.count > 0 {
                    let onePlacemark = placemarks.get(index: 0)
                    self.address = "\(onePlacemark?.administrativeArea,onePlacemark?.subLocality,onePlacemark?.thoroughfare)"
                    self.city = (onePlacemark?.administrativeArea!)!
                    self.street = (onePlacemark?.thoroughfare!)!
                }
                
            })
        }
        
    }
    
    
}

extension QKLocationManger: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations.get(index: locations.count - 1)
        self.updateLocation(userLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.updateLocation(manager.location!)
    }
   
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        self.resetLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.resetLocation()
        QKAlertView_show("\(error.localizedDescription)")
    }
}
