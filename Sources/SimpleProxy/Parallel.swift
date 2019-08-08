//
//  Parallel.swift
//  SimpleProxy
//
//  Created by Timothy Prepscius on 8/7/19.
//

import Foundation

extension Sequence
{
	public var count_slow : Int {
		var i = 0
		for _ in self
		{
			i += 1
		}
		
		return i
	}
	
	public func index_slow(_ z: Int) -> Element?
	{
		var i = z
		for v in self
		{
			if i == 0
			{
				return v
			}

			i -= 1
		}
		return nil
	}

#if NO_PARALLEL
	public func forEach_parallel(_ f: (_ t: Element) ->()) {
		self.forEach {
			f($0)
		}
	}
#else
	public func forEach_parallel(_ f: (_ t: Element) ->()) {
		DispatchQueue.concurrentPerform(iterations: self.count_slow) { (index) in
			f(self.index_slow(index)!)
		}
	}
#endif

#if NO_PARALLEL
	public func map_parallel<T>(_ f: (_ t: Element) -> T) -> [T] {
		return self.map {
			f($0)
		}
	}

#else
	public func map_parallel<T>(_ f: (_ t: Element) -> T) -> [T] {
		var a = [T]()
		let lock = NSLock()
		
		DispatchQueue.concurrentPerform(iterations: self.count_slow) { (index) in
			let r = f(self.index_slow(index)!)
			
			lock.lock()
			defer { lock.unlock() }
			a.append(r)
		}
		
		return a
	}
#endif
}

public extension Array
{
	var count_slow : Int {
		return self.count
	}
	
	func index_slow(_ i: Int) -> Element?
	{
		return self[i]
	}

}
