/*
             * Copyright (C) 2023  Jakub Krsko
             *
             * This program is free software: you can redistribute it and/or modify
             * it under the terms of the GNU General Public License as published by
             * the Free Software Foundation; version 3.
             *
             * cameratest is distributed in the hope that it will be useful,
             * but WITHOUT ANY WARRANTY; without even the implied warranty of
             * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
             * GNU General Public License for more details.
             *
             * You should have received a copy of the GNU General Public License
             * along with this program.  If not, see <http://www.gnu.org/licenses/>.
             */
import QtQuick 2.12
import Lomiri.Components 1.3
import QtMultimedia 5.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0

MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'camera-test.jakub'
    automaticOrientation: false

    width: units.gu(45)
    height: units.gu(75)

    function addToModel(value, index, array) {
        comboModel.append({
                              "text": value.displayName
                          }) // add cameras to model
        availableCameras.append(value.deviceId)
    }

    ListModel {
        id: comboModel
    }

    ListModel {
        id: availableCameras
    }

    Page {
        id: mainPage
        Component.onCompleted: function () {
            let cameras = QtMultimedia.availableCameras
            cameras.forEach(addToModel)
        }

        anchors.fill: parent

        ColumnLayout {
            spacing: units.gu(1)
            anchors {
                //margins: units.gu(1)
                top: parent.top
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            VideoOutput {
                id: videoOutput
                source: camera
                Layout.fillHeight: true
                Layout.fillWidth: true
                fillMode: Image.PreserveAspectCrop
                focus: visible
                orientation: 270

                Camera {
                    id: camera
                    focus.focusMode: Camera.FocusContinuous
                    focus.focusPointMode: Camera.FocusPointAuto
                    property alias currentZoom: camera.digitalZoom

                    function startAndConfigure() {
                        start()
                        focus.focusMode = Camera.FocusContinuous
                        focus.focusPointMode = Camera.FocusPointAuto
                    }
                }
            }

            Label {
                id: currentCamera
                text: ""
                visible: false
            }

            Button {
                id: captureButton
                text: "Capture"
                onClicked: {
                    camera.imageCapture.captureToLocation("/home/phablet/.cache/camera-test.jakub")
                    infoDialog.open()
                }
                icon.source: "../assets/camera-app-symbolic.svg"
                Layout.alignment: Qt.AlignCenter
            }

            RowLayout {
                ComboBox {
                    id: cameras
                    Layout.fillWidth: true
                    model: comboModel
                }

                Button {
                    id: chooseButton
                    text: "Choose"
                    onClicked: {
                        currentCamera.text = cameras.currentText
                        camera.deviceId = cameras.currentIndex
                    }
                }
            }
        }
    }

    Dialog {
        id: infoDialog
        x: Math.round((root.width - width) / 2)
        y: (root.height - height) / 2 - header.height
        width: units.gu(32) //250
        height: units.gu(20) //500
        modal: true
        focus: true
        title: "Info"
        standardButtons: Dialog.Ok
        onAccepted: {
            infoDialog.close()
        }

        contentItem: Label {
            text: "Image saved to /home/phablet/.cache/camera-test.jakub"
            wrapMode: "WordWrap"
        }
    }
}
