//
//  Data+PrettyJSON.swift
//  Movies
//
//  Created by Владислав Баранкевич on 20.09.2023.
//

import Foundation

extension Data {
    var prettyPrintedJSONString: String? {
        guard
            let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []),
            let data = try? JSONSerialization.data(
                withJSONObject: jsonObject,
                options: [.prettyPrinted]),
            let prettyJSON = NSString(
                data: data,
                encoding: String.Encoding.utf8.rawValue) 
        else {
            return nil
        }
        
        return prettyJSON as String
    }
}
