//
//  MessageContent.swift
//  ChatKit
//
//  Created by Klemen Kosir on 24. 01. 17.
//  Copyright © 2017 Klemen Kosir. All rights reserved.
//

import Foundation

class MessageContent: MessageContentProtocol {
	
	let contentType: MessageContentType
	let content: Any
	var contentExtras: Any? = nil
	
	init(_ contentType: MessageContentType, _ content: Any) {
		self.contentType = contentType
		self.content = content
	}
	
}
