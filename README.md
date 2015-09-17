# Lepton_Visualizer

This Processing sketch lets you visualize the infrared image data sent by the [Lepton Data Sender](https://github.com/jeradesign/Lepton_Data_Sender) program from a single board computer such as an Intel Edison or BeagleBone Black that is connected to FLIR Lepton infrared camera.

You must have a TCP connection between the machine running Lepton Data Sender and Lepton Visualizer. A hard-wired Ethernet connection works best, but a non-busy WiFi netowrk works fine as well.

To run the sketch, just open the file "Lepton_Visualizer.pde" in [Processing](https://processing.org) and hit the "Run" button in the toolbar of the window.

Note: You must run the sketch <i>first</i> before you start the Lepton Data Sender program on your remote device. This is so the sender has something to send to. You must re-run Lepton Visualizer <i>every time</i> you re-run Lepton Data Sender.
