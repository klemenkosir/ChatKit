//
//  ChatDelegate.swift
//  ChatKit
//
//  Created by Klemen Kosir on 24. 01. 17.
//  Copyright © 2017 Klemen Kosir. All rights reserved.
//

import UIKit

public protocol ChatDataSource: class {
	
	var hasLatestMessages: Bool { get }
	var hasMorePages: Bool { get }
	
	func numberOfMessages(_ chatCollectionView: UICollectionView) -> Int
	func chat(_ chatCollectionView: UICollectionView, messageForIndexPath indexPath: IndexPath) -> MessageProtocol
	func chat(loadNextPage pageIndex: Int, completion: @escaping (_ loaded: Bool, _ isLastPage: Bool) -> Void)
	func chatWantsReload(_ completion: @escaping (_ loaded: Bool, _ shouldReload: Bool) -> Void) //call completion if you want the chat to reload automaticaly aka no need to call reloadChat
	
}
