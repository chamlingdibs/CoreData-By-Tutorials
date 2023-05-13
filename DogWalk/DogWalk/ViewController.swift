//
//  ViewController.swift
//  DogWalk
//
//  Created by chamlingdibs on 04/05/23.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    //MARK: - Properties
    
    lazy var dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
    
    lazy var coreDataStack = CoreDataStack(modelName: "DogWalk" )
    var walks : [Date] = []
    
    var currentDog : Dog?
    
    //MARK: - IBOutlets
    @IBOutlet var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        let dogName = "Fido"
        let dogFetch : NSFetchRequest<Dog> = Dog.fetchRequest()
        dogFetch.predicate = NSPredicate( format: "%K == %@", #keyPath(Dog.name), dogName)
        
        do{
            let results = try coreDataStack.managedContext.fetch(dogFetch)
            if results.isEmpty{
                currentDog = Dog(context: coreDataStack.managedContext)
                currentDog?.name = dogName
                coreDataStack.saveContext()
            }else{
                currentDog = results.first
            }
        }catch let error as NSError{
            print( "Fetch error: \(error) description: \(error.userInfo)" )
        }
    }
}

//MARK: - IBActions

extension ViewController{
    @IBAction func add(_ sender : UIBarButtonItem){
        let walk = Walk(context: coreDataStack.managedContext)
        walk.date = Date()
        currentDog?.addToWalks(walk)
        coreDataStack.saveContext()
        tableView.reloadData()
    }
}

//MARK: - UITableViewDataSource

extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currentDog?.walks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        guard let walk =  currentDog?.walks?[indexPath.row] as? Walk,
              let walkDate = walk.date as Date? else{
            return cell
        }
        cell.textLabel?.text = dateFormatter.string(from: walkDate)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "List Of Walks"
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let walkToRemove = currentDog?.walks?[indexPath.row] as? Walk,
              editingStyle == .delete else {
            return
        }
        coreDataStack.managedContext.delete(walkToRemove)
        coreDataStack.saveContext()
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}



