//
//  LoginFormController.swift
//  Weather2App
//
//  Created by 2lup on 05.11.2022.
//

import UIKit

class LoginFormController: UIViewController {

    @IBOutlet weak var loginInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginTitleView: UILabel!
    @IBOutlet weak var passwordTitleView: UILabel!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var authButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Жест нажатия
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        // Присваиваем его UIScrollVIew
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
        
        // Les8 - Сначала потребуется создать UIPanGestureRecognizer и добавить его на основной view экрана:
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        self.view.addGestureRecognizer(recognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Подписываемся на два уведомления: одно приходит при появлении клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // Второе — когда она пропадает
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Запуск анимаций
        animateTitlesLes8()
        animateInputsLes8()
        animateTitleLes8()
//        animateTitlesAppearing()
//        animateTitleAppearing()
//        animateAuthButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // метод отписки при исчезновении контроллера с экрана
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        // Получаем текст логина
        let login = loginInput.text!
        // Получаем текст-пароль
        let password = passwordInput.text!
        // Проверяем, верны ли они
        if login == "admin" && password == "123456" {
            print("успешная авторизация")
        } else {
            print("неуспешная авторизация")
        }
    }
    
    // Осуществление перехода при успешной авторизации
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        // Проверяем данные
        let checkResult = checkUserData()
        // Если данные не верны, покажем ошибку
        if !checkResult {
            showLoginError()
        }
        // Вернем результат
        return checkResult
    }
    
    // Проверка логина и пароля при переходе
    func checkUserData() -> Bool {
        guard let login = loginInput.text,
              let password = passwordInput.text
        else { return false }
        if login == "admin" && password == "123456" {
            return true
        } else {
            return false
        }
    }
    
    // создание экшена
    func showLoginError() {
        // Создаем контроллер
        let alter = UIAlertController(title: "Ошибка", message: "Введены не верные данные пользователя", preferredStyle: .alert)
        // Создаем кнопку для UIAlertController
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        // Добавляем кнопку на UIAlertController
        alter.addAction(action)
        // Показываем UIAlertController
        present(alter, animated: true, completion: nil)
    }
    
    // исчезновение клавиатуры при клике по пустому месту на экране
    @objc func hideKeyboard() {
        self.scrollView?.endEditing(true)
    }
    
    // Когда клавиатура появляется
    @objc func keyboardWasShown(notification: Notification) {
        // Получаем размер клавиатуры
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        // Добавляем отступ внизу UIScrollView, равный размеру клавиатуры
        self.scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    //Когда клавиатура исчезает
    @objc func keyboardWillBeHidden(notification: Notification) {
        // Устанавливаем отступ внизу UIScrollView, равный 0
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
    }
    
    // сделаем простой вылет из краев над полями ввода логина и пароля

    func animateTitlesAppearing() {
        let offset = view.bounds.width
        loginTitleView.transform = CGAffineTransform(translationX: -offset, y: 0)
        passwordTitleView.transform = CGAffineTransform(translationX: offset, y: 0)
        UIView.animate(withDuration: 1, delay: 1, options: .curveEaseOut, animations: {
            self.loginTitleView.transform = .identity
            self.passwordTitleView.transform = .identity
            }, completion: nil)
    }
    
    // Для заголовка Weather создадим пружинную анимацию, будто он опускается немного ниже своего конечного местоположения, а затем возвращается к нему.
    func animateTitleAppearing() {
        self.titleView.transform = CGAffineTransform(translationX: 0, y: -self.view.bounds.height / 2)
        UIView.animate(withDuration: 1, delay: 1,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,
                       animations: { self.titleView.transform = .identity },
                       completion: nil)
    }
    
    // К кнопке «Войти» применим пружинную анимацию увеличения и тоже будем использовать анимации слоя.
    func animateAuthButton() {
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = 0
        animation.toValue = 1
        animation.stiffness = 200
        animation.mass = 2
        animation.duration = 2
        animation.beginTime = CACurrentMediaTime() + 1
        animation.fillMode = CAMediaTimingFillMode.backwards
        self.authButton.layer.add(animation, forKey: nil)
    }
    
    // анимация для надписей над полями ввода логина и пароля. Для них применим keyframe-анимацию, при которой эти надписи будут меняться местами.
    func animateTitlesLes8() {
        // Зададим начальную трансформацию. Чтобы поставить надписи на соседнее место, достаточно поменять их центры. Для этого — вычислить расстояние по оси y и сделать трансформацию
        let offset = abs(self.loginTitleView.frame.midY - self.passwordTitleView.frame.midY)
        self.loginTitleView.transform = CGAffineTransform(translationX: 0, y: offset)
        self.passwordTitleView.transform = CGAffineTransform(translationX: 0, y: -offset)
        
        // создадим keyframe-анимацию и добавим в нее ключевые кадры. Первым будет перемещение в сторону и вниз, а вторым — на исходное положение
        UIView.animateKeyframes(withDuration: 1, delay: 1, options: .calculationModeCubicPaced,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5,
                    animations: {
                        self.loginTitleView.transform = CGAffineTransform(translationX: 150, y: 50)
                        self.passwordTitleView.transform = CGAffineTransform(translationX: -150, y: -50)
                        })
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5,
                    animations: {
                        self.loginTitleView.transform = .identity
                        self.passwordTitleView.transform = .identity
                        })
                },
            completion: nil)
    }
    
    // Для полей ввода будем использовать предыдущую анимацию плавного появления с одновременным увеличением.
    func animateInputsLes8() {
        let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
        fadeInAnimation.fromValue = 0
        fadeInAnimation.toValue = 1
        
        let scaleAnimation = CASpringAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0
        scaleAnimation.toValue = 1
        scaleAnimation.stiffness = 150
        scaleAnimation.mass = 2
        
        let animationsGroup = CAAnimationGroup()
        animationsGroup.duration = 1
        animationsGroup.beginTime = CACurrentMediaTime() + 1
        animationsGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animationsGroup.fillMode = CAMediaTimingFillMode.backwards
        animationsGroup.animations = [fadeInAnimation, scaleAnimation]
        
        self.loginInput.layer.add(animationsGroup, forKey: nil)
        self.passwordInput.layer.add(animationsGroup, forKey: nil)
    }
    
    // Анимацию для заголовка менять не будем, а сделаем с помощью UIViewpropertyAnimator
    func animateTitleLes8() {
        self.titleView.transform = CGAffineTransform(translationX: 0, y: -self.view.bounds.height / 2)
        let animator = UIViewPropertyAnimator(duration: 1, dampingRatio: 0.5,
                                              animations: { self.titleView.transform = .identity })
        animator.startAnimation(afterDelay: 1)
    }
    
    // Создадим интерактивную анимацию для кнопки авторизации. Сделаем так, чтобы ее можно было оттягивать вниз, а при отпускании она бы с эффектом пружины возвращалась на исходную точку.
    
    var interactiveAnimator: UIViewPropertyAnimator!
    
    @objc func onPan(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            interactiveAnimator?.startAnimation()
            interactiveAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.5,
                                                         animations: {
                self.authButton.transform = CGAffineTransform(translationX: 0, y: 150)
            })
            interactiveAnimator.pauseAnimation()
        case .changed:
            let translation = recognizer.translation(in: self.view)
            interactiveAnimator.fractionComplete = translation.y / 100
        case .ended:
            interactiveAnimator.stopAnimation(true)
            interactiveAnimator.addAnimations {
                self.authButton.transform = .identity
            }
            interactiveAnimator.startAnimation()
        default: return
        }
    }
    
}
