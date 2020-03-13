//
//  AlertAction.swift
//  GeolocationTest
//
//  Created by Ramón Quiñonez on 09/03/20.
//  Copyright © 2020 rq-c. All rights reserved.
//

import UIKit

struct Alert {
    let view:UIViewController
    let title:String
    let message:String
    let descriptionButton:String
    let actionSheet: UIAlertController.Style
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
                                                preferredStyle: alert.actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: alert.descriptionButton, style: .default) { _ in
            self.alertActionDelegate?.accept()
        })
        
        if alert.actionSheet == .actionSheet{
            alertController.addAction(UIAlertAction(title: "Restart", style: .destructive) { _ in
                self.alertActionDelegate?.restart()
            })
        }

        
        alert.view.present(alertController, animated: true, completion: nil)
    }
    
    func showShareAlert(image:UIImage?){
        let screen = image
        var objectsToShare = [Any]()
        objectsToShare.append(alert.message)
        objectsToShare.append(screen!)

    
        let activityController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        alert.view.present(activityController, animated: true, completion: nil)
    }
}

protocol AlertActionDelegate {
    func accept()
    func restart()
}
