

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeTemperatureLabel: UILabel!
    
    var networkWeatheManager = NetworkWeatherManager()
    
    @IBAction func searchPressed(_ sender: UIButton) {
        self.presentSearchAlertController(withTitle: "Enter city name",
                                          message: nil,
                                          style: .alert) { city in
            self.networkWeatheManager.fetchCurrentWeather(forCity: city)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        networkWeatheManager.delegate = self
        networkWeatheManager.fetchCurrentWeather(forCity: "London") 
        
        
    }
}

extension ViewController: NetworkWeatherManagerDelegate {
    func updateViewController(_: NetworkWeatherManager, with currentWeather: CurrentWeather) {
        
        print(currentWeather.cityName)
        
    }
}
