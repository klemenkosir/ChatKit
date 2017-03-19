//
//  Message.swift
//  ChatKit
//
//  Created by Klemen Kosir on 24. 01. 17.
//  Copyright © 2017 Klemen Kosir. All rights reserved.
//

import UIKit

public protocol MessageProtocol: class {
	var user: MessageUserProtocol { get set }
	var content: MessageContentProtocol { get }
	var date: Date? { get }
	var isSystem: Bool { get }
}


public protocol MessageUserProtocol {
	var id: Int { get }
	var name: String { get }
	var image: UIImage? { get }
	var imageUpdateBlock: ((_ newImage: UIImage?) -> Void)? { get set }
}


public enum MessageContentType {
	case text, image, video
}

public protocol MessageContentProtocol {
	var contentType: MessageContentType { get }
	var content: Any { get }
	var contentExtras: Any? { get }
}
