
import QtQuick 2.9
import Ubuntu.Components 1.3
import Ubuntu.Content 1.3

Page {
	id:_sharePage
	
	header: PageHeader {
        title: i18n.tr("Denken sie an ihre Mitmenschen, teilen sie wichtige Meldungen auch per SMS!")
	}
	
	property var items: []
	
	ContentPeerPicker {
		id: peerPicker
		handler: ContentHandler.Share
		visible: parent.visible
		contentType:ContentType.Links

		onPeerSelected: {
			var activeTransfer = peer.request()
			activeTransfer.items = _sharePage.items
			activeTransfer.state = ContentTransfer.Charged
			mainLayout.remove(_sharePage)
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

