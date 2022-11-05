//
//  WeatherCell.swift
//  Weather2App
//
//  Created by 2lup on 05.11.2022.
//

import UIKit

class WeatherCell: UICollectionViewCell {
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
        self.containerView.layer.cornerRadius = self.containerView.frame.width / 2 }
}
