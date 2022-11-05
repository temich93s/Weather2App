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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Подписываемся на два уведомления: одно приходит при появлении клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // Второе — когда она пропадает
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Запуск анимаций
        animateTitlesAppearing()
        animateTitleAppearing()
        animateAuthButton()
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
}
