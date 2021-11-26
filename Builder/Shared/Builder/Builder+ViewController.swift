//
//  Builder+ViewController.swift
//  ViewBuilder
//
//  Created by Michael Long on 10/4/20.
//  Copyright © 2020 Michael Long. All rights reserved.
//

import UIKit

extension UIViewController {

//    convenience public init(view: View, padding: UIEdgeInsets? = nil, safeArea: Bool = false) {
//        self.init()
//        if #available(iOS 13, *) {
//            self.view.backgroundColor = .systemBackground
//        } else {
//            self.view.backgroundColor = .white
//        }
//        self.view.embed(view, padding: padding, safeArea: safeArea)
//    }
    
    convenience public init(_ view: View, padding: UIEdgeInsets? = nil, safeArea: Bool = false) {
        self.init()
        if #available(iOS 13, *) {
            self.view.backgroundColor = .systemBackground
        } else {
            self.view.backgroundColor = .white
        }
        self.view.embed(view.build(), padding: padding, safeArea: safeArea)
    }
    
    public func transtion(to page: View, position: UIView.EmbedPosition = .fill, padding: UIEdgeInsets? = nil,
                          safeArea: Bool = false, delay: Double = 0.2) {
        view.transtion(to: page, padding: padding, safeArea: safeArea, delay: delay)
    }

}

class BuilderHostViewController: UIViewController {

    private var builder: (() -> ViewConvertable)?
    private var onViewDidLoadBlock: ((_ viewController: BuilderHostViewController) -> Void)?
    private var onViewWillAppearBlock: ((_ viewController: BuilderHostViewController) -> Void)?
    private var onViewDidAppearBlock: ((_ viewController: BuilderHostViewController) -> Void)?

    public init(@ViewResultBuilder _ builder: @escaping () -> ViewConvertable) {
        self.builder = builder
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let view: View = builder?().asViews().first else {
            fatalError()
        }
        self.view.embed(view)
        if #available(iOS 13, *) {
            self.view.backgroundColor = .systemBackground
        } else {
            self.view.backgroundColor = .white
        }
        onViewDidLoadBlock?(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onViewWillAppearBlock?(self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        onViewDidAppearBlock?(self)
    }

}

extension BuilderHostViewController {

    @discardableResult
    public func onViewDidLoad(block: @escaping (_ viewController: BuilderHostViewController) -> Void) -> Self {
        self.onViewDidLoadBlock = block
        return self
    }

    @discardableResult
    public func onViewWillAppearBlock(block: @escaping (_ viewController: BuilderHostViewController) -> Void) -> Self {
        self.onViewWillAppearBlock = block
        return self
    }

    @discardableResult
    public func onViewDidAppear(block: @escaping (_ viewController: BuilderHostViewController) -> Void) -> Self {
        self.onViewDidAppearBlock = block
        return self
    }

}
