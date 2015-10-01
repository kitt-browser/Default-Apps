//
//  String+Encoding.swift
//  Default Apps
//
//  Created by Jan Dědeček on 01/10/15.
//  Copyright © 2015 Jan Dědeček. All rights reserved.
//

import Foundation

private let set = { () -> NSCharacterSet in
  let set = NSCharacterSet.URLQueryAllowedCharacterSet().mutableCopy() as! NSMutableCharacterSet
  set.removeCharactersInString("+?")
  return set
}()

extension String
{
  func stringByDecodingURLFormat() -> String?
  {
    return stringByRemovingPercentEncoding
  }

  func stringByEncodingURLFormat() -> String?
  {
    return stringByAddingPercentEncodingWithAllowedCharacters(set)
  }

  func dictionaryFromQueryComponents(decodeValues: Bool = true) -> [String: [String]]
  {
    var queryComponents = [String: [String]]()
    for keyValuePairString in componentsSeparatedByString("&") {
      let keyValuePairArray = keyValuePairString.componentsSeparatedByString("=")
      if keyValuePairArray.count < 2 {
        continue
      }

      if let key = keyValuePairArray[0].stringByDecodingURLFormat(),
        let value = (decodeValues ? keyValuePairArray[1].stringByDecodingURLFormat() : keyValuePairArray[1]) {

          var results = queryComponents[key] ?? [String]()
          results.append(value)
          queryComponents[key] = results
      }
    }
    return queryComponents;
  }
}