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
  func handleMaps(params: [String: [String]]) -> Bool
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

  func handleMaps(params: [String: [String]]) -> Bool
  {
    let urlString = "http://maps.apple.com/?\(queryString(params))"

    if let url = NSURL(string: urlString) {
      return UIApplication.sharedApplication().openURL(url)
    } else {
      return true
    }
  }
}

struct GoogleMapsHandler: MapsHandler, SchemeBasedApplication
{
  let displayName = "Google Maps"

  let scheme = "comgooglemaps"

  func handleMaps(var params: [String: [String]]) -> Bool
  {
    if let ll = params["ll"] {
      params.removeValueForKey("ll")
      params["center"] = ll
    }

    let urlString = "\(scheme):///?\(queryString(params))"

    if let url = NSURL(string: urlString) {
      return UIApplication.sharedApplication().openURL(url)
    } else {
      return true
    }
  }
}

struct YandexMapsHandler: MapsHandler, SchemeBasedApplication
{
  let displayName = "Yandex Maps"
  let scheme = "yandexmaps"

  func handleMaps(var params: [String: [String]]) -> Bool
  {
    if let ll = params["ll"]?.first {
      params["ll"] = [ll.componentsSeparatedByString(",").reverse().joinWithSeparator(",")]
    }

    let urlString = "\(scheme)://maps.yandex.ru/?\(queryString(params))"

    if let url = NSURL(string: urlString) {
      return UIApplication.sharedApplication().openURL(url)
    } else {
      return true
    }
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

func queryString(query: [String: [String]]) -> String
{
  return query.reduce("") { (query, e) -> String in

    if let key = e.0.stringByEncodingURLFormat() {
      let q = e.1.reduce("", combine: { (q, e) -> String in
        if q.isEmpty {
          return "\(key)=\(e)"
        } else {
          return "&\(key)=\(e)"
        }
      })

      if q.isEmpty {
        return query
      } else if query.isEmpty {
        return q
      } else {
        return "&\(q)"
      }
    }

    return query
  }
}