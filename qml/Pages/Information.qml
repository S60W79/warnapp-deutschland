
import QtQuick 2.9
import Ubuntu.Components 1.3

Page {
	id:_infoPage
    header: PageHeader {
        id:infoHeader
        title: i18n.tr("Informationen")
    }

    ListModel {
       id: infoModel
     }

    Component.onCompleted: {
       // infoModel.append({ name: i18n.tr("Dieses Projekt ermöglicht es offizielle Warnungen je nach Landkreis einfach zu empfangen.\nDabei wurde die RSS stelle des NINA Projektes genutzt und die App 'URsses' (im Openstore erhältlich) von Darkeye modifiziert."}))
        infoModel.append({ name: i18n.tr("Quellcode ansehen"), url: "https://github.com/S60W79/warnapp-deutschland" ,icon : "note"})
        infoModel.append({ name: i18n.tr("Fehler melden"), url: "https://github.com/S60W79/warnapp-deutschland/issues" ,icon : "info"})
        infoModel.append({ name: i18n.tr("Offizielle Nachrichtenquelle"), url: "https://warnung.bund.de/meldungen" ,icon : "external-link" })
//         infoModel.append({ name: i18n.tr("Help translate"), url: "https://translate.ubports.com/projects/ubports/clock-app/" })
        infoModel.append({ name: i18n.tr("Basiert auf URsses von DarkEye"), url: "https://open-store.io/app/darkeye.ursses" ,icon : "" })
        infoModel.append({ name: i18n.tr("URsses Quellcode"), url: "https://gitlab.com/dark-eye/ursses" ,icon : "note" })
        infoModel.append({ name: i18n.tr("Spenden (an S60W79 oder Darkeye)"), url: "https://infoportal.ddns.net/entwickler/spenden",icon : "like" })
    }

    Column {
        id: aboutCloumn
        spacing:units.dp(2)
        width:parent.width

        Label { //An hack to add margin to the column top
            width:parent.width
            height:infoHeader.height *2
        }

        Icon {
          anchors.horizontalCenter: parent.horizontalCenter
          height: Math.min(parent.width/2, parent.height/2)
          width:height
          source:Qt.resolvedUrl("../../assets/splash.svg")
          layer.enabled: true
          layer.effect: UbuntuShapeOverlay {
              relativeRadius: 0.75
           }
        }
        Label {
            width: parent.width
            font.pixelSize: units.gu(3)
            font.bold: true
            color: theme.palette.normal.backgroundText
            horizontalAlignment: Text.AlignHCenter
            text: i18n.tr("Warnapp Deutschland")
        }
        Label {
            width: parent.width
            color: theme.palette.normal.backgroundTertiaryText
            horizontalAlignment: Text.AlignHCenter
            text: i18n.tr("Version %1").arg(Qt.application.version)
        }

    }

    UbuntuListView {
         anchors {
            top: aboutCloumn.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            topMargin: units.gu(2)
         }

         currentIndex: -1
		 clip:true
		
         model :infoModel
         delegate: ListItem {
            ListItemLayout {
			 Icon {
                 width:units.gu(2)
				 SlotsLayout.position: SlotsLayout.Leading;
                 name:model.icon
             }
             title.text : model.name
             Icon {
                 width:units.gu(2)
                 name:"go-to"
             }
            }
            onClicked: Qt.openUrlExternally(model.url)


         }

    }

}

/*
 * Copyright (C) 2021  Eran DarkEye Uzan
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * darkeye.ursses is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

