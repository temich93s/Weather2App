//
//  AllCitiesCell.swift
//  Weather2App
//
//  Created by 2lup on 05.11.2022.
//

import UIKit

class AllCitiesCell: UITableViewCell {
    
    // IBOutlet’s для лейбла с названием города и UIImageView для герба. в методе didSet каждого свойства напишем настройку дизайна для компонента
    @IBOutlet var cityTitleLabel: UILabel! {
        didSet {
            self.cityTitleLabel.textColor = UIColor.yellow
        }
    }
    
    @IBOutlet var cityEmblemView: UIImageView! {
        didSet {
            self.cityEmblemView.layer.borderColor = UIColor.white.cgColor
            self.cityEmblemView.layer.borderWidth = 2
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // метод для конфигурации ячейки с переданными параметрами
    func configure(city: String, emblem: UIImage) {
        self.cityTitleLabel.text = city
        self.cityEmblemView.image = emblem
        self.backgroundColor = UIColor.black
    }
    
    // обнуление изображения и текста
    override func prepareForReuse() {
        super.prepareForReuse()
        self.cityTitleLabel.text = nil
        self.cityEmblemView.image = nil
    }
    
    // сделать закругление картинки с гербом
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        cityEmblemView.clipsToBounds = true
        cityEmblemView.layer.cornerRadius = cityEmblemView.frame.width / 2
    }
}
