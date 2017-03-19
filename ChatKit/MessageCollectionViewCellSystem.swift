//
//  MessageCollectionViewCellSystem.swift
//  ChatKit
//
//  Created by Klemen Kosir on 5. 03. 17.
//  Copyright © 2017 Klemen Kosir. All rights reserved.
//

import UIKit


class MessageCollectionViewCellSystem: MessageCell {
	
	@IBOutlet weak var label: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		setup()
	}
	
	private func setup() {
		label.font = ChatSettings.messageFont
		label.textColor = ChatSettings.systemMessageTextColor
		
//		self.backgroundColor = ChatSettings.backgroundColor
//		self.contentView.backgroundColor = ChatSettings.backgroundColor
//		label.backgroundColor = ChatSettings.backgroundColor
	}
	
	override func set(message: MessageProtocol) {
		label.text = message.content.content as? String
	}
	
}
