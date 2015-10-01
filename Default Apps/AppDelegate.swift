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

  func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool
  {
    if url.scheme == "defaultapps",
      let host = url.host where host == "x-callback-url" {

        let query = url.query?.dictionaryFromQueryComponents(false)
        let pathComponents = url.pathComponents

        // Browser
        if pathComponents?.contains("open") ?? false,
          let urlString = query?["url"]?.first?.stringByDecodingURLFormat(),
          let url = NSURL(string: urlString) {

            if let browserHandler = getSelectedHandler(Handlers, ofHandlerType: HandlerTypeBrowser) as? BrowserHander {
              // http://stackoverflow.com/questions/19356488/openurl-freezes-app-for-over-10-seconds
              dispatch_async(dispatch_get_main_queue()) {
                browserHandler.openURL(url)
              }
              return true
            } else {
              return false
            }
        }

        // Mail
        if pathComponents?.contains("mail") ?? false {

          let recipient = query?["to"]?.first ?? ""
          let subject = query?["subject"]?.first ?? ""
          let body = query?["body"]?.first ?? ""

          let mail = Mail(recipient: recipient, subject: subject, body: body)

          if let mailHandler = getSelectedHandler(Handlers, ofHandlerType: HandlerTypeMail) as? MailHandler {
            dispatch_async(dispatch_get_main_queue()) {
              mailHandler.handleMail(mail)
            }
            return true
          } else {
            return false
          }
        }

        // Maps
        if pathComponents?.contains("maps") ?? false {
          if let mapsHandler = getSelectedHandler(Handlers, ofHandlerType: HandlerTypeMaps) as? MapsHandler {
            dispatch_async(dispatch_get_main_queue()) {
              mapsHandler.handleMaps(query ?? [String:[String]]())
            }
            return true
          } else {
            return false
          }
        }

        return false
    } else {
      return false
    }
  }
}

