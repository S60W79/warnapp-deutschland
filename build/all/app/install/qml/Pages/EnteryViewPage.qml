import QtQuick 2.9
import Ubuntu.Components 1.3
import QtQuick.Controls 2.2 as QControls
import QtWebEngine 1.7
import Ubuntu.Content 1.3

import "../Components"

Page {
	id:_mainFeedEntryView
	
	clip:true
	
	property var model: {}
	property bool descOrWeb : appSettings.showDescInsteadOfWebPage
	property bool showDescInsteadOfWebPage : descOrWeb || !model.url
	
	header: PageHeader {
		id:header
		title: model.titleText
		subtitle: model.channel

		trailingActionBar {
			actions: [
				Action {
					iconName: "next"
					name:"next-sotry"
					text: i18n.tr("Nächste Meldung")
					visible:!appSettings.swipeBetweenEntries
					onTriggered: {
						mainEventBillboard.triggerNextStory(_mainFeedEntryView.descOrWeb);
					}
				},
				Action {
					iconName: "back"
					name:"back-sotry"
					text: i18n.tr("Vorherige Meldung")
					visible:!appSettings.swipeBetweenEntries
					onTriggered: {
						mainEventBillboard.triggerPreviousStory(_mainFeedEntryView.descOrWeb);
					}
				},
				Action {
					iconName: "external-link"
					name:"open_in_borwser"
					visible:model.url
					text: i18n.tr("Im Browser öffnen")
					onTriggered: {
						Qt.openUrlExternally(model.url)
					}
				},
				Action {
					name: "toggle_web"
					text: checked ? i18n.tr("Web Inhalt Zeigen") : i18n.tr("Inhalt zeigen")
					enabled: model.url
					checkable: true
					checked:_mainFeedEntryView.showDescInsteadOfWebPage
					iconName: checked ? 'stock_website' : 'stock_document'
					onTriggered: {
						_mainFeedEntryView.descOrWeb = checked;
					}
				},
				Action {
					iconName: enabled ? "non-starred" :  "starred";
					name: "bookmark"
					text: i18n.tr("Meldung speichern")
					enabled : !_mainFeedEntryView.isBookMarked(model.url)
					onTriggered: {
						mainEventBillboard.triggerBookmarkFeed(model);
					}
				},
				Action {
					name:"share"
					text:i18n.tr("Teilen")
					iconName:'share'
					onTriggered: {
						shareItem.shareLink(model.url);
					}
				}
			]
		}
	}
	
	opacity: !swipeArea.pressed ? 1 :  1 - Math.abs(swipeArea.distance) / width

	SwipeArea {
		id:swipeArea
		z:1
		anchors.fill:parent
		enabled:appSettings.swipeBetweenEntries
		direction:SwipeArea.Horizontal
		grabGesture:false
		onDraggingChanged:if(Math.abs(distance) > width/3 ) {
			 if(distance < 0) mainEventBillboard.nextStory(_mainFeedEntryView.descOrWeb);
			 else mainEventBillboard.previousStory(_mainFeedEntryView.descOrWeb);
			 wrapperFlickable.contentX = -swipeArea.distance * 3;
		}
		onPressedChanged: if(!pressed && webViewBottomEdge.status !== BottomEdge.Hidden) {
			webViewBottomEdge.collapse();
		}
	}
	
	Timer {
		id:readTimer
		running:true
		interval:5000
		onTriggered:{
			mainEventBillboard.triggerReadFeed(model);
		}
	}
	
	ShareItem {
		id:shareItem
		parentPage:_mainFeedEntryView
	}
	Flickable {
		id:wrapperFlickable
			anchors {
			top:header.bottom
			left:parent.left
			right:parent.right
			bottom:parent.bottom
			margins: units.gu(showDescInsteadOfWebPage ? 2 : 0)
		}
		interactive:false
		
		Behavior on contentX { UbuntuNumberAnimation { duration:UbuntuAnimation.BriskDuration}}
		contentX : swipeArea.pressed && (Math.abs(swipeArea.distance) > swipeArea.width/4 ) ? -swipeArea.distance : 0
		
		Flickable {
			id:longDescFlick
			anchors {
				fill:parent
			}

			visible: showDescInsteadOfWebPage
			clip:true
			interactive:true
			flickableDirection:Flickable.VerticalFlick
			contentHeight: longDesc.height;

			Text {
				id:longDesc
				anchors {
					top:parent.top
					left:parent.left
					right:parent.right
				}
				//height:units.gu(150)
				text: model.content ? model.content : model.description.replace(/(<\s*img[^>]*>\s*)([^<])/,"$1<br/>$2")
				textFormat:Text.RichText
				wrapMode:Text.Wrap 
				color:theme.palette.normal.foregroundText
				onLinkActivated: {
					Qt.openUrlExternally(link.replace(/^(?!https?:\/\/)/,"https://"));
				}
			}
		}
		
		//When we  display the associated url site display it on  awebView
		WebEngineView {
			id: webView
			visible: !showDescInsteadOfWebPage
			anchors.fill:parent
			profile: webProfileInstace
			url: model.url ? model.url : ""
			zoomFactor:appSettings.webBrowserDefaultZoom
			
			onFullScreenRequested: function(request) {
				request.accept()
			}
			
			// Open external URL's in the browser and not in the app
			onNavigationRequested: {
// 				if(request.navigationType == 1) {
// 					request.action = 1
// 					Qt.openUrlExternally( request.url )
// 				}
			}
		}
		BottomEdge {
			id:webViewBottomEdge
			height:units.gu(7)
// 			hint.status: BottomEdgeHint.Active
			hint.text: i18n.tr("Web Config")
			contentComponent : Row {

				spacing:units.gu(1)
				Button {
					styleName: "IconButtonStyle"
					iconName:"down"
					width:units.gu(4)
					onClicked: {
						webViewBottomEdge.collapse();
					}
				}
				Column {
					height: webViewBottomEdge.height
					Label {
						anchors.horizontalCenter:parent.horizontalCenter
						text:i18n.tr("Zoom")
						verticalAlignment:Text.AlignVCenter
					}
					Slider {
						visible:hint.status ==  BottomEdgeHint.Active
						enabled:visible
						value:appSettings.webBrowserDefaultZoom
						minimumValue:0.5
						maximumValue: 3
						onValueChanged: {
							webView.zoomFactor = value;
						}
						function formatValue(v) { return Math.round(v*10,2)/10;}
					}
				}
			}
		}
	}
	
	// ============================================ Functions ========================================
	function isBookMarked(url) {
		for(var i in appSettings.bookedmarked) {
			if(appSettings.bookedmarked[i] && appSettings.bookedmarked[i].url == url) {
				return true;
			}
		}
		return false;
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

