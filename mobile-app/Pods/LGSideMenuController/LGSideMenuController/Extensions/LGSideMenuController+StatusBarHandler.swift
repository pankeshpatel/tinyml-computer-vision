//
//  LGSideMenuController+StatusBarHandler.swift
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
import UIKit

extension LGSideMenuController {

    open override var prefersStatusBarHidden: Bool {
        if self.rootView != nil && (self.state == .rootViewIsShowing || self.state == .leftViewWillHide || self.state == .rightViewWillHide) {
            return self.isRootViewStatusBarHidden
        }
        else if self.leftView != nil && self.isLeftViewVisible && !self.isLeftViewAlwaysVisible {
            return self.isLeftViewStatusBarHidden
        }
        else if self.rightView != nil && self.isRightViewVisible && !self.isRightViewAlwaysVisible {
            return self.isRightViewStatusBarHidden
        }

        return super.prefersStatusBarHidden
    }

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        if self.rootView != nil && (self.state == .rootViewIsShowing || self.state == .leftViewWillHide || self.state == .rightViewWillHide) {
            return self.rootViewStatusBarStyle
        }
        else if self.leftView != nil && self.isLeftViewVisible && !self.isLeftViewAlwaysVisible {
            return self.leftViewStatusBarStyle
        }
        else if self.rightView != nil && self.isRightViewVisible && !self.isRightViewAlwaysVisible {
            return self.rightViewStatusBarStyle
        }

        return super.preferredStatusBarStyle
    }

    open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        if self.rootView != nil && self.state == .rootViewIsShowing {
            return self.rootViewStatusBarUpdateAnimation
        }
        else if self.leftView != nil && self.isLeftViewVisible && !self.isLeftViewAlwaysVisible {
            return self.leftViewStatusBarUpdateAnimation
        }
        else if self.rightView != nil && self.isRightViewVisible && !self.isRightViewAlwaysVisible {
            return self.rightViewStatusBarUpdateAnimation
        }

        return super.preferredStatusBarUpdateAnimation
    }

}
