//
//  WebViewController.swift
//  TestKeepAlive
//
//  Created by wh on 2024/3/8.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    struct Key {
        static let kJsApi = "kJsApi"
        static let kPrefix = "__invoke__"
    }
    
    private lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = WKUserContentController()
        configuration.preferences = WKPreferences()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        return webView
    }()
    
    private var jsApiHandler: JsApiHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        
        let apiHandler = JsApiHandler(delegate: self)
        webView.configuration.userContentController.add(apiHandler, name: Key.kJsApi)
        jsApiHandler = apiHandler
    }
    
    deinit {
        if jsApiHandler != nil {
            webView.configuration.userContentController.removeScriptMessageHandler(forName: Key.kJsApi)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
}

extension WebViewController: WKNavigationDelegate {
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
    {
        if allowNavigationAction(navigationAction) {
            decisionHandler(.allow)
        }
        else {
            decisionHandler(.cancel)
        }
    }
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        preferences: WKWebpagePreferences,
        decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void)
    {
        if allowNavigationAction(navigationAction) {
            decisionHandler(.allow, preferences)
        }
        else {
            decisionHandler(.cancel, preferences)
        }
    }
    
    private func allowNavigationAction(_ navigationAction: WKNavigationAction) -> Bool {
        guard let requestUrl = navigationAction.request.url else {
            return true
        }
        
        guard !requestUrl.isFileURL else {
            return true
        }
        
        guard let requestUrlScheme = requestUrl.scheme else {
            return true
        }
        
        switch requestUrlScheme {
        case "http", "https", "about":
            return true
        default:
            UIApplication.shared.open(requestUrl, options: [:], completionHandler: nil)
            return false
        }
    }
}

extension WebViewController: WKUIDelegate {
    
    func webView(
        _ webView: WKWebView,
        runJavaScriptTextInputPanelWithPrompt prompt: String,
        defaultText: String?,
        initiatedByFrame frame: WKFrameInfo,
        completionHandler: @escaping (String?) -> Void)
    {
        if prompt.hasPrefix(Key.kPrefix) {
            let startIndex = prompt.index(prompt.startIndex, offsetBy: Key.kPrefix.count)
            let endIndex = prompt.endIndex
            let jsonStr = String(prompt[startIndex..<endIndex])
            guard let jsonData = jsonStr.data(using: .utf8) else {
                completionHandler(nil)
                return
            }
            do {
                let jsonObj = try JSONSerialization.jsonObject(with: jsonData)
                if let json = jsonObj as? [String: Any] {
                    let result = jsApiHandler?.handleJsFunc(json)
                    completionHandler(result)
                }
                else {
                    completionHandler(nil)
                }
            } catch {
                completionHandler(nil)
            }
        }
        else {
            let inputAlertVc = UIAlertController(title: webView.title, message: prompt, preferredStyle: .alert)
            inputAlertVc.addTextField { textField in
                textField.text = defaultText
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
                completionHandler(nil)
            }
            let okAction = UIAlertAction(title: "OK", style: .default) { [weak inputAlertVc] action in
                if let textField = inputAlertVc?.textFields?.first {
                    completionHandler(textField.text)
                }
                else {
                    completionHandler(nil)
                }
            }
            inputAlertVc.addAction(cancelAction)
            inputAlertVc.addAction(okAction)
            
            self.present(inputAlertVc, animated: true)
        }
    }
}

extension WebViewController: JsCallbackProtocol {
    
}
