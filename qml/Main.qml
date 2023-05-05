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
import Ubuntu.Components 1.3
import QtMultimedia 5.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0

import Example 1.0

MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'cameratest.jakub'
    automaticOrientation: true

    width: units.gu(45)
    height: units.gu(75)

    ListModel {
        id: comboModel
    }

    Page {
        Component.onCompleted: function(){
            cameras = QtMultimedia.availableCameras
            console.log(cameras)
            /*for (cam : cameras){
                comboModel.append({text: cam.displayName})
            }*/
        }

        anchors.fill: parent

        header: PageHeader {
            id: header
            title: i18n.tr('Camera test')
        }

        ColumnLayout {
            spacing: units.gu(2)
            anchors {
                margins: units.gu(2)
                top: header.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            RowLayout{
                Button {
                    id: activateButton
                    text: "Activate preview"
                }
                Label{
                    id: currentCamera
                    text: "Current camera: 0"
                }
            }

            RowLayout {
                anchors.right: parent.right
                anchors.left: parent.left
                ComboBox{
                    id: cameras
                    Layout.fillWidth: true
                    model: comboModel
                }

                Button{
                    id: chooseButton
                    text: "Choose"
                }
            }
        }
    }
}
