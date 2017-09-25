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
	var content: MessageContentProtocol
	var date: Date = Date()
	var isSystem: Bool = false
	var subject: String? = nil
	
	init(_ user: MessageUserProtocol, _ content: MessageContentProtocol) {
		self.user = user
		self.content = content
	}
}
