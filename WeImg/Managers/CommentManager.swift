//
//  CommentManager.swift
//  WeImg
//
//  Created by lzw on 16/2/12.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import Foundation

class CommentManager: BaseManager {
    static let manager: CommentManager = {
        return CommentManager()
    }()
    
    func createComment(content: String, postId: Int, parentId: Int?, completion: (NSError?) -> Void) {
        var params = [String: AnyObject]()
        params["content"] = content
        if let parentId = parentId {
            params["parentId"] = parentId
        }
        HttpClient.request(.POST, "posts/" + String(postId) + "/comments", completion: completion)
    }
    
    func getComments(postId: Int, skip: Int, limit: Int, completion:([Comment], NSError?) -> Void) {
        var params = [String: AnyObject]()
        params["skip"] = skip
        params["limit"] = limit
        HttpClient.requestArray(.GET, "posts/" + String(postId) + "/comments", parameters: params, completion: completion)
    }
    
    func voteComment(postId: Int, commentId: Int, vote: String, completion:(NSError?) -> Void) {
        HttpClient.request(.GET, "posts/" + String(postId) + "/comments/" + String(commentId) + "/vote/" + vote, completion: completion)
    }
}
