
//
//  BluetoothScannerVC.swift
//  TechnicalAssignment-UIKit
//
//  Created by Ismailov Farrukh on 09/03/23.
//



import UIKit
import CoreBluetooth
import Combine

class BluetoothScannerVC: UIViewController {
    
    private let bluetoothService = BluetoothService()
    private var cancellables = Set<AnyCancellable>()
    private var nearbyDevices = [CBPeripheral]()
    private let tableViewCell = "cell"
    
    private var isScanning = false {
        didSet {
            if isScanning {
                print("scanning started")
                button.isHidden = true
                iconView.startRotationAnimation()
            } else {
                showAlert(for: nil, message: K.AlertMessages.scanningStoped)
                button.isHidden = false
                iconView.stopRotationAnimation()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appColor
        loadingIndicator.startAnimating()
        
        //Scanning scaning for nearby devices publisher
        bluetoothService.nearbyDevicesPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else {return}
                if case let .failure(error) = completion {
                    self.showAlert(for: error)
                }
            }, receiveValue: { [weak self] devices in
                guard let self = self else {return}
                print(devices)
                self.loadingIndicator.stopAnimating()
                self.nearbyDevices.removeAll()
                self.nearbyDevices.append(contentsOf: devices)
                self.tableView.reloadData()
            })
            .store(in: &cancellables)
        
        
        //Scanning publisher
        bluetoothService.scanningStatePublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isScanning in
                guard let self = self else { return }
                self.isScanning = isScanning
            })
            .store(in: &cancellables)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }
    
    //Alert func to handle errors
    private func showAlert(for error: Error?, message: String? = nil) {
        let alertController = UIAlertController(title: "", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        if let error = error {
            switch error {
            case BluetoothError.poweredOff:
                alertController.message = K.AlertMessages.bluetoothPoweredOff
            case BluetoothError.resetting:
                alertController.message = K.AlertMessages.bluetoothIsResetting
            case BluetoothError.unauthorized:
                alertController.message = K.AlertMessages.bluetoothUnauthorized
            case BluetoothError.unsupported:
                alertController.message = K.AlertMessages.bluetoothIsNotSupported
            case BluetoothError.unknown(let message):
                alertController.message = message
            default:
                alertController.message = error.localizedDescription
            }
        } else if let message = message {
            alertController.message = message
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    @objc func startScanning(){
        loadingIndicator.startAnimating()
        bluetoothService.startScanningWithDelay()
        button.isHidden = true
    }
    
    
    private func setupUI() {
        view.addSubviews(stackView, button)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor),
            stackView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -20),
            
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            iconView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12),
            
            titleLbl.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
            
            icon.centerXAnchor.constraint(equalTo: iconView.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
            icon.heightAnchor.constraint(equalTo: iconView.heightAnchor, multiplier: 0.6),
            icon.widthAnchor.constraint(equalTo: iconView.heightAnchor, multiplier: 0.6),
            
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    
    // MARK: - Page elements
    private lazy var icon: UIImageView = {
        let img = UIImageView(image: K.Images.bluetoothIcon)
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    
    private lazy var titleLbl: UILabel = {
        let lbl = TextLabel(textAlignment: .center, font: UIFont(name: K.Fonts.nimbus_bold, size: 28), textColor: .white, text: K.Strings.searching)
        lbl.setTextSpacingBy(value: 1)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
    private lazy var subTitle: UILabel = {
        let lbl = TextLabel(textAlignment: .center, font: UIFont(name: K.Fonts.gibson_regular, size: 24), textColor: .appGray, text: K.Strings.remeberKeepScooterNear)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.addSubview(loadingIndicator)
        tableView.backgroundView = loadingIndicator
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .appColor
        tableView.alwaysBounceVertical = false
        tableView.indicatorStyle = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableViewCell)
        return tableView
    }()
    
    private lazy var button: UIButton = {
        let btn = UIButton(type: .system)
        btn.isHidden = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(K.Strings.startScanning, for: .normal)
        btn.setTitleColor(.appGray, for: .normal)
        btn.addTarget(self, action: #selector(startScanning), for: .touchUpInside)
        return btn
    }()
    
    private lazy var iconView: UIView = {
        let view = UIView()
        view.addSubview(icon)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [iconView, titleLbl, subTitle, tableView])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = .appGray
        return indicator
    }()
    
}



extension BluetoothScannerVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearbyDevices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCell, for: indexPath)
        let device = nearbyDevices[indexPath.row]
        cell.backgroundColor = .appColor
        cell.selectionStyle = .none
        cell.textLabel?.text = device.name ?? "Unknown device"
        cell.textLabel?.textColor = .gray
        cell.imageView?.image = K.Images.blue_icon.withRenderingMode(.alwaysTemplate).withTintColor(.systemBlue)
        
        // adding disclosure indicator
        let image = K.Images.disclosureIndicator
        cell.accessoryView = UIImageView(image: image)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return K.Strings.scootersFound
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .appColor
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .appGray
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}


