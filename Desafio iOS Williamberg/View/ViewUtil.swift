//
//  ViewUtil.swift
//  Desafio iOS Williamberg
//
//  Created by berg on 20/03/19.
//  Copyright © 2019 berg. All rights reserved.
//

import UIKit

class ViewUtil {
    
    private static let activityControllerTag = 199//usado em showLoading e hideLoading
    
    class func showLoading(text: String, parent: UIView){
        let label: UILabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: parent.frame.width, height: 30.0))
        let activityController = UIView(frame: CGRect(x: 0, y: 0, width: parent.bounds.width, height: parent.bounds.height))
        activityController.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
        activityController.tag = activityControllerTag
        let activity = UIActivityIndicatorView(style: .whiteLarge)
        
        label.frame.size.width = (activityController.bounds.width) * 0.9
        label.center = (activityController.center)
        label.frame.origin.x = ((activityController.bounds.width) - label.bounds.width)/2
        label.frame.origin.y = activity.frame.origin.y + activity.bounds.height/2 + 8
        label.text = text
        label.textAlignment = .center
        label.textColor = UIColor.white
        
        activity.center = (activityController.center)
        activity.startAnimating()
        
        activityController.addSubview(label)
        activityController.addSubview(activity)
        parent.addSubview(activityController)
    }
    
    class func hideLoading(parent: UIView){
        if let view = parent.subviews.filter( {$0.tag == activityControllerTag } ).first{
            view.removeFromSuperview()
        }
    }
    
    /// it presents an AlertController with a title, a message and an OK button.
    ///
    /// - Parameters:
    ///   - title: title for the alert.
    ///   - message: A describe message for the alert.
    ///   - viewController: the viewController the will present the alert.
    class func showAlert(title: String?, message: String?,viewController: UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }
}
