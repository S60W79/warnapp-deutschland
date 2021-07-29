import QtQuick 2.9
import Ubuntu.Components 1.3
import QtQuick.Controls 2.2 as QControls

import "../Components"
import "../Components/UI"

Page {
	id:_settingsPage
	
	header: PageHeaderWithBottomText {
		id:header
		title:i18n.tr("Einstellungen")
		trailingActionBar {
			actions: [
				Action {
					name : i18n.tr("Offizielle Warnseite")
					iconName : "external-link"
					onTriggered : {
						Qt.openUrlExternally("https://warnung.bund.de/meldungen")
					}
				},
				Action {
					name : i18n.tr("Gebiete")
					iconName : "view-list-symbolic"
					onTriggered : {
						mainLayout.addPageToNextColumn(_settingsPage, Qt.resolvedUrl("ManageFeedsPage.qml"),{})
					}
				},
				Action {
					name : i18n.tr("Über...")
					iconName : "info"
					onTriggered : {
						mainLayout.addPageToNextColumn(_settingsPage, Qt.resolvedUrl("Information.qml"),{})
					}
				}
			]
		}
	}
	Flickable {
		flickableDirection: Flickable.VerticalFlick
		clip:true
		anchors {
				top:header.bottom
				left:parent.left
				right:parent.right
				bottom:parent.bottom
			}
			contentHeight: settingsUI.height
			
		GenerateInputForSettings {
			id:settingsUI
			anchors {
				left:parent.left
				right:parent.right
			}
			inputsObject:appSettings
			
			fieldsSelection : {
				"mainFeedSortField" :  ["updated","channel","author","titleText"],
				"mainFeedSectionField" :  ["updateDate","channel","author"]
			}
			presentableNames : { return {
				showDescInsteadOfWebPage : {
					title: i18n.tr("Zusammenfassung der Meldung zuerst zeigen"),
					description :i18n.tr("Umschaltung zwischen dem Laden des Kurztextes und dem Laden der gesamten Seite")
				},
				showSections : {
					title : i18n.tr("Übersicht in Gebiete unterteilen"),
					description : i18n.tr("Gebiete werden in der Übersicht untergliedert und nicht zusammen angezeigt.")
				},
				itemsToLoadPerChannel : {
					title : i18n.tr("Maximale Meldungen pro Gebiet"),
					description : i18n.tr("Zur Übersicht auf der Huptseite. Achtung: nicht zu gering einstellen!")
				},
				mainFeedSortField : {
					title : i18n.tr("Sortieren nach..."),
					description : i18n.tr("Nach welcher eigenschaft soll sortiert werden?")
				},
				mainFeedSectionField : {
					title : i18n.tr("Name der Sortierung"),
					description : i18n.tr(" ")
				},
				webBrowserDefaultZoom : {
					title : i18n.tr("Standart Zoom des Webbrowsers"),
					description : i18n.tr("Stellt die Vergrößerung beim Laden der Detailseite der Meldung ein.")
				},
				updateFeedEveryXMinutes : {
					title : i18n.tr("Aktualisieren aller..."),
					description : i18n.tr("Aller wie viel Minuten soll nach neuen Meldungen gesucht werden?")
				},
				openFeedsExternally : {
					title : i18n.tr("Webseiten extern öffnen"),
					description : i18n.tr("Öffnet die Detail seite im Standart Browser und nicht um eingebetteten Browser.")
				},
				swipeBetweenEntries :  {
					title : i18n.tr("Weiterblettern aktivieren"),
					description : i18n.tr("Ermöglicht das 'Blättern' zwischen Meldungen.")
				}
			}; }
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

