//
//  ChatViewController.swift
//  ChatKit
//
//  Created by Klemen Kosir on 22. 01. 17.
//  Copyright © 2017 Klemen Kosir. All rights reserved.
//

import UIKit

public class ChatViewController: UIViewController {

	public static func viewController() -> ChatViewController {
		return UIStoryboard(name: "ChatInterface", bundle: Bundle(identifier: "com.tovarnaidej.ChatKit")).instantiateViewController(withIdentifier: "chatViewController") as!  ChatViewController
	}
	
	@IBOutlet weak var collectionViewContainer: UIView!
	@IBOutlet weak var chatBarContainer: UIView!
	@IBOutlet weak var chatBarContainerHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var chatBarBottomConstraint: NSLayoutConstraint!
	
	public weak var dataSource: ChatDataSource? {
		didSet {
			collectionVC.dataSource = dataSource
		}
	}
	public weak var delegate: ChatDelegate? {
		didSet {
			collectionVC.delegate = delegate
			chatBarVC.delegate = delegate
		}
	}
	
	let collectionVC = ChatCollectionViewController.viewController()
	let chatBarVC = ChatBarViewController.viewController()
	
	private var isInitialLoad = true
	
    override public func viewDidLoad() {
        super.viewDidLoad()
		
		chatBarContainerHeightConstraint.constant = ChatSettings.chatBarStyle.height

		collectionViewContainer.addSubviewFromViewController(collectionVC, useAutoLayout: true)
		chatBarContainer.addSubviewFromViewController(chatBarVC, useAutoLayout: true)
		
		collectionVC.chatVC = self
		chatBarVC.chatVC = self
		
		chatBarContainer.isUserInteractionEnabled = !ChatSettings.disableInput
    }
	
	public override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if isInitialLoad {
			self.collectionVC.scrollToBottom()
		}
	}
	
	public override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
		
		isInitialLoad = false
	}
	
	public override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		NotificationCenter.default.removeObserver(self)
	}
	
	public func reloadChat(didReceiveNewMessage: Bool = false) {
		guard let _ = collectionVC.collectionView else { return }
		
		collectionVC.collectionView.reloadData()
		if didReceiveNewMessage {
			self.collectionVC.scrollToBottom(indexOffset: -1)
			self.collectionVC.scrollToBottom(animated: true)
		}
		else {
			self.collectionVC.scrollToBottom()
		}
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	public func showKeyboard() {
		self.chatBarVC.textView.becomeFirstResponder()
	}
	
}

extension ChatViewController {
	
	func keyboardWillShow(_ notification: Notification) {
		let info = notification.userInfo!
		let keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
		
		chatBarBottomConstraint.constant = keyboardFrame.size.height
		self.view.layoutIfNeeded()
		
		collectionVC.scrollToBottom(animated: true)
	}
	
	func keyboardWillChangeFrame(_ notification: Notification) {
		let info = notification.userInfo!
		let keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
		
		chatBarBottomConstraint.constant = keyboardFrame.size.height
		self.view.layoutIfNeeded()
	}
	
	func keyboardWillHide(_ notificaion: Notification) {
		chatBarBottomConstraint.constant = 0.0
		self.view.layoutIfNeeded()
	}
	
}
