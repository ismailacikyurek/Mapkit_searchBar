//
//  ViewController.swift
//  haritaüzerindearamaislemi
//
//  Created by İSMAİL AÇIKYÜREK on 9.05.2022.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var mapView: MKMapView!
    
    let istek = MKLocalSearch.Request()
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        mapView.delegate = self
        
        let konum = CLLocationCoordinate2D(latitude: 41.0370014, longitude: 28.9763369)
        let span  = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        let bolge = MKCoordinateRegion(center: konum, span: span)
        mapView.setRegion(bolge, animated: true)
        
      istek.region = mapView.region
  
    }


}

extension ViewController : UISearchBarDelegate, MKMapViewDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        istek.naturalLanguageQuery = searchBar.text!
        
        if mapView.annotations.count > 0 {
            mapView.removeAnnotations(mapView.annotations)
        }
        let arama = MKLocalSearch(request: istek)
        
        arama.start { response, error in
            if error != nil {
                print("hata")
            } else if response!.mapItems.count == 0 {
                print("mekan yok")
            } else {
               
                for mekan in response!.mapItems {
                    
                    if let ad = mekan.name, let tel = mekan.phoneNumber {
                        print("ad : \(ad)")
                        print("tel  : \(tel)")
                        print("enlem : \(mekan.placemark.coordinate.latitude)")
                        print("enlem : \(mekan.placemark.coordinate.longitude)")
                        
                        let pin = MKPointAnnotation()
                        pin.coordinate = mekan.placemark.coordinate
                        pin.title = ad
                        pin.subtitle = tel
                        self.mapView.addAnnotation(pin)
                    }
                }
            }
        }
    }
    
}

    
