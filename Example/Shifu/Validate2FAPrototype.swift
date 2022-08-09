//
//  2FAPrototype.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/4/27.
//  Copyright © 2022 CocoaPods. All rights reserved.
//


import SwiftUI
import Shifu
import JavaScriptCore
import Combine

struct Validate2FAPrototype:View{
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
                _rootViewController.presend2FAViewController{
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

protocol Merchant2FAValidator{
    var validated:CurrentValueSubject<Bool, Never> { get }
    var onValidationComplete:((Bool)->Void)? { get set }
}

class Merchant2FAViewController:UIViewController{
    var onValidationComplete:((Bool)->Void)?
    var validated = CurrentValueSubject<Bool, Never>(false)
    override func viewDidLoad() {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 38)
        view.addSubview(label)
        
        label.quickAlign()
        let btn = UIButton(configuration: .plain())
        btn.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        btn.configuration?.title = "Mock Validation"
        btn.configuration?.baseForegroundColor = .white
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(onChangeValidated), for: .touchUpInside)
        view.addSubview(btn)
        btn.quickAlign(5, 0, 38 + 5)
        validated.onReceive { validated in
            label.text = self.message(for: validated)
            if validated {
                delay(0.4){
                    self.dismiss(animated: false)
                }
            }
        }
    }
    
    func message(for validated: Bool)->String{
        if validated {
            return "VALIDATED"
        } else {
            return "VALIDATING..."
        }
    }
    
    @objc func onChangeValidated(){
        validated.value = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .gray.withAlphaComponent(0.96)
        view.layer.cornerRadius = 20
        view.quickMargin(8,8,8,8)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
            onValidationComplete?(validated.value)
        }
    }
}

extension UIViewController{
    func presend2FAViewController(onValidationComplete: @escaping (Bool)->Void ){
        let m2fa = Merchant2FAViewController()
        m2fa.onValidationComplete = onValidationComplete
        m2fa.modalPresentationStyle = .fullScreen
        self.present(m2fa, animated: false)
    }
}


