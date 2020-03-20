import UIKit
import CoreLocation
import MapKit

class ABStudent: NSObject, MKAnnotation {
    
    let firstName : String
    let lastName : String
    let dateOfBirth : String
    let gender : ABStudent.Gender
    
    let coordinate : CLLocationCoordinate2D
    
    var title: String?
    var subtitle: String?
    
    let dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.dateFormat = "dd/MMM/YYYY"
        return formatter
    } ()
    
    init(withDate date: Date, andCoordinate coordinate: CLLocationCoordinate2D) {
        firstName = Constants.firstNames.randomElement() ?? "nil"
        lastName = Constants.lastNames.randomElement() ?? "nil"
        dateOfBirth = dateFormatter.string(from: date)
        gender = Int.random(in: 0...1000) < 500 ? .male : .female
        self.coordinate = coordinate
        
        title = "\(firstName) \(lastName)"
        subtitle = dateOfBirth
    }
    

}

extension ABStudent {
    
    public enum Gender {
        case male,
             female
    }
    
}
