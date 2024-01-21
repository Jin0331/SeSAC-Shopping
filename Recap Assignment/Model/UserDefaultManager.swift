//
//  UserDefaultManager.swift
//  SeSAC4Network
//
//  Created by JinwooLee on 1/18/24.
//

import Foundation

// Singleton Pattern
class UserDefaultManager {
    
    static let shared = UserDefaultManager()
    
    private init(){  } // 초기화 구문에 대한 접근을 막음. 따라서 다른 인스턴스가 생성되지 못함.
       
    let ud = UserDefaults.standard
    
    //TODO: - Userstate, nickname, image 설정
    enum UDkey : String {
        case userState
        case search
        case like
    }
    
    enum UserStateCode {
        case new
        case old
        
        var state : Bool {
            switch self {
            case .new :
                return true
            case .old :
                return false
            }
        }
    }
    
    var userState : Bool {
        get {
            ud.bool(forKey: UDkey.userState.rawValue) ?? UserStateCode.new.state
        }
        set {
            ud.setValue(UserStateCode.old.state, forKey: UDkey.userState.rawValue)
        }
    }
    
    var search : [String] {
        get {
            ud.object(forKey: UDkey.search.rawValue) as? [String] ?? []
        }
        set {
            ud.set(newValue, forKey: UDkey.search.rawValue)
        }
    }
    
    var like : [String:Bool] {
        get {
            ud.object(forKey: UDkey.like.rawValue) as? [String:Bool] ?? [:]
        }
        set {
            ud.set(newValue, forKey: UDkey.like.rawValue)
        }
    }
    
    // function
    func userDefaultUpdateForLike(new : [String:Bool]) { // 전체 검색이 되었을 떄 실해되는 함수
        let currentValue = ud.object(forKey: UDkey.like.rawValue) as? [String:Bool] ?? [:]
        
        // merge를 할 때, 중복될 경우 현재 값을 보존한다.
        let keepingCurrent = currentValue.merging(new) { (current, _) in current }
        
        ud.setValue(keepingCurrent, forKey: UDkey.like.rawValue)
    }
    
    func userDefaultButtonUpdate(productID : String) { // button이 클릭될 떄마다, user
        var currentValue = ud.object(forKey: UDkey.like.rawValue) as? [String:Bool] ?? [:]
        
        currentValue[productID]?.toggle()
        
        ud.setValue(currentValue, forKey: UDkey.like.rawValue)
        
    }
    
}
