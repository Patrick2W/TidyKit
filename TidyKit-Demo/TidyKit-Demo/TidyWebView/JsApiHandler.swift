//
//  JsApiHandler.swift
//  TestKeepAlive
//
//  Created by wh on 2024/3/8.
//

import WebKit

class JsApiHandler: JsBaseHandler {
    
    enum InvokeResult: String {
        case succeed = "1"
        case failed = "0"
    }
    
    typealias InvokeFunc = @convention(c)(AnyObject, Selector, String, [String: Any]) -> String
    
    override func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let params = message.body as? [String: Any] else {
            return
        }
        handleJsFunc(params)
    }
    
    /// {"cmd": "share","args": {}}
    @discardableResult
    func handleJsFunc(_ params: [String: Any]) -> String {
        guard let cmd = params["cmd"] as? String else {
            return InvokeResult.failed.rawValue
        }
        let args = params["args"] as? [String: Any] ?? [:]
        let methodName = "_invoke_\(cmd):args:"
        let sel = Selector(methodName)
        
        if self.responds(to: sel), let imp = self.method(for: sel) {
            let m = unsafeBitCast(imp, to: InvokeFunc.self)
            return m(self, sel, cmd, args)
        }
        return InvokeResult.failed.rawValue
    }
}

private extension JsApiHandler {
    
    @objc func _invoke_shareWeb(_ cmd: String, args: [String: Any]) {
        
    }
}
