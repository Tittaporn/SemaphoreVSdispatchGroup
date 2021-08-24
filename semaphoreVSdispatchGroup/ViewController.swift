//
//  ViewController.swift
//  semaphoreVSdispatchGroup
//
//  Created by Lee on 8/23/21.
//

import UIKit

class ViewController: UIViewController {
    var movies: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let semaphore = DispatchSemaphore(value: 1)
        let queue = DispatchQueue.global()
        queue.async {
            semaphore.wait()
            print("Semaphore ==> First block after wait!") // 2
            let name = self.downloadMovie("Home Alone")
            self.movies.append(name)
            semaphore.signal()
            print("Semaphore ==> First block after signal!") //4
        }
        
        print("=================== movies : \(movies)======================")
        
        queue.async {
            semaphore.wait()
            print("Semaphore ==> Second block after wait!") // 5
            self.saveMovies()
            self.movies.remove(at: 0)
            semaphore.signal()
            print("Semaphore ==> Second block after signal!") // 7
        }
        print("I ain't waiting for no computer.") // 1
    }
    func downloadMovie(_ name: String) -> String {
        sleep(4)
        print("Semaphore ==> \(name) has been downloaded!") //3
        return name
    }
    func saveMovies(){
        sleep(2)
        print("Semaphore ==> Movies have been saved!")  //6
    }
}

/* ==> This one crash because the dispatchGroup tried to access the datasource
 class ViewController: UIViewController {
     var movies: [String] = []
     override func viewDidLoad() {
         super.viewDidLoad()
        let group = DispatchGroup()
         let queue = DispatchQueue.global()
         queue.async(group: group) {
             let movie = self.downloadMovie("Harry Potter")
             self.movies.append(movie)
             print("This is the queue block \(movie).") // ==> 4
         }
         queue.async(group: group) {
             self.saveMovies()
             self.movies.remove(at: 0) // ==> Fatal error because saveMovie took on 2 seconds and dispatchGroup not in order
         }
         group.notify(queue: .main) {
             print("All Downloads have been completed.") // ==> 5
         }
         print("I ain't waiting for no computer.") // ==> 1
     }
     func downloadMovie(_ name: String) -> String {
         sleep(4)
         print("\(name) has been downloaded!")  // ==> 3
         return name
     }
     func saveMovies(){
         sleep(2)
         print("Movies have been saved!")  // ==> 2
     }
 }
 */
