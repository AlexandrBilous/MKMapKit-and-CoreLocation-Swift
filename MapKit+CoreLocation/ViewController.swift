//
//  ViewController.swift
//  MKMapView 37-38 SW HW
//
//  Created by Marentilo on 20.03.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//
import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, UIPopoverPresentationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
    }
    
    var students = [ABStudent]()
    var meetupPoint : MeetupPoint?
    
    lazy var informationButton : UIButton = {
        let button = UIButton(type: .infoLight)
        button.addTarget(self, action: #selector(infoButtonPressed(sender:)), for: .touchUpInside)
        return button
    } ()
    
    lazy var meetupInfoButton : UIButton = {
        let meetupInfo = UIButton(type: .infoDark)
        meetupInfo.addTarget(self, action: #selector(meetupInfoButtonPresser(sender:)), for: .touchUpInside)
        return meetupInfo
    } ()
    
    lazy var mapView : MKMapView = {
        let map = MKMapView(frame: view.bounds)
        map.delegate = self
        return map
    } ()
    
    let nearestPathLabel : UILabel = {
        let label = UILabel(frame: CGRect(x: 185, y: 10, width: 25, height: 40))
        label.text = "0"
        return label
    }()
    
    let middlePathLabel : UILabel = {
        let label = UILabel(frame: CGRect(x: 185, y: 60, width: 25, height: 40))
        label.text = "0"
        return label
    }()
    
    let longPathLabel : UILabel = {
        let label = UILabel(frame: CGRect(x: 185, y: 110, width: 25, height: 40))
        label.text = "0"
        return label
    }()
    
    let othersPathLabel : UILabel = {
        let label = UILabel(frame: CGRect(x: 185, y: 160, width: 25, height: 40))
        label.text = "0"
        return label
    }()
    
    lazy var informationBoard : UIView = {
        let view = UIView(frame: CGRect(x: 10, y: 70, width: 215, height: 210))
        view.backgroundColor = UIColor(displayP3Red: 0.5543, green: 0.75467, blue: 0.3446, alpha: 0.8)
        let label_1 = UILabel(frame: CGRect(x: 5, y: 10, width: 180, height: 40))
        label_1.text = "Units inside 3000 m: "
        let label_2 = UILabel(frame: CGRect(x: 5, y: 60, width: 180, height: 40))
        label_2.text = "Units inside 7000 m: "
        let label_3 = UILabel(frame: CGRect(x: 5, y: 110, width: 180, height: 40))
        label_3.text = "Units inside 15000 m: "
        let label_4 = UILabel(frame: CGRect(x: 5, y: 160, width: 180, height: 40))
        label_4.text = "Other units: "
        
        [label_1, label_2, label_3, label_4, nearestPathLabel, middlePathLabel, longPathLabel, othersPathLabel].forEach({view.addSubview($0)})
        
        return view
    } ()
    
    func setupView() {
        view.addSubview(mapView)
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ABStudent")
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: "MeetupPoint")
        loadSettingForNavigation()
        createStudents()
    }
    
    func loadSettingForNavigation () {
        let addStudentButton = UIBarButtonItem(barButtonSystemItem: .add , target: self, action: #selector(addStudentButtonPressed(sender:)))
        let zoomButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(zoomButtonPressed(sender:)))
        let pathButton = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(pathButtonPressed(sender:)))

        let meetupButton = UIBarButtonItem(barButtonSystemItem: .add , target: self, action: #selector(meetupButtonPressed(sender:)))
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh , target: self, action: #selector(refreshButtonPressed(sender:)))

        navigationItem.rightBarButtonItems = [addStudentButton, zoomButton]
        navigationItem.leftBarButtonItems = [meetupButton, pathButton, refreshButton]
        navigationItem.title = "MapKit Framework"
    }
    
    func createStudents () {
        
        for _ in 0...100 {
            let student = ABStudent(withDate: Constants.randomDate(), andCoordinate: createRandomCoordinate())
            students.append(student)
        }
        mapView.showAnnotations(students, animated: true)
    }
    
    func createRandomCoordinate () -> CLLocationCoordinate2D {
        let randomLatitude = Double.random(in: -0.3...0.3)
        let randomLongtitude = Double.random(in: -0.3...0.3)
        
        let coordinate = CLLocationCoordinate2D(latitude: Constants.currentLocation.latitude + randomLatitude, longitude: Constants.currentLocation.longitude + randomLongtitude)
        
        return coordinate
    }
    
    func showAllElementsAtScreen () {
        var mapRect = MKMapRect.null
        
        let areaForMap = Constants.areaForMapRect
        let halfAreaForMap = areaForMap / 2
        
        for item in mapView.annotations {
            let mapPoint = MKMapPoint(item.coordinate)
            
            let tmpRect = MKMapRect(x: mapPoint.x - halfAreaForMap, y: mapPoint.y - halfAreaForMap, width: areaForMap, height: areaForMap)
            
            mapRect = mapRect.union(tmpRect)
        }
        
        
        mapView.setVisibleMapRect(mapRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
    }
    
    func showPopover (navController: UITableViewController, sender : MKAnnotationView) {
        let infoList = navController
        infoList.preferredContentSize = CGSize(width: 300, height: 300)
        infoList.modalPresentationStyle = .popover
        
        let popover = infoList.popoverPresentationController
        popover?.delegate = self
        popover?.permittedArrowDirections = .any
        popover?.sourceView = sender
        popover?.sourceRect = sender.bounds
        
        present(infoList, animated: true, completion: nil)
    }
    
    func showCircles () {
        let circle1 = MKCircle(center: meetupPoint!.coordinate, radius: 3000)
        let circle2 = MKCircle(center: meetupPoint!.coordinate, radius: 8000)
        let circle3 = MKCircle(center: meetupPoint!.coordinate, radius: 15000)
        
        mapView.addOverlays([circle1, circle2, circle3])
    }
    
    func refreshTitlesInInformationBar () {
        if meetupPoint != nil {
            meetupPoint?.devideStudentsACcordingToDistanse(students: students)
            nearestPathLabel.text = "\(meetupPoint!.nearestStudents.count)"
            middlePathLabel.text = "\(meetupPoint!.middleStudents.count)"
            longPathLabel.text = "\(meetupPoint!.largeStudents.count)"
            othersPathLabel.text = "\(meetupPoint!.otherStudents.count)"
        }
    }
    
    // MARK: - Actions For Buttons
    
    @objc func meetupInfoButtonPresser (sender: UIButton) {
        let annotationView : MKAnnotationView? = sender.superAnnotationView()
        
        if annotationView != nil {
            let meetup = annotationView?.annotation as! MeetupPoint
            let meetupPopover = MeetupViewController(meetupPoint: meetup)
            showPopover(navController: meetupPopover, sender: annotationView!)
        }
    }
    
    @objc func pathButtonPressed(sender: UIBarButtonItem) {
        
        mapView.removeOverlays(mapView.overlays)
        showCircles()
        
        if meetupPoint != nil {
            let studentsList = meetupPoint!.createParticipatorsList(students: students)
            
            let placemark = MKPlacemark(coordinate: meetupPoint!.coordinate)
            let mapItem = MKMapItem(placemark: placemark)
            let request = MKDirections.Request()
            request.transportType = .automobile
            request.source = mapItem
            
            for student in studentsList {
                let studentPlacemark = MKPlacemark(coordinate: student.coordinate)
                let destination = MKMapItem(placemark: studentPlacemark)
                
                request.destination = destination
                
                let directins = MKDirections(request: request)
                directins.calculate { (responce : MKDirections.Response?, error : Error?) in
                    if error != nil {
                        print(error.debugDescription)
                    } else {
                        if let tmp = responce, tmp.routes.count > 0 {
                            let mkRoute = tmp.routes.last!
                            self.mapView.addOverlay(mkRoute.polyline)
                            print("Hello")
                        } else {
                            print("No routes found")
                        }
                    }
                }
            }
        }
    }
    
    @objc func infoButtonPressed(sender: UIButton) {
        let annotationView : MKAnnotationView? = sender.superAnnotationView()
        
        if annotationView != nil {
            let student = annotationView?.annotation as! ABStudent
            let studentPopover = StudentViewController(student: student)
            showPopover(navController: studentPopover, sender: annotationView!)
        }
    }
    
    @objc func refreshButtonPressed(sender: UIBarButtonItem) {
        if meetupPoint != nil {
            mapView.removeAnnotation(meetupPoint!)
            mapView.removeOverlays(mapView.overlays)
            meetupPoint = nil
            informationBoard.removeFromSuperview()
        }
    }
    
    @objc func addStudentButtonPressed (sender: UIBarButtonItem) {
        let student = ABStudent(withDate: Constants.randomDate(), andCoordinate: createRandomCoordinate())
        students.append(student)
        mapView.showAnnotations(students, animated: true)
        refreshTitlesInInformationBar()
    }
    
    @objc func zoomButtonPressed(sender: UIBarButtonItem) {
        showAllElementsAtScreen()
    }
    
    @objc func meetupButtonPressed(sender: UIBarButtonItem) {
        if meetupPoint == nil {
            view.addSubview(informationBoard)
            meetupPoint = MeetupPoint(coordinate: createRandomCoordinate())
            mapView.addAnnotation(meetupPoint!)
            mapView.showAnnotations(mapView.annotations, animated: true)
            refreshTitlesInInformationBar()
            showCircles()
        }
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView : MKAnnotationView?
        
        if annotation.isKind(of: ABStudent.self) {
            annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ABStudent") ?? nil
            annotationView?.image = (annotation as! ABStudent).gender == ABStudent.Gender.male ? UIImage(named: "man.png") : UIImage(named: "woman.png")
            annotationView?.annotation = annotation
            annotationView?.rightCalloutAccessoryView = informationButton
            
        } else if annotation.isKind(of: MeetupPoint.self) {
            annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "MeetupPoint") ?? nil
            annotationView?.image = UIImage(named: "pin.png")
        
            annotationView?.rightCalloutAccessoryView = meetupInfoButton
            annotationView?.annotation = annotation
            annotationView?.isDraggable = true
        }
        
        annotationView?.canShowCallout = true
        
        return annotationView;
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        if newState == .starting {
            mapView.removeOverlays(mapView.overlays)
        } else if newState == .ending {
            showCircles()
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        var overlayRender = MKOverlayRenderer()
        
        if overlay.isKind(of: MKCircle.self) {
            let circleRender = MKCircleRenderer(overlay: overlay)
            circleRender.strokeColor = UIColor(displayP3Red: 0.4, green: 0.3665, blue: 0.987, alpha: 0.4)
            circleRender.fillColor = UIColor(displayP3Red: 0.4, green: 0.3665, blue: 0.987, alpha: 0.4)
            overlayRender = circleRender
            refreshTitlesInInformationBar()
        } else if overlay.isKind(of: MKPolyline.self) {
            let polylineRender = MKPolylineRenderer(overlay: overlay)
            var color : UIColor
            
            switch (overlay as! MKPolyline).pointCount {
            case 0...150:
                color = UIColor.green
            case 151...280:
                color = UIColor.yellow
            case 281...400:
                color = UIColor.orange
            default:
                color = UIColor.red
            }
            
            polylineRender.strokeColor = color
            polylineRender.lineWidth = 2.0
            
            overlayRender = polylineRender
        }
        
        return overlayRender
    }
    
    // MARK: - UIPopoverPresentationControllerDelegate
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
