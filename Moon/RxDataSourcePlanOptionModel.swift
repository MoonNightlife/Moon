//
//  RxDataSourceVotingOptionModel.swift
//  Moon
//
//  Created by Evan Noble on 7/29/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxDataSources

struct PlanOptionSectionModel {
    var header: String
    var items: [Item]
}
extension PlanOptionSectionModel: SectionModelType {
    typealias Item = PlanOption
    
    init(original: PlanOptionSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
