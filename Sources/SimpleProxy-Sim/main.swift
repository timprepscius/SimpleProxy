import Foundation
import SimpleProxy

let proxyFinder = ProxyFinder()
let proxies = try proxyFinder.scan()

let httpFoundation = JSONURLTaskFoundation()
let httpNIO = JSONURLTaskNIO()

let urlToDownload = URL(string: "https://code.jquery.com/jquery-3.4.1.slim.js")!

typealias ResultType = (Proxy, DataResult, DataResult)

let results = proxies.enumerated().map_parallel {
	(i, proxy) -> ResultType in

	print("testing proxy \(proxy) \(i)/\(proxies.count)")
	let fResult = httpFoundation.dataTask(with: urlToDownload, proxy: proxy)
	let nResult = httpNIO.dataTask(with: urlToDownload, proxy: proxy)
	
	return (proxy, fResult, nResult)
}

print("----------------------------")
print("----------------------------")
print("----------------------------")

for (proxy, fResult, nResult) in results {
	print("Test results for \(proxy)")

	if let error = fResult.error
	{
		print ("\tFoundation error \(error.localizedDescription)")
	}
	
	if let error = nResult.error
	{
		print("\tNIO error \(error.localizedDescription)")
	}
	
	var fs, ns : String!
	fs = nil
	ns = nil
	
	if let data = fResult.data, let s = String(data: data, encoding: .utf8)
	{
		fs = s
	}

	if let data = nResult.data, let s = String(data: data, encoding: .utf8)
	{
		ns = s
	}
	
	if fs == nil && ns == nil
	{
		print("\tFoundation and NIO both have no text")
	}
	else
	if fs == ns
	{
		print("\tFoundation text == NIO text")
	}
	else
	{
		print("\tERROR Foundation text != NIO text")
	}
}

