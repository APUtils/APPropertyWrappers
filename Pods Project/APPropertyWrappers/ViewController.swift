//
//  ViewController.swift
//  APPropertyWrappers
//
//  Created by Anton Plebanovich on 12/26/2019.
//  Copyright (c) 2019 Anton Plebanovich. All rights reserved.
//

import UIKit
import APPropertyWrappers
import RxSwift

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = ViewModel()
        
    }
}

final class ViewModel {
    
    let disposeBag = DisposeBag()
    
    @EquatableFilter_ObservableObserverProjected_UserDefaultCodable(key: "ViewController_sort", defaultValue: "")
    public var sort: String
    
    init() {
        Observable.combineLatest($sort, $sort)
            .do(onNext: { [sort = _sort] l, r in
                print(l)
                print(r)
                print(sort.wrappedValue)
            })
                .subscribe().disposed(by: disposeBag)
                
        sort = "123"
                
        
    }
}
