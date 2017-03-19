//
//  ChatAvatarStyle.swift
//  ChatKit
//
//  Created by Klemen Kosir on 24. 01. 17.
//  Copyright © 2017 Klemen Kosir. All rights reserved.
//

import Foundation

public struct ChatAvatarStyle {
	
	//corner
	public var cornerRadius: CGFloat = 0.0
	public var isCircle: Bool = false
	
	//shadow
	public var shadowOffset: CGSize = .zero
	public var shadowOpacity: CGFloat = 0.0
	public var shadowRadius: CGFloat = 0.0
	public var shadowColor: UIColor = .clear
	
	//border
	public var borderColor: UIColor = .clear
	public var borderWidth: CGFloat = 0.0
	
	//size
	public var size: CGSize = CGSize(width: 40.0, height: 40.0)
	
	//background
	public var backgroundColor: UIColor = .white
	
	public init() {}
	
}
