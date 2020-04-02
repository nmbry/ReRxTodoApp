//
//  TodoReducer.swift
//  ReRxTodoApp
//
//  Created by 南部竜太郎 on 2020/04/02.
//  Copyright © 2020 nmbry. All rights reserved.
//

import ReSwift

func todoInputReducer(action: Action, state: AppState?) -> AppState {
    var state = state ?? AppState()
    
    switch action {
    case is TodoActionInput:
        state.todo = (action as! TodoActionInput).todo
    case is TodoActionOkCancel:
        switch (action as! TodoActionOkCancel).okCancel {
        case .ok :
            state.todoList.insert(state.todo, at: 0)
        case .cancel:
            print("CANCEL")
        }
    case is TodoActionDelete:
        let idx = (action as! TodoActionDelete).rowIndex
        state.todoList.remove(at: idx)
    default:
        break
    }
    
    return state
}
