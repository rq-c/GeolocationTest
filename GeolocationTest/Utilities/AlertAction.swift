//
//  AlertAction.swift
//  GeolocationTest
//
//  Created by Emmauel Galindo on 09/03/20.
//  Copyright © 2020 rq-c. All rights reserved.
//

import UIKit

struct Alert {
    let view:UIViewController
    let title:String
    let message:String
}
class AlertAction {
    
    var alert:Alert
    
    init(alert:Alert){
        self.alert = alert
    }

    var alertActionDelegate: AlertActionDelegate?
    var alertController:UIAlertController!
    
    func show(){
        alertController = UIAlertController(title: alert.title,
                                                message: alert.message,
                                                preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            self.alertActionDelegate?.accept()
        })
        alertController.addAction(UIAlertAction(title: "Restart", style: .destructive) { _ in
            self.alertActionDelegate?.restart()
        })
        
        alert.view.present(alertController, animated: true, completion: nil)
    }
    
    func showShareAlert(){
        var objectsToShare = [Any]()
        objectsToShare.append(alert.title)
    
        let activityController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        alert.view.present(activityController, animated: true, completion: nil)
    }
    
    func showSimpleAlert() {
        alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in
            //Cancel Action
        }))
        alertController.addAction(UIAlertAction(title: "Yes, remove",
                                                style: .destructive,
                                      handler: {(_: UIAlertAction!) in
                                        self.alertActionDelegate?.accept()
        }))
        alert.view.present(alertController, animated: true, completion: nil)
    }
}

protocol AlertActionDelegate {
    func accept()
    func restart()
}
