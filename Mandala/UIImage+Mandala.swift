//
//  UIImage+Mandala.swift
//  Mandala
//
//  Created by nigelli on 2023/6/7.
//

import UIKit

enum ImageSource: String {
    case angry
    case confused
    case crying
    case goofy
    case happy
    case meh
    case sad
    case sleepy
}

extension UIImage {
    convenience init(resource: ImageSource) {
        self.init(named: resource.rawValue)!
    }
}
