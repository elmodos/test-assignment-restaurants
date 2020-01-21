//
//  String+CamelCase.swift
//  Restaurants
//
//  Created by Modo Ltunzher on 19.01.2020.
//  Copyright © 2020 Modo Ltunzher. All rights reserved.
//

import Foundation

extension String {
    
    func camelCaseToWords() -> String {
        return unicodeScalars.reduce("") {
            let touches = $0.count > 0 && !$0.hasSuffix(" ")
            return touches && CharacterSet.uppercaseLetters.contains($1)
                ? $0 + " " + String($1)
                : $0 + String($1)
        }
    }
}
