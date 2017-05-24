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

class ViewController: UIViewController {

    let locationManager = CLLocationManager()

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var lat: UILabel!
    
    @IBOutlet weak var long: UILabel!
    
    @IBOutlet weak var alt: UILabel!
    
    @IBOutlet weak var quatX: UILabel!
    
    @IBOutlet weak var quatY: UILabel!
    
    @IBOutlet weak var quatZ: UILabel!
    
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
        }
    }
}

