//
//  ChatBubbleStyle.swift
//  ChatKit
//
//  Created by Klemen Kosir on 24. 01. 17.
//  Copyright © 2017 Klemen Kosir. All rights reserved.
//

import Foundation

public struct ChatBubbleStyle {
	
	//corner
	public var cornerRadius: CGFloat = 0.0
	
	//shadow
	public var shadowOffset: CGSize = .zero
	public var shadowOpacity: CGFloat = 0.0
	public var shadowRadius: CGFloat = 0.0
	public var shadowColor: UIColor = .clear
	
	//border
	public var borderColor: UIColor = .clear
	public var borderWidth: CGFloat = 0.0
	
	//text color
	public var textColor: UIColor = .black
	
	//background
	public var bacgroundColor: UIColor = .white
	
	//tail
	public var hasBubbleTail: Bool = true
	
	//time label
	public var hasTimeLabel: Bool = true
	public var timeFont: UIFont?
	public var timeTextColor: UIColor = .black
	
	//text inset
	public var textContainerInset: UIEdgeInsets = UIEdgeInsetsMake(6.0, 6.0, 6.0, 6.0)
	
	public init() {}
	
}
