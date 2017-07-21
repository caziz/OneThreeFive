//
//  ReadabilityService.swift
//  OneThreeFive
//
//  Created by Christopher Aziz on 7/20/17.
//  Copyright © 2017 Christopher Aziz. All rights reserved.
//

import ReadabilityKit

class ReadabilityService {
    
    /* calls completion handler with number of characters in article in url, or -1 on error */
    static func charactersIn(url: String, completion: @escaping (Int) -> (Void)) {
        DispatchQueue.global(qos: .background).async {
            guard let urlToParse = URL(string: url) else {
                return
            }
            Readability.parse(url: urlToParse) { result in
                if let article = result {
                    if let text = article.text {
                        return completion(text.characters.count)
                    }
                }
                return completion(-1)
                
            }
        }
        
    }

}
