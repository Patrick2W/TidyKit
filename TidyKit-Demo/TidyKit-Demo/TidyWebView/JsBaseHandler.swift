//
//  JsBaseHandler.swift
//  TestKeepAlive
//
//  Created by wh on 2024/3/8.
//

import WebKit

protocol JsCallbackProtocol {
    
}

extension JsCallbackProtocol {
    
}

class JsBaseHandler: NSObject {
    
    private(set) weak var delegate: (UIViewController & JsCallbackProtocol)?
    
    init(delegate: (UIViewController & JsCallbackProtocol)) {
        super.init()
        self.delegate = delegate
    }
}

extension JsBaseHandler: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
}
