//
//  WebViewAController.swift
//  Spike
//
//  Created by Jose Torres Cardenas on 1/02/16.
//  Copyright © 2016 santex. All rights reserved.
//

import UIKit

class WebViewAController: UIViewController, UIWebViewDelegate {
    
    var stringURL : String!
    var theBool: Bool = false
    var myTimer: NSTimer = NSTimer()
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.tabBarController?.tabBar.hidden = true
        webView.opaque = false
        webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, -50, 0)
        webView.scrollView.bounces = false
        webView.delegate = self
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
    
    // MARK: - ProgressView logic
    
    func funcToCallWhenStartLoadingYourWebview() {
        progressView.progress = 0.0
        theBool = false
        myTimer = NSTimer.scheduledTimerWithTimeInterval(0.01667, target: self, selector: "timerCallback", userInfo: nil, repeats: true)
    }
    
    func funcToCallCalledWhenUIWebViewFinishesLoading() {
        theBool = true
    }
    
    func timerCallback() {
        if theBool {
            if progressView.progress >= 1 {
                progressView.hidden = true
                myTimer.invalidate()
            } else {
                progressView.progress += 0.1
            }
        } else {
            progressView.progress += 0.05
            if progressView.progress >= 0.95 {
                progressView.progress = 0.95
            }
        }
    }
    
    // MARK: - UIWebView delegate
    
    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.funcToCallWhenStartLoadingYourWebview()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        self.funcToCallCalledWhenUIWebViewFinishesLoading()
    }
    
}
