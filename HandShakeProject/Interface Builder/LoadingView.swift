import UIKit

class LoadingView: UIView {
    private let activityIndicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .large)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.startAnimating()
        return indicatorView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        // Настройка внешнего вида представления загрузки (если нужно)
        backgroundColor = .white

        // Добавление индикатора загрузки к представлению
        addSubview(activityIndicatorView)

        // Настройка constraints для индикатора загрузки
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
