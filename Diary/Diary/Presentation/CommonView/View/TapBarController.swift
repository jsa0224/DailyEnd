//
//  TapBarController.swift
//  Diary
//
//  Created by 정선아 on 2023/05/02.
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
    }

    private func configureTabBar() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = UIColor(named: Color.selected)
        tabBar.unselectedItemTintColor = UIColor(named: Color.main)

        let coreDataManager = CoreDataManager.shared
        let repository = DiaryRepository(coreDataManager: coreDataManager)
        let useCase = DefaultDiaryUseCase(diaryRepository: repository)
        let homeViewModel = HomeViewModel(diaryUseCase: useCase)
        let recordViewModel = RecordViewModel(diaryUseCase: useCase, diary: Diary(id: UUID(),
                                                                                  title: Description.emptyString,
                                                                                  body: Description.emptyString,
                                                                                  createdAt: Date(),
                                                                                  dateComponents: Date().convertDateToString(),
                                                                                  image: Data()))
        let searchViewModel = SearchViewModel(diaryUseCase: useCase)

        let homeNavigationController = UINavigationController(rootViewController: HomeViewController(viewModel: homeViewModel))
        let recordNavigationController = UINavigationController(rootViewController: RecordViewController(viewModel: recordViewModel))
        let searchNavigationController = UINavigationController(rootViewController: SearchViewController(viewModel: searchViewModel))

        homeNavigationController.navigationBar.scrollEdgeAppearance = homeNavigationController.navigationBar.standardAppearance
        recordNavigationController.navigationBar.scrollEdgeAppearance = recordNavigationController.navigationBar.standardAppearance
        searchNavigationController.navigationBar.scrollEdgeAppearance = searchNavigationController.navigationBar.standardAppearance

        viewControllers = [homeNavigationController, recordNavigationController, searchNavigationController]

        let homeImage = UIImage(systemName: Namespace.homeImage)
        let homeTabBarItem = UITabBarItem(title: Namespace.homeTitle,
                                          image: homeImage,
                                          tag: 0)

        let recordImage = UIImage(systemName: Namespace.recordImage)
        let recordTabBarItem = UITabBarItem(title: Namespace.recordTitle,
                                            image: recordImage,
                                            tag: 1)

        let searchImage = UIImage(systemName: Namespace.searchImage)
        let searchTabBarItem = UITabBarItem(title: Namespace.searchTitle,
                                            image: searchImage,
                                            tag: 2)

        homeNavigationController.tabBarItem = homeTabBarItem
        recordNavigationController.tabBarItem = recordTabBarItem
        searchNavigationController.tabBarItem = searchTabBarItem
    }

    private enum Namespace {
        static let homeImage = "house"
        static let homeTitle = "home"
        static let recordImage = "pencil.line"
        static let recordTitle = "write"
        static let searchImage = "magnifyingglass"
        static let searchTitle = "search"
    }
}
