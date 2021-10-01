/*
 * SPDX-License-Identifier: GPL-3.0-only
 * MuseScore-CLA-applies
 *
 * MuseScore
 * Music Composition & Notation
 *
 * Copyright (C) 2021 MuseScore BVBA and others
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.15
import QtQuick.Controls 2.15

import MuseScore.UiComponents 1.0
import MuseScore.Ui 1.0
import MuseScore.Inspector 1.0

import "../../../common"

InspectorPropertyView {
    id: root

    FocusableItem {
        width: parent.width
        height: gridView.implicitHeight + 2 * gridView.anchors.margins

        Rectangle {
            anchors.fill: parent

            color: ui.theme.textFieldColor
            radius: 3
        }

        GridView {
            id: gridView
            anchors.fill: parent
            anchors.margins: 8

            implicitHeight: Math.min(contentHeight, 3 * cellHeight)

            cellHeight: 40
            cellWidth: 40

            model: [
                { value: Beam.MODE_AUTO, iconCode: IconCode.AUTO_TEXT },
                { value: Beam.MODE_BEGIN, iconCode: IconCode.BEAM_START },
                { value: Beam.MODE_MID, iconCode: IconCode.BEAM_MIDDLE },
                { value: Beam.MODE_NONE, iconCode: IconCode.NOTE_HEAD_EIGHTH },
                { value: Beam.MODE_BEGIN32, iconCode: IconCode.BEAM_32 },
                { value: Beam.MODE_BEGIN64, iconCode: IconCode.BEAM_64 }
            ]

            interactive: true
            boundsBehavior: Flickable.StopAtBounds
            clip: true

            ScrollBar.vertical: StyledScrollBar {}

            delegate: FocusableItem {
                implicitHeight: gridView.cellHeight
                implicitWidth: gridView.cellWidth

                StyledIconLabel {
                    anchors.centerIn: parent
                    iconCode: modelData["iconCode"] ?? IconCode.NONE
                    font.pixelSize: 30
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (root.propertyItem) {
                            root.propertyItem.value = modelData["value"]
                        }
                    }
                }
            }

            highlight: Rectangle {
                color: ui.theme.accentColor
                opacity: ui.theme.accentOpacityNormal
                radius: 2
            }

            currentIndex: root.propertyItem && !root.propertyItem.isUndefined
                          ? model.findIndex((modelData) => (modelData["value"] === root.propertyItem.value))
                          : -1
        }
    }
}