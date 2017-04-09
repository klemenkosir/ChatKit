//
//  ChatDelegate.swift
//  ChatKit
//
//  Created by Klemen Kosir on 24. 01. 17.
//  Copyright © 2017 Klemen Kosir. All rights reserved.
//

import UIKit

public protocol ChatDataSource: class {
	
	func numberOfMessages(_ chatCollectionView: UICollectionView) -> Int
	func chat(_ chatCollectionView: UICollectionView, messageForIndexPath indexPath: IndexPath) -> MessageProtocol
	func chat(loadNextPage pageIndex: Int, completion: @escaping (_ loaded: Bool, _ isLastPage: Bool) -> Void)
	var hasLatestMessages: Bool { get }
	var hasMorePages: Bool { get }
	
}
