//
//  StudentViewController.swift
//  MKMapView 37-38 SW HW
//
//  Created by Marentilo on 20.03.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//
import UIKit
import CoreLocation

class StudentViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        decodeLocationToStrings()
            
    }
    
    
    
    static let tableViewSource = ["First name", "Last name", "Gender", "Day of Birth", "Country code", "Country", "City", "Neighborhood", "Street", "Postal code"]
    
    var student : ABStudent?
    
    var countryCode : String?
    var country : String?
    var city : String?
    var street : String?
    var state : String?
    var postalCode : String? {
        didSet {
            updateTableCells()
        }
    }

    
    init(student: ABStudent) {
        self.student = student
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.student = nil
        super.init(coder: coder)
    }
    
    func updateTableCells () {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                 return
            }
            self.tableView.reloadData()
        }
    }
    
    func decodeLocationToStrings (){
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: student?.coordinate.latitude ?? 50.0, longitude: student?.coordinate.longitude ?? 30.50)
        geocoder.reverseGeocodeLocation(location) { (placemarks : [CLPlacemark]?, error: Error?) in
            if error != nil {
                print(error.debugDescription)
            } else {
                if placemarks?.count ?? 0 > 0 {
                    let placemark = (placemarks?.last)!
                    self.countryCode = placemark.isoCountryCode
                    self.country = placemark.country
                    self.city = placemark.locality
                    self.street = placemark.thoroughfare
                    self.state = placemark.subAdministrativeArea
                    self.postalCode = placemark.postalCode
                    
                } else {
                    print("No placemarks found")
                }
            }
        }
    }

    
    func valueForRow (row: Int) -> String{
        let result : String
        switch row {
        case 0:
            result = student?.firstName ?? "Unknown area"
        case 1:
            result = student?.lastName ?? "Unknown area"
        case 2:
            result = student?.gender == ABStudent.Gender.male ? "Male" : "Female"
        case 3:
            result = student?.dateOfBirth ?? "Unknown area"
        case 4:
            result = countryCode ?? "Unknown"
        case 5:
            result = country ?? "Unknown"
        case 6:
            result = city ?? "Unknown"
        case 7:
            result = state ?? "Unknown"
        case 8:
            result = street ?? "Unknown"
        case 9:
            result = postalCode ?? "Unknown"
        default:
            result = "Null"
            break
        }
        
        return result
    }
    
    //MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentViewController.tableViewSource.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ABStudent")
        
        if (cell == nil) {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "ABStudent")
        }
        
        cell?.textLabel?.text = StudentViewController.tableViewSource[indexPath.row]
        cell?.detailTextLabel?.text = valueForRow(row: indexPath.row)
        
        return cell!
    }

}
