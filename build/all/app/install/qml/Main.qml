
import QtQuick 2.9
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import QtQuick.Controls 2.2 as QControls
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import Ubuntu.Content 1.3
import QtWebEngine 1.7

import "Components/UI"
import "Components"
import "Pages"
import "helpers"
import "Jslibs/rssAPI.js" as RssAPI
import "Jslibs/searchFeeds.js" as GetHelper
import Ubuntu.PushNotifications 0.1

MainView {
    Component {
         id: dialog
         Dialog {
             id: dialogue
             title: "Bitte bachten!"
             text: "Leider sind die Push Meldungen in dieser App Version noch in einem sehr frühen Stadium. Um zu erfahren wie sie mit dieser App am besten und schnellsten informiert werden können, lesen Sie sich bitte die erste Anleitung unten durch. Wenn sie keine Push Benachrichtigungen erhalten wollen, können Sie diese in den Systemeinstellungen unter Benachrichtigungen für diese App ausschalten."
             Button {
                 text: "Anleitung (online)"
                 color: UbuntuColors.green
                 onClicked: Qt.openUrlExternally("https://infoportal.ddns.net/entwickler/hinweis.html")
             }
             Button {
                 text: "Warnapp testen (online)"
                 onClicked: Qt.openUrlExternally("https://infoportal.ddns.net/entwickler/test.html")
             }
             Button {
                 text: "Dialog Schließen"
                 color: UbuntuColors.orange
                 onClicked: PopupUtils.close(dialogue)
             }
         }
    }

    //warn
    id: root
    objectName: 'mainView'
    applicationName: 's60w79.warnapp-deutschland'
    automaticOrientation: true
	anchorToKeyboard: true
    width: units.gu(45)
    height: units.gu(75)
	
	theme.name: ""
    backgroundColor: theme.palette.normal.background
	property var urls :  [];
	property alias mainBillboard: mainEventBillboard
	property var token : [];
    property var oldfeed : [];
    property var newfeed : [];
    property alias pushtoken : root.token
    property alias oldfeed: root.oldfeed
	onUrlsChanged : {
		console.log("onUrlsChanged")
		mainFeed.updateFeed();
		//appSettings.sync();
	}
	
	Settings {
		id:appSettings
		property bool showDescInsteadOfWebPage: true
		property bool showSections: false
		property string mainFeedSectionField : "channel"
		property alias urls: root.urls
		property var bookedmarked : []
		property int itemsToLoadPerChannel : 42
		property int mainFeedSortAsc :Qt.DescendingOrder
		property string mainFeedSortField : "updated"
		property real webBrowserDefaultZoom : 1.0
		property int updateFeedEveryXMinutes : 3
		property bool openFeedsExternally: false
		property bool swipeBetweenEntries: true
		//be crefull the following name is lying and stands for the feeds for which an alert already came.
		property var nextCloudCreds :[]
		
	}
	
	FeedCache {
		id:feedCacheDB
	}
	
	WebEngineProfile {
			id:webProfileInstace
			persistentCookiesPolicy: WebEngineProfile.AllowPersistentCookies
			storageName: "warnapp-deutschland"
			httpCacheType: WebEngineProfile.DiskHttpCache
	}
		
	EventBillboard {
		id:mainEventBillboard
		onBookmarkFeed :{
			appSettings.bookedmarked.push(feed);
			appSettings.bookedmarked = appSettings.bookedmarked;
			NextcloudAPI.bookmarkFeed(feed.url)
		}
		onRemoveFeed:{
			for(var index=0; index< root.urls.length;index++) {
				if(feedUrl == root.urls[index]) {
					root.urls.splice(index,1);
					break;
				}
			}
			root.urls = root.urls;
		}
		onAddFeed: {
			root.urls.push( feedUrl );
			root.urls = root.urls;
		}
	}
	// ---------------------------- UI ----------------------
	
	AdaptivePageLayout {
        Component.onCompleted:PopupUtils.open(dialog)
		id:mainLayout
		anchors {
			fill:parent
		}
		asynchronous: true
		primaryPage : MainFeedPage {
			id:mainFeed
				model: root.urls
				header: PageHeaderWithBottomText {
					id: header
					title: i18n.tr('Warnapp Deutschland')
					leadingActionBar {
						actions : [
							Action {
								text : i18n.tr("Warnapp Deutschland")
								iconSource : Qt.resolvedUrl("../assets/logo.svg")
								onTriggered : {
									mainLayout.addPageToNextColumn(mainLayout.primaryPage, Qt.resolvedUrl("Pages/Information.qml"),{})
								}
							}
						]
					}
					trailingActionBar  { 
						numberOfSlots: 3
						actions : [
							Action {
								text : i18n.tr("Gebiet hinzufügen")
								iconName : "list-add"
								onTriggered : {
									mainLayout.addPageToNextColumn(mainLayout.primaryPage, Qt.resolvedUrl("Pages/AddRssPage.qml"),{})
								}
							},
							Action {
								text : i18n.tr("Einstellungen")
								iconName : "settings"
								onTriggered : {
									mainLayout.addPageToCurrentColumn(mainLayout.primaryPage, Qt.resolvedUrl("Pages/SettingsPage.qml"),{})
								}
							},
							Action {
								property bool isAscending : appSettings.mainFeedSortAsc == Qt.AscendingOrder;
								text : i18n.tr("Toggle Sort (%1) ").arg(isAscending ? i18n.tr("Ascending") : i18n.tr("Descending") )
								iconName : isAscending ? "up" : "down"
								onTriggered : {
									appSettings.mainFeedSortAsc = isAscending ?
																	Qt.DescendingOrder :
																	Qt.AscendingOrder;
								}
							}
						]
					}
				}
		}
	}
	
	// =============== Sync Next Cloud Feeds ===============
	//function syncNextCloud() {
		//NextcloudAPI.getFeeds(appSettings.nextCloudCreds,function(feedsResult) {
			//if(feedsResult && feedsResult.feeds) {
				//var nextCloudFeeds = [];
				//for(var i in feedsResult.feeds) {
					//if( feedsResult.feeds[i] && appSettings.urls.indexOf(feedsResult.feeds[i].url) < 0)
						//appSettings.urls.push(feedsResult.feeds[i].url);
						//nextCloudFeeds.push(feedsResult.feeds[i].url);
				//}
			//}
		//});
	//}
	
	//Connections {
		////TODO : implement this, for some reason the add remove API fails with InternalError from the server...
		//target:mainEventBillboard
		//enabled:NextcloudAPI.isCredentialValid(appSettings.nextCloudCreds);
		//onRemoveFeed : {
			//console.log("Nextcloud remove feed for : "+ JSON.stringify(feed));
			////NextcloudAPI.readFeed(appSettings.nextCloudCreds, feed.url);
		//}
		//onAddFeed : {
			//console.log("Nextcloud add feed for : "+ JSON.stringify(feedUrl));
			////NextcloudAPI.addFeed(appSettings.nextCloudCreds, feedUrl);
		//}
	//}
	
	//Timer {
		//id:syncNextCloudTimer
		//running: appSettings.nextCloudCreds.accountId !== undefined && appSettings.nextCloudCreds.encodedCreds !== undefined &&
				 //appSettings.nextCloudCreds.accountId && appSettings.nextCloudCreds.encodedCreds
		//interval: 30 * 60000
		//triggeredOnStart: true
		//repeat: true
		//onTriggered: syncNextCloud();
	//}
	PushClient {
        id: pushClient
        appId: "s60w79.warnapp-deutschland_s60w79.warnapp-deutschland"
        onTokenChanged: messenger(pushClient.token);
        
    }
	
	//==================================  Sharing is caring ===========================
	property var urlMapping: {
		"^https?://" : function(url) {
			//if(pageStack && pageStack.currentPage && pageStack.currentPage.folderModel) {
				//pageStack.currentPage.folderModel.goTo(url);
			//}
			console.log("handling http:// for:"+url);
			for(var i in root.urls) {
				if(url == root.urls[i]) {
					console.log(""+url+ " Existiert bereits");
					return;
				}
			}
			root.urls[""+Object.keys(appSettings.urls).length] = url;
			header.message.text = i18n.tr("Gebiet hinzugefügt: %1").arg(url);
			mainFeed.updateFeed()
		}
	}

	DispatcherHandler {
			id:dispatcherHandler
	}

	Component.onCompleted:  {
        
		if(args) {
			console.log("onCompleted args:" + JSON.stringify(args));
			dispatcherHandler.handleOnCompleted(args);
		}
	}
	
	
	Connections {
		target: ContentHub
		
		onShareRequested: {
			if ( transfer.contentType == ContentType.Links ) {
					for ( var i = 0; i < transfer.items.length; i++ ) {
					if (String(transfer.items[i].url).length > 0 ) {
						var url = transfer.items[i].url;
						for(var i in root.urls) {
						if(url == root.urls[i]) {
								console.log(""+url+ " Existiert bereits");
								return;
							}
						}
						root.urls[""+Object.keys(appSettings.urls).length] = url;
						header.message.text = i18n.tr("Gebiet hinzu gefügt : %1").arg(url);
						console.log("Gebiet hinzugefügt : " + url);
						mainFeed.updateFeed()
					}
				}
			}
		}
		onImportRequested: {
			console.log("Get Uknown import type with the following items :");
			for ( var i = 0; i < transfer.items.length; i++ ) {
				if ( transfer.items[i]  ) {
					console.log(JSON.stringify(transfer.items[i]));
				}
			}
		}
	}
	
	function messenger(token){
        console.log("ready for push!", token)
        //RssAPI.initpush(token, function(){});
        root.token = token;
        if(oldfeed == null || oldfeed == undefined){
            root.oldfeed = [];
        }
        //root.oldfeed = appSettings.nextCloudCreds
        root.oldfeed = [];
        //abo all chanels on the push servers.
            for(var i in root.urls) {
            //go throw all RSS urls
            //RssAPI have to do that, because the QML pages are confined by the apparmor
            GetHelper.register(root.urls[i], root.token, function(){});
        }
        
        
    }
}


/*
 * Copyright (C) 2021  S60W79 and Eran DarkEye Uzan
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * s60w79.warnapp-deutschland is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
