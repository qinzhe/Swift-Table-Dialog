//
//  ViewController.swift
//  TableDialog
//
//  Created by qinzhe on 2018/5/2.
//  Copyright © 2018年 qinzhe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func showDialog() {
        let alert = UIAlertController(style: .actionSheet)
        var infos: [LocaleInfo] = []
        let i1 = LocaleInfo(country: "swift", selected: true)
        let i2 = LocaleInfo(country: "java", selected: true)
        let i3 = LocaleInfo(country: "php", selected: true)
        let i4 = LocaleInfo(country: "python", selected: true)
        let i5 = LocaleInfo(country: "bedroom", selected: true)
        let i6 = LocaleInfo(country: "football", selected: true)
        infos.append(i1)
        infos.append(i2)
        infos.append(i3)
        infos.append(i4)
        infos.append(i5)
        infos.append(i6)
        for i in 100...500 {
            infos.append(LocaleInfo(country: "HH\(i)", selected: (i % 1000 == 0)))
        }
        var hh = [String: [LocaleInfo]]()
        LocaleStore.fetch(info: infos) { [unowned self] result in
            switch result {
            case .success(let orderedInfo):
                let data: [String: [LocaleInfo]] = orderedInfo
                hh = data
            case .error(let error):
                break
            }
            
        }
        alert.addLocalePicker(data: hh, type: .country) { info in
            if(info?.count == 0) {
                print("empty")
            }
            for tmp in info! {
                print(tmp.country)
            }
            
        }
        alert.addAction(title: "Cancel", style: .cancel)
        alert.show()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

