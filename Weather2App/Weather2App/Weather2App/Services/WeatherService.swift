//
//  WeatherService.swift
//  Weather2App
//
//  Created by 2lup on 21.11.2022.
//

// import Alamofire

import Foundation
import RealmSwift
import SwiftyJSON

class WeatherService {
    let apiKey = "92cabe9523da26194b02974bfcd50b7e"
    
    func loadWeatherData(city: String, completion: @escaping ([WeatherSwiftyJSON]) -> Void) {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "http"
        urlConstructor.host = "api.openweathermap.org"
        urlConstructor.path = "/data/2.5/forecast"
        urlConstructor.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "appid", value: apiKey)
        ]
        guard let urlConstructor = urlConstructor.url else { return }
        let task = session.dataTask(with: urlConstructor) { (data, response, error) in
            guard let data = data else { return }
            var weather: [WeatherSwiftyJSON] = []
            do {
                let json = try JSON(data: data)
                print(json["list"].arrayValue.count)
                for index in 0..<json["list"].arrayValue.count {
                    guard let safeWeater = WeatherSwiftyJSON(json: json, index: index) else { continue }
                    weather.append(safeWeater)
                }
                completion(weather)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
        
//        let baseUrl = "http://api.openweathermap.org"
//        let apiKey = "92cabe9523da26194b02974bfcd50b7e"
//
//        let path = "/data/2.5/forecast"
//        let parameters: Parameters = [ "q": city,
//                                       "units": "metric",
//                                       "appid": apiKey ]
//        let url = baseUrl + path
//        AF.request(url, method: .get, parameters: parameters).responseData { response in
//            guard let data = response.value else { return }
//            do {
//                let json = try JSON(data: data)
//                var weather: [WeatherSwiftyJSON] = []
//                print(json["list"].arrayValue.count)
//                for index in 0..<json["list"].arrayValue.count {
//                    guard let safeWeater = WeatherSwiftyJSON(json: json, index: index) else { continue }
//                    weather.append(safeWeater)
//                }
//                print(weather)
//                completion(weather)
//            } catch {
//                print(error)
//            }
//        }
//    }
    
    //сохранение погодных данных в Realm. У метода есть аргумент, массив объектов погоды, именно его мы будем сохранять в Realm.

    func saveWeatherData(_ weathers: [WeatherSwiftyJSON]) {
        // обработка исключений при работе с хранилищем. Исключения будут созданы, если при получении доступа к хранилищу возникнет ошибка, например, структура хранилища не будет соответствовать объекту или он может не оказаться на устройстве.
        do {
            // получаем доступ к хранилищу.  Мы получаем объект класса Realm для доступа к хранилищу
            let realm = try Realm()
            // начинаем изменять хранилище. Имея эти объекты, мы начнем сеанс записи командой realm.beginWrite(), добавим все наши объекты в хранилище realm.add(weathers) и завершим сеанс записи командой try realm.commitWrite().
            realm.beginWrite()
            // кладем все объекты класса погоды в хранилище. Если попытаться изменить данные в хранилище без сеанса записи, мы увидим ошибку в консоли, а приложение упадет
            // realm.add(weathers)
            // завершаем изменения хранилища
            try realm.commitWrite()
        } catch {
            // если произошла ошибка, выводим ее в консоль
            print(error)
        }
    }
    
}
