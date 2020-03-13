//
//  Date+Extension.swift
//  GeolocationTest
//
//  Created by Ramón Quiñonez on 09/03/20.
//  Copyright © 2020 rq-c. All rights reserved.
//

import Foundation

extension Date{
    func toString()->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self)
    }
}
