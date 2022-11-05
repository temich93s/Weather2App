//
//  AllCitiesController.swift
//  Weather2App
//
//  Created by 2lup on 05.11.2022.
//

import UIKit

class AllCitiesController: UITableViewController {

    var cities = ["Moscow", "Krasnoyarsk", "London", "Paris"]
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! AllCitiesCell
        // Получаем город для конкретной строки
        let city = cities[indexPath.row]
        // Устанавливаем город в надпись ячейки
        cell.cityName.text = city
        return cell
    }
    
}
