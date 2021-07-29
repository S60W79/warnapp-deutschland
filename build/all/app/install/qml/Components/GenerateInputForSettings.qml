
import QtQuick 2.9
import Ubuntu.Components 1.3
import QtQuick.Controls 2.2 as QControls

Column {
	id:_inputColumn
	clip:true
	property var inputsObject: null
	property var inputsObjectValues: null
	
	property var propertiesToIgnore : ["objectName","fileName","category","mainFeedSortAsc"];
	property var fieldsSelection : {}
	property var presentableNames : {}
	
	onInputsObjectChanged : {
		//remove all current childrens
		for(var i = _inputColumn.children.length; i > 0 ; i--) {
			_inputColumn.children[i-1].destroy()
		}
		
		//generate inputs
		for(var i in inputsObject) {
			if(propertiesToIgnore.indexOf(i) > -1) { continue; }
			//console.log(i,inputsObject[i],typeof(inputsObject[i]));
			var defaultProps = {
				"title.text": presentableNames[i] ? presentableNames[i]['title'] : i.toString(),
				"summary.text": presentableNames[i] ? presentableNames[i]['description'] : "",
				"value":inputsObject[i],
				"callback" : (function(propId){ return function(val) { _inputColumn.inputsObject[propId] = val;}; })(i)
			};
			if(fieldsSelection[i]) {
				defaultProps['possibleValues'] = fieldsSelection[i];
				selectValueInputComponent.createObject(_inputColumn,defaultProps);
				continue;
			}
			switch(typeof(inputsObject[i])) {
				case 'number' : 
					numberInputComponent.createObject(_inputColumn,defaultProps);
					break;
				case 'string' : 
					stringInputComponent.createObject(_inputColumn,defaultProps);
					break;
				case 'boolean' : 
					booleanInputComponent.createObject(_inputColumn,defaultProps);
					break;
			}
			
		}
	}
	
	//-------------------------------- Components ------------------------------------
	
	Component {
		id:numberInputComponent
		ListItemLayout {
			id: numberInput
			property var value: 0
			property var callback: null
			title.text: i18n.tr("Number") 

			TextField {
				SlotsLayout.position: SlotsLayout.Trailing
				width: units.gu(15)
				inputMethodHints:Qt.ImhFormattedNumbersOnly
				text: numberInput.value
				onTextChanged: {
					if(callback) {
						callback(parseFloat(text));
					}
				}
			}
		}
	}
	
	Component {
		id:stringInputComponent
		ListItemLayout {
			id: stringInput
			property string value: ""
			property var callback: null
			title.text: i18n.tr("String")

			TextField {
				SlotsLayout.position: SlotsLayout.Trailing
				width: units.gu(15)
				text:stringInput.value
				onTextChanged: {
					if(callback) {
						callback(text);
					}
				}
			}
		}
	}
	
	Component {
		id:booleanInputComponent
		ListItemLayout {
			id: booleanInput
			property bool value: false
			property var callback: null
			title.text: i18n.tr("Boolen")

			CheckBox {
				SlotsLayout.position: SlotsLayout.Trailing
				width: units.gu(5)
				checked: booleanInput.value
				onCheckedChanged: {
					if(callback) {
						callback(checked);
					}
				}
			}
		}
	}
	
	Component {
		id:selectValueInputComponent
		ListItemLayout {
			id: selectValueInput
			property alias value: _comboBtn.text
			property alias possibleValues: _valueList.model
			property var callback: null
			title.text: i18n.tr("Select Value")

			ComboButton {
				id:_comboBtn
				SlotsLayout.position: SlotsLayout.Trailing
				text: ""
				width: units.gu(15)
				ListView {
					id:_valueList
					model:[]
					delegate: ListItem {
						height: units.gu(5)
						ListItemLayout {
							title.text:modelData
						}
						onClicked: {
							callback(modelData);
							_comboBtn.expanded = false;
							_comboBtn.text = modelData;
						}
					}
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


