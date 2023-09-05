import Foundation

//final class APIManager {
//
//    func observeUsers(completion: @escaping (Result<Void, Error>) -> Void) {
//        sleep(2)
//        print(1)
//    }
//    func observeMessages(completion: @escaping (Result<Void, Error>) -> Void) {
//        sleep(3)
//        print(2)
//    }
//    func observeTeams(completion: @escaping (Result<Void, Error>) -> Void) {
//        sleep(3)
//        print(3)
//    }
//    func observeEventsFromTeam(completion: @escaping (Result<Void, Error>) -> Void) {
//        sleep(2)
//        print(4)
//    }
//
//
//    func loadSingletonData(completion: @escaping () -> Void) {
//
//        let observeCompletion: (Result<Void, Error>) -> Void = { result in
//            switch result {
//            case .success():
//                print("success")
//
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//
//        observeUsers(completion: observeCompletion)
//
//        DispatchQueue.main.async { [self] in
//            observeMessages(completion: observeCompletion)
//        }
//
//        DispatchQueue.main.async { [self] in
//            observeTeams(completion: observeCompletion)
//        }
//
//        DispatchQueue.main.async { [self] in
//            observeEventsFromTeam(completion: observeCompletion)
//            completion()
//        }
//
//
//    }
//}
//
//let api = APIManager()
//api.loadSingletonData {
//    print("hello")
//}

class One {
    static let shared = One()
    private init() {}
    var counter = 0

    
    func myFunction(completion: @escaping () -> ()) {
        let group = DispatchGroup()
        group.enter()

        DispatchQueue.global().async {
            sleep(2)
            group.enter()
            DispatchQueue.global().async() { [self] in
                for i in 0...3 {
                    group.enter()
                    sleep(2)
                    counter += 2
                    group.leave()
                }
                group.leave()
            }
            group.leave()
        }
        group.notify(queue: .main) {
            print("counter notify", self.counter)
            completion()
        }
    }
}

class Three {
    var index = 0
    
    func youFunction(observeCounter: @escaping () -> Int, completion: @escaping () -> ()) {
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.global().async {
            sleep(1)
            
            group.enter()
            DispatchQueue.global().async() { [self] in
                let counter = observeCounter()
                for i in 0...counter {
                    group.enter()
                    
                    sleep(1)
                    index += 2
                    group.leave()
                }
                group.leave()
            }
            group.leave()
        }
        group.notify(queue: .main) {
            print("index notify", self.index)
            print(self.index)
            completion()
        }
    }
}


class Two {
    let one = One.shared
    let three = Three()
    
    func observe() {
        let group = DispatchGroup()
        group.enter()
        one.myFunction {
            group.leave()
        }
        group.enter()
        three.youFunction(observeCounter: { [weak one] in
            return one?.counter ?? 0
        }) {
            group.leave()
        }
        
        group.notify(queue: .main) {
            print("happy")
        }
    }
}


let two = Two()
two.observe()

