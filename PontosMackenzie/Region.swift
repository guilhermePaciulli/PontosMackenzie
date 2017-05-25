//
//  Region.swift
//  PontosMackenzie
//
//  Created by Guilherme Paciulli on 24/05/17.
//  Copyright © 2017 Guilherme Paciulli. All rights reserved.
//

import Foundation
import MapKit
import CoreMotion

class Region {
    
    var regionTitle: String
    
    var regionRect: MKMapRect
    
    var regionQuaternionMax: CMQuaternion
    
    var regionQuaternionMin: CMQuaternion
    
    init(title: String, center: CLLocationCoordinate2D, quaternionMax: CMQuaternion, quaternionMin: CMQuaternion) {
        self.regionTitle = title
        let span = MKCoordinateSpan(latitudeDelta: 0.0001, longitudeDelta: 0.0001)
        let region = MKCoordinateRegionMake(center, span)
        self.regionRect = Region.MKMapRectForCoordinateRegion(region: region)
        self.regionQuaternionMax = quaternionMax
        self.regionQuaternionMin = quaternionMin
    }
    
    func compareQuaternion(q: CMQuaternion) -> Bool {
        return abs(q.x) < abs(self.regionQuaternionMax.x)
//               abs(q.y) < abs(self.regionQuaternionMax.y) &&
//               abs(q.x) > abs(self.regionQuaternionMin.x)
//               abs(q.y) > abs(self.regionQuaternionMin.y)
    }
    
    static func MKMapRectForCoordinateRegion(region: MKCoordinateRegion) -> MKMapRect {
        let topLeft = CLLocationCoordinate2D(latitude: region.center.latitude + (region.span.latitudeDelta/2), longitude: region.center.longitude - (region.span.longitudeDelta/2))
        let bottomRight = CLLocationCoordinate2D(latitude: region.center.latitude - (region.span.latitudeDelta/2), longitude: region.center.longitude + (region.span.longitudeDelta/2))
        
        let a = MKMapPointForCoordinate(topLeft)
        let b = MKMapPointForCoordinate(bottomRight)
        
        return MKMapRect(origin: MKMapPoint(x:min(a.x,b.x), y:min(a.y,b.y)), size: MKMapSize(width: abs(a.x-b.x), height: abs(a.y-b.y)))
    }
    
}
