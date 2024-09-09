import UIKit
import CoreLocation

class HomeController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var name_field: UITextField!
    var locationManager: CLLocationManager!
    var currentLatitude: Double? // The variable to store latitude
    var name: String = "" // To store the user name
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the location manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        // Request location permissions
        locationManager.requestWhenInUseAuthorization()
    }

    @IBAction func onClick(_ sender: UIButton) {
        name = name_field.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        // Assign default name if empty
        if name.isEmpty {
            name = "Default"
        }
        
        // Request the current latitude
        getLatitude()
    }

    // Function to start location updates
    func getLatitude() {
        locationManager.requestLocation() // Requests a single location update
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLatitude = location.coordinate.latitude
            locationManager.stopUpdatingLocation()
            print("Latitude fetched: \(currentLatitude!)")
            
            // Manually instantiate and present the next view controller
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let destinationVC = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
                destinationVC.userName = self.name
                destinationVC.latitude = self.currentLatitude
                
                // Present the view controller
                self.present(destinationVC, animated: true, completion: nil)
            }
        }
    }

       
       func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print("Failed to get location: \(error.localizedDescription)")
       }

       // Prepare for segue and send data to the destination view controller
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "NameAndLatitude" {
               if let destinationVC = segue.destination as? ViewController {
                   destinationVC.userName = self.name // Pass the name
                   destinationVC.latitude = self.currentLatitude // Pass the latitude
               }
           }
       }
   }
