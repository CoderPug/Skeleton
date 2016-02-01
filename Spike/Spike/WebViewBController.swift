//
//  WebViewBController.swift
//  Spike
//
//  Created by Jose Torres Cardenas on 1/02/16.
//  Copyright © 2016 santex. All rights reserved.
//

import UIKit

class WebViewBController: UIViewController {
    
    var stringURL : String!
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.tabBarController?.tabBar.hidden = true
        webView.opaque = false
        webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, -50, 0)
        
        let url = NSURL (string: stringURL)
        let requestObj = NSURLRequest(URL: url!)
        webView.loadRequest(requestObj)
    }

}
