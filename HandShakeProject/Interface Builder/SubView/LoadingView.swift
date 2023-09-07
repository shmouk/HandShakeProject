import UIKit

class LoadingView: UIView {
    private let interfaceBuilder = InterfaceBuilder()
    private let notificationCenterManager = NotificationCenterManager.shared
    
    lazy var logoImageView = interfaceBuilder.createImageView()
    lazy var progressView = interfaceBuilder.createProgressView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewAppearance()
        setSubviews()
        setupConstraints()
        notificationCenterManager.addObserver(self, selector: #selector(addProgressHandle), forNotification: .addProgressNotification)
    }
    
    deinit {
        notificationCenterManager.removeObserver(self, forNotification: .addProgressNotification)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViewAppearance() {
        logoImageView.clipsToBounds = false
        logoImageView.image = UIImage(named: "logoImage.png")
    }
    
    private func setSubviews() {
        backgroundColor = .colorForView()
        addSubviews(logoImageView, progressView)
    }
    
}
extension LoadingView {
    @objc
    func addProgressHandle() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear) { [weak self] in
            guard let self = self else { return }
            progressView.progress += 0.2
        }
    }
}
