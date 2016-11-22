//
//  LoginItems.swift
//  LoginItems
//
//  Created by Nikolai Vazquez on 7/20/15.
//  Copyright (c) 2015 Nikolai Vazquez. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

/// Manager is a subclass of NSObject so that it can be conveniently included in xib files.
public class LoginItemsManager : NSObject {

    public static var shared = LoginItemsManager()

    public var startAtLogin: Bool {
        get {
            return itemReferencesInLoginItems().thisReference != nil
        }
        set {
            makeLoginItem(newValue)
        }
    }

    private var loginItemsReference: LSSharedFileList? {
        return LSSharedFileListCreate(
            nil,
            kLSSharedFileListSessionLoginItems.takeRetainedValue(),
            nil
            ).takeRetainedValue() as LSSharedFileList?
    }

    private func makeLoginItem(_ shouldBeLoginItem: Bool) {
        let itemReferences = itemReferencesInLoginItems()
        if let loginItemsRef = loginItemsReference {
            if shouldBeLoginItem {
                let bundleURL = Bundle.main.bundleURL as NSURL
                LSSharedFileListInsertItemURL(loginItemsRef, itemReferences.lastItemReference, nil, nil, bundleURL, nil, nil)
            }
            else if let itemReference = itemReferences.thisReference {
                LSSharedFileListItemRemove(loginItemsRef, itemReference)
            }
        }
    }

    private func itemReferencesInLoginItems() -> (thisReference: LSSharedFileListItem?, lastItemReference: LSSharedFileListItem?) {
        let bundleURL = Bundle.main.bundleURL as NSURL
        if let loginItemsRef = loginItemsReference {
            let loginItems = LSSharedFileListCopySnapshot(loginItemsRef, nil).takeRetainedValue() as NSArray
            if loginItems.count > 0 {
                let lastItemReference = loginItems.lastObject as! LSSharedFileListItem

                for currentItemReference in loginItems as! [LSSharedFileListItem] {
                    let itemURL = LSSharedFileListItemCopyResolvedURL(currentItemReference, 0, nil)
                    if itemURL != nil && bundleURL.isEqual(itemURL?.takeRetainedValue()) {
                        return (currentItemReference, lastItemReference)
                    }
                }
                return (nil, lastItemReference)
            }
            else {
                return (nil, kLSSharedFileListItemBeforeFirst.takeRetainedValue())
            }
        }
        return (nil, nil)
    }

}
