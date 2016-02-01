//
//  AcademicLifeViewController.swift
//  Spike
//
//  Created by Jose Torres Cardenas on 1/02/16.
//  Copyright © 2016 santex. All rights reserved.
//

import UIKit

class AcademicLifeViewController: UIViewController {
    
    private func loadWebAComponent(webPageURL: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let webViewA = storyboard.instantiateViewControllerWithIdentifier("webViewAController") as! WebViewAController
        webViewA.stringURL = webPageURL
        self.navigationController!.pushViewController(webViewA, animated: true)
    }
    
    @IBAction func buttonNewsTouchUpInside(sender: AnyObject) {
        self.loadWebAComponent("http://www.poli.edu.co");
    }
    
    @IBAction func buttonEventsTouchUpInside(sender: AnyObject) {
        self.loadWebAComponent("http://www.poli.edu.co");
    }
    
    @IBAction func buttonFAQsTouchUpInside(sender: AnyObject) {
        self.loadWebAComponent("http://www.poli.edu.co");
    }
    
}
