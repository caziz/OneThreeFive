//
//  AnimatedSearchBar.swift
//  OneThreeFive
//
//  Created by Christopher Aziz on 8/2/17.
//  Copyright © 2017 Christopher Aziz. All rights reserved.
//

import UIKit

protocol AnimatedSearchBarDelegate {
    func displayWithFilter(text: String)
}

class AnimatedSearchBar: UISearchBar {
    
    var view: UIView?
    var constraint: NSLayoutConstraint?
    var animatedDelegate: AnimatedSearchBarDelegate?
    
    func initSearchbar(view: UIView, constraint: NSLayoutConstraint, delegate: AnimatedSearchBarDelegate) {
        // members
        self.view = view
        self.constraint = constraint
        self.animatedDelegate = delegate

        super.delegate = self
        self.autocapitalizationType = .none
        
        // gui
        searchBarStyle = .minimal
        constraint.constant = -self.bounds.height + Constants.UI.borderWidth

        // add border
        let border = CALayer()
        border.backgroundColor = Constants.UI.borderColor.cgColor
        border.frame = CGRect(x: 0, y: frame.size.height - Constants.UI.borderWidth, width: frame.size.width*10, height: Constants.UI.borderWidth)
        layer.addSublayer(border)
    }
    
    func toggle() {
        if constraint?.constant == 0 {
            dismiss()
        } else {
            show()
        }
    }
    
    func show() {
        UIView.animate(withDuration: Constants.UI.animationDuration) {
            self.constraint?.constant = 0
            self.view?.layoutIfNeeded()
            self.becomeFirstResponder()
        }
    }

    func dismiss() {
        view?.endEditing(true)
        if self.text == nil || self.text == "" {
            UIView.animate(withDuration: Constants.UI.animationDuration) {
                self.constraint?.constant = -self.bounds.height + Constants.UI.borderWidth
                self.view?.layoutIfNeeded()
            }
        }
    }
}

extension AnimatedSearchBar: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        animatedDelegate?.displayWithFilter(text: self.text!)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view?.endEditing(true)
        return false
    }
}
