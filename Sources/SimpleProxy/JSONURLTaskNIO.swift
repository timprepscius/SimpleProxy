//
//  JSONURLTaskNIO.swift
//  AltCoin
//
//  Created by Timothy Prepscius on 8/7/19.
//

import Foundation
import AsyncHTTPClient
import NIO

public class JSONURLTaskNIO : IOURLTask
{
	public init () {}

	public func dataTask (with url: URL, proxy: Proxy) -> DataResult
	{
		let sem = DispatchSemaphore(value: 0)
		var resultError : Error? = nil
		var resultData : Data? = nil

		let httpClient = HTTPClient(eventLoopGroupProvider: .createNew, configuration: .init(certificateVerification: .noHostnameVerification, followRedirects: true, timeout: HTTPClient.Timeout(connect: .seconds(timeoutInSeconds), read: .seconds(timeoutInSeconds)), proxy: .server(host: proxy.url, port: proxy.port)))
		
    	defer { try? httpClient.syncShutdown() }

		let future = httpClient.get(url: url.absoluteString)
		
		future.whenComplete
		{
			result in
			
			switch result {

			case .success(let response):
				if response.status != .ok
				{
					resultError = URLResponseError.statusCodeNot200
				}
		
				response.body?.withUnsafeReadableBytes {
					resultData = Data($0)
				}
				break;
				
			case .failure(let error):
				resultError = error
				break;
			}
			
			sem.signal();
		}

		sem.wait()

		return DataResult(data: resultData, error: resultError)
	}
	
}
