//
//  ViewController.swift
//  Default Apps
//
//  Created by Jan Dědeček on 29/09/15.
//  Copyright © 2015 Jan Dědeček. All rights reserved.
//

import UIKit

let Handlers: [Handler] = [
  SafariHandler(),
  ChromeHandler(),
  TwoSchemeBrowserHandler(displayName: "Opera", scheme: "opera-http", secureScheme: "opera-https"),
  TwoSchemeBrowserHandler(displayName: "Kitt", scheme: "kitt", secureScheme: "kitts"),
  TwoSchemeBrowserHandler(displayName: "Adblock Browser", scheme: "adblockbrowser", secureScheme: "adblockbrowsers"),
  iOSMailHandler(),
  GoogleMailHandler(),
  OutlookHandler(),
  iOSMapsHandler(),
  GoogleMapsHandler(),
  YandexMapsHandler()
]

class HomeController: UITableViewController
{
  static let handlerTypes = [HandlerTypeBrowser, HandlerTypeMail, HandlerTypeMaps]

  override func viewDidLoad()
  {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    tableView?.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
  }

  // MARK: - UITableViewDataSource

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return HomeController.handlerTypes.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
    if let handlerCell = cell as? HandlerCell {

      let names = [
        HandlerTypeBrowser: "Web Browser",
        HandlerTypeMail: "Mail",
        HandlerTypeMaps: "Maps"]

      let handlerType = HomeController.handlerTypes[indexPath.row]
      let name = names[handlerType] ?? handlerType
      let handlers = Handlers.filter { (h) in
        return h.handlerType == handlerType
      }

      let defaults = NSUserDefaults.standardUserDefaults()

      let displayName: String
      if let selected = defaults.stringForKey(handlerType),
        let index = handlers.indexOf({ $0.displayName == selected }) {
          let handler = handlers[index]
          displayName = handler.displayName
      } else {
        if let index = handlers.indexOf({ $0 is InstalledApplication }) {
          let handler = handlers[index]
          displayName = handler.displayName
        } else {
          displayName = handlers.first?.displayName ?? ""
        }
      }

      handlerCell.handlers = handlers
      handlerCell.handlerNameTextField?.text = displayName
      handlerCell.handlerTypeLabel?.text = "\(name):"
    }
    return cell
  }

  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
  {
    return "Default Apps™"
  }

  // MARK: - UITableViewDelegate

  override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
  {
    return 100
  }

  override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
  {
    if let header = view as? UITableViewHeaderFooterView {
      header.textLabel?.font = UIFont.systemFontOfSize(36)
      header.textLabel?.textAlignment = .Center
      header.backgroundView?.backgroundColor = UIColor.clearColor()
    }
  }

}

