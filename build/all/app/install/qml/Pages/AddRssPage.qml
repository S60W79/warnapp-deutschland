
import QtQuick 2.9
import Ubuntu.Components 1.3
import QtQuick.Controls 2.2 as QControls

import "../Components"
import "../Jslibs/searchFeeds.js" as SearchFeeds

Page {
	id:_addrsspage
	
	property bool searching: false
	
	header: PageHeader {
		id:pageHeader
		title:i18n.tr("Neues Gebiet hinzufügen")
	}
	Row {
		id:searchRow
		anchors {
			top:pageHeader.bottom
			left:parent.left
			right:parent.right
			margins:units.gu(0.5)
		}
		
		spacing:units.gu(0.2)
		
		TextField {
			id:searchText
			property bool isLegitimate : true
			property bool isURL : false
			width: searchRow.width - searchBtn.width
			placeholderText: i18n.tr("Geben sie den Namen eines Landkreises ein")
			onAccepted: {
				if(isLegitimate) {
					addOrSearchFromText();
				}
			}
		}
		Button {
			id:searchBtn
			width:units.gu(5)
			enabled:searchText.isLegitimate
			text : searchText.isURL ? i18n.tr("Gebiet hinzufügen") : i18n.tr("Suchen")
			iconName:  searchText.isURL? "list-add" : "search"
			onClicked : addOrSearchFromText();
		}
	}
	UbuntuListView {
		id:searchResults
		anchors {
			top:searchRow.bottom
			left:parent.left
			right:parent.right
			bottom:parent.bottom
		}
		pullToRefresh {
			enabled:_addrsspage.searching
			refreshing: _addrsspage.searching
		}
		model:[]
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
			onClicked:{
				root.mainBillboard.addFeed(modelData.url);

				mainLayout.removePages(_addrsspage);
			}
		}
	}
	
	// =========================================== Functions ==================================
	function addOrSearchFromText() {
		if(searchText.isURL) {
			root.mainBillboard.addFeed(searchText.text);

			mainLayout.removePages(_addrsspage);
		} else {
	_addrsspage.searching = true;
			SearchFeeds.searchDomain(searchText.text, function(feeds){
				_addrsspage.searching = false;
				var availableFeeds = [];
				//console.log(JSON.stringify(feeds));
				for( var i in feeds ) {
					availableFeeds.push({
						"title" : feeds[i]['title'],
						"description" : feeds[i]['description'],
						"url" : feeds[i]['url'],
						"image" : feeds[i]['favicon']
					});
				}
				searchResults.model = availableFeeds;
			});
		}
	}
}


/*
 * Copyright (C) 2021 S60W79 and Eran DarkEye Uzan
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

