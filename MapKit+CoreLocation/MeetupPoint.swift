//
//  MeetupPoint.swift
//  MKMapView 37-38 SW HW
//
//  Created by Marentilo on 20.03.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//
import UIKit
import MapKit
import CoreLocation

class MeetupPoint: NSObject, MKAnnotation  {

    var coordinate: CLLocationCoordinate2D
    
    var title: String?

    var subtitle: String?
    
    var nearestStudents = [ABStudent]()
    var middleStudents = [ABStudent]()
    var largeStudents = [ABStudent]()
    var otherStudents = [ABStudent]()
    
    var date = Date(timeIntervalSinceNow: Double.random(in: 0...Double(Int.max)).truncatingRemainder(dividingBy: 30.0 * 3600))
    
    let dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.dateFormat = "dd/MMM/YYYY"
        return formatter
    } ()
    
    let timeFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.dateFormat = "HH-mm"
        return formatter
    } ()
    
    init (coordinate : CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.title = "IOS developers meetup"
        self.subtitle = "Let's do this world better!"
    }
    
    func devideStudentsACcordingToDistanse (students: [ABStudent]) {
        nearestStudents = [ABStudent]()
        middleStudents = [ABStudent]()
        largeStudents = [ABStudent]()
        otherStudents = [ABStudent]()
        
        for item in students {
            switch distanceFromStudentToMeetup(student: item) {
            case 0...3000:
                nearestStudents.append(item)
            case 3001...7000:
                middleStudents.append(item)
            case 7001...15000:
                largeStudents.append(item)
            default:
                otherStudents.append(item)
            }
        }
    }
    
    func createParticipatorsList (students: [ABStudent]) -> [ABStudent] {
        var result = [ABStudent]()
        
        for student in students {
            if willVisitTheEvent(student: student) {
                result.append(student)
            }
        }
        
        return result
    }
        
    func willVisitTheEvent (student: ABStudent) -> Bool {
        var willVisit = false
        switch distanceFromStudentToMeetup(student: student) {
            case 0...3000:
                willVisit = Int.random(in: 0...1000) < 900
            case 3001...7000:
                willVisit = Int.random(in: 0...1000) < 600
            case 7001...15000:
                willVisit = Int.random(in: 0...1000) < 200
            default:
                willVisit = Int.random(in: 0...1000) < 80
        }
        
        return willVisit
    }
    
    func distanceFromStudentToMeetup (student : ABStudent) -> CLLocationDistance {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let studentLocation = CLLocation(latitude: student.coordinate.latitude, longitude: student.coordinate.longitude)
        
        return location.distance(from: studentLocation)
    }
    
    
}
