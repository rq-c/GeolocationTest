//
//  AlertAction.swift
//  GeolocationTest
//
//  Created by Emmauel Galindo on 09/03/20.
//  Copyright © 2020 rq-c. All rights reserved.
//

import UIKit


class AlertAction {
    
    var alertActionDelegate: AlertActionDelegate?
    
    func show(view:UIViewController, title:String, message:String){
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            self.alertActionDelegate?.accept()
        })
        alertController.addAction(UIAlertAction(title: "Restart", style: .destructive) { _ in
            self.alertActionDelegate?.restart()
        })
        
        view.present(alertController, animated: true, completion: nil)
    }
    
    func showShareAlert(view:UIViewController, title:String?){
        var objectsToShare = [Any]()
        
        if let shareTitle = title {
            objectsToShare.append(shareTitle)
        }
        let activityController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        view.present(activityController, animated: true, completion: nil)
    }
    
    func showSimpleAlert(view:UIViewController,title:String, message:String) {
        let alert = UIAlertController(title: title, message: message,         preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "Yes, remove",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        self.alertActionDelegate?.accept()
        }))
        view.present(alert, animated: true, completion: nil)
    }

    
}

protocol AlertActionDelegate {
    func accept()
    func restart()
}
