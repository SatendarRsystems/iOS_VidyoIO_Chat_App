//
//  MyError.swift
//  VIO
//
//
//  Summary: MyError Component
//  Description: A custom error class to consume data of API call failure.
//
//  Created by Arun Kumar on 27/09/18.
//  Copyright © 2018 R Systems. All rights reserved.
//

import Foundation

public enum MyError: Error {
    case customError
}

extension MyError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .customError:
            return NSLocalizedString("Something went wrong", comment: "Server Error")
        }
    }
}
