//
//  JSONURLTask.swift
//  AltCoinSimulator
//
//  Created by Timothy Prepscius on 6/15/19.
//  Copyright © 2019 Timothy Prepscius. All rights reserved.
//

import Foundation

extension URLSession {

    func withProxy(proxyURL: String, proxyPort: Int) -> URLSession
    {
        let configuration = URLSessionConfiguration.ephemeral

		configuration.connectionProxyDictionary = [
			kCFNetworkProxiesHTTPEnable: true,
			kCFNetworkProxiesHTTPProxy: proxyURL,
			kCFNetworkProxiesHTTPPort: proxyPort,
			kCFNetworkProxiesHTTPSEnable: true,
			kCFNetworkProxiesHTTPSProxy: proxyURL,
			kCFNetworkProxiesHTTPSPort: proxyPort
		]
		
		configuration.timeoutIntervalForRequest = Double(timeoutInSeconds)
		configuration.timeoutIntervalForResource = Double(timeoutInSeconds)

        return URLSession(configuration: configuration, delegate: self.delegate, delegateQueue: self.delegateQueue)
    }
}

public class JSONURLTaskFoundation : IOURLTask
{
	public init () {}

	public func dataTask (with url: URL, proxy: Proxy) -> DataResult
	{
		let session = URLSession.shared.withProxy(proxyURL: proxy.url, proxyPort: proxy.port)

		let sem = DispatchSemaphore(value: 0)
		var resultError : Error? = nil
		var resultData : Data? = nil
		
		let task = session.dataTask(with: url) {
			data, response, error in
			
			resultData = data
			resultError = error
			
			if let urlResponse = response as? HTTPURLResponse
			{
				if urlResponse.statusCode != 200
				{
					resultError = URLResponseError.statusCodeNot200
				}
			}

			sem.signal();
		}
		
		task.resume()
		sem.wait()

		return DataResult(data: resultData, error: resultError)
	}
}

