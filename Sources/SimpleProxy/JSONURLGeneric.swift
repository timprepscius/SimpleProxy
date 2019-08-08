//
//  JSONURLGeneric.swift
//  AltCoin
//
//  Created by Timothy Prepscius on 8/7/19.
//

import Foundation

enum URLResponseError : Error {
	case statusCodeNot200
}

public typealias Proxy = (url: String, port: Int)
public typealias DataResult = (data:Data?, error:Error?)

public protocol IOURLTask
{
	func dataTask (with url: URL, proxy: Proxy) -> DataResult
}

let timeoutInSeconds : Int64 = 5
