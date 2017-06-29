//
//  UserSetting.swift
//  Moon
//
//  Created by Evan Noble on 6/29/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation


open class UserSettings: JSONEncodable {
    public var id: String?
    public var privacy: Bool?
    public var blockedUsers: [String]?
    public var friendPlansNotifications: Bool?
    public var statusLikeNotifications: Bool?
}
