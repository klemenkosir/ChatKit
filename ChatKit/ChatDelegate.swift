//
//  ChatDelegate.swift
//  ChatKit
//
//  Created by Klemen Kosir on 24. 01. 17.
//  Copyright © 2017 Klemen Kosir. All rights reserved.
//

import UIKit

public protocol ChatDelegate: class {
	
	func chat(didSelectContent message: MessageProtocol)
	func chat(didSelectAvatar message: MessageProtocol)
	func chat(send message: MessageProtocol)
	func chatDidSelectAction()
	func chatIsConnected() -> Bool
	
}
