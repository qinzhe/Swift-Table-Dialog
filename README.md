# Swift-Table-Dialog qin
Swift custom UIAlertController with Tableview select

![image](https://github.com/qinzhe/Swift-Table-Dialog/blob/master/QQ20180502-195630-HD.gif)

How to use?

1, Drag TableDialog folder to your project

2, Like this to show dialog

```
        let alert = UIAlertController(style: .actionSheet)
        var infos: [LocaleInfo] = []
        for i in 100...500 {
            infos.append(LocaleInfo(country: "HH\(i)", selected: (i % 2 == 0)))
        }
        var hh = [String: [LocaleInfo]]()
        LocaleStore.fetch(info: infos) { [unowned self] result in
            switch result {
            case .success(let orderedInfo):
                hh = orderedInfo
            case .error(let error):
                break
            }
            
        }
        alert.addLocalePicker(data: hh, type: .country) { info in
            for tmp in info! {
                print(tmp.country)
            }
            
        }
        alert.addAction(title: "Cancel", style: .cancel)
        alert.show()
```
        
Thanks dillidon/alerts-and-pickers (https://github.com/dillidon/alerts-and-pickers)
