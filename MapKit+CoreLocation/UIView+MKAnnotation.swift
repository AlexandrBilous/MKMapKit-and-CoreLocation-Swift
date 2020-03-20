//
//  UIView+MKAnnotation.swift
//  MKMapView 37-38 SW HW
//
//  Created by Marentilo on 20.03.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//
import Foundation
import UIKit
import MapKit

extension UIView {
    
    func superAnnotationView () -> MKAnnotationView? {
        if self == nil {
            return nil
        } else if self.isKind(of: MKAnnotationView.self) {
            return self as! MKAnnotationView
        }
        
        return self.superview?.superAnnotationView()
    }
    
}
