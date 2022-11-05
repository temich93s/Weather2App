//
//  WeatherViewController.swift
//  Weather2App
//
//  Created by 2lup on 05.11.2022.
//

import UIKit

class WeatherViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as? WeatherCell {
            cell.weather.text = "30 C"
            cell.time.text = "30.08.2017 18:00"
            return cell
        }
        return UICollectionViewCell()
    }
}
