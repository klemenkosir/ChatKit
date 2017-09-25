//
//  Message.swift
//  ChatKit
//
//  Created by Klemen Kosir on 24. 01. 17.
//  Copyright © 2017 Klemen Kosir. All rights reserved.
//

import UIKit

public typealias ContentUpdateBlock = ((_ updatedContent: Any) -> Void)
public typealias UserImageUpdateBlock = ((_ newImage: UIImage?) -> Void)

public protocol MessageProtocol: class {
	var user: MessageUserProtocol { get set }
	var content: MessageContentProtocol { get set }
	var subject: String? { get set }
	var date: Date { get }
	var isSystem: Bool { get }
}


public protocol MessageUserProtocol {
	var id: Int { get }
	var name: String { get }
	var image: UIImage? { get }
	var imageUpdateBlock: UserImageUpdateBlock? { get set }
}


public enum MessageContentType {
	case text, image, video
}

public protocol MessageContentProtocol: class {
	
	var contentType: MessageContentType { get }
	var content: Any? { get set }
	var contentExtras: Any? { get }
	var contentUpdate: ContentUpdateBlock? { get set }
}
