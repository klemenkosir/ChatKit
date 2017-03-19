//
//  MessageCollectionViewCell.swift
//  ChatKit
//
//  Created by Klemen Kosir on 24. 01. 17.
//  Copyright © 2017 Klemen Kosir. All rights reserved.
//

import UIKit

class MessageCollectionViewCell: MessageCell {
	
	
	@IBOutlet weak var messageContentView: UIView!
	@IBOutlet weak var userView: UIImageView!
	@IBOutlet weak var bubbleView: UIView!
	@IBOutlet weak var timeLabel: UILabel?
	
	//constraints
	@IBOutlet weak var userViewWidth: NSLayoutConstraint!
	@IBOutlet weak var userViewHeight: NSLayoutConstraint!
	
	weak var message: MessageProtocol!
	
	var contentHeight: CGFloat = 80.0 {
		didSet {
			var ch = contentHeight
			if ch < 66 {
				ch = 66
			}
			contentHeight = ch
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		setup()
	}
	
	private func setup() {
		//avatar
		let avatarStyle = ChatSettings.avatarStyle
		self.userView.cornerRadius = avatarStyle.cornerRadius
		self.userView.shadowColor = avatarStyle.shadowColor
		self.userView.shadowOffset = avatarStyle.shadowOffset
		self.userView.shadowRadius = avatarStyle.shadowRadius
		self.userView.shadowOpacity = Float(avatarStyle.shadowOpacity)
		self.userViewWidth.constant = avatarStyle.size.width
		self.userViewHeight.constant = avatarStyle.size.height
		
		let userTapGesture = UITapGestureRecognizer(target: self, action: #selector(userTapHandler(_:)))
		self.userView.addGestureRecognizer(userTapGesture)
		
		
		//bubble
		let bubbleStyle = self.reuseIdentifier!.contains("received") ? ChatSettings.receivedbubbleStyle : ChatSettings.sentbubbleStyle
		self.bubbleView.cornerRadius = bubbleStyle.cornerRadius
		self.bubbleView.shadowColor = bubbleStyle.shadowColor
		self.bubbleView.shadowOffset = bubbleStyle.shadowOffset
		self.bubbleView.shadowRadius = bubbleStyle.shadowRadius
		self.bubbleView.shadowOpacity = Float(bubbleStyle.shadowOpacity)
		self.bubbleView.backgroundColor = bubbleStyle.bacgroundColor
		
		if bubbleStyle.hasTimeLabel {
			self.timeLabel!.font = bubbleStyle.timeFont
			self.timeLabel!.textColor = bubbleStyle.timeTextColor
		}
		else {
			timeLabel!.removeFromSuperview()
		}
		
		//basic
		self.backgroundColor = ChatSettings.backgroundColor
		self.contentView.backgroundColor = ChatSettings.backgroundColor
		messageContentView.backgroundColor = ChatSettings.backgroundColor
		
		createBubbleTail()
		
		self.layer.rasterizationScale = UIScreen.main.nativeScale
		self.layer.shouldRasterize = true
	}
	
	private func createBubbleTail() {
		let tail = UIView()
		tail.translatesAutoresizingMaskIntoConstraints = false
		self.messageContentView.addSubview(tail)
		
		let path = UIBezierPath()
		if self.reuseIdentifier == "messageCell_received" {
			self.messageContentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[tail(4)][bubble]", options: .directionLeadingToTrailing, metrics: nil, views: ["tail" : tail, "bubble" : bubbleView]))
			self.messageContentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[tail(12)]", options: .directionLeadingToTrailing, metrics: nil, views: ["tail" : tail]))
			self.messageContentView.addConstraint(NSLayoutConstraint(item: userView, attribute: .centerY, relatedBy: .equal, toItem: tail, attribute: .centerY, multiplier: 1.0, constant: 0.0))
			
			path.move(to: CGPoint(x: 0.0, y: 6.0))
			path.addLine(to: CGPoint(x: 4.0, y: 0.0))
			path.addLine(to: CGPoint(x: 4.0, y: 12))
			path.close()
		}
		else {
			self.messageContentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[bubble][tail(4)]", options: .directionLeadingToTrailing, metrics: nil, views: ["tail" : tail, "bubble" : bubbleView]))
			self.messageContentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[tail(12)]", options: .directionLeadingToTrailing, metrics: nil, views: ["tail" : tail]))
			self.messageContentView.addConstraint(NSLayoutConstraint(item: userView, attribute: .centerY, relatedBy: .equal, toItem: tail, attribute: .centerY, multiplier: 1.0, constant: 0.0))
			
			path.move(to: CGPoint(x: 4.0, y: 6.0))
			path.addLine(to: CGPoint(x: 0.0, y: 0.0))
			path.addLine(to: CGPoint(x: 0.0, y: 12))
			path.close()
		}
		
		let shapeLayer = CAShapeLayer()
		shapeLayer.path = path.cgPath
		let bubbleStyle = self.reuseIdentifier!.contains("received") ? ChatSettings.receivedbubbleStyle : ChatSettings.sentbubbleStyle
		shapeLayer.fillColor = bubbleStyle.bacgroundColor.cgColor
		
		tail.layer.addSublayer(shapeLayer)
	}
	
	private func cleanupBubble() {
		bubbleView.subviews.forEach { (subview) in
			subview.removeFromSuperview()
		}
	}
	
	override func set(message: MessageProtocol) {
		self.message = message
		switch message.content.contentType {
		case .text:
			handleTextContent(message.content)
		case .image:
			break
		case .video:
			break
		}
		
		self.timeLabel?.text = message.timeString
		
		self.userView?.backgroundColor = ChatSettings.avatarStyle.backgroundColor
		self.userView?.image = message.user.image
		self.message.user.imageUpdateBlock = { [unowned self] (newImage) in
				self.userView?.image = newImage
		}
	}
	
	private func handleTextContent(_ content: MessageContentProtocol) {
		
		let bubbleStyle = self.reuseIdentifier!.contains("received") ? ChatSettings.receivedbubbleStyle : ChatSettings.sentbubbleStyle
		
		let text = content.content as! String
		
		if let textView = bubbleView.viewWithTag(1) as? UITextView {
			textView.text = text
		}
		else {
			cleanupBubble()
			
			let textView = UITextView()
			textView.tag = 1
			textView.text = text
			textView.backgroundColor = .clear
			textView.font = ChatSettings.messageFont
			textView.textColor = bubbleStyle.textColor
			textView.textContainerInset = bubbleStyle.textContainerInset
			textView.translatesAutoresizingMaskIntoConstraints = false
			textView.isScrollEnabled = false
			textView.showsVerticalScrollIndicator = false
			textView.showsHorizontalScrollIndicator = false
			textView.isEditable = false
			textView.dataDetectorTypes = .all
			textView.tintColor = .white
			self.bubbleView.addSubview(textView)
			
			//constraints
			self.bubbleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[textView]|", options: .directionLeadingToTrailing, metrics: nil, views: ["textView" : textView]))
			self.bubbleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[textView]|", options: .directionLeadingToTrailing, metrics: nil, views: ["textView" : textView]))
		}
	}
	
	func userTapHandler(_ gesture: UITapGestureRecognizer) {
		delegate?.chat(didSelectAvatar: message)
	}
	
}

extension MessageProtocol {
	
	var timeString: String {
		guard let date = date else { return "" }
		if date.isToday() {
			return date.toString(format: .custom("H:mm"))
		}
		if date.isThisWeek() {
			return date.toString(format: .custom("EEE H:mm"))
		}
		if date.isThisYear() {
			return date.toString(format: .custom("d.MMM"))
		}
		return date.toString(format: .custom("H:mm d.M.yyyy"))
	}
	
}
