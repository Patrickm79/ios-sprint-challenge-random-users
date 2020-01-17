//
//  Cache.swift
//  Random Users
//
//  Created by Patrick Millet on 1/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {

    private var cache = [Key: Value]()
    private var queue = DispatchQueue(label: "com.LambdaSchool.RandomUsers.ConcurrentOperationStateQueue")

    func cache(value: Value, forKey key: Key) {
        queue.async {
            self.cache[key] = value
        }
    }

    func value(forKey key: Key) -> Value? {
        return queue.sync {
            self.cache[key]
        }
    }
}
