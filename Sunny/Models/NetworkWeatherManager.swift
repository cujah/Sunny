

import Foundation
import CoreLocation

struct NetworkWeatherManager {
    
    enum RequestType {
        case cityName(city: String)
        case coordinate(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    }
    
    var onCompletion: ((CurrentWeather) -> Void)?
    
    func fetchCurrentWeather(forRequestType requestType: RequestType) {
        var urlString = ""
        switch requestType {
        case .cityName(let city):
            urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        case .coordinate(let latitude, let longitude):
            urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        }
        performRequest(withURLString: urlString)
    }


    fileprivate func performRequest(withURLString urlString: String) {
        guard let url = URL(string: urlString) else { return }              // создаем URL (optional)
        let session = URLSession(configuration: .default)                   // создаем url-сессию (99% default)
        let task = session.dataTask(with: url) { data, response, error in   // (данные, ответ сервера, ошибка)
            if let data = data {                                            // проверяем запрос на наличие данных
                if let currentWeather = parseJSON(withData: data) {
                    self.onCompletion?(currentWeather)
                }
            }
        }
        // таск создается в "подвешенном" состоянии, и чтобы он начал работу нужен метод .resume()
        task.resume()                                                       // запускаем таск
    }
    
    
    fileprivate func parseJSON(withData data: Data) -> CurrentWeather? {
        let decoder = JSONDecoder()
        do {
            let currentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)    // указываем тип
            guard let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData) else {
                return nil
            }
            return currentWeather
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
    
}
