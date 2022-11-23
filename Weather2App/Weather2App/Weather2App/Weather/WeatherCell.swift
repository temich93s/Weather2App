//
//  WeatherCell.swift
//  Weather2App
//
//  Created by 2lup on 05.11.2022.
//

import UIKit

class WeatherCell: UICollectionViewCell {
    
    // Так как экземпляр dateFormatter одинаков для всех строк, не стоит создавать его каждый раз заново, в статическом свойстве он будет создан один раз. Задаем значение этого свойства в замыкании. Это позволит создать объект форматтера, и сразу же сконфигурировать его.
    static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        // Устанавливаем градусы, используя свойство temp. Установим формат, в котором будем выводить дату. Мы используем шаблон из букв dd/MM/yyyy/HH/mm – он предназначен для дня/месяца/года/часа/минут.
        df.dateFormat = "dd.MM.yyyy HH.mm"
        return df
    }()

    @IBOutlet weak var weather: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var time: UILabel!
    
    // Добавим два IBOutlet для новых view и настроим их в методе didSet
    @IBOutlet weak var shadowView: UIView! {
        didSet {
            self.shadowView.layer.shadowOffset = .zero
            self.shadowView.layer.shadowOpacity = 0.75
            self.shadowView.layer.shadowRadius = 6
            self.shadowView.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            self.containerView.clipsToBounds = true
        }
    }
    
    // круглые view и тень
    override func layoutSubviews() {
        super.layoutSubviews()
        self.shadowView.layer.shadowPath = UIBezierPath(ovalIn: self.shadowView.bounds).cgPath
        self.containerView.layer.cornerRadius = self.containerView.frame.width / 2
    }
    
    // Теперь создадим метод configure и перенесем в него код конфигурации из контроллера.
    func configure(whithWeather weather: Weather) {
        let date = Date(timeIntervalSince1970: weather.date)
        let stringDate = WeatherCell.dateFormatter.string(from: date)
        self.weather.text = String(weather.temp)
        time.text = stringDate
        icon.image = UIImage(named: weather.weatherIcon)
    }

}
