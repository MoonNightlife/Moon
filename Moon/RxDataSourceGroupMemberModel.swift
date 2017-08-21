//
//  RxDataSourceGroupMemberModel.swift
//  Moon
//
//  Created by Evan Noble on 7/26/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxDataSources

struct GroupMemberSectionModel {
    var header: String
    var items: [Item]
}
extension GroupMemberSectionModel: SectionModelType {
    typealias Item = GroupMemberSnapshot
    
    init(original: GroupMemberSectionModel, items: [Item]) {
        self = original
        self.items = items
    } 
}
