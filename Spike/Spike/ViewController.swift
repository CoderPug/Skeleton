//
//  ViewController.swift
//  Spike
//
//  Created by Jose Torres Cardenas on 1/02/16.
//  Copyright © 2016 santex. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private func loadWebAComponent(webPageURL: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let webViewA = storyboard.instantiateViewControllerWithIdentifier("webViewAController") as! WebViewAController
        webViewA.stringURL = webPageURL
        self.navigationController!.pushViewController(webViewA, animated: true)
    }
    
    private func loadWebBComponent(webPageURL: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let webViewB = storyboard.instantiateViewControllerWithIdentifier("webViewBController") as! WebViewBController
        webViewB.stringURL = webPageURL
        self.navigationController!.pushViewController(webViewB, animated: true)
    }

    @IBAction func buttonGeneralInformationTouchUpInside(sender: AnyObject) {
        self.loadWebAComponent("http://www.poli.edu.co/content/quienes-somos");
    }
    
    @IBAction func buttonMapTouchUpInside(sender: AnyObject) {
        self.loadWebAComponent("http://www.poli.edu.co/sedes");
    }
    
    @IBAction func buttonNewTouchUpInside(sender: AnyObject) {
        self.loadWebBComponent("http://www.poli.edu.co/content/disponible-el-3er-y-ultimo-listado-de-becas-para-el-2015-ii");
    }
}

