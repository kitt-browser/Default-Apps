//
//  BrowserHandler.swift
//  Default Apps
//
//  Created by Jan Dědeček on 30/09/15.
//  Copyright © 2015 Jan Dědeček. All rights reserved.
//

import UIKit

let HandlerTypeBrowser = "HandlerTypeBrowser"

protocol BrowserHander
{
  func openURL(url: NSURL) -> Bool
}

extension BrowserHander
{
  var handlerType: String {
    get {
      return HandlerTypeBrowser
    }
  }
}

struct SafariHandler : BrowserHander, InstalledApplication
{
  let displayName = "Safari"

  func openURL(url: NSURL) -> Bool
  {
    return UIApplication.sharedApplication().openURL(url)
  }
}

struct ChromeHandler : BrowserHander, SchemeBasedApplication
{
  let displayName = "Chrome"

  let scheme = "googlechrome-x-callback"

  func openURL(url: NSURL) -> Bool
  {
    let set = NSCharacterSet.URLQueryAllowedCharacterSet().mutableCopy() as! NSMutableCharacterSet
      set.removeCharactersInString("+?")
    let urlString = url.absoluteString.stringByAddingPercentEncodingWithAllowedCharacters(set)!

    let chromeURLString = "\(scheme)://x-callback-url/open/?&url=\(urlString)"
    if let chromeURL = NSURL(string: chromeURLString) {
      return UIApplication.sharedApplication().openURL(chromeURL)
    } else {
      return false
    }
  }
}

struct TwoSchemeBrowserHandler: BrowserHander, SchemeBasedApplication
{
  let displayName: String
  let scheme: String
  let secureScheme: String

  func openURL(url: NSURL) -> Bool
  {
    let s: String
    if url.scheme == "https" {
      s = secureScheme
    } else {
      s = scheme
    }

    let components = NSURLComponents(URL: url, resolvingAgainstBaseURL: false)
    components?.scheme = s
    if let operaURL = components?.URL {
      return UIApplication.sharedApplication().openURL(operaURL)
    } else {
      return false
    }
  }
}