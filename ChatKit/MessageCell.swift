//
//  MessageCellProtocol.swift
//  ChatKit
//
//  Created by Klemen Kosir on 5. 03. 17.
//  Copyright © 2017 Klemen Kosir. All rights reserved.
//

import UIKit

class MessageCell: UICollectionViewCell {
	weak var delegate: ChatDelegate?
	
	func set(message: MessageProtocol) {}
}
