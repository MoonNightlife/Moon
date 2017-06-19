//
//  WebViewUIViViewController.swift
//  Moon
//
//  Created by Evan Noble on 6/9/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Material

class WebViewUIViViewController: UIViewController, BindableType, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    var viewModel: WebViewViewModel!
    var navBackButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.delegate = self
        webView.loadRequest(URLRequest(url: viewModel.url))
        prepareNavigationBackButton()
    }
    
    fileprivate func prepareNavigationBackButton() {
        navBackButton = UIBarButtonItem()
        navBackButton.image = Icon.cm.arrowBack
        navBackButton.tintColor = .lightGray
        self.navigationItem.leftBarButtonItem = navBackButton
    }
    
    func bindViewModel() {
        navBackButton.rx.action = viewModel.onBack()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        title = webView.stringByEvaluatingJavaScript(from: "document.title")
    }

}
