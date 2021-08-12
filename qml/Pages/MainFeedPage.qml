
import QtQuick 2.9
import Ubuntu.Components 1.3
import QtQuick.Controls 2.2 as QControls
import QtQuick.XmlListModel 2.0
import QtQml.Models 2.2

import "../Components"
import "../Components/UI"
import "../Jslibs/rssAPI.js" as RssAPI
import "../Jslibs/searchFeeds.js" as GetHelper


Page {
	id:_mainFeed
	
	clip:true
	
	property var model : []
	property var oldmodel : []
	property var lastRefresh: 0;
	property var refreshing:  false;
	
	
	header: PageHeader {
		id:header
	}
	
	Component.onCompleted : {
		_mainFeed.updateFeed();
        
	}
	
	Component {
		id:channelComponent
		RssChannel {
			id:_channelComponentObj
			onStatusChanged: if(feedCacheDB) {
				if(status == XmlListModel.Error) {
					//change xml to cached xml
					var cachedXML = feedCacheDB.getDoc(source);
					if(cachedXML) {
						//console.log(JSON.stringify(cachedXML));
						_channelComponentObj.xml = cachedXML;
					}
				} else if(status == XmlListModel.Ready && _channelComponentObj.xml ) {
					//TODO save updated data to cache
					feedCacheDB.putDoc(source.toString(), _channelComponentObj.xml );
				}
				//console.log(_channelComponentObj)
			}
		}
	}
	
	Component {
		id:channelItemsComponent
		RssChannelItems {
			id:channelItemsComponentObj
			onStatusChanged: if(feedCacheDB) {
				if(status == XmlListModel.Error) {
					//change xml to cached xml
					var cachedXML = feedCacheDB.getDoc(source);
					if(cachedXML) {
						//console.log(JSON.stringify(cachedXML));
						channelItemsComponentObj.xml = cachedXML;
					}
				} else if(status == XmlListModel.Ready && channelItemsComponentObj.xml) {
					//TODO save updated data to cache
					feedCacheDB.putDoc(source.toString(), channelItemsComponentObj.xml );
				}
			}
		}
	}

	
	function loadChannelItems(channelData) {
		var channelItems = channelItemsComponent.createObject(null,{});
		if(channelData['isAtom']) {
			channelItems.namespaceDeclarations = "declare default element namespace 'http://www.w3.org/2005/Atom';";
		}
		
		channelItems.statusChanged.connect(function() {
            
			if (channelItems.status == XmlListModel.Ready) {
				var channelDomain = (""+channelData["feedUrl"]).match(/https?:\/\/([^\/]+)/).pop();
				for(var i=0; i < channelItems.count && i < appSettings.itemsToLoadPerChannel; i++) {
					var item = channelItems.get(i);
					//console.log("channel items :" + JSON.stringify(item));
					item["chImageUrl"] = channelData["imageUrl"];
					item['domain'] = channelDomain
					item["channel"] = channelData["titleText"] ? channelData["titleText"] : channelDomain ;
					try {
						//If no date then try and  get the date from the title
						if(!item["updated"]) {
							item["updated"] = Date.parse(
								item["title"].match(/(\d{4}[\-./]\d\d[\-./]\d\d|\d\d[\-./]\d\d[\-./]\d{4})/) ? 
									item["title"].match(/(\d{4}[\-./]\d\d[\-./]\d\d|\d\d[\-./]\d\d[\-./]\d{4})/).pop() :
									item["description"].match(/(\d{4}[\-./]\d\d[\-./]\d\d|\d\d[\-./]\d\d[\-./]\d{4})/).pop()
							);
						}
					} catch(e) {/*If we can't get a date we cant get a date...*/}
					item["updateDate"] = (new Date(Date.parse(item["updated"]))).toDateString();
					item["itemData"] =  JSON.parse(JSON.stringify(item));
					feedList.model.append(item);
                    
                    //push message section:
                    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                    //direct push push now disabled!
//                     if(root.oldfeed.includes(item["updateDate"]+item["titleText"])){}else{
//                         //that's a new message /es gibt was neues!
//                         //=>warnen
//                         var today1 = new Date();
//                         if(today1.toDateString() == item["updateDate"]){
//                             //warne, da das ereignis von heute ist
//                             //warn for every message, emmited today
//                             RssAPI.warnPop(root.token, item["titleText"], function(){});
//                         }else{
//                             console.log("nichts...")
//                         }
//                         //=> item is now 'old'
//                         root.oldfeed.push(item["updateDate"]+item["titleText"]);
//                         
//                     }
				}
				feedList.model.sort();
			}
		});
		channelItems.source = channelData["feedUrl"];
	}

	function updateFeed() {
		if( !_mainFeed.model || _mainFeed.model.length == 0  ||  Date.now() - _mainFeed.lastRefresh < 10000 &&  _mainFeed.refreshing ) {
			console.log(Date.now(),  _mainFeed.lastRefresh)
			return;
		}
		
		console.log("updating the feeds..");
		_mainFeed.lastRefresh = Date.now();
		_mainFeed.refreshing = true;
		feedList.model.clear();
		var channels = {}
		for(var i in _mainFeed.model) {
			channels[i] = channelComponent.createObject(null,{});
			(function(channel) {
			channel.statusChanged.connect(function()  { 
				try {
					if (channel.status == XmlListModel.Ready) {
						var channelData = channel.get(0);
						if(!channelData) {
							//Workaround for atom rss feeds
							channel.namespaceDeclarations = "declare default element namespace 'http://www.w3.org/2005/Atom';";
							channelData = {};
							channelData['isAtom'] = 1;
						}
						//console.log("channel :" + JSON.stringify(channelData));
						channelData['feedUrl'] = channel.source;
						loadChannelItems(channelData);
						_mainFeed.refreshing = false;
					} else if (channel.status == XmlListModel.Error){
						console.log("ERROR : Failed to load channel :" + JSON.stringify(channel));
					}
				} catch(e) {
					console.log("Failed to load channel :" + JSON.stringify(channel) + " got exception : " + e);
				}
				_mainFeed.refreshing = false;
			});
			channel.source = _mainFeed.model[i];
			})(channels[i]);
		}
	}
	
	Label {
		anchors { 
			verticalCenter:parent.verticalCenter
			left:parent.left
			right:parent.right
			margins:units.gu(2)
		}
		visible: feedList.model.count == 0 && !_mainFeed.refreshing
		text: _mainFeed.model.length > 0 ? i18n.tr("Meldungen werden geladen") :
											i18n.tr("Bisher sind keine Gebiete in der Benachrichtigungsliste. Tippen sie auf '+' um ein Landkreis oder eine Kreisfreie Stadt hinzu zu fügen.")
		wrapMode: Text.Wrap
		horizontalAlignment:Text.AlignHCenter
	}
	
	Feed {
		id:feedList
		
		anchors {
			topMargin:header.height
			fill:parent
		}

		model: FeedsModel {
				id:feedModel
		}

		pullToRefresh {
			enabled: true
			refreshing: _mainFeed.refreshing && feedList.model.count == 0;
			onRefresh: _mainFeed.updateFeed()
		}
		
		section.property :appSettings.showSections ?  appSettings.mainFeedSectionField : ""
        section.criteria: ViewSection.FullString
        section.labelPositioning: ViewSection.InlineLabels

        section.delegate: ListItem {
            height: sectionHeader.implicitHeight + units.gu(2)
            Label {
                id: sectionHeader
                text: section
                font.weight: Font.Bold
                anchors {
                    left: parent.left
                    leftMargin: units.gu(2)
                    verticalCenter: parent.verticalCenter
                }
            }
        }
		
		delegate: FeedItem {
			onClicked:{
				feedList.currentIndex = index;
				if(appSettings.openFeedsExternally && itemData.url) {
					Qt.openUrlExternally(itemData.url);
				} else {
					feedList.openEntryView({"model": itemData });
				}
			}
		}

		Timer {
			interval: appSettings.updateFeedEveryXMinutes*60000
			running: appSettings.updateFeedEveryXMinutes > 0
			repeat: true
			onTriggered: { 
				_mainFeed.updateFeed();
			}
		}
		
		//======== Feeds Functions ===========
		
		function openEntryView(pageData) {
			var incubator =mainLayout.addPageToNextColumn(	mainLayout.primaryPage, 
															Qt.resolvedUrl("EnteryViewPage.qml"),
															 pageData );
			incubator.onStatusChanged = function(status) {
				if (status == Component.Ready) {
				}
			}
		}
	}
	
	
	Connections {
		target:mainEventBillboard
		onNextStory: {
			console.log("Next story!",showDesc);
			feedList.currentIndex =  (feedList.currentIndex + 1) % feedList.count
			var item = feedList.model.get(feedList.currentIndex);
			feedList.openEntryView({"model": item,"descOrWeb":showDesc});
		}
		onPreviousStory: {
			console.log("Previous story!",showDesc);
			feedList.currentIndex =  (feedList.count + feedList.currentIndex - 1) % feedList.count
			var item = feedList.model.get(feedList.currentIndex);
			feedList.openEntryView({"model": item,"descOrWeb":showDesc});
		}
	}
	
	BottomEdge {
		 id:bookmarksBottomEdge
		 height: parent.height
		 hint.text:i18n.tr("Gespeicherte Meldungen")
		 hint.deactivateTimeout:5000
		 hint.status:BottomEdgeHint.Active
		 contentComponent:	ManageBookmarksPage {
			 id:bottomBookmarks
			 opacity: bookmarksBottomEdge.dragProgress
			 implicitHeight: bookmarksBottomEdge.height
			 implicitWidth: bookmarksBottomEdge.width
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

