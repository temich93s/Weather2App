//
//  WeekDayPicker.swift
//  Weather2App
//
//  Created by 2lup on 05.11.2022.
//

import UIKit

// перечисление, содержащее все дни недели
// Сделаем его типа Int, тогда каждый элемент будет иметь порядковый номер в неделе
enum Day: Int {
    
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    
    static let allDays: [Day] = [monday, tuesday, wednesday, thursday, friday, saturday, sunday]
    
    // переменную title, которая будет возвращать сокращенное название дня
    var title: String {
        switch self {
        case .monday: return "ПН"
        case .tuesday: return "ВТ"
        case .wednesday: return "СР"
        case .thursday: return "ЧТ"
        case .friday: return "ПТ"
        case .saturday: return "СБ"
        case .sunday: return "ВС"
        }
    }
}

// Класс, который будет наследником UIControl
@IBDesignable class WeekDayPicker: UIControl {
    
    // Чтобы сохранять выбранный день, создадим переменную selectedDay
    var selectedDay: Day? = nil {
        didSet {
            // Метод updateSelectedDay вызывается каждый раз при изменении свойства selectedDay
            self.updateSelectedDay()
            // метод sendActions, который сообщит об изменении значения контрола
            self.sendActions(for: .valueChanged)
        }
    }
    
    // Контрол будет состоять из семи кнопок, которые находятся в UIStackView
    private var buttons: [UIButton] = []
    private var stackView: UIStackView!
    
    // Метод setupView нужно вызвать в инициализаторах класса
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    // Метод, отвечающий за создание UIStackView и кнопок,
    private func setupView() {
        for day in Day.allDays {
            let button = UIButton(type: .system)
            button.setTitle(day.title, for: .normal)
            button.setTitleColor(.lightGray, for: .normal)
            button.setTitleColor(.white, for: .selected)
            button.addTarget(self, action: #selector(selectDay(_:)), for: .touchUpInside)
            self.buttons.append(button)
        }
        
        stackView = UIStackView(arrangedSubviews: self.buttons)
        self.addSubview(stackView)
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
    }
    
    // Метод, который будет обновлять интерфейс в соответствии с выбранной кнопкой
    private func updateSelectedDay() {
        for (index, button) in self.buttons.enumerated() {
            guard let day = Day(rawValue: index) else { continue }
            button.isSelected = day == self.selectedDay
        }
    }
    
    // Чтобы обработать нажатия на кнопки, создадим метод selectDay
    @objc private func selectDay(_ sender: UIButton) {
        guard let index = self.buttons.index(of: sender) else { return }
        guard let day = Day(rawValue: index) else { return }
        self.selectedDay = day
    }
    
    // Мы не установили констрейнты для UIStackView. Вместо них будем менять frame в методе layoutSubviews:
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
}
