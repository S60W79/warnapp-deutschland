
import QtQuick 2.9
import Ubuntu.Components 1.3
import QtQuick.Controls 2.2 as QControls

import "../Components"

Page {
	id:_bookmarksPage
// 	anchors.fill:parent

	property alias model : _bookmarksList.model

	clip:true
	
	header: PageHeader {
		id:header
		title:i18n.tr("Gespeicherte Meldungen")
	}
	
	Label {
		anchors.centerIn:parent
		visible: _bookmarksList.model.length == 0
		text:i18n.tr("Bisher wurden keine Meldungen gespeichert.")
	}
	
	ShareItem {
		id:shareItem
		parentPage:mainFeed
	}
	

	UbuntuListView {
		id:_bookmarksList
		anchors {
			top:header.bottom
			left:parent.left
			right:parent.right
			bottom:parent.bottom
		}
		model:  appSettings.bookedmarked
		delegate:  ListItem {
			height:units.gu(10)
			ListItemLayout {

				title.text : modelData.titleText
				subtitle.text : modelData.url
				summary.text : modelData.description
				summary.textFormat:Text.PlainText
				Icon {
					width:units.gu(3)
					height:width
					name:"go-next"
					SlotsLayout.position: SlotsLayout.Trailing;
				}
			}
			leadingActions : ListItemActions{ 
				actions : Action {
					name: i18n.tr("Löschen")
					iconName:'delete'
					onTriggered: {
						appSettings.bookedmarked.splice(index,1);
						appSettings.bookedmarked = appSettings.bookedmarked;
					}
				}
			}
			trailingActions : ListItemActions{ 
				actions : [
					Action {
						name: i18n.tr("Teilen")
						iconName:'share'
						onTriggered: {
							shareItem.shareLink(modelData.url);
							
						}
					},
					Action {
						name: i18n.tr("In externen Browser öffnen")
						iconName:'external-link'
						onTriggered: {
							Qt.openUrlExternally(modelData.url);
						}
					}
				]
			}
			onClicked: {
				mainLayout.addPageToNextColumn(	mainLayout.primaryPage, 
												Qt.resolvedUrl("EnteryViewPage.qml"),
												{"model": modelData} );
			}
		}
	}
}

/*
 * Copyright (C) 2021  S60W79 andEran DarkEye Uzan
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

