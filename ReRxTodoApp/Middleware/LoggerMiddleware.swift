//
//  LoggerMiddleware.swift
//  ReRxTodoApp
//
//  Created by 南部竜太郎 on 2020/04/02.
//  Copyright © 2020 nmbry. All rights reserved.
//

import Foundation
import RxSwift
import ReSwift

struct LoggerMiddleware {
    func myLogger() -> Middleware<AppState> {
        return { dispatch, getState in
            return { next in
                return { action in
                    switch action {
                    case is TodoActionInput:
                        next(action)
                        print("[Middleware]: TodoActionInput")
                    case is TodoActionOkCancel:
                        next(action)
                        print("[Middleware]: TodoActionOkCancel")
                    case is TodoActionDelete:
                        next(action)
                        print("[Middleware]: TodoActionDelete")
                    default:
                        next(action)
                    }
                }
            }
        }
    }
}
