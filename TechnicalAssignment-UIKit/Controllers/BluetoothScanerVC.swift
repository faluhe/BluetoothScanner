
import UIKit
import CoreBluetooth
import Combine

class BluetoothService: NSObject, CBCentralManagerDelegate {
    
    private var centralManager: CBCentralManager!
    private let nearbyDevicesSubject = PassthroughSubject<[CBPeripheral], Error>()
    private var nearbyDevices = [CBPeripheral]()
    private let scanDelayTime: TimeInterval = 2.0
    private var delayedStartWorkItem: DispatchWorkItem?
    
    var nearbyDevicesPublisher: AnyPublisher<[CBPeripheral], Error> {
        return nearbyDevicesSubject.eraseToAnyPublisher()
    }
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue(label: "hi"))
    }
    
    func startScanningWithDelay() {
        nearbyDevices.removeAll()
        let workItem = DispatchWorkItem { [weak self] in
            self?.startScanning()
        }
        delayedStartWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + scanDelayTime, execute: workItem)
    }

    func startScanning() {
        print("Starting Bluetooth scan...")
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func stopScanning() {
        delayedStartWorkItem?.cancel()
        centralManager.stopScan()
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Bluetooth state updated: \(central.state)")
        switch central.state {
        case .poweredOn:
            startScanningWithDelay()
        case .poweredOff:
            nearbyDevicesSubject.send(completion: .failure(BluetoothError.poweredOff))
        case .resetting:
            nearbyDevicesSubject.send(completion: .failure(BluetoothError.resetting))
        case .unauthorized:
            nearbyDevicesSubject.send(completion: .failure(BluetoothError.unauthorized))
        case .unknown:
            nearbyDevicesSubject.send(completion: .failure(BluetoothError.unknown("An unknown error occurred.")))
        case .unsupported:
            nearbyDevicesSubject.send(completion: .failure(BluetoothError.unsupported))
        @unknown default:
            nearbyDevicesSubject.send(completion: .failure(BluetoothError.unknown("An unknown error occurred.")))
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.name != nil {
            if !nearbyDevices.contains(peripheral) {
                nearbyDevices.append(peripheral)
                print(nearbyDevices.count)
                nearbyDevicesSubject.send(nearbyDevices)
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to peripheral: \(peripheral)")
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect to peripheral: \(peripheral), error: \(String(describing: error))")
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected from peripheral: \(peripheral), error: \(String(describing: error))")
    }
}

enum BluetoothError: Error {
    case poweredOff
    case resetting
    case unavailable
    case unsupported
    case unauthorized
    case unknown(String)
}

class BluetoothViewController: UIViewController {
    
    private let bluetoothService = BluetoothService()
    private var cancellables = Set<AnyCancellable>()
    private var nearbyDevices = [CBPeripheral]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appColor
        loadingIndicator.startAnimating()
        
        bluetoothService.nearbyDevicesPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else {return}
                if case let .failure(error) = completion {
                    self.showAlert(for: error)
                }
            }, receiveValue: { [weak self] devices in
                guard let self = self else {return}
                self.loadingIndicator.stopAnimating()
                self.nearbyDevices.removeAll()
                self.nearbyDevices.append(contentsOf: devices)
                print(devices.count)
                self.tableView.reloadData()
            })
            .store(in: &cancellables)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }
    
    private func showAlert(for error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        
        switch error {
            case BluetoothError.poweredOff:
                alertController.message = "Bluetooth is powered off."
            case BluetoothError.resetting:
                alertController.message = "Bluetooth is resetting."
            case BluetoothError.unauthorized:
                alertController.message = "You are not authorized to use Bluetooth."
            case BluetoothError.unsupported:
                alertController.message = "Bluetooth is not supported on this device."
            case BluetoothError.unknown(let message):
                alertController.message = message
            default:
                break
            }
    }
    
    @objc func stopScanning(){
        button.isSelected.toggle()
        print(button.isSelected)
        if button.isSelected{
            button.setTitle("Stop searching", for: .normal)
            loadingIndicator.stopAnimating()
            bluetoothService.stopScanning()
        }else{
            button.setTitle("Search for devices", for: .selected)
            loadingIndicator.startAnimating()
            bluetoothService.startScanningWithDelay()
        }
        
        
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
        let img = UIImageView(image: UIImage(named: "bluetooth"))
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    
    private lazy var titleLbl: UILabel = {
        let lbl = TextLabel(textAlignment: .center, font: UIFont(name: "NimbusSanL-Bol", size: 28), textColor: .white, text: "SEARCHING")
        lbl.setTextSpacingBy(value: 1)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
    private lazy var subTitle: UILabel = {
        let lbl = TextLabel(textAlignment: .center, font: UIFont(name: "Gibson-regular", size: 24), textColor: .appGray, text: "Remember to keep your scooter on and within 6 feet")
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private lazy var button: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Stop searching", for: .normal)
        btn.setTitleColor(.appGray, for: .normal)
        btn.addTarget(self, action: #selector(stopScanning), for: .touchUpInside)
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



extension BluetoothViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearbyDevices.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let device = nearbyDevices[indexPath.row]
        cell.backgroundColor = .appColor
        cell.selectionStyle = .none
        cell.textLabel?.text = device.name ?? "Unknown device"
        cell.textLabel?.textColor = .gray
        cell.imageView?.image = UIImage(named: "icon")?.withRenderingMode(.alwaysTemplate).withTintColor(.systemBlue)
        
        // adding disclosure indicator
        let image = UIImage(systemName: "chevron.right")
        cell.accessoryView = UIImageView(image: image)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Scooters found"
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



//class NearbyDevicesVC: UIViewController {
//
//    // MARK: - Properties
//    private let centralManager = CBCentralManager(delegate: nil, queue: DispatchQueue(label: "background"))
//    private var isSearching = false
//    private let scanDelayTime: TimeInterval = 2.0
//    private let stopScanDelayTime: TimeInterval = 20.0
//    private var scanTask: DispatchWorkItem?
//
//    // Array of discovered CBPeripheral devices
//    @Published private var devices = [CBPeripheral]()
//
//    // Publisher for the devices array, erasing the specific Never is error type
//    private var devicesPublisher: AnyPublisher<[CBPeripheral], Never> {
//        return $devices.eraseToAnyPublisher()
//    }
//
//    //AnyCancellable instances to manage the lifecycle of Combine subscribers
//    private var cancellables = Set<AnyCancellable>()
//
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .appColor
//        loadingIndicator.startAnimating()
//        centralManager.delegate = self
//
//        // Subscribe to changes in the devices array, and reload the table view when updates occur
//        devicesPublisher
//            .receive(on: RunLoop.main)
//            .sink(receiveValue: { [weak self] _ in
//                self?.tableView.reloadData()
//            })
//            .store(in: &cancellables)
//    }
//
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        startScanning()
//    }
//
//    override func viewDidLayoutSubviews() {
//        setupUI()
//    }
//
//
//
//    private func setupUI() {
//
//        view.addSubviews(stackView, button)
//
//        NSLayoutConstraint.activate([
//            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
//            stackView.widthAnchor.constraint(equalTo: view.widthAnchor),
//            stackView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -20),
//
//            tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45),
//            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
//
//            iconView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12),
//
//            titleLbl.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
//
//            icon.centerXAnchor.constraint(equalTo: iconView.centerXAnchor),
//            icon.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
//            icon.heightAnchor.constraint(equalTo: iconView.heightAnchor, multiplier: 0.6),
//            icon.widthAnchor.constraint(equalTo: iconView.heightAnchor, multiplier: 0.6),
//
//            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
//        ])
//    }
//
//
//
//    private func startScanning(){
//
//        devices.removeAll()
//
//        // Cancel any previously scheduled tasks
//        if let task = scanTask {
//            task.cancel()
//        }
//
//        // Create a new DispatchWorkItem to scan for peripherals
//        scanTask = DispatchWorkItem { [weak self] in
//            guard let self = self else { return }
//            self.centralManager.scanForPeripherals(withServices: nil)
//        }
//
//        // Schedule the DispatchWorkItem to run after a delay
//        DispatchQueue.main.asyncAfter(deadline: .now() + scanDelayTime, execute: scanTask!)
//
//        // Schedule a task to stop scanning after a longer delay
//        DispatchQueue.main.asyncAfter(deadline: .now() + stopScanDelayTime) { [weak self] in
//            guard let self = self else { return }
//            self.centralManager.stopScan()
//
//
//            // Show an alert if no devices were found
//            if self.devices.isEmpty {
//                self.showAlert(title: "No nearby devices found", message: "Please try again.")
//            }
//        }
//    }
//
//    @objc func stopScanning(){
//
//        self.centralManager.stopScan()
//
//        // Cancel any scheduled tasks in the DispatchQueue
//        scanTask?.cancel()
//
//        if self.devices.isEmpty {
//            self.showAlert(title: "No nearby devices found", message: "Please try again.")
//        }
//    }
//
//    private func showAlert(title: String, message: String) {
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "OK", style: .default))
//        present(alertController, animated: true, completion: nil)
//    }
//
//
//
//    // MARK: - Page elements
//    private lazy var icon: UIImageView = {
//        let img = UIImageView(image: UIImage(named: "bluetooth"))
//        img.translatesAutoresizingMaskIntoConstraints = false
//        return img
//    }()
//
//
//    private lazy var titleLbl: UILabel = {
//        let lbl = TextLabel(textAlignment: .center, fontSize: 32, textColor: .systemBackground,fontWeight: .heavy, text: "SEARCHING")
//        lbl.setTextSpacingBy(value: 1)
//        lbl.translatesAutoresizingMaskIntoConstraints = false
//        return lbl
//    }()
//
//
//    private lazy var subTitle: UILabel = {
//        let lbl = TextLabel(textAlignment: .center, fontSize: 12, textColor: .systemGray5, fontWeight: .medium, text: "Remember to keep your scooter on and within 6 feet")
//        lbl.adjustsFontSizeToFitWidth = true
//        lbl.minimumScaleFactor = 0.5
//        lbl.translatesAutoresizingMaskIntoConstraints = false
//        return lbl
//    }()
//
//
//    private lazy var tableView: UITableView = {
//        let tableView = UITableView(frame: .zero, style: .plain)
//        tableView.addSubview(loadingIndicator)
//        tableView.backgroundView = loadingIndicator
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.backgroundColor = .appColor
//        tableView.alwaysBounceVertical = false
//        tableView.indicatorStyle = .white
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        return tableView
//    }()
//
//    private lazy var button: UIButton = {
//        let btn = UIButton(type: .system)
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.setTitle("Stop searching", for: .normal)
//        btn.setTitleColor(.systemGray5, for: .normal)
//        btn.addTarget(self, action: #selector(stopScanning), for: .touchUpInside)
//        return btn
//    }()
//
//    private lazy var iconView: UIView = {
//        let view = UIView()
//        view.addSubview(icon)
//        view.backgroundColor = .clear
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    private lazy var stackView: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [iconView, titleLbl, subTitle, tableView])
//        stackView.axis = .vertical
//        stackView.alignment = .center
//        stackView.distribution = .fill
//        stackView.spacing = 10
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        return stackView
//    }()
//
//    private lazy var loadingIndicator: UIActivityIndicatorView = {
//        let indicator = UIActivityIndicatorView()
//        indicator.color = .systemGray5
//        return indicator
//    }()
//
//}
//
//
//
//
//
//
//
//extension NearbyDevicesVC: UITableViewDataSource, UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return devices.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        let device = devices[indexPath.row]
//        cell.backgroundColor = .appColor
//        cell.selectionStyle = .none
//        cell.textLabel?.text = device.name ?? "Unknown device"
//        cell.textLabel?.textColor = .gray
//        cell.imageView?.image = UIImage(named: "icon")?.withRenderingMode(.alwaysTemplate).withTintColor(.systemBlue)
//        // adding disclosure indicator
//        let image = UIImage(systemName: "chevron.right")
//        cell.accessoryView = UIImageView(image: image)
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 60
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Scooters found"
//    }
//
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        view.tintColor = .appColor
//        let header = view as! UITableViewHeaderFooterView
//        header.textLabel?.textColor = .systemGray5
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 40
//    }
//}
//
//
//
//
//
//
//
//extension NearbyDevicesVC: CBCentralManagerDelegate {
//
//    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        switch central.state {
//        case .unknown, .resetting, .unsupported:
//            showAlert(title: "Bluetooth not available", message: "Please make sure Bluetooth is turned on and try again.")
//        case .unauthorized:
//            showAlert(title: "Bluetooth permission denied", message: "Please grant permission to use Bluetooth in Settings and try again.")
//        case .poweredOff:
//            showAlert(title: "Bluetooth turned off", message: "Please turn on Bluetooth and try again.")
//        case .poweredOn:
//            break
//        @unknown default:
//            fatalError("Unhandled case")
//        }
//    }
//
//    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
//        if peripheral.name != nil{
//            if !devices.contains(peripheral) {
//                devices.append(peripheral)
//            }
//        }
//    }
//}
//
//
//
//

//
//
//
//
//
//
