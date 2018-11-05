//
//  ViewController.swift
//  NavigationControllerExercise
//
//  Created by Risa on 11/1/18.
//  Copyright © 2018 Risa. All rights reserved.
//

import UIKit

struct Employee: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let email: String
    let phone: String
    let title: String
    let department: String
    let image: String
}

class EmployeeTableViewCell: UITableViewCell {
    //@IBOutlet weak var employeeImage: UIImageView!
   /// @IBOutlet weak var employeeName: UILabel!
   // @IBOutlet weak var employeeTitle: UILabel!
   // @IBOutlet weak var employeeEmail: UILabel!
    //@IBOutlet weak var employeePhone: UILabel!
   // @IBOutlet weak var employeeDepartment: UILabel!
    @IBOutlet weak var employeeImage: UIImageView!
    @IBOutlet weak var employeeName: UILabel!
    @IBOutlet weak var employeeTitle: UILabel!
    @IBOutlet weak var employeeEmail: UILabel!
    @IBOutlet weak var employeePhone: UILabel!
    @IBOutlet weak var employeeDepartment: UILabel!
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var employees: [Employee] = []
    let SegueEmployeeDetailViewController = "SegueEmployeeDetailViewController"
    @IBOutlet weak var employeeTableView: UITableView!
    
    // do a preparation before navigation, pass employee name to EmployeeDetailViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // going toSegueEmployeeDetailViewController
        if segue.identifier == SegueEmployeeDetailViewController {
            // get table view selected row index
            if let indexPath = employeeTableView.indexPathForSelectedRow {
                // downcast UIViewController to EmployeeDetailViewController
                let destinationViewController = segue.destination as! EmployeeDetailViewController
                // set employeeName variable from employees collection
                destinationViewController.employeeName = employees[indexPath.row].lastName + " " + employees[indexPath.row].firstName
                let url = URL(string: employees[indexPath.row].image)
                let imageData = try? Data(contentsOf: url!)
                 if imageData != nil {
                    destinationViewController.employeePicture = UIImage(data: imageData!)
                    
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // perform Segue
        performSegue(withIdentifier: SegueEmployeeDetailViewController, sender: self)
        // remove selection from table view
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // our cell layout identifier
        let cellIdentifier: String = "Cell"
        // get the current row and create a reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! EmployeeTableViewCell
        
        // modify/assign cell data from employees collection in specific row
        cell.employeeName.text = employees[indexPath.row].lastName + " " + employees[indexPath.row].firstName
        cell.employeeTitle.text = employees[indexPath.row].title
        cell.employeeEmail.text = employees[indexPath.row].email
        cell.employeePhone.text = employees[indexPath.row].phone
        cell.employeeDepartment.text = (employees[indexPath.row].department)
        
        // load image from url
        let url = URL(string: employees[indexPath.row].image)
        let imageData = try? Data(contentsOf: url!)
        if imageData != nil {
            cell.employeeImage.image = UIImage(data: imageData!)
        }
        cell.employeeImage.makeRounded()
        // return cell
        return cell
    }
    
    func loadAndParseJson() {
        let urlString = "http://ptm.fi/data/employees.json"
        guard let url = URL(string: urlString) else {
            print("Error: URL error")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // do we have any errors
            if error != nil {
                print(error!.localizedDescription)
            }
            // check that we actually have data
            guard let data = data else {
                print("Error: did not receive data")
                return
            }
            // JSON decoding and parsing
            do {
                // decode retrived data with JSONDecoder and assing type of Employee object
                let employeesData = try JSONDecoder().decode([Employee].self, from: data)
                
                // get back to the main queue and assing data to TableView
                DispatchQueue.main.async {
                    print(employeesData)
                    self.employees = employeesData
                    self.employeeTableView.reloadData()
                }
                
            } catch let jsonError {
                print(jsonError)
            }
            }.resume() // start task
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAndParseJson()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
extension UIImageView {
    func makeRounded() {
        let radius = self.frame.width/2.0
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}


