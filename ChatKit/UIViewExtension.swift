//
//  UIViewExtensions.swift
//  
//
//  Created by Klemen Kosir on 23/01/16.
//  Copyright © 2016 Klemen Košir. All rights reserved.
//

import UIKit

enum UIViewAddAnimation {
	case fade
	case none
}

private var viewIdentifierKey: UInt8 = 0
private var drawDottedLineKey: UInt8 = 0

extension UIView {
	
	@IBInspectable var identifier: String? {
		get {
			return objc_getAssociatedObject(self, &viewIdentifierKey) as? String
		}
		set(newValue) {
			if let nv = newValue {
				objc_setAssociatedObject(self, &viewIdentifierKey, nv, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
			}
		}
	}
	
	@IBInspectable var cornerRadius: CGFloat {
		get {
			return layer.cornerRadius
		}
		set {
			layer.cornerRadius = newValue
		}
	}
	
	@IBInspectable var allowsEdgeAntialiasing: Bool {
		get {
			return layer.allowsEdgeAntialiasing
		}
		set {
			layer.allowsEdgeAntialiasing = newValue
		}
	}
	
	@IBInspectable var borderWidth: CGFloat {
		get {
			return self.layer.borderWidth
		}
		set {
			layer.borderWidth = newValue
		}
	}
	
	@IBInspectable var borderColor: UIColor {
		get {
			if let bc = layer.borderColor {
				return UIColor(cgColor: bc)
			}
			return UIColor.clear
		}
		set {
			layer.borderColor = newValue.cgColor
		}
	}
	
	@IBInspectable var clipToBounds: Bool {
		get {
			return self.clipsToBounds
		}
		set {
			self.clipsToBounds = newValue
		}
	}
	
	@IBInspectable var shadowOffset: CGSize {
		get {
			return self.layer.shadowOffset
		}
		set {
			self.layer.shadowOffset = newValue
		}
	}
	
	@IBInspectable var shadowColor: UIColor {
		get {
			return UIColor(cgColor: self.layer.shadowColor ?? UIColor.clear.cgColor)
		}
		set {
			self.layer.shadowColor = newValue.cgColor
		}
	}
	
	@IBInspectable var shadowRadius: CGFloat {
		get {
			return self.layer.shadowRadius
		}
		set {
			self.layer.shadowRadius = newValue
		}
	}
	
	@IBInspectable var shadowOpacity: Float {
		get {
			return self.layer.shadowOpacity
		}
		set {
			self.layer.shadowOpacity = newValue
		}
	}
	
	var parentViewController: UIViewController? {
		var parentResponder: UIResponder? = self
		while parentResponder != nil {
			parentResponder = parentResponder!.next
			if let viewController = parentResponder as? UIViewController {
				return viewController
			}
		}
		return nil
	}
	
	func addSubviewFromViewController(_ vc: UIViewController) {
		self.addSubviewFromViewController(vc, useAutoLayout: false)
	}
	
	func addSubviewFromViewController(_ vc: UIViewController, useAutoLayout: Bool, addConstraints: Bool = true) {
		//		self.superview?.layoutIfNeeded()
		self.parentViewController?.addChildViewController(vc)
		vc.view.frame = self.bounds
		self.addSubview(vc.view)
		vc.didMove(toParentViewController: self.parentViewController)
		
		if useAutoLayout {
			vc.view.translatesAutoresizingMaskIntoConstraints = false
			if !addConstraints {
				return
			}
			self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[vcView]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["vcView": vc.view]))
			self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[vcView]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["vcView": vc.view]))
			self.layoutIfNeeded()
		}
	}
	
	func addSubviewFromViewController(_ vc: UIViewController, useAutoLayout: Bool, animation: UIViewAddAnimation) {
		vc.view.alpha = 0.0
		self.addSubviewFromViewController(vc, useAutoLayout: useAutoLayout)
		switch animation {
		case .fade:
			UIView.animate(withDuration: 0.1, animations: {
				vc.view.alpha = 1.0
			})
		default:
			vc.view.alpha = 1.0
			break
		}
	}
	
	func addSubviewWithAutolayout(_ view: UIView) {
		self.addSubview(view)
		
		view.translatesAutoresizingMaskIntoConstraints = false
		self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["view": view]))
		self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["view": view]))
		self.layoutIfNeeded()
		
	}
	
	func addSubviewFromViewControllerWithOfset(_ vc: UIViewController, offset: CGPoint) {
		self.parentViewController?.addChildViewController(vc)
		vc.view.frame = self.bounds.offsetBy(dx: offset.x, dy: offset.y)
		self.addSubview(vc.view)
		vc.didMove(toParentViewController: self.parentViewController)
	}
	
	func addSubviewFromViewControllerWithFrame(_ vc: UIViewController, frame: CGRect) {
		self.parentViewController?.addChildViewController(vc)
		vc.view.frame =  frame
		self.addSubview(vc.view)
		vc.didMove(toParentViewController: self.parentViewController)
	}
	
	func removeAllGestureRecognizers() {
		if let gr = self.gestureRecognizers {
			for gesture in gr {
				self.removeGestureRecognizer(gesture)
			}
		}
	}
	
	func removeAllSubviews() {
		for subview in self.subviews {
			subview.removeFromSuperview()
		}
	}
	
	func removeAllConstraints() {
		self.removeConstraints(self.constraints)
	}
	
	func round(_ corners: UIRectCorner, radius: CGFloat) {
		if self.translatesAutoresizingMaskIntoConstraints == false {
			self.layoutIfNeeded()
		}
		let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
		let mask = CAShapeLayer()
		mask.path = path.cgPath
		self.layer.mask = mask
	}
	
	func currentFirstResponder() -> UIResponder? {
		if self.isFirstResponder {
			return self
		}
		
		for view in self.subviews {
			if let responder = view.currentFirstResponder() {
				return responder
			}
		}
		return nil
	}
	
	func constraints(enabled: Bool) {
		for constraint in self.constraints {
			constraint.isActive = enabled
		}
	}
	
	func constraints(withIdentifier identifier: String) -> [NSLayoutConstraint] {
		var foundConstraints = [NSLayoutConstraint]()
		
		for constraint in self.constraints {
			if constraint.identifier == identifier {
				foundConstraints.append(constraint)
			}
		}
		
		for constraint in self.superview?.constraints ?? [] {
			if constraint.identifier == identifier && (constraint.firstItem as? UIView == self || constraint.secondItem as? UIView == self) {
				foundConstraints.append(constraint)
			}
		}
		
		return foundConstraints
	}
	
	var zPosition: CGFloat {
		get {
			return self.layer.zPosition
		}
		set(newValue) {
			self.layer.zPosition = newValue
		}
	}
	
	func drawDottedLine(_ color: UIColor?) {
		for sublayer in self.layer.sublayers ?? [] {
			sublayer.removeFromSuperlayer()
		}
		let path = UIBezierPath()
		path.move(to: CGPoint(x: 0.25, y: 0.25))
		path.addLine(to: CGPoint(x: 0.25, y: self.frame.size.height-0.25))
		
		let shapeLayer = CAShapeLayer()
		shapeLayer.path = path.cgPath
		shapeLayer.strokeColor = color?.cgColor ?? self.backgroundColor?.cgColor ?? UIColor.black.cgColor
		self.backgroundColor = .clear
		shapeLayer.lineWidth = 0.5
		shapeLayer.lineDashPattern = [NSNumber(value: 0.5 as Float), NSNumber(value: 0.5 as Float)]
		self.layer.addSublayer(shapeLayer)
	}
}
