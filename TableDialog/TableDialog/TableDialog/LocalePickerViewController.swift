import UIKit

extension UIAlertController {

    /// Add Locale Picker
    ///
    /// - Parameters:
    ///   - type: country, phoneCode or currency
    ///   - action: for selected locale
    
    func addLocalePicker(data: [String: [LocaleInfo]], type: LocalePickerViewController.Kind, selection: @escaping LocalePickerViewController.Selection) {
        var info: [LocaleInfo]?
        let selection: LocalePickerViewController.Selection = selection
        let buttonSelect: UIAlertAction = UIAlertAction(title: "Select", style: .default) { action in
            selection(info)
        }
        buttonSelect.isEnabled = false
        let vc = LocalePickerViewController(data: data, type: type) { new in
            info = new
            buttonSelect.isEnabled = new != nil
        }
        set(vc: vc)
        addAction(buttonSelect)
    }
}

final class LocalePickerViewController: UIViewController {
    
    // MARK: UI Metrics
    
    struct UI {
        static let rowHeight = CGFloat(50)
        static let separatorColor: UIColor = UIColor.lightGray.withAlphaComponent(0.4)
    }
    
    // MARK: Properties
    
    public typealias Selection = ([LocaleInfo]?) -> Swift.Void
    
    public enum Kind {
        case country
        case phoneCode
        case currency
    }
    
    fileprivate var type: Kind
    fileprivate var selection: Selection?
    
    fileprivate var orderedInfo = [String: [LocaleInfo]]()
    fileprivate var sortedInfoKeys = [String]()
    fileprivate var filteredInfo: [LocaleInfo] = []
    
    fileprivate lazy var searchView: UIView = UIView()
    
    fileprivate lazy var tableView: UITableView = { [unowned self] in
        $0.dataSource = self
        $0.delegate = self
        $0.rowHeight = UI.rowHeight
        $0.separatorColor = UI.separatorColor
        $0.bounces = true
        $0.backgroundColor = nil
        $0.tableFooterView = UIView()
        $0.sectionIndexBackgroundColor = .clear
        $0.sectionIndexTrackingBackgroundColor = .clear
        return $0
    }(UITableView(frame: .zero, style: .plain))
    
    fileprivate lazy var indicatorView: UIActivityIndicatorView = {
        $0.color = .lightGray
        return $0
    }(UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge))
    
    // MARK: Initialize
    
    required init(data: [String: [LocaleInfo]], type: Kind, selection: @escaping Selection) {
        self.orderedInfo = data
        self.sortedInfoKeys = Array(self.orderedInfo.keys).sorted(by: <)
        self.type = type
        self.selection = selection
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(type: Kind, selection: @escaping Selection) {
        self.type = type
        self.selection = selection
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Log("has deinitialized")
    }
    
    override func loadView() {
        view = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(indicatorView)
        
        tableView.allowsMultipleSelection = true
        //extendedLayoutIncludesOpaqueBars = true
        //edgesForExtendedLayout = .bottom
        definesPresentationContext = true
        
        tableView.register(CountryTableViewCell.self, forCellReuseIdentifier: CountryTableViewCell.identifier)
        tableView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.tableHeaderView?.height = 57
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        indicatorView.center = view.center
        preferredContentSize.height = tableView.contentSize.height
    }
    
    func sortFilteredInfo() {
        filteredInfo = filteredInfo.sorted { lhs, rhs in
            switch type {
            case .country:
                return lhs.country < rhs.country
            case .phoneCode:
                return lhs.country < rhs.country
            case .currency:
                return lhs.country < rhs.country
            }
        }
    }
    
    func info(at indexPath: IndexPath) -> LocaleInfo? {
        let key: String = sortedInfoKeys[indexPath.section]
        if let info = orderedInfo[key]?[indexPath.row] {
            return info
        }
        return nil
    }
    
    func updateInfo(at indexPath: IndexPath, selected: Bool){
        let key: String = sortedInfoKeys[indexPath.section]
        orderedInfo[key]?[indexPath.row].selected = selected
    }
    
    func updateSelection() {
        var infos:[LocaleInfo] = []
        for (key, value) in orderedInfo {
            for v in value {
                if(v.selected) {
                    infos.append(v)
                }
            }
        }
        selection?(infos)
    }
}

// MARK: - TableViewDelegate

extension LocalePickerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateInfo(at: indexPath, selected: true)
        updateSelection()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        updateInfo(at: indexPath, selected: false)
        updateSelection()
    }
}

// MARK: - TableViewDataSource

extension LocalePickerViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedInfoKeys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let infoForSection = orderedInfo[sortedInfoKeys[section]] {
            return infoForSection.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        tableView.scrollToRow(at: IndexPath(row: 0, section: index), at: .top , animated: false)
        return sortedInfoKeys.index(of: title)!
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sortedInfoKeys
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortedInfoKeys[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let info = info(at: indexPath) else { return UITableViewCell() }
        
        let cell: UITableViewCell
        
        cell = tableView.dequeueReusableCell(withIdentifier: CountryTableViewCell.identifier) as! CountryTableViewCell
        cell.textLabel?.text = info.country
        cell.detailTextLabel?.textColor = .darkGray
        
        DispatchQueue.main.async {
            let size: CGSize = CGSize(width: 24, height: 24)
            let flag: UIImage? = info.flag?.imageWithSize(size: size, roundedRadius: 3)
            cell.imageView?.image = flag
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            if(info.selected) {
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            }
        }
        
        return cell
    }
}
