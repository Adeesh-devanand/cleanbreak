import SwiftUI
import CoreBluetooth

class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    @Published var isConnected = false
    @Published var peripheralName: String = "Unknown Device"
    
    @Published var totalTimer: CGFloat = 180  // Total timer duration (e.g., 3 hours)
    @Published var timeElapsed: CGFloat = 90  // Time elapsed since timer started
    @Published var juiceLevel: CGFloat = 0
    @Published var batteryLevel: CGFloat = 0

    var progress: CGFloat {
        return timeElapsed / totalTimer
    }

    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral?

    // Replace with actual UUIDs from your ESP32 firmware
    private let serviceUUID = CBUUID(string: "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX")
    private let timerCharacteristicUUID = CBUUID(string: "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX")
    private let juiceCharacteristicUUID = CBUUID(string: "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX")
    private let batteryCharacteristicUUID = CBUUID(string: "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX")

    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
    }

    // MARK: - Bluetooth Scanning & Connection

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
        } else {
            isConnected = false
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        self.peripheral = peripheral
        self.peripheral?.delegate = self
        self.centralManager.stopScan()
        self.centralManager.connect(peripheral, options: nil)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        isConnected = true
        peripheralName = peripheral.name ?? "ESP32 Device"
        peripheral.discoverServices([serviceUUID])
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            if service.uuid == serviceUUID {
                peripheral.discoverCharacteristics([timerCharacteristicUUID, juiceCharacteristicUUID, batteryCharacteristicUUID], for: service)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            if characteristic.uuid == timerCharacteristicUUID || characteristic.uuid == juiceCharacteristicUUID || characteristic.uuid == batteryCharacteristicUUID {
                peripheral.setNotifyValue(true, for: characteristic) // Subscribe to changes
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value else { return }
        
        if characteristic.uuid == timerCharacteristicUUID {
            let (total, elapsed) = parseTimeData(data)
            totalTimer = total
            timeElapsed = elapsed
        } else if characteristic.uuid == juiceCharacteristicUUID {
            juiceLevel = parseJuiceBatteryData(data)
        } else if characteristic.uuid == batteryCharacteristicUUID {
            batteryLevel = parseJuiceBatteryData(data)
        }
    }

    // MARK: - Parsing ESP32 Data

    private func parseTimeData(_ data: Data) -> (CGFloat, CGFloat) {
        let values = data.withUnsafeBytes { $0.load(as: (UInt16, UInt16).self) }
        let total = CGFloat(values.0)  // Total timer duration
        let elapsed = CGFloat(values.1) // Time elapsed
        return (total, elapsed)
    }

    private func parseJuiceBatteryData(_ data: Data) -> CGFloat {
        let percentage = data.withUnsafeBytes { $0.load(as: UInt8.self) }
        return CGFloat(percentage) / 100.0 // Convert to 0-1 range
    }
}
