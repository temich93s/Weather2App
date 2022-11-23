//
//  WeatherService.swift
//  Weather2App
//
//  Created by 2lup on 21.11.2022.
//

import Foundation
import Alamofire

class WeatherService {
    // базовый URL сервиса
    let baseUrl = "http://api.openweathermap.org"
    // ключ для доступа к сервису
    let apiKey = "92cabe9523da26194b02974bfcd50b7e"
    
    // Получим массив объектов Weather. Теперь их надо показать на экране. Ответ Alamofire, как и URLSession, обрабатывается асинхронно, параллельно основному потоку, так что, чтобы вытащить из responseData-замыкания данные, мы будем использовать замыкание. Замыкание мы передадим в метод получения данных loadWeatherData. После того, как получим данные, вызовем замыкание и передадим ему полученные данные.
    func loadWeatherData(city: String, completion: @escaping ([Weather]) -> Void) {
        // путь для получения погоды за 5 дней
        let path = "/data/2.5/forecast"
        // параметры, город, единицы измерения градусы, ключ для доступа к сервису
        let parameters: Parameters = [ "q": city,
                                       "units": "metric",
                                       "appid": apiKey ]
        // составляем URL из базового адреса сервиса и конкретного пути к ресурсу
        let url = baseUrl + path
        // делаем запрос
        AF.request(url, method: .get, parameters: parameters).responseData { response in
            // парсим json.
            guard let data = response.value else { return }
            let weather = try! JSONDecoder().decode(WeatherResponse.self, from: data).list
            // После того, как получим данные, вызовем замыкание и передадим ему полученные данные.
            completion(weather)
        }
    }
    
}
