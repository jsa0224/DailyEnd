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
        tabBar.tintColor = UIColor(named: "selectedColor")
        tabBar.unselectedItemTintColor = UIColor(named: "mainColor")

        let coreDataManager = CoreDataManager.shared
        let repository = DiaryRepository(coreDataManager: coreDataManager)
        let useCase = DefaultDiaryUseCase(diaryRepository: repository)
        let homeViewModel = HomeViewModel(diaryUseCase: useCase)
        let recordViewModel = RecordViewModel(diaryUseCase: useCase, diary: Diary(id: UUID(),
                                                                                  title: "",
                                                                                  body: "",
                                                                                  createdAt: Date(),
                                                                                  dateComponents: Date().convertDateToString(),
                                                                                  image: Data()))

        let homeNavigationController = UINavigationController(rootViewController: HomeViewController(viewModel: homeViewModel))

        let recordNavigationController = UINavigationController(rootViewController: RecordViewController(viewModel: recordViewModel))

        homeNavigationController.navigationBar.scrollEdgeAppearance = homeNavigationController.navigationBar.standardAppearance

        recordNavigationController.navigationBar.scrollEdgeAppearance = recordNavigationController.navigationBar.standardAppearance

        viewControllers = [homeNavigationController, recordNavigationController]

        let homeImage = UIImage(systemName: "house")
        let homeTabBarItem = UITabBarItem(title: "home",
                                          image: homeImage,
                                          tag: 0)

        let pencilImage = UIImage(systemName: "pencil.line")
        let recordTabBarItem = UITabBarItem(title: "write",
                                            image: pencilImage,
                                            tag: 1)

        homeNavigationController.tabBarItem = homeTabBarItem
        recordNavigationController.tabBarItem = recordTabBarItem
    }

}
