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
        view.addSubview(webView)

        load(url: "https://google.com")
    }
    @IBAction func BackButtonAction(_ sender: Any) {
    }
    @IBAction func ForwardButtonAction(_ sender: Any) {
    }
    
    // MARK: Private methods
    private func load(url: String) {
        webView.load(URLRequest(url: URL(string: url)!))
    }
    
}

// MARK: Delegates
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

