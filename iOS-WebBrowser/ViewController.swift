//
//  ViewController.swift
//  iOS-WebBrowser
//
//  Created by Flavio Leite on 23/07/2019.
//  Copyright © 2019 Flavio Leite. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {


    // MARK: Outlets
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    
    // MARK: Variables
    private let searchBar = UISearchBar()
    private var webView: WKWebView!
    private let refreshControl = UIRefreshControl()
    private let baseURL = "http://www.google.com"
    private let searchPath = "/search?q="


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SearchBar
        self.navigationItem.titleView = searchBar
        searchBar.delegate = self
        

        // Navigation Buttons
        forwardButton.isEnabled = false
        backButton.isEnabled = false
        
        let webViewPrefs = WKPreferences()
        webViewPrefs.javaScriptEnabled = true
        webViewPrefs.javaScriptCanOpenWindowsAutomatically = true
        let webViewConf = WKWebViewConfiguration()
        webViewConf.preferences = webViewPrefs
        
        webView = WKWebView(frame: view.frame, configuration: webViewConf)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.scrollView.keyboardDismissMode = .onDrag
        view.addSubview(webView)
        webView.navigationDelegate = self
        
        refreshControl.addTarget(self, action: #selector(reload), for: .valueChanged)
        webView.scrollView.addSubview(refreshControl)
        view.bringSubviewToFront(refreshControl)
        
        load(url: baseURL)
    }
    
    // MARK: Buttons action's
    @IBAction func BackButtonAction(_ sender: Any) {
        webView.goBack()
    }
    @IBAction func ForwardButtonAction(_ sender: Any) {
        webView.goForward()
    }
    
    // MARK: Private methods
    private func load(url: String) {
        var urlToLoad: URL!
        if let url = URL(string: url), UIApplication.shared.canOpenURL(url) {
            urlToLoad = url
        } else {
            urlToLoad = URL(string: "\(baseURL)\(searchPath)\(url)")!
        }
        webView.load(URLRequest(url: urlToLoad))
    }
    
    @objc private func reload() {
        webView.reload()
    }
    
}

// MARK: Search Delegate
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        load(url: searchBar.text ?? "")
    }
}

// MARK: WebView Navigation Delegate
extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        backButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward
        refreshControl.endRefreshing()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        refreshControl.beginRefreshing()
        searchBar.text = webView.url?.absoluteString
    }
}

