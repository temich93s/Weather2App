//
//  GradientView.swift
//  Weather2App
//
//  Created by 2lup on 05.11.2022.
//

import UIKit

// view с градиентом
@IBDesignable class GradientView: UIView {
    
    // Изменим класс слоя на CAGradientLayer
    override static var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    // Можно создать вычисляемую переменную для удобной работы со слоем:
    var gradientLayer: CAGradientLayer {
        return self.layer as! CAGradientLayer
    }
    
    // MARK: Добавим свойства, отвечающие за параметры градиента и добавим вызов этих методов после изменения свойств, а также атрибуты @IBDesignable и @IBInspectable для поддержки редактирования и визуализации view в storyboard
    
    // Начальный цвет градиента
    @IBInspectable var startColor: UIColor = .white {
        didSet { self.updateColors() }
    }
    
    // Конечный цвет градиента
    @IBInspectable var endColor: UIColor = .black {
        didSet { self.updateColors() }
    }
    
    // Начало градиента
    @IBInspectable var startLocation: CGFloat = 0 {
        didSet { self.updateLocations() }
    }
    
    // Конец градиента
    @IBInspectable var endLocation: CGFloat = 1 {
        didSet { self.updateLocations() }
    }
    
    // Точка начала градиента
    @IBInspectable var startPoint: CGPoint = .zero {
        didSet { self.updateStartPoint() }
    }
    
    // Точка конца градиента
    @IBInspectable var endPoint: CGPoint = CGPoint(x: 0, y: 1) {
        didSet { self.updateEndPoint() }
    }
    
    // MARK: методы, которые будут обновлять параметры слоя с градиентом
    
    func updateLocations() {
        self.gradientLayer.locations = [self.startLocation as NSNumber, self.endLocation as NSNumber]
    }
    
    func updateColors() {
        self.gradientLayer.colors = [self.startColor.cgColor, self.endColor.cgColor]
    }
    
    func updateStartPoint() {
        self.gradientLayer.startPoint = startPoint
    }
    
    func updateEndPoint() {
        self.gradientLayer.endPoint = endPoint
    }
}
