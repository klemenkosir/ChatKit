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
	
	@IBOutlet weak var collectionView: UICollectionView!
	
	weak var dataSource: ChatDataSource?
	weak var delegate: ChatDelegate?
	weak var chatVC: ChatViewController?
	
    override public func viewDidLoad() {
        super.viewDidLoad()
		
		self.view.backgroundColor = ChatSettings.backgroundColor
		self.collectionView.backgroundColor = ChatSettings.backgroundColor
		self.collectionView.scrollsToTop = false
		
		self.collectionView.contentInset = UIEdgeInsetsMake(16.0, 0.0, 16.0, 0.0)
    }
	
	func scrollToBottom(animated: Bool = false, indexOffset: Int = 0) {
		let numberOfItems = collectionView.numberOfItems(inSection: 0) + indexOffset
		if numberOfItems > 0 {
			collectionView.scrollToItem(at: IndexPath(item: numberOfItems-1, section: 0), at: .bottom, animated: animated)
		}
	}
	
	func calculateContentSize(forMessage message: MessageProtocol) -> CGSize {
		
		let bubbleStyle = message.user.id == ChatSettings.senderUser?.id ? ChatSettings.sentbubbleStyle : ChatSettings.receivedbubbleStyle
		
		let contentText = message.content.content as! NSString
		
		let contentWidth: CGFloat = self.collectionView.frame.size.width - (35.0 + 8.0 + 50.0 + 12.0 + 8.0)
		var contentRect = contentText.boundingRect(with: CGSize(width: contentWidth,
		                                                        height: CGFloat.greatestFiniteMagnitude),
		                         options: [.usesFontLeading, .usesLineFragmentOrigin],
		                         attributes: [NSFontAttributeName : ChatSettings.messageFont],
		                         context: nil)
		
		//add contentInset
		contentRect = contentRect.insetBy(dx: -(bubbleStyle.textContainerInset.left + bubbleStyle.textContainerInset.right)/2.0,
		                    dy: -(bubbleStyle.textContainerInset.top + bubbleStyle.textContainerInset.bottom)/2.0)
		
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

}

extension ChatCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	
	public func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return dataSource?.numberOfMessages(collectionView) ?? 0
	}
	
	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		guard let message = dataSource?.chat(collectionView, messageForIndexPath: indexPath) else {
			return UICollectionViewCell()
		}
		
		var cellIdentifier = message.user.id == ChatSettings.senderUser?.id ? "messageCell_sent" : "messageCell_received"
		if message.isSystem {
			cellIdentifier = "messageCell_system"
		}
//		print("CELL IDENTIFIER: ",cellIdentifier, " | ",message.user.id,":",ChatSettings.senderUser?.id)
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! MessageCell
		
		cell.delegate = delegate
		cell.set(message: message)
		
		return cell
	}
	
	public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//		(cell as! MessageCell).update()
	}
	
	
}

extension ChatCollectionViewController: UICollectionViewDelegateFlowLayout {
	
	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		if let message = dataSource?.chat(collectionView, messageForIndexPath: indexPath) {
			let cellSize = CGSize(width: collectionView.frame.size.width, height: calculateContentSize(forMessage: message).height)
			return cellSize
		}
		return .zero
	}
	
}
