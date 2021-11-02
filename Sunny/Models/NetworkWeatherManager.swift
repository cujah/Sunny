

import Foundation

struct NetworkWeatherManager {
    
    var onCompletion: ((CurrentWeather) -> Void)?
    
    func fetchCurrentWeather(forCity city: String) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)"
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
    
    func parseJSON(withData data: Data) -> CurrentWeather? {
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
