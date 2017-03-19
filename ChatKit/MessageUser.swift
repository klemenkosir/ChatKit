//
//  MessageUser.swift
//  ChatKit
//
//  Created by Klemen Kosir on 24. 01. 17.
//  Copyright © 2017 Klemen Kosir. All rights reserved.
//

import Foundation

class MessageUser: MessageUserProtocol {
	
	let id: Int
	var name: String = ""
	var image: UIImage? = nil
	var imageUpdateBlock: ((UIImage?) -> Void)?
	
	init(_ id: Int) {
		self.id = id
	}
	
}
