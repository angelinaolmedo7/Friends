//
//  FriendsTableViewController.swift
//  Friends
//
//  Created by Angelina Olmedo on 6/21/20.
//  Copyright © 2020 Angelina Olmedo. All rights reserved.
//

import UIKit
import CoreData

class FriendsTableViewController: UITableViewController {
    
//    var names : [String] = []
    var people: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // 1
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =  NSFetchRequest<NSManagedObject>(entityName: "Person")

        //3
         do {
           people = try managedContext.fetch(fetchRequest)
          } catch let error as NSError {
              print("Could not fetch. \(error), \(error.userInfo)")
         }
    }
    
    func save(name: String) {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}

        // 1
        let managedContext = appDelegate.persistentContainer.viewContext

        // 2
        let entity = NSEntityDescription.entity(forEntityName: "Person",
                                           in: managedContext)!

        let person = NSManagedObject(entity: entity,
                                         insertInto: managedContext)

        // 3
        person.setValue(name, forKeyPath: "name")

        // 4
        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError {
            print(error.userInfo)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let person = people[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = person.value(forKeyPath: "name") as? String
        
        return cell
    }

    @IBAction func addButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Friend", message: "Add the name of your friend", preferredStyle: .alert)

        let saveAction = UIAlertAction(title: "Add Now", style: .default) { [unowned self] action in

              guard let textField = alert.textFields?.first, let nameToSave = textField.text else { return }
            
              self.save(name: nameToSave)
              self.tableView.reloadData()
          }

          let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

          alert.addTextField()
          alert.addAction(saveAction)
          alert.addAction(cancelAction)
          present(alert, animated: true)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
