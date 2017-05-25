//
//  ViewController.swift
//  PontosMackenzie
//
//  Created by Guilherme Paciulli on 24/05/17.
//  Copyright © 2017 Guilherme Paciulli. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation
import MapKit

class ViewController: UIViewController {

    let locationManager = CLLocationManager()
    
    let motionManager = CMMotionManager()

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var lat: UILabel!
    
    @IBOutlet weak var long: UILabel!
    
    @IBOutlet weak var alt: UILabel!
    
    @IBOutlet weak var quatX: UILabel!
    
    @IBOutlet weak var quatY: UILabel!
    
    @IBOutlet weak var quatZ: UILabel!
    
    var regions: [Region] = []
    
    var userQuaternion = CMQuaternion()
    
    var userRegion = MKMapPoint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            break
        case .restricted, .denied:
            break
        }
        regions.append(Region(title: "Auditório Ruy Barbosa",
                              center: CLLocationCoordinate2D(latitude: -23.5466883983682, longitude: -46.6526777856486),
                              quaternionMax: CMQuaternion(x: 0.9, y: 0.5, z: 0.1, w: 0),
                              quaternionMin: CMQuaternion(x: 0.3, y: 0.3, z: 0.5, w: 0)))
        regions.append(Region(title: "Starbucks",
                              center: CLLocationCoordinate2D(latitude: -23.5467902384918, longitude: -46.6521239933061),
                              quaternionMax: CMQuaternion(x: 0.9, y: 0.5, z: 0.1, w: 0),
                              quaternionMin: CMQuaternion(x: 0.3, y: 0.2, z: 0.5, w: 0)))
        regions.append(Region(title: "Mr. Cheeney",
                              center: CLLocationCoordinate2D(latitude: -23.5476672789301, longitude: -46.6509710625248),
                              quaternionMax: CMQuaternion(x: 0.7, y: 0.4, z: 0.1, w: 0),
                              quaternionMin: CMQuaternion(x: 0.4, y: 0.1, z: 0.5, w: 0)))
        
        
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.01
            motionManager.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: { (deviceMotionData, error) in
                if error == nil {
                    if let data = deviceMotionData {
                        self.quatX.text = "X: \(data.attitude.quaternion.x)"
                        self.quatY.text = "Y: \(data.attitude.quaternion.y)"
                        self.quatZ.text = "Z: \(data.attitude.quaternion.z)"
                        self.userQuaternion = data.attitude.quaternion
                        
                        if let usrRegion = (self.regions.filter({ r in
//                            r.compareQuaternion(q: self.userQuaternion) &&
                            MKMapRectContainsPoint(r.regionRect, self.userRegion)
                        })).first {
                            self.label.text = usrRegion.regionTitle
                        } else {
                            self.label.text = "You are no where"
                        }
                        
                    }
                }
            })
        }
    }
}

extension ViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            break
        case .restricted, .denied:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let l = locations.first {
            lat.text = "Latitude: \(l.coordinate.latitude)"
            long.text = "Longitude: \(l.coordinate.longitude)"
            alt.text = "Altitude: \(l.altitude)"
            self.userRegion = MKMapPointForCoordinate(l.coordinate)
        }
    }
}

