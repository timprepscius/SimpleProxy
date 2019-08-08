//
//  ProxyFinder.swift
//  altcoin_simulator
//
//  Created by Timothy Prepscius on 6/25/19.
//

import Foundation
import SwiftSoup

public class ProxyFinder
{
	var urlStrings = ["https://www.sslproxies.org/", "https://www.us-proxy.org/", "https://free-proxy-list.net/"]
	
	public init ()
	{
	}
	
	public func scan () throws -> [Proxy]
	{
		var proxies = [Proxy]()

		for urlString in urlStrings
		{
			let url = URL(string: urlString)
			
			let html = try String(contentsOf: url!, encoding: .utf8)
			let doc: Document = try SwiftSoup.parse(html)
			let trs = try doc.select("tbody > tr")
			
			for (i, tr) in trs.array().enumerated()
			{
				if i > 100
				{
					break
				}
				
				if let tds = try? tr.select("td").array(),
					let ip = try? tds[0].text(),
					let port = try? tds[1].text(),
					let p = Int(port)
				{
					proxies.append((ip, p))
				}
			}
		}
		
		return proxies
		
	}

}
