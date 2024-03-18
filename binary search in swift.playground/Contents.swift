import Foundation
import SwiftUI


func binarySearch(arr:[Int],x : Int, high : Int,low : Int) -> Int  {
    if low > high {
       print( "Lower > Higher")
    }
    else {
    var mid = ( low + high ) / 2
           if  x == arr[mid] {
               print("element found at index \(mid) ")
               return mid
               
           }
        else if x > arr[mid] {
            
            return binarySearch(arr: arr, x: x, high: high, low: mid + 1)
            
        }
        else {
            
            return binarySearch(arr: arr, x: x, high: mid - 1, low: low)
            
        }
    }
    return 69
}


binarySearch(arr: [13,14,23,34,56,78,102,303,401,705,802,907], x: 907, high: 12, low: 0)
