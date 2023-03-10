//
//  BluetoothService.swift
//  TechnicalAssignment-UIKit
//
//  Created by Ismailov Farrukh on 10/03/23.
//

import UIKit
import Combine
import CoreBluetooth

class BluetoothService: NSObject, CBCentralManagerDelegate {
    
    //MARK: - Properties
    private var centralManager: CBCentralManager!
    private let nearbyDevicesSubject = PassthroughSubject<[CBPeripheral], Error>()
    private let scanningStateSubject = CurrentValueSubject<Bool, Never>(false)
    private var nearbyDevices = [CBPeripheral]()
    private let scanDelayTime: TimeInterval = 2.0
    private let stopScanDelay: TimeInterval = 10.0
    private var delayedStartWorkItem: DispatchWorkItem?
    
    var nearbyDevicesPublisher: AnyPublisher<[CBPeripheral], Error> {
        return nearbyDevicesSubject.eraseToAnyPublisher()
    }
    
    var scanningStatePublisher: AnyPublisher<Bool, Never> {
        return scanningStateSubject.eraseToAnyPublisher()
    }
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue(label: "queue"))
    }
    
    func startScanningWithDelay() {
        nearbyDevices.removeAll()
        
        if centralManager.state == .poweredOn {
            let workItem = DispatchWorkItem { [weak self] in
                self?.startScanning()
            }
            
            delayedStartWorkItem = workItem
            DispatchQueue.main.asyncAfter(deadline: .now() + scanDelayTime, execute: workItem)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + stopScanDelay) {
                self.stopScanning()
            }
            
            scanningStateSubject.send(true)
        } else {
            self.stopScanning()
        }
    }
    
    func startScanning() {
        print("Starting Bluetooth scan...")
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func stopScanning() {
        delayedStartWorkItem?.cancel()
        centralManager.stopScan()
        scanningStateSubject.send(false)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Bluetooth state updated: \(central.state)")
        switch central.state {
        case .poweredOn:
            startScanningWithDelay()
        case .poweredOff:
            nearbyDevicesSubject.send(completion: .failure(BluetoothError.poweredOff))
            stopScanning()
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
                nearbyDevicesSubject.send(nearbyDevices)
            }
        }
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
