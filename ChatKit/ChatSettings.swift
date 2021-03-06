//
//  ChatSettings.swift
//  ChatKit
//
//  Created by Klemen Kosir on 24. 01. 17.
//  Copyright © 2017 Klemen Kosir. All rights reserved.
//

import Foundation

public enum ChatSettings {
	
	public static var messageFont: UIFont = UIFont.systemFont(ofSize: 14.0)
	public static var systemMessageTextColor: UIColor = .black
	public static var backgroundColor: UIColor = .white
	public static var usesPagination: Bool = true
	public static var pageSize: Int = 50
	public static var disableInput = false
	
	public static var avatarStyle = ChatAvatarStyle()
	public static var receivedbubbleStyle = ChatBubbleStyle()
	public static var sentbubbleStyle = ChatBubbleStyle()
	public static var chatBarStyle = ChatBarStyle()
	
	public static var senderUser: MessageUserProtocol?
	
}
