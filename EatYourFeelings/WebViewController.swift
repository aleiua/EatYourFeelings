//
//  WebViewController.swift
//  EatYourFeelings
//
//  Created by A. Lynn on 12/15/14.
//  Copyright (c) 2014 Lexie Lynn. All rights reserved.
//

//import Cocoa
import UIKit

class WebViewController: UIViewController {
    
    
    var url: NSURL!
    
    @IBOutlet var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = NSURLRequest(URL: url)
        webView.loadRequest(request)
    }

//    @IBAction func doRefresh(AnyObject) {
//        webView.reload()
//    }
//    
//    @IBAction func goBack(AnyObject) {
//        webView.goBack()
//    }
//    
//    @IBAction func goForward(AnyObject) {
//        webView.goForward()
//    }
//    
//    @IBAction func stop(AnyObject) {
//        webView.stopLoading()
//    }

}
