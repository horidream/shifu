//
//  ShifuPopover.swift
//  Shifu
//
//  Created by Baoli Zhai on 2023/1/22.
//

import SwiftUI

public extension View{
    @ViewBuilder
    func shifuPopover<Content: View>(isPresented: Binding<Bool>, arrowDirection: UIPopoverArrowDirection = .down, @ViewBuilder content: @escaping ()->Content) -> some View{
        self.background{
            PopoverController(isPresented: isPresented, arrowDirection: arrowDirection, content: content())
        }
    }
}

public struct PopoverController<Content: View>: UIViewControllerRepresentable {
    
    @Binding var isPresented: Bool
    var arrowDirection: UIPopoverArrowDirection
    var content: Content
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    public func makeUIViewController(context: Context) -> UIViewController {
        let vc = UIViewController()
        return vc
    }
    
    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
        
        if isPresented {
            if let controller = uiViewController.presentedViewController as? CustomHostingController<Content>{
                controller.rootView = content
                controller.preferredContentSize = controller.view.intrinsicContentSize
            } else {
                let controller = CustomHostingController(rootView: content)
                controller.view.backgroundColor = .clear
                controller.modalPresentationStyle = .popover
                controller.popoverPresentationController?.permittedArrowDirections = arrowDirection
                controller.presentationController?.delegate = context.coordinator
                controller.popoverPresentationController?.sourceView = uiViewController.view
                uiViewController.present(controller, animated: true)
            }
        }
    }
    
    public class Coordinator: NSObject, UIPopoverPresentationControllerDelegate{
        var parent: PopoverController
        init(parent: PopoverController){
            self.parent = parent
        }
        
        public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
            return .none
        }
        
        public func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
            parent.isPresented = false
        }
    }
}


class CustomHostingController<Content: View>: UIHostingController<Content>{
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = view.intrinsicContentSize
    }
}
