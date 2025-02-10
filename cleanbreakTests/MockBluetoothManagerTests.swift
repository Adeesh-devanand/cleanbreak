import XCTest
@testable import cleanbreak

class MockBluetoothManagerTests: XCTestCase {
    var mockBluetooth: MockBluetoothManager!

    override func setUp() {
        super.setUp()
        mockBluetooth = MockBluetoothManager()
    }

    func testConnectionSimulation() {
        mockBluetooth.simulateConnection(true, name: "Test Device")
        XCTAssertTrue(mockBluetooth.isConnected)
        XCTAssertEqual(mockBluetooth.peripheralName, "Test Device")
    }

    func testTimeElapsedUpdate() {
        mockBluetooth.updateTimeElapsed(by: 30)
        XCTAssertEqual(mockBluetooth.timeElapsed, 30)

        mockBluetooth.updateTimeElapsed(by: 160) // Should cap at 180
        XCTAssertEqual(mockBluetooth.timeElapsed, 180)
    }

    func testJuiceAndBatteryLevels() {
        mockBluetooth.updateJuiceLevel(0.5)
        XCTAssertEqual(mockBluetooth.juiceLevel, 0.5)

        mockBluetooth.updateBatteryLevel(-0.2) // Should clamp to 0
        XCTAssertEqual(mockBluetooth.batteryLevel, 0)
    }

    func testResetTimer() {
        mockBluetooth.updateTimeElapsed(by: 100)
        mockBluetooth.resetTimer()
        XCTAssertEqual(mockBluetooth.timeElapsed, 0)
    }
}
