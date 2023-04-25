//
//  Reactive.swift
//  Diary
//
//  Created by 정선아 on 2023/04/13.
//

import Foundation
import RxSwift
import RxCocoa

extension RxSwift.Reactive where Base: UIViewController {
    var viewWillAppear: ControlEvent<Void> {
        let source = methodInvoked(#selector(Base.viewWillAppear))
            .map { _ in }

        return ControlEvent(events: source)
    }
}
