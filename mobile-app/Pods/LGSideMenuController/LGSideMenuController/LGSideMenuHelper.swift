//
//  LGSideMenuHelper.swift
//  LGSideMenuController
//
//
//  The MIT License (MIT)
//
//  Copyright © 2015 Grigorii Lutkov <friend.lga@gmail.com>
//  (https://github.com/Friend-LGA/LGSideMenuController)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import ObjectiveC
import QuartzCore
import UIKit

internal struct LGSideMenuHelper {
    private struct Keys {
        static var sideMenuController = "sideMenuController"
    }

    static func animate(duration: TimeInterval, timingFunction: CAMediaTimingFunction, animations: @escaping () -> Void, completion: @escaping () -> Void) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(duration)
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        CATransaction.setAnimationTimingFunction(timingFunction)
        animations()
        CATransaction.commit()
        UIView.commitAnimations()
    }

    static func statusBarAppearanceUpdate(viewController: UIViewController, duration: TimeInterval, animations: (() -> Void)?) {
        if viewController.preferredStatusBarUpdateAnimation == .none || duration == .zero {
            if let animations = animations {
                animations()
            }
            viewController.setNeedsStatusBarAppearanceUpdate()
        }
        else {
            UIView.animate(withDuration: duration, animations: {
                if let animations = animations {
                    animations()
                }
                viewController.setNeedsStatusBarAppearanceUpdate()
            })
        }
    }

    static func isPhone() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }

    static func isPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }

    static func getKeyWindow() -> UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        } else {
            return UIApplication.shared.keyWindow
        }
    }

    static func getStatusBarFrame() -> CGRect {
        if #available(iOS 13.0, *) {
            return getKeyWindow()?.windowScene?.statusBarManager?.statusBarFrame ?? .zero
        } else {
            return UIApplication.shared.statusBarFrame
        }
    }

    static func getInterfaceOrientation() -> UIInterfaceOrientation? {
        if #available(iOS 13.0, *) {
            return getKeyWindow()?.windowScene?.interfaceOrientation
        } else {
            return UIApplication.shared.statusBarOrientation
        }
    }

    static func isPortrait() -> Bool {
        return getInterfaceOrientation()?.isPortrait ?? true
    }

    static func isLandscape() -> Bool {
        return getInterfaceOrientation()?.isLandscape ?? false
    }

    static func setSideMenuController(_ sideMenuController: LGSideMenuController?, to viewController: UIViewController) {
        objc_setAssociatedObject(viewController, &Keys.sideMenuController, sideMenuController, .OBJC_ASSOCIATION_ASSIGN)
    }

    static func getSideMenuController(from viewController: UIViewController) -> LGSideMenuController? {
        return objc_getAssociatedObject(viewController, &Keys.sideMenuController) as? LGSideMenuController
    }

    static func canPerformSegue(_ viewController: UIViewController, withIdentifier identifier: String) -> Bool {
        guard let identifiers = viewController.value(forKey: "storyboardSegueTemplates") as? [NSObject] else { return false }
        return identifiers.contains { (object: NSObject) -> Bool in
            if let id = object.value(forKey: "_identifier") as? String {
                return id == identifier
            } else {
                return false
            }
        }
    }

}
