
//
//  ChatBarStype.swift
//  ChatKit
//
//  Created by Klemen Kosir on 24. 01. 17.
//  Copyright © 2017 Klemen Kosir. All rights reserved.
//

import Foundation

public struct ChatBarStyle {
	
	//shadow
	public var shadowOffset: CGSize = .zero
	public var shadowOpacity: CGFloat = 0.0
	public var shadowRadius: CGFloat = 0.0
	public var shadowColor: UIColor = .clear
	
	//size
	public var height: CGFloat = 50.0
	
	//background
	public var backgroundColor: UIColor = .white
	
	//send button
	public var sendButtonText: String = "SEND"
	public var sendButtonImage: UIImage?
	public var sendButtonImageDisabled: UIImage?
	
	//placeholder text
	public var placeholderText: String = "Type message"
	
	//action button
	public var actionButtonVisible: Bool = false
	public var actionButtonImage: UIImage?
	public var actionButtonImageDisabled: UIImage?
	public var actionButtonText: String = "ACT"
	
	public init() {}
	
}
