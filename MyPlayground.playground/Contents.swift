Для реализации данной функциональности вам понадобится расширение UITableView delegate метода `tableView(_:heightForRowAt:)` для вычисления высоты ячейки, а также расширение UITableViewCell метода `layoutSubviews()` для настройки ширины текстового поля.

Вот пример кода на Swift UIKit для реализации требуемого поведения:

```swift
import UIKit

class CustomTableViewCell: UITableViewCell {
    let textView: UITextView = {
        let view = UITextView()
        view.isScrollEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: contentView.topAnchor),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let screenWidth = UIScreen.main.bounds.width
        textView.frame.size.width = screenWidth
        
        let halfScreenWidth = screenWidth / 2
        if textView.contentSize.width > halfScreenWidth {
            textView.textContainer.size = textView.contentSize
            textView.frame.size.height = textView.contentSize.height
        } else {
            textView.frame.size.height = textView.sizeThatFits(CGSize(width: halfScreenWidth, height: CGFloat.infinity)).height
        }
        
        frame.size.height = textView.frame.size.height
    }
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Верните количество ячеек в таблице
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
        
        cell.textView.text = "Some long text that may or may not wrap to a new line depending on its width"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomTableViewCell
        
        cell.textView.text = "Some long text that may or may not wrap to a new line depending on its width"
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        return cell.textView.frame.size.height
    }
}
```

В этом коде используется кастомная ячейка CustomTableViewCell, которая содержит UITextView для отображения текста. В методе `layoutSubviews()` мы настраиваем ширину и высоту текстового поля с учетом условий, которые вы указали. Также в методе `tableView(_
