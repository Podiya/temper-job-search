//
//  JobMapViewController.swift
//  TemperWorks
//
//  Created by Ravindu Senevirathna on 10/10/20.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa


class JobMapViewController: BaseViewController {
    
    private let viewModel: JobMapViewModel
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var mapView: MKMapView!
    private let locationManager = CLLocationManager()
    private let disposeBag = DisposeBag()
    private var isLocationEnable = false
    
    init(viewModel: JobMapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: Self.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isLocationEnable {
            viewModel.fetchJobs(by: Date())
        }
    }
    
    override func setupUI() {
        super.setupUI()
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(didChangedDate), for: .valueChanged)
        
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
    override func setupViewModelListners() {
        super.setupViewModelListners()
        
        _ = viewModel.status.bind { status in
            DispatchQueue.main.async {
                status == .fetching ? self.showHud() : self.hideHud()
            }
        }.disposed(by: disposeBag)
        
        _ = viewModel.error.bind { error in
            guard let e = error else { return }
            self.showAlert(text: e, type: FloatingAlertType.error)
        }.disposed(by: disposeBag)
        
        _ = viewModel.jobsObserver.bind { objects in
            self.markJobLocationsOnMap(objects)
        }
    }
    
    @objc func didChangedDate() {
        if isLocationEnable {
            viewModel.fetchJobs(by: datePicker.date)
        }
    }
    
    @IBAction func didPressClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func checkLocationServices() {
        locationManager.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorization()
        } else {
            self.showAlert(text: "Please enable location service for further actions.", type: .error)
        }
    }
    
    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            isLocationEnable = true
        case .denied, .restricted:
            isLocationEnable = false
            self.showAlert(text: "You have restricted accessing location on your phone. Please enable location for further actions.", type: .error)
            break
        case .notDetermined:
            isLocationEnable = false
            locationManager.requestWhenInUseAuthorization()
            break
        default:
            break
        }
    }
    
    private func markJobLocationsOnMap(_ locations: [JobMapLocationViewModel]) {
        DispatchQueue.main.async {
            self.mapView.removeAnnotations(self.mapView.annotations)
            for location in locations {
                let annotations = MKPointAnnotation()
                annotations.title = location.name
                annotations.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                annotations.subtitle = "Shift \(location.shiftTime)"
                self.mapView.addAnnotation(annotations)
            }
        }
    }
}

extension JobMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            self.viewModel.fetchJobs(by: Date())
            break
        case .denied, .restricted:
            isLocationEnable = false
            self.showAlert(text: "You have restricted accessing location on your phone. Please enable location for further actions.", type: .error)
            break
        default:
           break
        }
    }
}

extension JobMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKUserLocation) {
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: "reuseIdentifier") as? MKMarkerAnnotationView
            if view == nil {
                view = MKMarkerAnnotationView(annotation: nil, reuseIdentifier: "reuseIdentifier")
            }
            view?.annotation = annotation
            view?.displayPriority = .required
            view?.canShowCallout = true
            return view
        } else {
            return nil
        }
    }
}
