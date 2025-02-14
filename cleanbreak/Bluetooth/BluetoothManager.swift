import SwiftUI
import CoreBluetooth

class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    @Published var isConnected = false
    @Published var peripheralName: String = "Unknown Device"
    
    // Timer data from the SYNC characteristic (in milliseconds)
    @Published var persistentTotal: CGFloat = 0    // Field 1: Persistent Timer Total (ms)
    @Published var persistentElapsed: CGFloat = 0  // Field 2: Persistent Timer Elapsed (ms)
    @Published var coilTotal: CGFloat = 0          // Field 3: Coil Unlock Total Duration (ms)
    @Published var coilElapsed: CGFloat = 0          // Field 4: Coil Unlock Elapsed (ms)
    
    // Computed progress (optional)
    var progress: CGFloat {
        return persistentTotal > 0 ? persistentElapsed / persistentTotal : 0
    }
    
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral?
    
    // Characteristics
    private var timerCharacteristic: CBCharacteristic?
    private var syncCharacteristic: CBCharacteristic?
    
    // UUIDs from the ESP32 firmware (as defined in your BLEManager.h file)
    private let serviceUUID = CBUUID(string: "12345678-1234-5678-1234-56789abcdef0")
    private let timerCharacteristicUUID = CBUUID(string: "12345678-1234-5678-1234-56789abcdef1")
    private let syncCharacteristicUUID = CBUUID(string: "12345678-1234-5678-1234-56789abcdef3")
    
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
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any], rssi RSSI: NSNumber) {
        self.peripheral = peripheral
        self.peripheral?.delegate = self
        centralManager.stopScan()
        centralManager.connect(peripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        isConnected = true
        peripheralName = peripheral.name ?? "ESP32 Device"
        peripheral.discoverServices([serviceUUID])
    }
    
    // MARK: - Peripheral Delegate
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            if service.uuid == serviceUUID {
                peripheral.discoverCharacteristics([timerCharacteristicUUID, syncCharacteristicUUID], for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            if characteristic.uuid == timerCharacteristicUUID {
                timerCharacteristic = characteristic
            } else if characteristic.uuid == syncCharacteristicUUID {
                syncCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: characteristic) // Subscribe to changes
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value else { return }
        if characteristic.uuid == syncCharacteristicUUID {
            let parsed = parseSyncData(data)
            persistentTotal = parsed.persistentTotal
            persistentElapsed = parsed.persistentElapsed
            coilTotal = parsed.coilTotal
            coilElapsed = parsed.coilElapsed
        }
    }
    
    // MARK: - Parsing ESP32 Sync Data
    // Expected data format (16 bytes): four UInt32 values in little-endian order:
    // Field 1: Persistent Timer Total (ms)
    // Field 2: Persistent Timer Elapsed (ms)
    // Field 3: Coil Unlock Total Duration (ms)
    // Field 4: Coil Unlock Elapsed (ms)
    // If a timer isn't running, the elapsed field equals the total.
    private func parseSyncData(_ data: Data) -> (persistentTotal: CGFloat, persistentElapsed: CGFloat, coilTotal: CGFloat, coilElapsed: CGFloat) {
        guard data.count >= 16 else { return (0, 0, 0, 0) }
        
        let values: [UInt32] = data.withUnsafeBytes { pointer in
            let buffer = pointer.bindMemory(to: UInt32.self)
            return Array(buffer.prefix(4))
        }
        
        // Convert values from little-endian
        let pTotal = CGFloat(UInt32(littleEndian: values[0]))
        let pElapsed = CGFloat(UInt32(littleEndian: values[1]))
        let cTotal = CGFloat(UInt32(littleEndian: values[2]))
        let cElapsed = CGFloat(UInt32(littleEndian: values[3]))
        
        let cappedPersistentElapsed = pElapsed > pTotal ? pTotal : pElapsed
        let cappedCoilElapsed = cElapsed > cTotal ? cTotal : cElapsed
        
        return (persistentTotal: pTotal, persistentElapsed: cappedPersistentElapsed, coilTotal: cTotal, coilElapsed: cappedCoilElapsed)
    }
    
    // MARK: - Writing Timer Value
    // Sends a new timer value to the ESP32 via the timer characteristic.
    func writeTimerValue(_ value: UInt32) {
        guard let timerChar = timerCharacteristic, let peripheral = peripheral else { return }
        var timerValue = value.littleEndian
        let data = Data(bytes: &timerValue, count: MemoryLayout<UInt32>.size)
        peripheral.writeValue(data, for: timerChar, type: .withResponse)
    }
}
