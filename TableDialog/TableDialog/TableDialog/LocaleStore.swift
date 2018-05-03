import Foundation

struct LocaleStore {
    
    /// Result Enum
    ///
    /// - Success: Returns Grouped By Alphabets Locale Info
    /// - Error: Returns error
    public enum GroupedByAlphabetsFetchResults {
        case success(response: [String: [LocaleInfo]])
        case error(error: (title: String?, message: String?))
    }

    public static func fetch(info: [LocaleInfo], completionHandler: @escaping (GroupedByAlphabetsFetchResults) -> ()) {

                var data = [String: [LocaleInfo]]()
                
                info.forEach {
                    let country = $0.country
                    let index = String(country[country.startIndex])
                    var value = data[index] ?? [LocaleInfo]()
                    value.append($0)
                    data[index] = value
                }
                
                data.forEach { key, value in
                    data[key] = value.sorted(by: { lhs, rhs in
                        return lhs.country < rhs.country
                    })
                }
                completionHandler(GroupedByAlphabetsFetchResults.success(response: data))
    }
}
