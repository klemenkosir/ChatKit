//
//  ChatCollectionViewController.swift
//  ChatKit
//
//  Created by Klemen Kosir on 22. 01. 17.
//  Copyright © 2017 Klemen Kosir. All rights reserved.
//

import UIKit

public class ChatCollectionViewController: UIViewController {
	
	public static func viewController() -> ChatCollectionViewController {
		return UIStoryboard(name: "ChatInterface", bundle: Bundle(identifier: "com.tovarnaidej.ChatKit")).instantiateViewController(withIdentifier: "chatCollectionViewController") as!  ChatCollectionViewController
	}
	
	static weak var instance: ChatCollectionViewController!
	
	@IBOutlet weak var collectionView: UICollectionView!
	
	weak var dataSource: ChatDataSource?
	weak var delegate: ChatDelegate?
	var chatVC: ChatViewController!
	
	var pageIndex = 0
	var currentNumOfMessages = 0
	var lastPageSize = 0
	var isLoadingNextPage = false
	var hasMorePages: Bool {
		return dataSource?.hasMorePages ?? false
	}
	
	fileprivate var hasLatestMessages: Bool {
		return dataSource?.hasLatestMessages == true
	}
	
	override public func viewDidLoad() {
		super.viewDidLoad()
		ChatCollectionViewController.instance = self
		
		self.view.backgroundColor = ChatSettings.backgroundColor
		self.collectionView.backgroundColor = ChatSettings.backgroundColor
		self.collectionView.scrollsToTop = false
		
		self.collectionView.contentInset = UIEdgeInsetsMake(16.0, 0.0, 16.0, 0.0)
	}
	
	func scrollToBottom(animated: Bool = false, indexOffset: Int = 0) {
		let numberOfItems = collectionView.numberOfItems(inSection: 0) + indexOffset
		if numberOfItems > 0 {
			DispatchQueue.main.async {
				self.collectionView.scrollToItem(at: IndexPath(item: numberOfItems-1, section: 0), at: .bottom, animated: animated)
			}
		}
	}
	
	func calculateContentSize(forMessage message: MessageProtocol) -> CGSize {
		switch message.content.contentType {
		case .text:
			let size = calculateTextContentSize(forMessage: message)
			return CGSize(width: collectionView.frame.size.width, height: size.height)
		case .image:
			return calculateImageContentSize(forMessage: message)
		case .video:
			break
		}
		return .zero
	}
	
	func calculateTextContentSize(forMessage message: MessageProtocol) -> CGSize {
		let bubbleStyle = message.user.id == ChatSettings.senderUser?.id ? ChatSettings.sentbubbleStyle : ChatSettings.receivedbubbleStyle
		
		var contentRect = calculateTextViewRect(forMessage: message)
		
		//add offset if there is time label
		if bubbleStyle.hasTimeLabel && !message.isSystem {
			let timeContentRect = NSString(string: "0:00").boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude,
			                                                                         height: CGFloat.greatestFiniteMagnitude),
			                                                            options:  [.usesFontLeading, .usesLineFragmentOrigin],
			                                                            attributes: [NSFontAttributeName : bubbleStyle.timeFont],
			                                                            context: nil)
			contentRect = contentRect.insetBy(dx: 0.0, dy: -(timeContentRect.size.height + 4.0)/2.0)
		}
		
		//add top and bottom inset
		contentRect = contentRect.insetBy(dx: 0.0, dy: -16.0/2.0)
		let size = CGSize(width: ceil(contentRect.size.width), height: ceil(contentRect.size.height))
		//		print("CONTENT WIDTH: ",contentWidth, "; CONTENT SIZE: ",size,"; CONTENT TEXT: ",message.content.content as! String)
		return size
	}
	
	func calculateTextViewRect(forMessage message: MessageProtocol) -> CGRect {
		let bubbleStyle = message.user.id == ChatSettings.senderUser?.id ? ChatSettings.sentbubbleStyle : ChatSettings.receivedbubbleStyle
		
		let contentText = message.content.content as! NSString
		
		let contentWidth: CGFloat = self.collectionView.frame.size.width - (35.0 + 8.0 + 50.0 + 12.0 + 8.0)
		var contentRect = contentText.boundingRect(with: CGSize(width: contentWidth,
		                                                        height: CGFloat.greatestFiniteMagnitude),
		                                           options: [.usesFontLeading, .usesLineFragmentOrigin],
		                                           attributes: [NSFontAttributeName : ChatSettings.messageFont],
		                                           context: nil)
		
		//add contentInset
		contentRect = contentRect.insetBy(dx: -(bubbleStyle.textContainerInset.left + bubbleStyle.textContainerInset.right),
		                                  dy: -(bubbleStyle.textContainerInset.top + bubbleStyle.textContainerInset.bottom)/2.0)
		
		contentRect.origin = .zero
		
		return contentRect
	}
	
	func calculateImageContentSize(forMessage message: MessageProtocol) -> CGSize {
		return CGSize(width: collectionView.frame.size.width, height: 300.0)
	}
	
}

