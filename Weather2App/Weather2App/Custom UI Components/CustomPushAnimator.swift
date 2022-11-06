//
//  CustomPushAnimator.swift
//  Weather2App
//
//  Created by 2lup on 06.11.2022.
//

import UIKit

// создадим анимации переходов между экранами в UINavigationViewController. Добавим такой переход, при котором текущий экран отдаляется и смещается в левую сторону, а следующий появляется справа и становится на его место
final class CustomPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    // Задаем длительность анимации — 0,6 секунды
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    // Указывает объекту-аниматору как выполнять анимацию перехода.
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // Сначала получаем текущий и следующий view controller:
        guard let source = transitionContext.viewController(forKey: .from) else { return }
        guard let destination = transitionContext.viewController(forKey: .to) else { return }
        
        // добавляем следующий view controller в контейнер и задаем начальные frame и transform
        transitionContext.containerView.addSubview(destination.view)
        destination.view.frame = source.view.frame
        destination.view.transform = CGAffineTransform(translationX: source.view.frame.width, y: 0)
        
        // Изначально следующий view controller находится справа за пределами экрана
        
        // keyframe-анимацию, будет состоять из трех кадров
        // Осталось вставить эти keyframe в анимацию и правильно обработать completion-блок:
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext),
                                delay: 0,
                                options: .calculationModePaced,
                                animations: {
            // на первом будет удаляться текущий view controller
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.75,
                               animations: {
                let translation = CGAffineTransform(translationX: -200, y: 0)
                let scale = CGAffineTransform(scaleX: 0.8, y: 0.8)
                source.view.transform = translation.concatenating(scale)
            })
            // на втором следующий view controller будет немного увеличиваться и накрывать текущий
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.4,
                               animations: {
                let translation = CGAffineTransform(translationX: source.view.frame.width / 2, y: 0)
                let scale = CGAffineTransform(scaleX: 1.2, y: 1.2)
                destination.view.transform = translation.concatenating(scale)
            })
            // на последнем кадре следующий view controller полностью накроет текущий.
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4,
                               animations: {
                destination.view.transform = .identity
            })
        // в completion-блоке мы возвращаем текущему view прежнюю трансформацию, если анимация закончилась и переход не был отменен. Это нужно, чтобы трансформация всегда была правильной, если будем переходить с одного экрана на другой и возвращаться несколько раз.
        }) { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
}

