//
//  CoreDataRepository.swift
//  Diary
//
//  Created by 정선아 on 2023/03/29.
//

import Foundation
import RxSwift

protocol CoreDataRepository {
    func fetchDiaryList() -> Observable<[Diary]>
}


