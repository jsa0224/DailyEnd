//
//  RecordViewController.swift
//  Diary
//
//  Created by 정선아 on 2023/05/02.
//

import UIKit
import RxSwift
import RxCocoa

final class RecordViewController: UIViewController {
    private let recordView = RecordView()
    private let viewModel: RecordViewModel
    private var disposeBag = DisposeBag()
    private let saveButton: UIBarButtonItem = {
        let saveImage = UIImage(systemName: Namespace.saveImage)
        let barButtonItem = UIBarButtonItem(image: saveImage,
                                            style: .plain,
                                            target: nil,
                                            action: nil)
        barButtonItem.tintColor = UIColor(named: Color.main)
        return barButtonItem
    }()

    init(viewModel: RecordViewModel, disposeBag: DisposeBag = DisposeBag()) {
        self.viewModel = viewModel
        self.disposeBag = disposeBag
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
        configureImagePicker()
    }

    private func configureUI() {
        let image = UIImage(named: Image.logo)
        navigationItem.titleView = UIImageView(image: image)
        navigationItem.rightBarButtonItem = saveButton
        
        view.backgroundColor = UIColor(named: Color.main)

        view.addSubview(recordView)

        NSLayoutConstraint.activate([
            recordView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                            constant: Layout.topAnchorConstant),
            recordView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                constant: Layout.leadingAnchorConstant),
            recordView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                 constant: Layout.trailingAnchorConstant),
            recordView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                               constant: Layout.bottomAnchorConstant)
        ])

        recordView.backgroundColor = UIColor(named: Color.background)
        recordView.layer.cornerRadius = Layout.cornerRadius
        recordView.clipsToBounds = true
        recordView.isHiddenImage(true)

        addDoneButtonOnKeyboard(textView: recordView.titleTextView)
        addDoneButtonOnKeyboard(textView: recordView.bodyTextView)
    }

    private func bind() {
        let didShowViewEvent = Observable.just(())
        let didTapSaveButton = saveButton.rx.tap
            .withUnretained(self)
            .map { owner, _ in
                if owner.recordView.titleTextView.text == Description.emptyString || owner.recordView.bodyTextView.text == Description.emptyString {
                    self.configureAlert()
                }
                return (owner.recordView.titleTextView.text,
                        owner.recordView.bodyTextView.text,
                        owner.recordView.diaryImageView.image?.pngData())
            }

        let input = RecordViewModel.Input(didShowView: didShowViewEvent,
                                          didTapSaveButton: didTapSaveButton)
        let output = viewModel.transform(input)

        output
            .diaryItem
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, item in
                owner.recordView.configureView(item)
            })
            .disposed(by: disposeBag)

        output
            .popRecordViewTrigger
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                self.recordView.titleTextView.text = nil
                self.recordView.bodyTextView.text = nil
                self.recordView.diaryImageView.image = nil
                self.recordView.isHiddenImage(true)
                self.tabBarController?.selectedIndex = Namespace.selectedIndex
            })
            .disposed(by: disposeBag)
    }

    private enum Layout {
        static let topAnchorConstant: CGFloat = 8
        static let leadingAnchorConstant: CGFloat = 8
        static let trailingAnchorConstant: CGFloat = -8
        static let bottomAnchorConstant: CGFloat = -8
        static let cornerRadius: CGFloat = 16
    }

    private enum Namespace {
        static let saveImage = "checkmark.circle"
        static let selectedIndex = 0
        static let confirmActionTitle = "확인"
        static let alertTitle = "빈 일기장은 저장되지 않습니다."
    }
}

extension RecordViewController {
    func configureAlert() {
        let confirmAction = UIAlertAction(title: Namespace.confirmActionTitle,
                                          style: .default)

        let alert = AlertManager.shared
            .setType(.alert)
            .setTitle(Namespace.alertTitle)
            .setActions([confirmAction])
            .apply()
        self.present(alert, animated: true)
    }
}

extension RecordViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func configureImagePicker() {
        let buttonAction = UIAction { [weak self] _ in
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            imagePicker.allowsEditing = true

            self?.present(imagePicker, animated: true, completion: nil)
        }

        recordView.registrationButton.addAction(buttonAction, for: .touchUpInside)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: false) { () in
            let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            self.recordView.diaryImageView.image = image
            self.recordView.isHiddenImage(false)
        }
    }
}
