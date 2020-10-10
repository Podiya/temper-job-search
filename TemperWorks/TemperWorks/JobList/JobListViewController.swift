//
//  JobListViewController.swift
//  TemperWorks
//
//  Created by Ravindu Senevirathna on 8/10/20.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

enum ScrollDirection {
    case up
    case down
}

class JobListViewController: BaseViewController {
    
    @IBOutlet weak var jobListTableView: UITableView!
    private let disposeBag = DisposeBag()
    private let viewModel: JobListViewModel
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, JobViewModel>>!
    private let jobCell = "jobCell"
    private let refresher = UIRefreshControl()
    private var scrollDirection: ScrollDirection = .up
    
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
        viewModel.initialFetch()
    }
    
    override func setupUI() {
        super.setupUI()
        jobListTableView.register(UINib(nibName: String(describing: JobTableViewCell.self), bundle: nil), forCellReuseIdentifier: jobCell)
    }
    
    override func setupViewModelListners() {
        super.setupViewModelListners()
        
        _ = viewModel.status.bind { status in
            DispatchQueue.main.async {
                status == .fetching ? self.showHud() : self.hideHud()
            }
        }.disposed(by: disposeBag)
        
        _ = viewModel.error.bind { error in
            guard let e = error else { return }
            self.showAlert(text: e, type: FloatingAlertType.error)
        }.disposed(by: disposeBag)
        
        _ = viewModel.isRefreshing.bind { bool in
            DispatchQueue.main.async {
                bool ? self.refresher.beginRefreshing() : self.refresher.endRefreshing()
            }
        }.disposed(by: disposeBag)
        
        dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, JobViewModel>> { (dataSource, tableView, indexPath, item) -> JobTableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: self.jobCell) as! JobTableViewCell
            cell.update(model: item)
            return cell
        }
        
        viewModel.jobsObserver.bind(to: jobListTableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        jobListTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        jobListTableView.addSubview(refresher)
        refresher.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
    }

    @objc func refresh() {
        viewModel.refresh()
    }
    
    @IBAction func didPressKaart(_ sender: Any) {
        self.present(JobMapViewController(viewModel: JobMapViewModel()), animated: true, completion: nil)
    }
}

extension JobListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = JobListHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 40))
        headerView.label.text = dataSource[section].model
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if scrollDirection == .down {
                let jobs = viewModel.jobsObserver.value
                if indexPath.section == jobs.count - 1 && indexPath.row == 0 {
                    viewModel.fetchJobViewModels()
                }
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if targetContentOffset.pointee.y < scrollView.contentOffset.y {
            scrollDirection = .up
        } else {
            scrollDirection = .down
        }
    }
}


