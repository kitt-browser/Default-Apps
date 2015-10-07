//
//  MapsHandler.swift
//  Default Apps
//
//  Created by Jan Dědeček on 01/10/15.
//  Copyright © 2015 Jan Dědeček. All rights reserved.
//

import UIKit

let HandlerTypeMaps = "HandlerTypeMaps"

protocol MapsHandler
{
  func createURL(fromMapsParams params: [String: [String]]) -> NSURL?
}

extension MapsHandler
{
  var handlerType: String {
    return HandlerTypeMaps
  }
}

struct iOSMapsHandler: MapsHandler, InstalledApplication
{
  let displayName = "Maps"

  func createURL(fromMapsParams params: [String: [String]]) -> NSURL?
  {
    let urlString = "http://maps.apple.com/?\(String.queryStringFromDictionary(params))"
    return NSURL(string: urlString)
  }
}

struct GoogleMapsHandler: MapsHandler, SchemeBasedApplication
{
  let displayName = "Google Maps"

  let scheme = "comgooglemaps"

  func createURL(var fromMapsParams params: [String: [String]]) -> NSURL?
  {
    if let ll = params["ll"] {
      params.removeValueForKey("ll")
      params["center"] = ll
    }

    let urlString = "\(scheme):///?\(String.queryStringFromDictionary(params))"
    return NSURL(string: urlString)
  }
}

struct YandexMapsHandler: MapsHandler, SchemeBasedApplication
{
  let displayName = "Yandex Maps"
  let scheme = "yandexmaps"

  func createURL(var fromMapsParams params: [String: [String]]) -> NSURL?
  {
    if let ll = params["ll"]?.first {
      params["ll"] = [ll.componentsSeparatedByString(",").reverse().joinWithSeparator(",")]
    }

    let urlString = "\(scheme)://maps.yandex.ru/?\(String.queryStringFromDictionary(params))"
    return NSURL(string: urlString)
  }
}

/*
struct GenericMapsHandler: MapsHandler, SchemeBasedApplication
{
  let displayName: String
  let scheme: String
  let hostname: String

  func handleMaps(var params: [String: [String]]) -> Bool
  {
    params["z"] = ["12"]
    let urlString = "\(scheme)://\(hostname)/?\(queryString(params))"

    if let url = NSURL(string: urlString) {
      return UIApplication.sharedApplication().openURL(url)
    } else {
      return true
    }
  }
}
*/

