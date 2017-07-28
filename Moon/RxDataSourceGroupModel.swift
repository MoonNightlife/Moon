//
//  RxDataSourceGroupModel.swift
//  Moon
//
//  Created by Evan Noble on 7/28/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxDataSources

struct SnapshotSectionModel {
    var header: String
    var items: [Item]
}
extension SnapshotSectionModel: SectionModelType {
    typealias Item = Snapshot
    
    init(original: SnapshotSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
