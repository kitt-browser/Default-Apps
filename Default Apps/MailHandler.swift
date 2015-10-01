//
//  MailHandler.swift
//  Default Apps
//
//  Created by Jan Dědeček on 30/09/15.
//  Copyright © 2015 Jan Dědeček. All rights reserved.
//

import UIKit

struct Mail
{
  let recipient: String
  let subject: String
  let body: String
}

let HandlerTypeMail = "HandlerTypeMail"

protocol MailHandler
{
  func handleMail(mail: Mail) -> Bool
}

extension MailHandler
{
  var handlerType: String {
    return HandlerTypeMail
  }
}

struct iOSMailHandler: MailHandler, InstalledApplication
{
  let displayName = "Mail"

  func handleMail(mail: Mail) -> Bool
  {
    let urlString = "mailto:\(mail.recipient)?subject=\(mail.subject)&body=\(mail.body)!"

    if let url = NSURL(string: urlString) {
      return UIApplication.sharedApplication().openURL(url)
    } else {
      return true
    }
  }
}

struct GoogleMailHandler: MailHandler, SchemeBasedApplication
{
  let displayName = "GMail"

  let scheme = "googlegmail"

  func handleMail(mail: Mail) -> Bool
  {
    let urlString = "\(scheme):///co?to=\(mail.recipient)&subject=\(mail.subject)&body=\(mail.body)!"

    if let url = NSURL(string: urlString) {
      return UIApplication.sharedApplication().openURL(url)
    } else {
      return true
    }
  }
}

struct OutlookHandler: MailHandler, SchemeBasedApplication
{
  let displayName = "Outlook"

  let scheme = "ms-outlook"

  func handleMail(mail: Mail) -> Bool
  {
    let urlString = "\(scheme):///co?to=\(mail.recipient)&subject=\(mail.subject)&body=\(mail.body)!"

    if let url = NSURL(string: urlString) {
      return UIApplication.sharedApplication().openURL(url)
    } else {
      return true
    }
  }
}
