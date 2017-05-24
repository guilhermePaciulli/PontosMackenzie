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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
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
        //Prédio 31
        regions.append(Region(title: "Prédio 31",
                              center: CLLocationCoordinate2D(latitude: 10, longitude: 10),
                              quaternionMax: CMQuaternion(x: 10, y: 10, z: 10, w: 0),
                              quaternionMin: CMQuaternion(x: 10, y: 10, z: 10, w: 0)))
        //Prédio 33
        //Mr. Cheeney
        
        
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.5
            motionManager.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: { (deviceMotionData, error) in
                if error == nil {
                    if let data = deviceMotionData {
                        self.quatX.text = "X: \(data.attitude.quaternion.x)"
                        self.quatY.text = "Y: \(data.attitude.quaternion.y)"
                        self.quatZ.text = "Z: \(data.attitude.quaternion.z)"
                        self.userQuaternion = data.attitude.quaternion
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
            long.text = "Latitude: \(l.coordinate.longitude)"
            alt.text = "Altitude: \(l.altitude)"
            
            let c = MKMapPointForCoordinate(l.coordinate)
            
            if let userRegion = (regions.filter({ r in MKMapRectContainsPoint(r.regionRect, c) })).first {
                if userRegion.compareQuaternion(q: self.userQuaternion) {
                    label.text = userRegion.regionTitle
                }
            }
        }
    }
}

