//
//  File.swift
//  Places
//
//  Created by Nazarii Melnyk on 11/23/17.
//  Copyright © 2017 Andrew. All rights reserved.
//

import Foundation

protocol SearchManagerDelegate{
    func reloadRowAt(index: Int)
    func reloadAllData()
}
