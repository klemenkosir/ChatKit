//
//  Message.swift
//  ChatKit
//
//  Created by Klemen Kosir on 24. 01. 17.
//  Copyright © 2017 Klemen Kosir. All rights reserved.
//

import Foundation

class Message: MessageProtocol {

	var user: MessageUserProtocol
	let content: MessageContentProtocol
	var date: Date? = nil
	var isSystem: Bool = false
	
	init(_ user: MessageUserProtocol, _ content: MessageContentProtocol) {
		self.user = user
		self.content = content
	}
}
