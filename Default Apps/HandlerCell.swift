//
//  HandlerCell.swift
//  Default Apps
//
//  Created by Jan Dědeček on 30/09/15.
//  Copyright © 2015 Jan Dědeček. All rights reserved.
//

import UIKit

class HandlerCell: UITableViewCell, UITextFieldDelegate
{
  var handlers: [Handler]?

  @IBOutlet weak var handlerTypeLabel: UILabel?

  @IBOutlet weak var handlerNameTextField: UITextField?

  // MARK: - UITextFieldDelegate

  func textFieldShouldBeginEditing(textField: UITextField) -> Bool
  {
    let alertController = UIAlertController(title: "Select", message: nil, preferredStyle: .ActionSheet)

    if let handlers = handlers {
      for handler in handlers.filter({ $0.installed }) {
        alertController.addAction(UIAlertAction(title: handler.displayName, style: .Default, handler: { (a) -> Void in
          self.handlerNameTextField?.text = handler.displayName
          NSUserDefaults.standardUserDefaults().setObject(handler.displayName, forKey: handler.handlerType)
          NSUserDefaults.standardUserDefaults().synchronize()
        }))
      }
    }

    alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))

    if var controller = UIApplication.sharedApplication().delegate?.window??.rootViewController {
      while true {
        if let c = controller.presentedViewController {
          controller = c
        } else {
          break
        }
      }
      controller.presentViewController(alertController, animated: true, completion: nil)
    }

    return false
  }

}
