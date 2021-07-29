import QtQuick 2.9
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Content 1.3

import "./UI"

Item {
    id: shareItem

    property var parentPage : null
    
    signal done()

    Component {
        id: sharePage
        SharePage {
            Component.onDestruction: shareItem.done()
        }
    }

    Component {
        id: contentItemComponent
        ContentItem {}
    }


    function shareLink(url) {
		var incubator = mainLayout.addPageToCurrentColumn(parentPage, sharePage)
			if (incubator && incubator.status == Component.Loading) {
			incubator.onStatusChanged = function(status) {
				if (status == Component.Ready) {
					incubator.object.items.push(contentItemComponent.createObject(shareItem, {"url" : url}))
				}
			}
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


