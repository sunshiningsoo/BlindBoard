//
//  FirebaseConstant.swift
//  BlindBoard
//
//  Created by 박성수 on 2022/08/15.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct FirebaseConstant {
    static let appName: String = "BlindBoard"
    static let collectiontemp: String = "Boardtemp"
    static let documenttemp: String = "documenttemp"
    static let commentCollection: String = "comments"
    
    static let FIRESTORE = Firestore.firestore().collection(FirebaseConstant.collectiontemp)
    static let FIRECOMMENT = Firestore.firestore().collection(FirebaseConstant.commentCollection)
}
