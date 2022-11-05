//
//  AllCitiesController.swift
//  Weather2App
//
//  Created by 2lup on 05.11.2022.
//

import UIKit

class AllCitiesController: UITableViewController {
    
    var cities = [
        (title: "Moscow", emblem: UIImage(named: "Drive")!),
        (title: "Krasnoyarsk", emblem: UIImage(named: "Lightwire")!),
        (title: "London", emblem: UIImage(named: "Scandroid")!),
        (title: "Paris", emblem: UIImage(named: "Drive")!),
        (title: "Nobos", emblem: UIImage(named: "Lightwire")!),
        (title: "Omsk", emblem: UIImage(named: "Scandroid")!)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    // Количество ячеек
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    // Сама ячейка
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Получаем ячейку из пула
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllCitiesCell", for: indexPath) as! AllCitiesCell
        // Получаем город для конкретной строки
        let city = self.cities[indexPath.row]
        // конфигурируем ячейку
        cell.configure(city: city.title, emblem: city.emblem)
        return cell
    }
    
}
