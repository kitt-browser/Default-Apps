//
//  AppDelegate.swift
//  Default Apps
//
//  Created by Jan Dědeček on 29/09/15.
//  Copyright © 2015 Jan Dědeček. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
  {
    // Override point for customization after application launch.
    return true
  }

  func applicationWillResignActive(application: UIApplication)
  {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication)
  {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(application: UIApplication)
  {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(application: UIApplication)
  {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(application: UIApplication)
  {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }

  func application(application: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool
  {
    if let url = createURL(fromURL: url) {
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
        application.openURL(url)
      })
      return true
    } else {
      return false
    }
  }


  func createURL(fromPathComponents pathComponents: [String], andQuery query: [String:[String]]) -> NSURL?
  {
    // Browser
    if pathComponents.contains("open"),
      let urlString = query["url"]?.first?.stringByDecodingURLFormat(),
      let url = NSURL(string: urlString) {

        if let browserHandler = getSelectedHandler(Handlers, ofHandlerType: HandlerTypeBrowser) as? BrowserHander {
          return browserHandler.createURL(fromURL: url)
        } else {
          return nil
        }
    }

    // Mail
    if pathComponents.contains("mail") {

      let recipient = query["to"]?.first ?? ""
      let subject = query["subject"]?.first ?? ""
      let body = query["body"]?.first ?? ""

      let mail = Mail(recipient: recipient, subject: subject, body: body)

      if let mailHandler = getSelectedHandler(Handlers, ofHandlerType: HandlerTypeMail) as? MailHandler {
        return mailHandler.createURL(fromMail: mail)
      } else {
        return nil
      }
    }

    // Maps
    if pathComponents.contains("maps") {
      if let mapsHandler = getSelectedHandler(Handlers, ofHandlerType: HandlerTypeMaps) as? MapsHandler {
        return mapsHandler.createURL(fromMapsParams: query ?? [String:[String]]())
      } else {
        return nil
      }
    }

    return nil
  }

  func createURL(fromURL url: NSURL) -> NSURL?
  {
    if url.scheme == "defaultapps", let host = url.host where host == "x-callback-url",
      let query = url.query?.dictionaryFromQueryComponents(false),
      let pathComponents = url.pathComponents,
      let url = createURL(fromPathComponents: pathComponents, andQuery: query) {

        if let callerScheme = query["callerScheme"]?.first {
          let query = String.queryStringFromDictionary(["url": [url.absoluteString]], encodeValues: true)
          let urlString = "\(callerScheme)://x-callback-url/open/?\(query)"
          if let url = NSURL(string: urlString) {
            return url
          }
        }
        return url
    }
    return nil
  }
}
