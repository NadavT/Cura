// Copyright (c) 2021 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.9
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.3

import UM 1.5 as UM
import Cura 1.1 as Cura


Item
{
    id: prepareMenu

    property var fileProviderModel: CuraApplication.getFileProviderModel()

    UM.I18nCatalog
    {
        id: catalog
        name: "cura"
    }

    anchors
    {
        left: parent.left
        right: parent.right
        leftMargin: UM.Theme.getSize("wide_margin").width * 2
        rightMargin: UM.Theme.getSize("wide_margin").width * 2
    }

    // Item to ensure that all of the buttons are nicely centered.
    Item
    {
        anchors.fill: parent

        RowLayout
        {
            id: itemRow

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: UM.Theme.getSize("default_margin").width + openFileButton.width + openFileMenu.width
            property int machineSelectorWidth: Math.round((width - printSetupSelectorItem.width) / 3)

            height: parent.height
            // This is a trick to make sure that the borders of the two adjacent buttons' borders overlap. Otherwise
            // there will be double border (one from each button)
            spacing: -UM.Theme.getSize("default_lining").width

            Cura.MachineSelector
            {
                id: machineSelection
                headerCornerSide: Cura.RoundedRectangle.Direction.Left
                Layout.preferredWidth: parent.machineSelectorWidth
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            Cura.ConfigurationMenu
            {
                id: printerSetup
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.preferredWidth: parent.machineSelectorWidth * 2
            }

            Item
            {
                id: printSetupSelectorItem
                // This is a work around to prevent the printSetupSelector from having to be re-loaded every time
                // a stage switch is done.
                children: [printSetupSelector]
                height: childrenRect.height
                width: childrenRect.width
            }
        }

        //Pop-up shown when there are multiple items to select from.
        Cura.ExpandablePopup
        {
            id: openFileMenu
            visible: prepareMenu.fileProviderModel.count > 1

            contentAlignment: Cura.ExpandablePopup.ContentAlignment.AlignLeft
            headerCornerSide: Cura.RoundedRectangle.Direction.All
            headerPadding: Math.round((parent.height - UM.Theme.getSize("button_icon").height) / 2)
            contentPadding: UM.Theme.getSize("default_lining").width
            enabled: visible

            height: parent.height
            width: visible ? (headerPadding * 3 + UM.Theme.getSize("button_icon").height + iconSize) : 0

            headerItem: UM.RecolorImage
            {
                id: menuIcon
                source: UM.Theme.getIcon("Folder", "medium")
                color: UM.Theme.getColor("icon")

                sourceSize.height: height
            }

            contentItem: Item
            {
                id: popup

                Column
                {
                    id: openProviderColumn

                    //The column doesn't automatically listen to its children rect if the children change internally, so we need to explicitly update the size.
                    onChildrenRectChanged:
                    {
                        popup.height = childrenRect.height
                        popup.width = childrenRect.width
                    }
                    onPositioningComplete:
                    {
                        popup.height = childrenRect.height
                        popup.width = childrenRect.width
                    }

                    Repeater
                    {
                        model: prepareMenu.fileProviderModel
                        delegate: Button
                        {
                            leftPadding: UM.Theme.getSize("default_margin").width
                            rightPadding: UM.Theme.getSize("default_margin").width
                            width: contentItem.width + leftPadding + rightPadding
                            height: UM.Theme.getSize("action_button").height
                            hoverEnabled: true

                            contentItem: UM.Label
                            {
                                text: model.displayText
                                font: UM.Theme.getFont("medium")
                                width: contentWidth
                                height: parent.height
                            }

                            onClicked:
                            {
                                if(model.index == 0) //The 0th element is the "From Disk" option, which should activate the open local file dialog.
                                {
                                    Cura.Actions.open.trigger();
                                }
                                else
                                {
                                    prepareMenu.fileProviderModel.trigger(model.name);
                                }
                            }

                            background: Rectangle
                            {
                                color: parent.hovered ? UM.Theme.getColor("action_button_hovered") : "transparent"
                                radius: UM.Theme.getSize("action_button_radius").width
                                width: popup.width
                            }
                        }
                    }
                }
            }
        }

        //If there is just a single item, show a button instead that directly chooses the one option.
        Button
        {
            id: openFileButton
            visible: prepareMenu.fileProviderModel.count <= 1

            height: parent.height
            width: visible ? height : 0 //Square button (and don't take up space if invisible).
            onClicked: Cura.Actions.open.trigger()
            enabled: visible && prepareMenu.fileProviderModel.count > 0
            hoverEnabled: true

            contentItem: Item
            {
                UM.RecolorImage
                {
                    id: buttonIcon
                    source: UM.Theme.getIcon("Folder", "medium")
                    anchors.centerIn: parent
                    width: UM.Theme.getSize("button_icon").width
                    height: UM.Theme.getSize("button_icon").height
                    color: UM.Theme.getColor("icon")

                    sourceSize.height: height
                }
            }

            background: Rectangle
            {
                id: background
                height: parent.height
                width: parent.width
                border.color: UM.Theme.getColor("lining")
                border.width: UM.Theme.getSize("default_lining").width

                radius: UM.Theme.getSize("default_radius").width
                color: openFileButton.hovered ? UM.Theme.getColor("action_button_hovered") : UM.Theme.getColor("action_button")
            }
        }
    }
}
