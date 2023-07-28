//
//  ViewController.swift
//  TaskMaster
//
//  Created by Catherine Shing on 6/6/23.
//

import UIKit
import CoreData
import ChameleonFramework

class TaskViewController: UIViewController, TaskViewVCDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addTaskButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var tasksByDate: [String: [Task]] = [:]
    var displayMode: DisplayMode = .collection
    
    enum DisplayMode {
        case collection
        case list
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var tasks: [Task]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupCollectionView()
        setupAddTaskButton()
        setupUserNameLabel()
        setupDateLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        refreshData()
    }
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    func setupUI() {
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func setupCollectionView() {
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.collectionViewLayout = UICollectionViewFlowLayout()
    }
    
    private func setupUserNameLabel() {
        if let savedUserName = UserDefaults.standard.string(forKey: "UserName") {
            let greeting = "Hi \(savedUserName)!"
            nameLabel?.text = greeting
            nameLabel?.textColor = FlatWatermelon()
        }
    }

    private func setupDateLabel() {
        let dateMessage = "Today is \(DateHelper.formattedDate(from: Date()))"
        dateLabel?.text = dateMessage
        dateLabel?.textColor = FlatSkyBlue()
    }
    
    private func setupAddTaskButton() {
        addTaskButton?.backgroundColor = .systemBlue
        addTaskButton?.layer.cornerRadius = addTaskButton.bounds.width / 2
        addTaskButton?.clipsToBounds = true
    }
    
    // MARK: Task Operations
    
    func didAddTask(_ task: Task) {
        self.tasks?.append(task)
        self.saveTasks()
    }
    
    func didEditTask(_ task: Task) {
        self.saveTasks()
        self.collectionView.reloadData()
        self.tableView.reloadData()
    }
    
    @IBAction func addTask(_ sender: UIButton) {
        let addTaskViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddTaskViewController") as! AddTaskViewController
        addTaskViewController.delegate = self

        presentPanModal(addTaskViewController)
    }
    
    func saveTasks() {
        do {
            try self.context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func loadTasks(with request: NSFetchRequest<Task> = Task.fetchRequest(), predicate: NSPredicate? = nil) {
        let sortByDueDate = NSSortDescriptor(key: "dueDate", ascending: true)
          request.sortDescriptors = [sortByDueDate]
          request.predicate = NSPredicate(format: "isCompleted == %d", false)
        
        do {
            tasks = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }

    @IBAction func toggleCheckbox(_ sender: UIButton) {
        if let cell = sender.superview?.superview as? TaskCollectionViewCell, let collectionView = self.collectionView, let indexPath = collectionView.indexPath(for: cell) {
            let task = tasks?[indexPath.row]
            task?.isCompleted.toggle()
            self.tableView.reloadData()
            self.collectionView.reloadData()

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if let index = self.tasks?.firstIndex(where: { $0 == task }) {
                    self.tasks?.remove(at: index)
                    self.saveTasks()
                    self.tableView.reloadData()
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    @IBAction func viewTypeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            displayMode = .collection
        case 1:
            displayMode = .list
        default:
            break
        }
        updateViews()
        refreshData()
    }
    
    func refreshData() {
         loadTasks()
         groupTasksByDate()
         if let tasks = tasks {
             DataManager.shared.groupTasksByDate(tasks: tasks)
         }
         tableView?.reloadData()
         collectionView?.reloadData()
     }
    
    func updateViews() {
         collectionView?.isHidden = displayMode == .list
         tableView?.isHidden = displayMode == .collection
     }
}
