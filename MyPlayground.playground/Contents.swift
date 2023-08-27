
import UIKit

// Общая реализация кода для работы с API
class APIManager {
    static let shared = APIManager()
    
    private init() {}
    
    func fetchData(url: URL, completion: @escaping (Data?, Error?) -> Void) {
        // Здесь может быть реализация отправки запроса и получения данных
        // ...
        
        // Пример асинхронного выполнения запроса с задержкой в 2 секунды
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let data = Data() // Вместо пустых данных здесь должны быть полученные данные
            completion(data, nil)
        }
    }
}

// Пример использования первого API
class FirstAPI {
    func fetchData(completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: "https://api.first.com/data") else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        APIManager.shared.fetchData(url: url, completion: completion)
    }
}

// Пример использования второго API
class SecondAPI {
    func fetchData(completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: "https://api.second.com/data") else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        APIManager.shared.fetchData(url: url, completion: completion)
    }
}

// Пример использования API
let firstAPI = FirstAPI()
firstAPI.fetchData { (data, error) in
    if let error = error {
        print("Ошибка при получении данных из первого API: \(error)")
    } else {
        print("Данные из первого API: \(data ?? Data())")
    }
}

let secondAPI = SecondAPI()
secondAPI.fetchData { (data, error) in
    if let error = error {
        print("Ошибка при получении данных из второго API: \(error)")
    } else {
        print("Данные из второго API: \(data ?? Data())")
    }
}


class APIManager {
    static let shared = APIManager()
    
    private init() {}
    
    func fetchData(url: URL, completion: @escaping (Data?, Error?) -> Void) {
        // Здесь может быть реализация отправки запроса и получения данных
        // ...
        
        // Пример асинхронного выполнения запроса с задержкой в 2 секунды
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let data = Data() // Вместо пустых данных здесь должны быть полученные данные
            completion(data, nil)
        }
    }
    
    func clearData(completion: @escaping () -> Void) {
        // Очистка данных из синглтона
        // ...
        
        completion()
    }
    
    func reloadData(completion: @escaping (Data?, Error?) -> Void) {
        clearData {
            guard let url = URL(string: "https://api.first.com/data") else {
                completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
                return
            }
            
            self.fetchData(url: url, completion: completion)
        }
    }
}


В приведенном выше коде добавлены два новых метода: clearData(completion:) для очистки данных из синглтона и reloadData(completion:) для повторной загрузки данных.

Метод clearData(completion:) должен содержать логику очистки данных из синглтона, например, сбросить значения свойств или удалить объекты из коллекций.

Метод reloadData(completion:) вызывает clearData(completion:) для очистки данных и затем выполняет загрузку новых данных, используя метод fetchData(url:completion:).

Вы можете вызвать метод reloadData(completion:) для автоматической очистки и загрузки данных в вашем коде, например:

swift
APIManager.shared.reloadData { (data, error) in
    if let error = error {
        print("Ошибка при получении данных: \(error)")
    } else {
        print("Данные: \(data ?? Data())")
    }
}


Обратите внимание, что в примере я использовал метод reloadData(completion:) из класса APIManager, но вы также можете использовать его из экземпляров классов FirstAPI и SecondAPI, если они наследуются от APIManager.
