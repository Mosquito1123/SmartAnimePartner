//
//  AppDelegate.swift
//  SmartAnimePartner
//
//  Created by Mosquito1123 on 11/07/2019.
//  Copyright © 2019 Cranberry. All rights reserved.
//

import UIKit
import MJRefresh

class LBUCateController: LBUBaseController {

    private var searchString = ""
    private var topList = [LBUTopModel]()
    private var rankList = [LBURankingModel]()
    
    private lazy var searchButon: UIButton = {
        let searchButon = UIButton(type: .system)
        searchButon.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 20, height: 30)
        searchButon.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        searchButon.layer.cornerRadius = 15
        searchButon.setTitleColor(.white, for: .normal)
        searchButon.setImage(UIImage(named: "nav_search")?.withRenderingMode(.alwaysOriginal), for: .normal)
        searchButon.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        searchButon.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        searchButon.addTarget(self, action:#selector(searchButtonClick), for: .touchUpInside)
        return searchButon
    }()
    
    private lazy var collectionView: UICollectionView = {
        let lt = UICollectionViewFlowLayout()
        lt.minimumInteritemSpacing = 10
        lt.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: lt)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.register(cellType: LBURankCollectionViewCell.self)
        collectionView.register(cellType: LBUTopCollectionViewCell.self)
        collectionView.uHead = URefreshHeader { [weak self] in self?.setupLoadData() }
        collectionView.uempty = UEmptyView { [weak self] in self?.setupLoadData() }
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 加载数据
        setupLoadData()
    }
    
    private func setupLoadData() {
        ApiLoadingProvider.request(LBUApi.cateList, model: LBUCateListModel.self) { (returnData) in
            self.collectionView.uempty?.allowShow = true
            
            self.searchString = returnData?.recommendSearch ?? ""
            self.topList = returnData?.topList ?? []
            self.rankList = returnData?.rankingList ?? []
            
            self.searchButon.setTitle(self.searchString, for: .normal)
            self.collectionView.reloadData()
            self.collectionView.uHead.endRefreshing()
        }
    }
    
    @objc private func searchButtonClick() {
        // mark -- 增加
        navigationController?.pushViewController(LBUSearchController(), animated: true)
    }
    
    override func setupLayout(){
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{make in
            make.edges.equalTo(self.view.usnp.edges)
        }
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        navigationItem.titleView = searchButon
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: nil,
                                                           style: .plain,
                                                           target: nil,
                                                           action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil,
                                                            style: .plain,
                                                            target: nil,
                                                            action: nil)
    }
    
}

extension LBUCateController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return topList.prefix(3).count
        } else {
            return rankList.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: LBUTopCollectionViewCell.self)
            cell.model = topList[indexPath.row]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: LBURankCollectionViewCell.self)
            cell.model = rankList[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: section == 0 ? 0 : 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor(Double(screenWidth - 40.0) / 3.0)
        return CGSize(width: width, height: (indexPath.section == 0 ? 55 : (width * 0.75 + 30)))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // mark -- 增加
        if indexPath.section == 0 {
            let model = topList[indexPath.row]
            var titles: [String] = []
            var vcs: [UIViewController] = []
            for tab in model.extra?.tabList ?? [] {
                guard let tabTitle = tab.tabTitle else { continue }
                titles.append(tabTitle)
                vcs.append(LBUComicListController(argCon: tab.argCon,
                                                    argName: tab.argName,
                                                    argValue: tab.argValue))
            }
            let vc = LBUPageController(titles: titles, vcs: vcs, pageStyle: .topTabBar)
            vc.title = model.sortName
            navigationController?.pushViewController(vc, animated: true)
        }
        
        if indexPath.section == 1 {
            let model = rankList[indexPath.row]
            let vc = LBUComicListController(argCon: model.argCon,
                                              argName: model.argName,
                                              argValue: model.argValue)
            vc.title = model.sortName
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}







