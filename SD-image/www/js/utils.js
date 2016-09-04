/* Utility functions for Duet Web Control
 * 
 * written by Christian Hammacher (c) 2016
 * 
 * licensed under the terms of the GPL v2
 * see http://www.gnu.org/licenses/gpl-2.0.html
 */


/* Text formatting */

function formatSize(bytes) {
	if (settings.useKiB) {
		if (bytes > 1073741824) {	// GiB
			return (bytes / 1073741824).toFixed(1) + " GiB";
		}
		if (bytes > 1048576) {		// MiB
			return (bytes / 1048576).toFixed(1) + " MiB";
		}
		if (bytes > 1024) {			// KiB
			return (bytes / 1024).toFixed(1) + " KiB";
		}
	} else {
		if (bytes > 1000000000) {	// GB
			return (bytes / 1000000000).toFixed(1) + " GB";
		}
		if (bytes > 1000000) {		// MB
			return (bytes / 1000000).toFixed(1) + " MB";
		}
		if (bytes > 1000) {			// KB
			return (bytes / 1000).toFixed(1) + " KB";
		}
	}
	return bytes + " B";
}

function formatTime(value) {
	value = Math.round(value);
	if (value < 0) {
		value = 0;
	}

	var timeLeft = [], temp;
	if (value >= 3600) {
		temp = Math.floor(value / 3600);
		if (temp > 0) {
			timeLeft.push(temp + "h");
			value = value % 3600;
		}
	}
	if (value >= 60) {
		temp = Math.floor(value / 60);
		if (temp > 0) {
			timeLeft.push((temp > 9 ? temp : "0" + temp) + "m");
			value = value % 60;
		}
	}
	value = value.toFixed(0);
	timeLeft.push((value > 9 ? value : "0" + value) + "s");

	return timeLeft.reduce(function(a, b) { return a + " " + b; });
}


/* Tool mapping */

function setToolMapping(mapping) {
	// Don't compare raw objects here as this would always evaluate as false
	if (JSON.stringify(toolMapping) != JSON.stringify(mapping)) {
		toolMapping = mapping;

		// Clean up current tools
		$("#page_tools").children(":not(:first-child)").remove();

		// Create new panels for each tool
		if (toolMapping != undefined) {
			for(var i=0; i<toolMapping.length; i++) {
				var number = toolMapping[i].hasOwnProperty("number") ? toolMapping[i].number : (i + 1);

				var heaters;
				if (toolMapping[i].heaters.length == 0) {
					heaters = T("none");
				} else {
					heaters = toolMapping[i].heaters.reduce(function(a, b) { return a + ", " + b; });
				}

				var drives;
				if (toolMapping[i].drives.length == 0) {
					drives = T("none");
				} else {
					drives = toolMapping[i].drives.reduce(function(a, b) { return a + ", " + b; });
				}

				var div =	'<div class="col-xs-6 col-sm-6 col-md-3 col-lg-3"><div class="panel panel-default">';
				div +=		'<div class="panel-heading"><span>' + T("Tool {0}", number) + '</span></div>';
				div +=		'<div data-tool="' + number + '" class="panel-body">';
				div +=		'<dl><dt>' + T("Heaters:") + '</dt><dd>' + heaters + '</dd>';
				div +=		'<dt>' + T("Drives:") + '</dt><dd>' + drives + '</dd>';
				div +=		'</dl><div class="row"><div class="col-md-12 text-center">';
				if (lastStatusResponse != undefined && lastStatusResponse.currentTool == number) {
					div +=		'<button class="btn btn-success btn-select-tool" title="' + T("Deselect this tool") + '">';
					div +=		'<span class="glyphicon glyphicon-remove"></span> <span>' + T("Deselect") + '</span></button>';
				} else {
					div +=		'<button class="btn btn-success btn-select-tool" title="' + T("Select this tool") + '">';
					div +=		'<span class="glyphicon glyphicon-pencil"></span> <span>' + T("Select") + '</span></button>';
				}
				div +=		' <button class="btn btn-danger btn-remove-tool" title="' + T("Remove this tool") + '">';
				div +=		'<span class="glyphicon glyphicon-trash"></span> ' + T("Remove") + '</button>';
				div +=		'</div></div></div></div></div>';
				$("#page_tools").append(div);
			}
		}

		// Keep the GUI updated
		validateAddTool();
	}
}

