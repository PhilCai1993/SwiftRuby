//
//  Array.swift
//  RubyNative
//
//  Created by John Holdsworth on 26/09/2015.
//  Copyright © 2015 John Holdsworth. All rights reserved.
//
//  $Id: //depot/SwiftRuby/Array.swift#2 $
//
//  Repo: https://github.com/RubyNative/SwiftRuby
//
//  See: http://ruby-doc.org/core-2.2.3/Array.html
//

public protocol to_a_protocol {

    var to_a: [String] { get }

}

extension Array: to_a_protocol {

    public var to_a: [String] {
        return map { String( $0 ) }
    }

//    public func join( sep: String = " " ) -> String {
//        return joinWithSeparator( sep )
//    }

}

extension CollectionType {

    public func each( block: (Generator.Element) -> () ) {
        forEach( block )
    }
    
}
