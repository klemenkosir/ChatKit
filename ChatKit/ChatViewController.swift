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
		return UIStoryboard(name: "ChatInterface", bundle: Bundle(identifier: "com.klemenkosir.ChatKit")).instantiateViewController(withIdentifier: "chatViewController") as!  ChatViewController
	}
	
	public static weak var currentInstance: ChatViewController?
	
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
	
	fileprivate var isInitialLoad = true
	fileprivate var shouldShowKeyboardWOAnimation = true
	fileprivate var wasKeyboardVisible = false
	
    override public func viewDidLoad() {
        super.viewDidLoad()
		
		ChatViewController.currentInstance = self
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)

		collectionViewContainer.addSubviewFromViewController(collectionVC, useAutoLayout: true)
		chatBarContainer.addSubviewFromViewController(chatBarVC, useAutoLayout: true)
		
		chatBarContainerHeightConstraint.constant = ChatSettings.chatBarStyle.height
		
		collectionVC.chatVC = self
		chatBarVC.chatVC = self
    }
	
	public override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		chatBarContainer.isUserInteractionEnabled = !ChatSettings.disableInput
		
		let barStyle = ChatSettings.chatBarStyle
		chatBarContainer.shadowRadius = barStyle.shadowRadius
		chatBarContainer.shadowOpacity = Float(barStyle.shadowOpacity)
		chatBarContainer.shadowOffset = barStyle.shadowOffset
		chatBarContainer.shadowColor = barStyle.shadowColor
		chatBarContainer.backgroundColor = barStyle.backgroundColor
		
		if isInitialLoad {
			self.collectionVC.scrollToBottom()
		}
		if wasKeyboardVisible {
			self.chatBarVC.showKeyboard()
		}
		else {
			chatBarBottomConstraint.constant = 0.0
		}
	}
	
	public override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		isInitialLoad = false
		shouldShowKeyboardWOAnimation = false
	}
	
	public override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		shouldShowKeyboardWOAnimation = true
		wasKeyboardVisible = self.chatBarVC.textView.isFirstResponder
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
		self.chatBarVC.showKeyboard()
	}
	
	public func hideKeyboard() {
		self.chatBarVC.hideKeyboard()
	}
	
}

extension ChatViewController {
	
	func keyboardWillShow(_ notification: Notification) {
		let info = notification.userInfo!
		let keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
		
		chatBarBottomConstraint.constant = keyboardFrame.size.height
		if !shouldShowKeyboardWOAnimation {
			self.view.layoutIfNeeded()
		}
		
		collectionVC.scrollToBottom(animated: true)
	}
	
	func keyboardWillChangeFrame(_ notification: Notification) {
		guard !shouldShowKeyboardWOAnimation else { return }
		let info = notification.userInfo!
		let keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
		
		chatBarBottomConstraint.constant = keyboardFrame.size.height
		self.view.layoutIfNeeded()
	}
	
	func keyboardWillHide(_ notificaion: Notification) {
		guard !shouldShowKeyboardWOAnimation else { return }
		chatBarBottomConstraint.constant = 0.0
		self.view.layoutIfNeeded()
	}
	
}
