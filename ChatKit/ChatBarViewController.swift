//
//  ChatBarViewController.swift
//  ChatKit
//
//  Created by Klemen Kosir on 22. 01. 17.
//  Copyright © 2017 Klemen Kosir. All rights reserved.
//

import UIKit

public class ChatBarViewController: UIViewController {

	public static func viewController() -> ChatBarViewController {
		return UIStoryboard(name: "ChatInterface", bundle: Bundle(identifier: "com.tovarnaidej.ChatKit")).instantiateViewController(withIdentifier: "chatBarViewController") as!  ChatBarViewController
	}
	
	@IBOutlet weak var sendButton: UIButton!
	@IBOutlet weak var textView: UITextView!
	@IBOutlet weak var textViewContainer: UIView!
	@IBOutlet weak var placeholderTextView: UITextView!
	@IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
	
	weak var delegate: ChatDelegate!
	weak var chatVC: ChatViewController!
	
    override public func viewDidLoad() {
        super.viewDidLoad()
		setup()
    }
	
	private func setup() {
		let barStyle = ChatSettings.chatBarStyle
		
		if let sendButtonImage = barStyle.sendButtonImage {
			sendButton.setImage(sendButtonImage, for: .normal)
			sendButton.setTitle(nil, for: .normal)
		}
		else {
			sendButton.setImage(nil, for: .normal)
			sendButton.setTitle(barStyle.sendButtonText, for: .normal)
		}
		
		textView.textContainerInset = .zero
		textView.autocorrectionType = .no
		placeholderTextView.textContainerInset = .zero
		
		sendButton.isUserInteractionEnabled = false
		if let img = barStyle.sendButtonImageDisabled {
			sendButton.setImage(img, for: .normal)
			sendButton.setTitle(nil, for: .normal)
		}
		else {
			sendButton.alpha = 0.3
		}
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(textViewContainerHandler(_:)))
		textViewContainer.addGestureRecognizer(tap)
	}
	
	public override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		textViewHeightConstraint.constant = textView.intrinsicContentSize.height
		chatVC.view.layoutIfNeeded()
	}
	
	fileprivate func createMessage() -> MessageProtocol? {
		guard let senderUser = ChatSettings.senderUser else { return nil }
		let user = MessageUser(senderUser.id)
		let content = MessageContent(.text, self.textView.text)
		let message = Message(user, content)
		return message
	}
	
	fileprivate func enableSendButtonIfNeeded() {
		if !textView.text.characters.isEmpty && !sendButton.isUserInteractionEnabled {
			if let _ = ChatSettings.chatBarStyle.sendButtonImageDisabled {
				self.sendButton.setImage(ChatSettings.chatBarStyle.sendButtonImage, for: .normal)
			}
			else {
				UIView.animate(withDuration: 0.3) {
					self.sendButton.alpha = 1.0
				}
			}
			sendButton.isUserInteractionEnabled = true
		}
		else if textView.text.characters.isEmpty {
			if let img = ChatSettings.chatBarStyle.sendButtonImageDisabled {
				self.sendButton.setImage(img, for: .normal)
			}
			else {
				UIView.animate(withDuration: 0.3) {
					self.sendButton.alpha = 0.3
				}
			}
			sendButton.isUserInteractionEnabled = false
		}
	}
	
	fileprivate func updateTextViewHeight() {
		let textHeight = textView.textStorage.size().height
		let placeholderHeight = placeholderTextView.textStorage.size().height
		var newHeight = textHeight + 2.0
		if newHeight > 120.0 {
			newHeight = 120.0
		}
		if newHeight < placeholderHeight {
			newHeight = placeholderHeight
		}
		print("NEW CHAT BAR HEIGHT: ", newHeight)
		textViewHeightConstraint.constant = newHeight
		textView.isScrollEnabled = textHeight > 120.0
		chatVC.view.layoutIfNeeded()
	}

}

//Actions
extension ChatBarViewController {
	
	@IBAction func sendButtonHandler(_ sender: UIButton) {
		guard let message = createMessage() else {
			print("MESSAGE NOT CREATED")
			return
		}
		textView.text = ""
		showPlaceholderIfNeeded()
		updateTextViewHeight()
		delegate.chat(send: message)
	}
	
}

//Gestures
extension ChatBarViewController {
	
	func textViewContainerHandler(_ gesture: UITapGestureRecognizer) {
		textView.becomeFirstResponder()
	}
	
}

//TextView Delegate
extension ChatBarViewController: UITextViewDelegate {
	
	public func textViewDidChange(_ textView: UITextView) {
		showPlaceholderIfNeeded()
		enableSendButtonIfNeeded()
		updateTextViewHeight()
	}
	
	
	public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
		return delegate.chatIsConnected()
	}
	
	public func textViewDidBeginEditing(_ textView: UITextView) {
		enableSendButtonIfNeeded()
	}
	
	public func textViewDidEndEditing(_ textView: UITextView) {
		enableSendButtonIfNeeded()
	}
	
	public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		if text == "\n" && textView.text.isEmpty {
			return false
		}
		return true
	}
	
	fileprivate func showPlaceholderIfNeeded(_ text: String = "") {
		placeholderTextView.isHidden = !(textView.text.characters.isEmpty && text.characters.isEmpty)
	}
	
}