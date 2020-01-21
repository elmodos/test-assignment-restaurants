//
//  BookmarkStore.swift
//  Restaurants
//
//  Created by Modo Ltunzher on 19.01.2020.
//  Copyright © 2020 Modo Ltunzher. All rights reserved.
//

import Foundation
import RxSwift

public protocol BookmarkStore {
    associatedtype Element
    
    var bookmarksChanged: Observable<Void> { get }
    mutating func setBookmarked(_ value: Bool, element: Element)
    func isBookmarked(_ element: Element) -> Bool
}

public class AnyBookmarkStore<TElement: Encodable & Equatable> : BookmarkStore {
    public typealias Element = TElement
    public private(set) var bookmarksChanged: Observable<Void> = Observable.empty()
    public func setBookmarked(_ value: Bool, element: Element) {}
    public func isBookmarked(_ element: Element) -> Bool { return false}
}

public extension BookmarkStore {
    
    mutating func toggle(for element: Element) {
        let isBookmarked =  self.isBookmarked(element)
        self.setBookmarked(!isBookmarked, element: element)
    }
}