function getTool(number) {
	if (toolMapping == undefined) {
		return undefined;
	}

	for(var i = 0; i < toolMapping.length; i++) {
		if (toolMapping[i].hasOwnProperty("number")) {
			if (toolMapping[i].number == number) {
				return toolMapping[i];
			}
		} else if (i + 1 == number) {
			return toolMapping[i];
		}
	}
	return undefined;
}

function getToolsByHeater(heater) {
	if (toolMapping == undefined) {
		return [];
	}

	var result = [];
	for(var i = 0; i < toolMapping.length; i++) {
		for(var k = 0; k < toolMapping[i].heaters.length; k++) {
			if (toolMapping[i].heaters[k] == heater) {
				if (toolMapping[i].hasOwnProperty("number")) {
					result.push(toolMapping[i].number);
				} else {
					result.push(i + 1);
				}
			}
		}
	}
	return result;
}


/* Control state management */

function enableControls() {
	$("nav input, #div_heaters input, #main_content input").prop("disabled", false);			// Generic inputs
	$("#page_tools label").removeClass("disabled");												// and on Settings page
	$("#btn_fw_diagnostics").removeClass("disabled");

	$(".btn-emergency-stop, .gcode-input button[type=submit], .gcode").removeClass("disabled");	// Navbar
	$(".bed-temp, .gcode, .heater-temp, .btn-upload").removeClass("disabled");					// List items and Upload buttons

	$("#mobile_home_buttons button, #btn_homeall, #table_move_head a").removeClass("disabled");	// Move buttons
	$("#panel_extrude label.btn, #panel_extrude button").removeClass("disabled");				// Extruder Control
	$("#panel_control_misc label.btn").removeClass("disabled");									// ATX Power
	$("#slider_fan_control").slider("enable");													// Fan Control

	$("#page_print .checkbox").removeClass("disabled");											// Print Control
	$("#slider_fan_print").slider("enable");													// Fan Control
	$("#slider_speed").slider("enable");														// Speed Factor
	for(var extr = 1; extr <= maxExtruders; extr++) {
		$("#slider_extr_" + extr).slider("enable");												// Extrusion Factors
	}

	$(".online-control").removeClass("hidden");													// G-Code/Macro Files
}

function disableControls() {
	$("nav input, #div_heaters input, #main_content input").prop("disabled", true);				// Generic inputs
	$("#page_general input, #page_ui input, #page_listitems input").prop("disabled", false);	// ... except ...
	$("#page_tools label").addClass("disabled");												// ... for Settings
	$("#btn_fw_diagnostics").addClass("disabled");

	$(".btn-emergency-stop, .gcode-input button[type=submit], .gcode").addClass("disabled");	// Navbar
	$(".bed-temp, .gcode, .heater-temp, .btn-upload").addClass("disabled");						// List items and Upload buttons

	$("#mobile_home_buttons button, #btn_homeall, #table_move_head a").addClass("disabled");	// Move buttons
	$("#panel_extrude label.btn, #panel_extrude button").addClass("disabled");					// Extruder Control
	$("#panel_control_misc label.btn").addClass("disabled");									// ATX Power
	$("#slider_fan_control").slider("disable");													// Fan Control

	$("#btn_pause, #page_print .checkbox").addClass("disabled");								// Print Control
	$("#slider_fan_print").slider("disable");													// Fan Control
	$("#slider_speed").slider("disable");														// Speed Factor
	for(var extr = 1; extr <= maxExtruders; extr++) {
		$("#slider_extr_" + extr).slider("disable");											// Extrusion Factors
	}

	$(".online-control").addClass("hidden");													// G-Code/Macro Files
}


/* Window size queries */


function windowIsXsSm() {
	return window.matchMedia('(max-width: 991px)').matches;
}

function windowIsMdLg() {
	return window.matchMedia('(min-width: 992px)').matches;
}


/* Misc */

function log(style, message) {
	var entry =		'<div class="row alert-' + style + '">';
	entry +=		'<div class="col-xs-2 col-sm-2 col-md-2 col-lg-1 text-center"><strong>' + (new Date()).toLocaleTimeString() + '</strong></div>';
	entry +=		'<div class="col-xs-10 col-sm-10 col-md-10 col-lg-11">' + message + '</div></div>';
	$("#console_log").prepend(entry);
}

var audioContext = new (window.AudioContext || window.webkitAudioContext);
function beep(frequency, duration) {
	var oscillator = audioContext.createOscillator();

	oscillator.type = 'sine';
	oscillator.frequency.value = frequency;
	oscillator.connect(audioContext.destination);
	oscillator.start();

	setTimeout(function() {
		oscillator.disconnect();
	}, duration);
}
