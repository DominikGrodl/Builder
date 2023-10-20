//
//  Builder+Button
//  ViewBuilder
//
//  Created by Michael Long on 10/29/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


public struct ButtonView: ModifiableView {
    
    public let modifiableView = Modified(UIButton()) {
		$0.setTitleColor(ViewBuilderEnvironment.defaultButtonColor ?? $0.tintColor, for: .normal)
		$0.titleLabel?.font = ViewBuilderEnvironment.defaultButtonFont ?? .preferredFont(forTextStyle: .headline)
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    // lifecycle
    public init(_ title: String? = nil) {
        modifiableView.setTitle(title, for: .normal)
    }
    
    public init(_ title: String? = nil, action: @escaping (_ context: ViewBuilderContext<UIButton>) -> Void) {
        modifiableView.setTitle(title, for: .normal)
        onTap(action)
    }
}


// Custom UIImageView modifiers
extension ModifiableView where Base: UIButton {

    @discardableResult
    public func alignment(_ alignment: UIControl.ContentHorizontalAlignment) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.contentHorizontalAlignment, value: alignment)
    }

    @discardableResult
    public func backgroundColor(_ color: UIColor, for state: UIControl.State) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { $0.setBackgroundImage(UIImage(color: color), for: state) }
    }

    @discardableResult
    public func color(_ color: UIColor, for state: UIControl.State = .normal) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { $0.setTitleColor(color, for: state) }
    }

    @discardableResult
    public func font(_ font: UIFont?) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { $0.titleLabel?.font = font }
    }

    @discardableResult
    public func font(_ style: UIFont.TextStyle) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { $0.titleLabel?.font = .preferredFont(forTextStyle: style) }
    }

    @discardableResult
    public func onTap(_ handler: @escaping (_ context: ViewBuilderContext<UIButton>) -> Void) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { [unowned modifiableView] view in
            view.rx.tap
                .throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
                .subscribe(onNext: { () in handler(ViewBuilderContext(view: modifiableView)) })
                .disposed(by: view.rxDisposeBag)
        }
    }

}

extension UIButton: ViewBuilderPaddable {
    
    public func setPadding(_ padding: UIEdgeInsets) {
        self.contentEdgeInsets = padding
    }

}
