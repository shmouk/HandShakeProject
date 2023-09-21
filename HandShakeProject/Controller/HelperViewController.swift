import UIKit

class HelperViewController: UIViewController {
    
    var helpImageView = InterfaceBuilder.createImageView()
    var titleLabel = InterfaceBuilder.createTitleLabel()
    var closeVCButton = InterfaceBuilder.createButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        setSubviews()
        setupTargets()
        settingTextLabel()
        settingButton()
        settingImageView()
        setupConstraints()
    }
    
    func settingImageView() {
        helpImageView.image = UIImage(named: "helpEventImage.png")
    }
    
    private func setSubviews() {
        view.addSubviews(titleLabel, helpImageView, closeVCButton)
        view.backgroundColor = .colorForView()
    }
    
    private func settingTextLabel() {
        titleLabel.text = "Help"
        titleLabel.textAlignment = .center
    }
    
    private func settingButton() {
        closeVCButton.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
    }
    
    private func setupTargets() {
        closeVCButton.addTarget(self, action: #selector(closeVCAction), for: .touchUpInside)
    }
}

extension HelperViewController {
    @objc
    private func closeVCAction(_ sender: Any) {
        dismiss(animated: true)
    }
}
