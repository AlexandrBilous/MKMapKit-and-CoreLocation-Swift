//
//  MeetupViewController.swift
//  MKMapView 37-38 SW HW
//
//  Created by Marentilo on 20.03.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//
import UIKit
import CoreLocation

class MeetupViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else {
              return
            }
            
            self.decodeLocationToStrings()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: { [weak self] in
                self?.tableView.performBatchUpdates({
                    self?.tableView.reloadData()
                }, completion: nil)
            })
        }
        
    }
    
        var meetupPoint : MeetupPoint?
        
        var countryCode : String?
        var country : String?
        var city : String?
        var street : String?
        var state : String?
        var postalCode : String?

        static let meetupSource = ["Event", "Main goal", "Date", "Time", "Country code", "Country", "City", "Neighborhood", "Street", "Postal code"]

    
        init(meetupPoint: MeetupPoint) {
            self.meetupPoint = meetupPoint
            
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            self.meetupPoint = nil
            super.init(coder: coder)
        }
    
    func valueForRow (row: Int) -> String{

           let result : String
           switch row {
           case 0:
                result = meetupPoint?.title ?? "Unknown area"
           case 1:
                result = meetupPoint?.subtitle ?? "Unknown area"
           case 2:
                result =  meetupPoint!.dateFormatter.string(from: meetupPoint!.date)
           case 3:
            result = meetupPoint!.timeFormatter.string(from: meetupPoint!.date)
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
    
    
    func decodeLocationToStrings (){
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: meetupPoint?.coordinate.latitude ?? 50.0, longitude: meetupPoint?.coordinate.longitude ?? 30.50)
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
    
    

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return MeetupViewController.meetupSource.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MeetupPoint")
        
        if (cell == nil) {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "MeetupPoint")
        }
        
        cell?.textLabel?.text = MeetupViewController.meetupSource[indexPath.row]
        cell?.detailTextLabel?.text = valueForRow(row: indexPath.row)
        
        return cell!
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
