//
//  WebViewAController.swift
//  Spike
//
//  Created by Jose Torres Cardenas on 1/02/16.
//  Copyright © 2016 santex. All rights reserved.
//

import UIKit

class WebViewAController: UIViewController {
    
    var stringURL : String!
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.tabBarController?.tabBar.hidden = true
        webView.opaque = false
        webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, -50, 0)
        
        let url = NSURL (string: stringURL)
        let requestObj = NSURLRequest(URL: url!, cachePolicy:NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval:15.0)
        webView.loadRequest(requestObj)
    }
    
    @IBAction func buttonRefreshTouchUpInside(sender: AnyObject) {
        webView.reload()
    }
    
    @IBAction func buttonBackTouchUpInside(sender: AnyObject) {
        webView.goBack()
    }
    
    @IBAction func buttonForwardTouchUpInside(sender: AnyObject) {
        webView.goForward()
    }
}
