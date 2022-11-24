//
//  WeatherService.swift
//  Weather2App
//
//  Created by 2lup on 21.11.2022.
//

import Foundation
import Alamofire
import RealmSwift
import SwiftyJSON

class WeatherService {
    // базовый URL сервиса
    let baseUrl = "http://api.openweathermap.org"
    // ключ для доступа к сервису
    let apiKey = "92cabe9523da26194b02974bfcd50b7e"
    
    // Получим массив объектов Weather. Теперь их надо показать на экране. Ответ Alamofire, как и URLSession, обрабатывается асинхронно, параллельно основному потоку, так что, чтобы вытащить из responseData-замыкания данные, мы будем использовать замыкание. Замыкание мы передадим в метод получения данных loadWeatherData. После того, как получим данные, вызовем замыкание и передадим ему полученные данные.
    func loadWeatherData(city: String, completion: @escaping ([WeatherSwiftyJSON]) -> Void) {
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
            // let weather = try! JSONDecoder().decode(WeatherSwiftyJSON.self, from: data).list
            // вызваем метод сохранения данных при получении их с сервера.
            // self.saveWeatherData(weather)
            // print(weather)
            
            guard let data = response.value else { return }
            do {
                let json = try JSON(data: data)
                var weather: [WeatherSwiftyJSON] = []
                print(json["list"].arrayValue.count)
                for index in 0..<json["list"].arrayValue.count {
                    guard let safeWeater = WeatherSwiftyJSON(json: json, index: index) else { continue }
                    weather.append(safeWeater)
                }
                print(weather)
                // После того, как получим данные, вызовем замыкание и передадим ему полученные данные.
                completion(weather)
            } catch {
                print(error)
            }
        }
    }
    
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
