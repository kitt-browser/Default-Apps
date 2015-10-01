//
//  Handler.swift
//  Default Apps
//
//  Created by Jan Dědeček on 30/09/15.
//  Copyright © 2015 Jan Dědeček. All rights reserved.
//

import UIKit

protocol Handler
{
  var displayName: String { get }

  var installed: Bool { get }

  var handlerType: String { get }
}

protocol InstalledApplication : Handler
{
}

extension InstalledApplication
{
  var installed: Bool { return true }
}

protocol SchemeBasedApplication : Handler
{
  var scheme: String { get }
}

extension SchemeBasedApplication
{
  var installed: Bool {
    if let url = NSURL(string: "\(scheme)://") {
      return UIApplication.sharedApplication().canOpenURL(url)
    } else {
      return false
    }
  }
}

func getSelectedHandler(handlers: [Handler], ofHandlerType handlerType: String) -> Handler?
{
  if let selected = NSUserDefaults.standardUserDefaults().stringForKey(handlerType),
    let index = handlers.indexOf({ $0.displayName == selected }) {
     return handlers[index]
  } else {
    if let index = handlers.indexOf({ $0.handlerType == handlerType && $0 is InstalledApplication }) {
      return handlers[index]
    } else {
      return nil
    }
  }
}