//
//  Array+Combine.swift
//  PokeMaster
//
//  Created by 杨冬青 on 2020/6/18.
//  Copyright © 2020 杨冬青. All rights reserved.
//

import Foundation
import Combine

extension Array where Element: Publisher {
    var zipAll: AnyPublisher<[Element.Output], Element.Failure> {
        let initial = Just([Element.Output]())
            .setFailureType(to: Element.Failure.self)
            .eraseToAnyPublisher()
        return reduce(initial) { result, publisher in
            result.zip(publisher) { $0 + [$1] }.eraseToAnyPublisher()
        }
    }
}
