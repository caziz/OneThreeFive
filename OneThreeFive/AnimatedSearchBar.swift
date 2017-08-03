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
    
    func initSearchbar() {
        delegate = self
        self.autocapitalizationType = .none
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismiss))
        view?.addGestureRecognizer(tap)
    }
    
    func toggle() {
        if constraint?.constant == 0 {
            dismiss()
        } else {
            show()
        }
    }
    
    func show() {
        UIView.animate(withDuration: 0.2) {
            self.constraint?.constant = 0
            self.view?.layoutIfNeeded()
            self.becomeFirstResponder()
        }
    }

    func dismiss() {
        view?.endEditing(true)
        if self.text == nil || self.text == "" {
            UIView.animate(withDuration: 0.2) {
                self.constraint?.constant = -self.bounds.height
                self.view?.layoutIfNeeded()
            }
        }
    }
}

extension AnimatedSearchBar: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if self.text == nil {
            animatedDelegate?.displayWithFilter(text: "")
        } else {
            animatedDelegate?.displayWithFilter(text: self.text!)
        }
    }
}
