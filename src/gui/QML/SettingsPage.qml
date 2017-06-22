import QtQuick 2.2
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1
import Qt.labs.settings 1.0

// Import custom styles
import "style"

Item {
    id: settingsPage
    property alias enableFullScreenState : enableFullScreen.checked
    property alias enableExpertModeState : enableExpertMode.checked
    property alias enableAGCState : enableAGC.checked
    property alias manualGainState : manualGain.currentValue

    Settings {
        property alias enableFullScreenState : settingsPage.enableFullScreenState
        property alias enableExpertModeState : settingsPage.enableExpertModeState
        property alias manualGainState : settingsPage.manualGainState
        property alias enableAGCState : settingsPage.enableAGCState
    }

    Connections{
        target: cppGUI
        onChannelScanStopped:{
            startChannelScanButton.enabled = true
            stopChannelScanButton.enabled = false
        }

        onChannelScanProgress:{
            channelScanProgressBar.value = progress
        }

        onFoundChannelCount:{
            channelScanProgressBar.text = qsTr("Found channels") + ": " + channelCount;
        }
    }

    Flickable {
        anchors.fill: parent
        contentHeight: layout.implicitHeight > parent.height ? layout.implicitHeight : parent.height
        contentWidth: parent.width

        ColumnLayout {
            id: layout
            anchors.fill: parent
            spacing: Units.dp(30)

            ColumnLayout{
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: Units.dp(20)

                SettingsFrame{
                    ColumnLayout{
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        spacing: Units.dp(20)

                        ColumnLayout{
                            Layout.preferredWidth: parent.width
                            spacing: parent.spacing / 2

                            RowLayout {
                                Layout.preferredWidth: parent.width

                                TextStandart {
                                    text: qsTr("Channel scan")
                                    Layout.alignment: Qt.AlignLeft
                                }

                                TouchButton {
                                    id: startChannelScanButton
                                    text: qsTr("Start")
                                    Layout.alignment: Qt.AlignCenter
                                    onClicked: {
                                        startChannelScanButton.enabled = false
                                        stopChannelScanButton.enabled = true
                                        cppGUI.startChannelScanClick()
                                    }
                                }

                                TouchButton {
                                    id: stopChannelScanButton
                                    text: qsTr("Stop")
                                    Layout.alignment: Qt.AlignRight
                                    enabled: false
                                    onClicked: {
                                        startChannelScanButton.enabled = true
                                        stopChannelScanButton.enabled = false
                                        cppGUI.stopChannelScanClick()
                                    }
                                }
                            }

                            TouchProgressBar{
                                id: channelScanProgressBar
                                minimumValue: 0
                                maximumValue: 54 // 54 channels
                                width: parent.width
                                text: qsTr("Found stations") + ": 0"
                            }
                        }

                        RowLayout {
                            Layout.preferredWidth: parent.width
                            visible: enableExpertMode.checked ? true : false

                            ComboBox {
                                id: styleBox
                                model: ["5A", "5B", "5C", "5D",
                                    "6A", "6B", "6C", "6D",
                                    "7A", "7B", "7C", "7D",
                                    "8A", "8B", "8C", "8D",
                                    "9A", "9B", "9C", "9D",
                                    "10A", "10B", "10C", "10D",
                                    "11A", "11B", "11C", "11D",
                                    "12A", "12B", "12C", "12D",
                                    "13A", "13B", "13C", "13D", "13E", "13F",
                                    "LA", "LB", "LC", "LD",
                                    "LE", "LF", "LG", "LH",
                                    "LI", "LJ", "LK", "LL",
                                    "LM", "LN", "LO", "LP"]

                                Component.onCompleted: { }
                                implicitHeight: Units.dp(25)
                            }

                            TouchButton {
                                id: resetChannelListButton
                                text: qsTr("Tune")
                                Layout.alignment: Qt.AlignCenter
                                onClicked: { }
                            }

                            TouchButton {
                                id: clearListButton
                                text: qsTr("Clear station list")
                                Layout.preferredWidth: Units.dp(160)
                                Layout.alignment: Qt.AlignRight
                                onClicked: { }
                            }
                        }
                    }
                }

                SettingsFrame {
                    Layout.fillWidth: true
                    ColumnLayout{
                        anchors.fill: parent
                        spacing: Units.dp(20)

                        TouchSwitch {
                            id: enableAGC
                            name: qsTr("Automatic RF gain")
                            height: 24
                            Layout.fillHeight: true
                            objectName: "enableAGC"
                            checked: true
                            onChanged: {
                                cppGUI.inputEnableAGCChanged(valueChecked)

                                if(valueChecked == false)
                                    cppGUI.inputGainChanged(manualGain.currentValue)
                            }
                        }

                        TouchSlider {
                            id: manualGain
                            enabled: !enableAGC.checked
                            name: qsTr("Manual gain")
                            maximumValue: cppGUI.gainCount
                            showCurrentValue: qsTr("Value: ") + cppGUI.currentGainValue.toFixed(2)
                            Layout.fillHeight: true
                            onValueChanged: {
                                if(enableAGC.checked == false)
                                    cppGUI.inputGainChanged(valueGain)
                            }
                        }
                    }
                }

                SettingsFrame {
                    id: settingsFrame
                    Layout.fillWidth: true
                    ColumnLayout{
                        anchors.fill: parent
                        spacing: Units.dp(20)

                        TouchSwitch {
                            id: enableFullScreen
                            name: qsTr("Full screen mode")
                            height: 24
                            Layout.fillHeight: true
                            objectName: "enableFullScreen"
                            checked: false
                        }

                        TouchSwitch {
                            id: enableExpertMode
                            name: qsTr("Expert mode")
                            height: 24
                            Layout.fillHeight: true
                            objectName: "enableExpertMode"
                            checked: false
                        }
                    }
                }

                /*TouchButton {
                    id: inputSettingsButton
                    text: "Input settings"
                    width: parent.width
                }*/
            }

            TouchButton {
                id: exitAppButton
                text: qsTr("Exit welle.io")
                onClicked: Qt.quit()
                Layout.preferredWidth: parent.width
                Layout.alignment: Qt.AlignBottom
            }
        }

        ScrollBar.vertical: ScrollBar { }
    }
}