extension ChatCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	
	public func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let numOfMessages = dataSource?.numberOfMessages(collectionView) ?? 0
		lastPageSize = numOfMessages - currentNumOfMessages
		currentNumOfMessages = numOfMessages
		return currentNumOfMessages + (hasMorePages ? 1 : 0) + (hasLatestMessages ? 0 : 1)
	}
	
	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		if (hasMorePages && indexPath.row == 0) || (!hasLatestMessages && indexPath.row+1 == collectionView.numberOfItems(inSection: 0)) {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "loadingCell", for: indexPath)
			(cell.viewWithTag(1) as! UIActivityIndicatorView).startAnimating()
			return cell
		}
		
		let messageIndex = IndexPath(row: indexPath.row-(hasMorePages ? 1 : 0), section: indexPath.section)
		guard let message = dataSource?.chat(collectionView, messageForIndexPath: messageIndex) else {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "loadingCell", for: indexPath)
			(cell.viewWithTag(1) as! UIActivityIndicatorView).startAnimating()
			return cell
		}
		
		var cellIdentifier = message.user.id == ChatSettings.senderUser?.id ? "messageCell_sent" : "messageCell_received"
		if message.isSystem {
			cellIdentifier = "messageCell_system"
		}
		//		print("CELL IDENTIFIER: ",cellIdentifier, " | ",message.user.id,":",ChatSettings.senderUser?.id)
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: messageIndex) as! MessageCell
		
		cell.delegate = delegate
		cell.set(message: message)
		
		return cell
	}
	
	public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		if !isLoadingNextPage && indexPath.row == 0 && hasMorePages && currentNumOfMessages > 0 {
			isLoadingNextPage = true
			let nextPageIndex = pageIndex+1
			dataSource?.chat(loadNextPage: nextPageIndex, completion: { (loaded, isLastPage) in
				DispatchQueue.main.async {
					if loaded {
						self.collectionView.reloadData()
						self.collectionView.scrollToItem(at: IndexPath(row: self.lastPageSize, section: 0), at: .top, animated: false)
					}
					else {
						self.collectionView.reloadData()
					}
					self.pageIndex = nextPageIndex
					self.isLoadingNextPage = false
				}
			})
		}
	}
	
	public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if let cell = collectionView.cellForItem(at: indexPath) as? MessageCollectionViewCell {
			delegate?.chat(collectionView, didSelect: cell.message)
		}
	}
	
}

//extension ChatCollectionViewController: UICollectionViewDataSourcePrefetching {
//
//	public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//		for indexPath in indexPaths {
//			let messageIndex = IndexPath(row: indexPath.row-(hasMorePages ? 1 : 0), section: indexPath.section)
//			guard let message = dataSource?.chat(collectionView, messageForIndexPath: messageIndex) else {
//				return
//			}
//
//			if message.content.contentType == .image {
//				message.content.contentUpdate = nil
//			}
//		}
//	}
//
//}

extension ChatCollectionViewController: UICollectionViewDelegateFlowLayout {
	
	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		if (hasMorePages && indexPath.row == 0) || (!hasLatestMessages && indexPath.row+1 == collectionView.numberOfItems(inSection: 0)) {
			return CGSize(width: collectionView.frame.size.width, height: 60.0)
		}
		if let message = dataSource?.chat(collectionView, messageForIndexPath: IndexPath(row: indexPath.row-(hasMorePages ? 1 : 0), section: indexPath.section)) {
			let cellSize = calculateContentSize(forMessage: message)
			return cellSize
		}
		return .zero
	}
	
}
