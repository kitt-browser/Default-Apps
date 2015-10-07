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
  func createURL(fromMail mail: Mail) -> NSURL?
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

  func createURL(fromMail mail: Mail) -> NSURL?
  {
    let urlString = "mailto:\(mail.recipient)?subject=\(mail.subject)&body=\(mail.body)!"
    return NSURL(string: urlString)
  }
}

struct GoogleMailHandler: MailHandler, SchemeBasedApplication
{
  let displayName = "GMail"

  let scheme = "googlegmail"

  func createURL(fromMail mail: Mail) -> NSURL?
  {
    let urlString = "\(scheme):///co?to=\(mail.recipient)&subject=\(mail.subject)&body=\(mail.body)!"
    return NSURL(string: urlString)
  }
}

struct OutlookHandler: MailHandler, SchemeBasedApplication
{
  let displayName = "Outlook"

  let scheme = "ms-outlook"

  func createURL(fromMail mail: Mail) -> NSURL?
  {
    let urlString = "\(scheme):///co?to=\(mail.recipient)&subject=\(mail.subject)&body=\(mail.body)!"
    return NSURL(string: urlString)
  }
}
