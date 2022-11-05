//
//  WeatherCollectionViewLayout.swift
//  Weather2App
//
//  Created by 2lup on 05.11.2022.
//

import UIKit

// Кастомного layout для коллекции на экране погоды
class WeatherCollectionViewLayout: UICollectionViewLayout {
    
    // Хранит атрибуты для заданных индексов
    var cacheAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    // Количество столбцов
    var columnsCount = 2
    // Высота ячейки
    var cellHeight: CGFloat = 150
    // Хранит суммарную высоту всех ячеек
    private var totalCellsHeight: CGFloat = 0
    
    // нужно переопределить метод prepare. Это самая сложная часть в разработке кастомного layout
    override func prepare() {
        // Инициализируем атрибуты
        self.cacheAttributes = [:]
        // Проверяем наличие collectionView
        guard let collectionView = self.collectionView else { return }
        // Проверяем, что в секции есть хотя бы одна ячейка
        let itemsCount = collectionView.numberOfItems(inSection: 0)
        guard itemsCount > 0 else { return }
        
        // Далее нужно определить ширину для большой ячейки и для маленькой:
        let bigCellWidth = collectionView.frame.width
        let smallCellWidth = collectionView.frame.width / CGFloat(self.columnsCount)
        
        // Переменные lastX и lastY, которые будут хранить последние x и y для вычисления origin каждого frame:
        var lastY: CGFloat = 0
        var lastX: CGFloat = 0
        
        // Затем нужно посчитать frame для каждой ячейки. Для этого добавим цикл, в котором будем создавать атрибуты для ячейки и считать frame
        for index in 0..<itemsCount {
            let indexPath = IndexPath(item: index, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            // Теперь вычисление frame разделится на две части — для большой и для маленькой ячейки. Чтобы определить, большая ячейка или маленькая, достаточно взять остаток от деления (текущего индекса + 1) на (количество столбцов + 1). Если остаток равен 0, это большая ячейка
            let isBigCell = (index + 1) % (self.columnsCount + 1) == 0
            
            // Напишем вычисление frame в зависимости от ячейки
            if isBigCell {
                attributes.frame = CGRect(x: 0, y: lastY, width: bigCellWidth, height: self.cellHeight)
                lastY += self.cellHeight
            } else {
                attributes.frame = CGRect(x: lastX, y: lastY, width: smallCellWidth, height: self.cellHeight)
                let isLastColumn = (index + 2) % (self.columnsCount + 1) == 0 || index == itemsCount - 1
                if isLastColumn {
                    lastX = 0
                    lastY += self.cellHeight
                } else {
                    lastX += smallCellWidth
                }
            }
            
            // добавим атрибуты в словарь
            cacheAttributes[indexPath] = attributes
            // присвоим значение переменной totalCellsHeight
            self.totalCellsHeight = lastY
        }
    }
    
    // Теперь нужно переопределить методы, которые возвращают атрибуты для заданных области и индекса:
    // Получает атрибуты компоновки для всех ячеек и видов в указанном прямоугольнике.
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cacheAttributes.values.filter { attributes in
            return rect.intersects(attributes.frame)
        }
    }
    
    // Получает информацию о макете элемента по указанному пути индекса с соответствующей ячейкой.
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cacheAttributes[indexPath]
    }
    
    // Осталось переопределить свойство collecitonViewContentSize:
    override var collectionViewContentSize: CGSize {
        return CGSize(width: self.collectionView?.frame.width ?? 0, height: self.totalCellsHeight)
    }
}
