//
//  PageModel.swift
//  Pinch
//
//  Created by Natalie Choo on 7/31/22.
//

import Foundation

struct Page: Identifiable {
    let id: Int
    let imageName: String
}

extension Page {
    var thumbnailName: String {
        return "thumb-" + imageName
    }
}
