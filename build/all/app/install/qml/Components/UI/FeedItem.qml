
import QtQuick 2.9
import Ubuntu.Components 1.3
import QtQuick.Controls 2.2 as QControls

ListItem {
	height:__listItemLayout.height + units.gu(1)
	ListItemLayout {
		id:__listItemLayout
		title.text:titleText
		title.wrapMode:Text.WordWrap
		title.textFormat:Text.RichText
		subtitle.text:{return (new Date(updated)).toDateString()}
		summary.text:description.replace(/<[^>]+>/g,'')
		summary.textFormat:Text.PlainText
		summary.wrapMode:Text.WordWrap
		Image {
			height:units.gu(3)
			width:height
			cache:true
			sourceSize.width:width
			SlotsLayout.position: SlotsLayout.Trailing;
			source:imageUrl ? imageUrl : (chImageUrl ? chImageUrl : "" )
			asynchronous:true
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

