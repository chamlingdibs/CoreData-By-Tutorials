//
//  ColorAttributeTransformer.swift
//  BowTies
//
//  Created by chamlingdibyarai on 28/04/23.
//  Copyright © 2023 Razeware. All rights reserved.
//

import UIKit

class ColorAttributeTransformer: NSSecureUnarchiveFromDataTransformer {

  override static var allowedTopLevelClasses: [AnyClass]{
    [UIColor.self]
  }
  
  static func register() {
    let className = String( describing: ColorAttributeTransformer.self)
    let name = NSValueTransformerName(className)
    let transformer = ColorAttributeTransformer()
    ValueTransformer.setValueTransformer(transformer, forName: name)
  }
}
