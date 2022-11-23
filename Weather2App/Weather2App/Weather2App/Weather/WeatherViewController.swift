//
//  WeatherViewController.swift
//  Weather2App
//
//  Created by 2lup on 05.11.2022.
//

import UIKit

class WeatherViewController: UIViewController {

    // создаем экземпляр сервиса
    let weatherService = WeatherService()
    
    // массив с погодой
    var weathers = [Weather]()
    
    // Так как мы будем работать с классом Date, представляющим дату, и необходимо получать понятное ее представление, нужен специальный класс DateFormatter для такого преобразования. Определим его свойством, так как он нужен в одном экземпляре.
    let dateFormatter = DateFormatter()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // отправим запрос для получения погоды в Москве
        weatherService.loadWeatherData(city: "Moscow") { [weak self] weathers in
            // сохраняем полученные данные в массиве, чтобы коллекция могла получить к ним доступ
            self?.weathers = weathers
            // коллекция должна прочитать новые данные
            self?.collectionView?.reloadData()
        }
    }
}

extension WeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Осталось научить коллекцию отображать полученные данные. Установим количество ячеек равным количеству элементов в массиве.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weathers.count
    }

    // Изменяем метод подготовки ячейки.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as? WeatherCell {
            // вызваtv метод конфигурирования в контроллере.
            cell.configure(whithWeather: weathers[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
}
