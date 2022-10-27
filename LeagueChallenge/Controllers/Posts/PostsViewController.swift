import UIKit
import SnapKit

class PostsViewController: BaseViewController {
    var viewModel: PostsViewModel!
    
    var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.separatorStyle = .singleLine
        view.estimatedRowHeight = 70
        view.backgroundColor = .clear
        view.rowHeight = UITableView.automaticDimension
        view.register(PostCell.self, forCellReuseIdentifier: PostCell.toString())
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        setupUI()
        bindUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.title = "Posts".localized
    }
    
    func configure() {
        viewModel = PostsViewModel(dependencies: dependencies, errorDelegate: self)
    }
}

private extension PostsViewController {
    func setupUI() {
        self.view.addSubviews(tableView)
        setupConstraints()
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottomMargin)
        }
    }
    
    func bindUI() {
        viewModel.items.bind(to: tableView.rx.items(cellIdentifier: PostCell.cellReuseIdentifier, cellType: PostCell.self)) { index, item, cell in
            cell.setItem(item)
            
        }.disposed(by: viewModel.disposeBag)
    }
}