//
//Хорошо, я могу помочь вам с написанием функции showLoadingView для отображения представления загрузки поверх текущего UIViewController без использования Storyboard на языке Swift с использованием UIKit.
//
//Прежде всего, нам потребуется создать кастомное представление (view) для отображения индикатора загрузки. Мы можем использовать UIActivityIndicatorView для этой цели:
//
//import UIKit
//
//class LoadingView: UIView {
//    private let activityIndicatorView: UIActivityIndicatorView = {
//        let indicatorView = UIActivityIndicatorView(style: .large)
//        indicatorView.translatesAutoresizingMaskIntoConstraints = false
//        indicatorView.startAnimating()
//        return indicatorView
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        // Настройка внешнего вида представления загрузки (если нужно)
//        backgroundColor = .white
//
//        // Добавление индикатора загрузки к представлению
//        addSubview(activityIndicatorView)
//
//        // Настройка constraints для индикатора загрузки
//        NSLayoutConstraint.activate([
//            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
//            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
//        ])
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//
//В этом примере мы создаем кастомное представление LoadingView, которое содержит UIActivityIndicatorView. Мы также настраиваем constraints для центрирования индикатора загрузки в представлении. Представление автоматически запускает анимацию индикатора загрузки при создании.
//
//Теперь, чтобы использовать это представление во время загрузки данных, мы можем создать расширение для UIViewController, которое будет добавлять метод showLoadingView:
//
//extension UIViewController {
//    private static var loadingViewKey: UInt8 = 0
//
//    func showLoadingView() {
//        // Проверяем, не показывается ли уже представление загрузки
//        guard let _ = objc_getAssociatedObject(self, &UIViewController.loadingViewKey) as? LoadingView else {
//            let loadingView = LoadingView(frame: view.bounds)
//            view.addSubview(loadingView)
//
//            // Сохраняем экземпляр представления загрузки в ассоциированный объект
//            objc_setAssociatedObject(self, &UIViewController.loadingViewKey, loadingView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//
//            return
//        }
//    }
//
//    func hideLoadingView() {
//        // Удаляем представление загрузки
//        if let loadingView = objc_getAssociatedObject(self, &UIViewController.loadingViewKey) as? LoadingView {
//            loadingView.removeFromSuperview()
//
//            // Удаляем ссылку на представление загрузки
//            objc_setAssociatedObject(self, &UIViewController.loadingViewKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }
//}
//
//
//В этом расширении для UIViewController мы определяем метод showLoadingView, который добавляет LoadingView поверх текущего представления. Мы сохраняем экземпляр LoadingView в ассоциированном объекте с использованием objc_setAssociatedObject. Мы также определяем метод hideLoadingView, который удаляет представление загрузки.
//
//
//
//
//
//итесь, что у вас есть экземпляр NotificationCenterManager и все необходимые импорты для правильной работы этого кода.
//
//
//
//Понял! Проблема заключается в том, что при использовании события observe(.childAdded), Firebase присылает все дочерние элементы, включая те, которые мы уже получили ранее с помощью observeSingleEvent.
//
//Чтобы избежать повторного добавления уже полученных данных, мы можем использовать дополнительную проверку перед добавлением элемента в массив. Мы можем проверить, есть ли уже элемент с таким же идентификатором (Snapshot Key) в массиве перед добавлением.
//
//Вот обновленный пример кода для этой ситуации:
//
//import Firebase
//
//// Получаем ссылку на базу данных Firebase Realtime
//let ref = Database.database().reference()
//
//// Получаем ссылку на узел "users"
//let usersRef = ref.child("users")
//
//// Создаем массив для хранения пользователей
//var users: [User] = []
//
//// Обрабатываем событие observeSingleEvent для получения всех пользователей из базы данных
//usersRef.observeSingleEvent(of: .value) { (snapshot) in
//    if let usersSnapshot = snapshot.children.allObjects as? [DataSnapshot] {
//        for userSnapshot in usersSnapshot {
//            if let userDict = userSnapshot.value as? [String: Any] {
//                let user = User(dictionary: userDict)
//
//                // Проверяем, есть ли уже элемент с таким же идентификатором (Snapshot Key) в массиве
//                let alreadyAdded = users.contains { $0.id == userSnapshot.key }
//
//                if !alreadyAdded {
//                    users.append(user)
//                }
//            }
//        }
//
//        // Здесь можешь выполнить какую-либо логику после заполнения массива users
//        print("Массив пользователей был заполнен успешно!")
//    }
//}
//
//// Обрабатываем событие observe для отслеживания любых изменений в "users"
//usersRef.observe(.childAdded) { (snapshot) in
//    if let userDict = snapshot.value as? [String: Any] {
//        let user = User(dictionary: userDict)
//
//        // Проверяем, есть ли уже элемент с таким же идентификатором (Snapshot Key) в массиве
//        let alreadyAdded = users.contains { $0.id == snapshot.key }
//
//        if !alreadyAdded {
//            users.append(user)
//
//            // Здесь можешь выполнить какую-либо логику после добавления нового элемента в массив users
//            print("Новый пользователь был добавлен!")
//        }
//    }
//}
//
//// Вспомогательная модель данных User
//struct User {
//    let id: String
//    let name: String
//    let age: Int
//
//    init(dictionary: [String: Any]) {
//        self.id = dictionary["id"] as? String ?? ""
//        self.name = dictionary["name"] as? String ?? ""
//        self.age = dictionary["age"] as? Int ?? 0
//    }
//}
//
//
//В этом обновленном примере кода добавлена проверка перед добавлением элементов в массив. Мы используем users.contains с замыканием, чтобы проверить, есть ли уже элемент с тем же значением идентификатора (snapshot.key). Если такой элемент уже существует, мы его не добавляем в массив.
//
//Теперь при использовании события .childAdded, только новые элементы будут добавлены в массив users.
//
//Надеюсь, эти обновления помогут решить проблему! Если у тебя возникнут еще вопросы, не стесняйся задавать дальше!




