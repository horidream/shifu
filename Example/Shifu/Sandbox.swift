//
//  Sandbox.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/3/13.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI
import Shifu
import JavaScriptCore
import Combine

struct Sandbox:View{
    @ObservedObject private var injectObserver = Self.injectionObserver
    @State var content = "> Stay Hungry, Stay Foolish<br><p style='text-align: right; margin-right: 20px;'>—— Jobs</p> "
    @State var loadingStatus: LoadingViewStatus = .empty
    @State var is2FAValidated = false
    @EnvironmentObject var vm: HomeViewModel
    var body: some View{
        VStack(){
            SimpleMarkdownViewer(content: content)
                .id(content)
                .padding()
            
            Text("Is 2FA Validated:  \(is2FAValidated ? "YES" : "NO" )")
                .font(.largeTitle)
            Spacer()
            
            Button{
                rootViewController.presend2FAViewController{
                    is2FAValidated = $0
                }
            } label: {
                Text("2FA Validation")
            }

        }
        .onChange(of: vm.isNetworkAvailable) {
            _ in
            sandbox()
        }
        .navigationTitle("Sandbox")
        .onInjection {
            sandbox()
        }
        .onAppear{
            sandbox()
            
        }
    }
    
    
    enum LoadingStatus {
        case empty, loading, loadingWithConnectivityCheck, success, failed
    }
    
    enum LoadingViewStatus:String{
        case empty, loading, nointernet, success, failed
        var description:String{
            switch self{
            case .empty: return ""
            case .nointernet: return "No Internet Connection"
            default: return self.rawValue
            }
        }
    }
    
    func sandbox(){
        let status:LoadingStatus = .loadingWithConnectivityCheck
        if case .loadingWithConnectivityCheck = status, !vm.isNetworkAvailable{
            // render no internet connection view
            loadingStatus = .nointernet
        }else{
            // render loading view
            loadingStatus = .loading
        }
        
    }
}


class Merchant2FAViewController:UIViewController{
    var dismissCallback:((Bool)->Void)?
    var validated = CurrentValueSubject<Bool, Never>(false)
    override func viewDidLoad() {
        let label = UILabel()
        view.addSubview(label)
        label.quickAlign()
        let btn = UIButton()
        btn.setTitle("change validated status", for: .normal)
        btn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(onChangeValidated), for: .touchUpInside)
        view.addSubview(btn)
        btn.quickAlign(5, 0, 40)
        validated.onReceive { validated in
            label.text = "Validated: \(validated)"
        }
    }
    
    @objc func onChangeValidated(){
        validated.value = !validated.value
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .gray
        view.quickMargin(8,8,8,8)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
            dismissCallback?(validated.value)
        }
    }
}

extension UIViewController{
    func presend2FAViewController(result: @escaping (Bool)->Void ){
        let m2fa = Merchant2FAViewController()
        m2fa.dismissCallback = result
        self.show(m2fa, sender: self)
    }
}


