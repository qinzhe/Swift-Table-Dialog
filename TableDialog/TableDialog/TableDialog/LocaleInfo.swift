import UIKit

public struct LocaleInfo {
    
    public var country: String
    public var selected: Bool
    
    public var flag: UIImage? {
        return UIImage(named: "logo", in: Bundle.main, compatibleWith: nil)
    }

    init(country: String, selected: Bool) {
        self.country = country
        self.selected = selected
    }
}
