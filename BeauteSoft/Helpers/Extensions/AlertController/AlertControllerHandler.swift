//  AlertControllerHandler.swift
//  Copyright © 2018 27 APP. All rights reserved.
//  Created by Andre Colares & Francisco Guerios

import UIKit

typealias NullableCompletion = (() -> ())?
typealias AlertButtonWithAction = (AlertButtonTitle, NullableCompletion)
typealias AlertButtonTitle = Messages

extension UIViewController {
    func singleButtonAlertWith(title: String = AppInfo.AppName , message: Messages? = nil, customMessage: String? = nil,
                               button action: AlertButtonTitle = Messages.ok,
                               completionOnButton: NullableCompletion = nil,
                               completionOPresentationOfAlert:  NullableCompletion = nil) {
        let alert = UIAlertController(title: title, message: customMessage ??  message?.value ?? "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: action.value, style: .default, handler: { action in
            if let methodAfterCompletion = completionOnButton {
                methodAfterCompletion()
            }
        }))
        present(alert, animated: true, completion: completionOPresentationOfAlert)
    }

    func alertWith(title: String = AppInfo.AppName, message: Messages? = nil,customMessage: String? = nil, completionOPresentationOfAlert:  NullableCompletion = nil, actions: AlertButtonWithAction...) {
        let alertController = UIAlertController(title: title, message: customMessage ??  message?.value ?? "", preferredStyle: UIAlertController.Style.alert)
        for (title, action) in actions {
            let alertAction = UIAlertAction(title: title.value, style:
                title.value == Messages.cancel.value ? .destructive : .default) { _ in
                if let actionToPerform = action {
                    actionToPerform()
                }
            }
            alertController.addAction(alertAction)
        }
        present(alertController, animated: true, completion: completionOPresentationOfAlert)
    }
}
