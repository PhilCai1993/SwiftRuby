//
//  Object.swift
//  RubyNative
//
//  Created by John Holdsworth on 26/09/2015.
//  Copyright © 2015 John Holdsworth. All rights reserved.
//
//  $Id: //depot/RubyKit/Object.swift#3 $
//
//  Repo: https://github.com/RubyNative/RubyKit
//
//  See: http://ruby-doc.org/core-2.2.3/Object.html
//

import Foundation

public let ARGV = Process.arguments

public let STDIN = IO( what: "stdin", unixFILE: stdin )
public let STDOUT = IO( what: "stdout", unixFILE: stdout )
public let STDERR = IO( what: "stderr", unixFILE: stderr )

public enum WarningDisposition {
    case Ignore, Warn, Fatal
}

public var WARNING_DISPOSITION: WarningDisposition = .Warn

public func RKLog( msg: String, file: String = __FILE__, line: Int = __LINE__ ) {
    STDERR.print( "RubyNative: "+msg+" at \(file)#\(line)\n" )
}

public func RKError( msg: String, file: String = __FILE__, line: Int = __LINE__ ) {
    if WARNING_DISPOSITION != .Ignore {
        RKLog( msg+": \(String( UTF8String: strerror( errno ) )!)", file: file, line: line )
    }
    if WARNING_DISPOSITION == .Fatal {
        fatalError()
    }
}

public func RKFatal( msg: String, file: String = __FILE__, line: Int = __LINE__ ) {
    RKLog( msg, file: file, line: line )
    fatalError()
}

func notImplemented( what: String, file: String = __FILE__, line: Int = __LINE__ ) {
    RKFatal( "\(what) not implemented", file: file, line: line )
}

public let ENV = ENVProxy()

public class ENVProxy {

    public subscript( key: to_s_protocol ) -> String? {
        get {
            let val = getenv( key.to_s )
            return val != nil ? String( UTF8String: val ) : nil
        }
        set {
            if newValue != nil {
                setenv( key.to_s, newValue!, 1 )
            }
            else {
                unsetenv( key.to_s )
            }
        }
    }
    
}

@asmname("instanceVariablesForClass")
func instanceVariablesForClass( cls: AnyClass, _: NSMutableArray ) -> NSArray
@asmname("methodSymbolsForClass")
func methodSymbolsForClass( cls: AnyClass ) -> NSArray

public class Object: NSObject {

    public var instance_variables: [String] {
        return instanceVariablesForClass( self.dynamicType, NSMutableArray() ) as! [String]
    }

    public var methods: [String] {
        var out = [String]()
        for symName in methodSymbolsForClass( self.dynamicType ) {
            out.append( _stdlib_demangleName( symName as! String ) )
        }
        return out
    }

}
