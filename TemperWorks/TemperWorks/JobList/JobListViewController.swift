//
//  JobListViewController.swift
//  TemperWorks
//
//  Created by Ravindu Senevirathna on 8/10/20.
//

import UIKit
import RxSwift
import RxCocoa
import Nuke



class JobListViewController: BaseViewController {
    
    @IBOutlet weak var jobListTableView: UITableView!
    private let disposeBag = DisposeBag()
    private let viewModel: JobListViewModel
    
    init(viewModel: JobListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: Self.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.fetchJobViewModels()
    }
    
    override func setupUI() {
        super.setupUI()
        jobListTableView.register(UINib(nibName: String(describing: JobTableViewCell.self), bundle: nil), forCellReuseIdentifier: "jobCell")
    }
    
    override func setupViewModelListners() {
        super.setupViewModelListners()
        _ = viewModel.status.bind { (status) in
            DispatchQueue.main.async {
                status == .fetching ? self.showHud() : self.hideHud()
            }
        }
        viewModel.jobsObserver.bind(to: jobListTableView.rx.items(cellIdentifier: "jobCell", cellType: JobTableViewCell.self)) { index, viewModel, cell in
            cell.update(model: viewModel)
        }.disposed(by: disposeBag)
    }
}





final class JobListViewModel: BaseViewControllerViewModel {
    
    private let jobListService: JobListServiceProtocol
    private var startingDate = Date().addingTimeInterval(-86400)
    private let disposeBag = DisposeBag()
    var jobsObserver = BehaviorSubject<[JobViewModel]>(value: [])
    var jobDates = [String]()
    
    
    init(jobListService: JobListServiceProtocol = JobListService()) {
        self.jobListService = jobListService
    }
    
    func fetchJobViewModels() {
        status.on(.next(.fetching))
        let nextThreeDates = startingDate.nextThreeDates
        let stringDates = nextThreeDates.map { $0.toString() }.joined(separator: ",")
        
        jobListService.fetchJobs(dates: stringDates).subscribe { (response) in
            if let data = response?.data {
                var jobViewModels = [JobViewModel]()
                for (key, value) in data {
                    self.jobDates.append(key)
                    jobViewModels.append(contentsOf: value.map { JobViewModel(model: $0) })
                }
                self.jobsObserver.on(.next(jobViewModels))
                self.jobsObserver.on(.completed)
            }

        } onError: { (e) in
            self.error.on(.next(e.localizedDescription))
        } onCompleted: {
            self.status.on(.next(.done))
        }.disposed(by: disposeBag)

        
        startingDate = nextThreeDates.last!
    }
}

class BaseViewControllerViewModel {
    var status = BehaviorSubject<Status>(value: Status.done)
    var error = BehaviorSubject<String>(value: "")
}






enum Status {
    case fetching
    case done
}















struct JobViewModel {
    
    private let model: JobModel
    var clientName: String {
        model.client.name
    }
    var shiftTime: String {
        if !model.shifts.isEmpty {
            return "\(model.shifts[0].startTime) - \(model.shifts[0].endTime)"
        }
        return ""
    }
    var coverImage: String {
        model.client.photos.first?.formats.first?.cdnURL ?? ""
        
    }
    var jobCategory: String {
        model.jobCategory.jobCategoryDescription
    }
    var earningsPerHour: String {
        if !model.shifts.isEmpty {
            return "$ \(String(format: "%.2f", model.shifts[0].earningsPerHour))"
        }
        return ""
    }
    
    init(model: JobModel) {
        self.model = model
    }
}

extension Date {
    var nextThreeDates: [Date] {
        var dates = [Date]()
        for i in 1...3 {
            guard let date = Calendar.current.date(byAdding: .day, value: i, to: self) else { return dates }
            dates.append(date)
        }
        return dates
    }
    
    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
