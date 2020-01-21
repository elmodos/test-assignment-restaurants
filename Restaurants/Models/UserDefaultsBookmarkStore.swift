//
//  UserDefaultsBookmarkStore.swift
//  Restaurants
//
//  Created by Modo Ltunzher on 19.01.2020.
//  Copyright © 2020 Modo Ltunzher. All rights reserved.
//

import Foundation
import RxSwift

public class UserDefaultsBookmarkStore<TElement: Encodable & Equatable>: AnyBookmarkStore<TElement> {
    
    var synchronizeToFile: Bool = true
    public typealias Element = TElement
    override public var bookmarksChanged: Observable<Void> {
        self.bookmarksChangedSubject.asObservable()
    }
    
    private let bookmarksChangedSubject: PublishSubject<Void> = PublishSubject()
    private var userDefaults: UserDefaults
    public let key: String
    
    public init(userDefaults: UserDefaults, key: String = "bookmarks") {
        self.userDefaults = userDefaults
        self.key = key
    }
    
    public convenience init?(suiteName: String, key: String = "bookmarks") {
        guard let userDefaults = UserDefaults(suiteName: suiteName) else {
            return nil
        }
        self.init(userDefaults: userDefaults)
    }

    public override func setBookmarked(_ value: Bool, element: Element) {
        var array: [Element] = self.userDefaults
            .array(forKey: self.key) as? [Element]
            ?? []
        let index = array.firstIndex(of: element)
        let isBookmarked = index != nil
        guard value != isBookmarked else { return }
        if let index = index {
            // remove
            array.remove(at: index)
        } else {
            array.append(element)
        }
        self.userDefaults.set(array, forKey: self.key)
        if self.synchronizeToFile {            
            self.userDefaults.synchronize()
        }
        self.bookmarksChangedSubject.onNext(())
    }
    
    public override func isBookmarked(_ element: Element) -> Bool {
        let array = self.userDefaults.array(forKey: self.key) as? [Element]
        return array?.contains(element)
            ?? false
    }
}
