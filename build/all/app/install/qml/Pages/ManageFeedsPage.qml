
import QtQuick 2.9
import Ubuntu.Components 1.3
import QtQuick.Controls 2.2 as QControls

import "../Components"
import "../Jslibs/searchFeeds.js" as SearchFeeds

Page {
    Timer{
        interval: 1001; running: true; repeat: true
        onTriggered: showareas(root.urls);
    }
	id:_manageFeed
	clip:true
	header: PageHeader {
		id:header
		title:i18n.tr("Meine Gebiete...")
		trailingActionBar  { 
						numberOfSlots: 3
						actions : [
							Action {
								text : i18n.tr("Gebiet hinzufügen")
								iconName : "list-add"
                                	
								onTriggered : {
									mainLayout.addPageToNextColumn(_manageFeed, Qt.resolvedUrl("AddRssPage.qml"),{})
                                    
								}
								
							}
						]
		}
		
	}
	
	UbuntuListView {
        Component.onCompleted:{
            showareas(root.urls);
    }
		id:_feedsList
		anchors {
			top:header.bottom
			left:parent.left
			right:parent.right
			bottom:parent.bottom
		}
		model:root.urls
		delegate: ListItem {
            height:units.gu(10)
			ListItemLayout {
				title.text:modelData.title
				summary.text:modelData.description
				Image {
					height:units.gu(3)
					width:height
					cache:true
					sourceSize.width:width
					SlotsLayout.position: SlotsLayout.Trailing;
					source:modelData.image
					asynchronous:true
				}
			}
			leadingActions : ListItemActions{ 
				actions : Action {
					name: "Delete"
					text: i18n.tr("Entfernen")
					iconName:'delete'
					onTriggered: {
						root.mainBillboard.removeFeed(modelData.url);
                        showareas(root.urls);
					}
				}
			}
		}
	}
	    
	
	
	/*Functions*/
    
    	function showareas(rsses) {
    SearchFeeds.rss2name(rsses, function(feeds){
				var availableFeeds = [];
				
				for( var i in feeds ) {
					availableFeeds.push({
						"title" : feeds[i]['title'],
						"description" : feeds[i]['description'],
						"url" : feeds[i]['url'],
						"image" : feeds[i]['favicon']
					});
				}
				//console.log(availableFeeds[0]["title"]);
				_feedsList.model = availableFeeds;
			});
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

