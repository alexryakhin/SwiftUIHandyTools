import UIKit
import SwiftUI
import Combine

@available(iOS 13.0, *)
final class BottomSheetHostingController<Content>: UIHostingController<Content> where Content: View {

    @Binding private var isPresented: Bool

    private let bottomSheetTransitioningDelegate: BottomSheetTransitioningDelegate

    private let indicatorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2
        view.backgroundColor = .secondaryLabel
        return view
    }()

    override var modalPresentationStyle: UIModalPresentationStyle {
        get { .custom }
        set { }
    }

    override var transitioningDelegate: UIViewControllerTransitioningDelegate? {
        get { bottomSheetTransitioningDelegate }
        set { }
    }

    // swiftlint:disable final_class
    init(
        isPresented: Binding<Bool>,
        ignoresKeyboard: Bool = true,
        showsIndicator: Bool = true,
        preferredSheetCornerRadius: CGFloat = 16,
        preferredSheetBackdropColor: UIColor = .label,
        preferredSheetSizing: BottomSheetSize = .fit,
        tapToDismissEnabled: Bool = true,
        panToDismissEnabled: Bool = true,
        content: Content
    ) {
        _isPresented = isPresented

        bottomSheetTransitioningDelegate = BottomSheetTransitioningDelegate(
            preferredSheetCornerRadius: preferredSheetCornerRadius,
            preferredSheetBackdropColor: preferredSheetBackdropColor,
            preferredSheetSizing: preferredSheetSizing.value,
            panToDismissEnabled: panToDismissEnabled,
            tapToDismissEnabled: tapToDismissEnabled
        )

        indicatorView.isHidden = !showsIndicator

        super.init(rootView: content)

        if ignoresKeyboard {
            guard let viewClass = object_getClass(view) else { return }

            let viewSubclassName = String(cString: class_getName(viewClass)).appending("_IgnoresKeyboard")
            if let viewSubclass = NSClassFromString(viewSubclassName) {
                object_setClass(view, viewSubclass)
            } else {
                guard let viewClassNameUtf8 = (viewSubclassName as NSString).utf8String else { return }
                guard let viewSubclass = objc_allocateClassPair(viewClass, viewClassNameUtf8, 0) else { return }

                if let method = class_getInstanceMethod(viewClass, NSSelectorFromString("keyboardWillShowWithNotification:")) {
                    let keyboardWillShow: @convention(block) (AnyObject, AnyObject) -> Void = { _, _ in }
                    class_addMethod(viewSubclass, NSSelectorFromString("keyboardWillShowWithNotification:"),
                                    imp_implementationWithBlock(keyboardWillShow), method_getTypeEncoding(method))
                }
                objc_registerClassPair(viewSubclass)
                object_setClass(view, viewSubclass)
            }
        }
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicatorView.topAnchor.constraint(equalTo: view.topAnchor, constant: 4),
            indicatorView.widthAnchor.constraint(equalToConstant: 32),
            indicatorView.heightAnchor.constraint(equalToConstant: 4)
        ])
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        isPresented = false
    }
}
