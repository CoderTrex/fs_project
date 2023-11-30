import Cocoa
import FlutterMacOS

@NSprojectlicationMain
class projectDelegate: FlutterprojectDelegate {
  override func projectlicationShouldTerminateAfterLastWindowClosed(_ sender: NSprojectlication) -> Bool {
    return true
  }
}
