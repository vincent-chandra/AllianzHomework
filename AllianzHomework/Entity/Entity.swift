//
//  Entity.swift
//  AllianzHomework
//
//  Created by Vincent on 19/09/22.
//

import Foundation

struct UserEntity: Codable {
    var total_count: Int
    var incomplete_results: Bool
    var items: [UserListItem]
}

struct UserListItem: Codable {
    var login: String
    var id: Int
    var avatar_url: String
}

struct LimitExceed: Codable {
    var message: String
}
