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
  func createURL(fromURL url: NSURL) -> NSURL?
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

  func createURL(fromURL url: NSURL) -> NSURL?
  {
    return url
  }
}

struct ChromeHandler : BrowserHander, SchemeBasedApplication
{
  let displayName = "Chrome"

  let scheme = "googlechrome-x-callback"

  func createURL(fromURL url: NSURL) -> NSURL?
  {
    let urlString = url.absoluteString.stringByEncodingURLFormat() ?? ""
    let chromeURLString = "\(scheme)://x-callback-url/open/?url=\(urlString)"
    return NSURL(string: chromeURLString)
  }
}

struct TwoSchemeBrowserHandler: BrowserHander, SchemeBasedApplication
{
  let displayName: String
  let scheme: String
  let secureScheme: String

  func createURL(fromURL url: NSURL) -> NSURL?
  {
    let s: String
    if url.scheme == "https" {
      s = secureScheme
    } else {
      s = scheme
    }

    let components = NSURLComponents(URL: url, resolvingAgainstBaseURL: false)
    components?.scheme = s
    return components?.URL
  }
}