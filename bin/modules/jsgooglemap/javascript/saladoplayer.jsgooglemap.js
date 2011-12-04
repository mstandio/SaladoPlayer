(function( $ ){
	
	// default settings
	var SaladoPlayerJSGoogleMapSettings = {
		'player_name': 'player',
		'higlight_callback': null,
		'setOpen_callback': null,
		'icon_off': null,
		'icon_on': null,
		'radar_id': null,
		'radar_style': {},
		'visibility': true
	};
	
	var SaladoPlayerJSGoogleMapState = {
		'parent': null,
		'points': [],
		'markers': [],
		'tracks': [],
		'layers': []
	}
	
	// JSGoogleMap inner query object
	var SaladoPlayerJSGoogleMapQuery = {
		settings: null,
		scene: null,
		lang: 'en'
	}
	
	var query = {};
	
	var image_off;
	
	var image_on;
	
	var disabled = false;
	
	var methods = {
		
		// plugin initialization
		init : function( options ) {
			SaladoPlayerJSGoogleMapState.parent = $(this);
			$(SaladoPlayerJSGoogleMapState.parent).fadeOut(0);
			// default settings
			// merge it with options
			if ( options ) {
				$.extend(SaladoPlayerJSGoogleMapSettings, options);
			}
		},
		
		configure: function(JSONstring){
			var config = eval('('+JSONstring+')');
			$.each(config.data.waypoints, function(index, waypoint){
				var obj = {};
				obj.id = waypoint.target;
				obj.lat = waypoint.lat;
				obj.lng = waypoint.lng;
				obj.title = waypoint.label;
				SaladoPlayerJSGoogleMapState.points.push(obj);
			});
			
			$.each(config.data.tracks, function(index, track){
				SaladoPlayerJSGoogleMapState.tracks.push(track.path);
			});
			
			SaladoPlayerJSGoogleMapSettings.icon_on = config.data.markers.markerOn;
			SaladoPlayerJSGoogleMapSettings.icon_off = config.data.markers.markerOff;
			
			image_off = new google.maps.MarkerImage(SaladoPlayerJSGoogleMapSettings.icon_off,
				// This marker is 20 pixels wide by 32 pixels tall.
				new google.maps.Size(35, 41),
				// The origin for this image is 0,0.
				new google.maps.Point(0,0),
				// The anchor for this image is the base of the flagpole at 0,32.
				new google.maps.Point(18, 40));
			
			image_on = new google.maps.MarkerImage(SaladoPlayerJSGoogleMapSettings.icon_on,
				// This marker is 20 pixels wide by 32 pixels tall.
				new google.maps.Size(35, 41),
				// The origin for this image is 0,0.
				new google.maps.Point(0,0),
				// The anchor for this image is the base of the flagpole at 0,32.
				new google.maps.Point(16, 34));
			
			methods.build();
		},
		
		// build map with track and points
		build: function() {
			if (disabled) {
				return;
			}
			var myLatlng = (SaladoPlayerJSGoogleMapState.points.length > 0) ? new google.maps.LatLng(SaladoPlayerJSGoogleMapState.points[0].lat, SaladoPlayerJSGoogleMapState.points[0].lng) : new google.maps.LatLng(0, 0);
			var bounds = null;
			var myOptions = {
				zoom:11,
				center: myLatlng,
				mapTypeId: google.maps.MapTypeId.TERRAIN
			}
			
			var map = new google.maps.Map(document.getElementById('right'), myOptions);
			
			for (key in SaladoPlayerJSGoogleMapState.tracks) {
				var trackLayer = new google.maps.KmlLayer(SaladoPlayerJSGoogleMapState.tracks[key], {suppressInfoWindows: true, preserveViewport: true});
				SaladoPlayerJSGoogleMapState.layers.push(trackLayer);
				google.maps.event.addListener(trackLayer, 'click', function(kmlEvent) {
					methods.run(kmlEvent.featureData.name);
				});
				
				trackLayer.setMap(map);
			};
			
			for (key in SaladoPlayerJSGoogleMapState.points) {
				var marker = new google.maps.Marker({
					position: new google.maps.LatLng(SaladoPlayerJSGoogleMapState.points[key].lat, SaladoPlayerJSGoogleMapState.points[key].lng),
					map: map,
					icon: (query != null && query.scene != null && query.scene == SaladoPlayerJSGoogleMapState.points[key].id) ? image_on : image_off,
					title: SaladoPlayerJSGoogleMapState.points[key].title
				});
				
				if ((query != null && query.scene != null && query.scene == SaladoPlayerJSGoogleMapState.points[key].id)) {
					if (SaladoPlayerJSGoogleMapSettings.radar_id != null) {
						$('#' + SaladoPlayerJSGoogleMapSettings.radar_id).SaladoPlayerJSGoogleMapRadar({ marker: marker, style: SaladoPlayerJSGoogleMapSettings.radar_style });
						$('#' + SaladoPlayerJSGoogleMapSettings.radar_id).SaladoPlayerJSGoogleMapRadar('bind', marker);
					}
				}
				if (bounds == null) {
					bounds = new google.maps.LatLngBounds(marker.getPosition(), marker.getPosition());
				} else {
					bounds.extend(marker.getPosition());
				}
				SaladoPlayerJSGoogleMapState.markers.push(marker);
				google.maps.event.addListener(marker, 'click', function() {
					for (key in SaladoPlayerJSGoogleMapState.markers) {
						if (SaladoPlayerJSGoogleMapState.markers[key] == this) {
							methods.run(key);
						}
					}
				});
			}
			if (bounds != null) {
				map.fitBounds(bounds);
			}
			if (SaladoPlayerJSGoogleMapSettings.visibility) {
				if (SaladoPlayerJSGoogleMapSettings.setOpen_callback != null) {
					SaladoPlayerJSGoogleMapSettings.setOpen_callback(true);
				}
			} else {
				if (SaladoPlayerJSGoogleMapSettings.setOpen_callback != null) {
					SaladoPlayerJSGoogleMapSettings.setOpen_callback(false);
				}
			}
		},
		
		// higlight waypoint
		higlight: function(id) {
			if(disabled) {
				return;
			}
			if(SaladoPlayerJSGoogleMapSettings.radar_id != null) {
				$('#' + SaladoPlayerJSGoogleMapSettings.radar_id).SaladoPlayerJSGoogleMapRadar('unbind');
			}
			for (key in SaladoPlayerJSGoogleMapState.markers) {
				if (SaladoPlayerJSGoogleMapState.points[key].id == id) {
					SaladoPlayerJSGoogleMapState.markers[key].setIcon(image_on);
					if (SaladoPlayerJSGoogleMapSettings.radar_id != null) {
						$('#' + SaladoPlayerJSGoogleMapSettings.radar_id).SaladoPlayerJSGoogleMapRadar('bind', SaladoPlayerJSGoogleMapState.markers[key]);
					}
					map = SaladoPlayerJSGoogleMapState.markers[key].getMap();
					map.setCenter(SaladoPlayerJSGoogleMapState.markers[key].getPosition());
				} else {
					SaladoPlayerJSGoogleMapState.markers[key].setIcon(image_off);
				}
			}
		},
		
		redraw_radar: function(fov, pan) {
			if (disabled) {
				return;
			}
			if (SaladoPlayerJSGoogleMapSettings.radar_id != null) {
				$('#' + SaladoPlayerJSGoogleMapSettings.radar_id).SaladoPlayerJSGoogleMapRadar('refresh', fov, pan);
			}
		},
		
		// run SaladoPlayer action
		run: function(key) {
			if (disabled) {
				return;
			}
			id = SaladoPlayerJSGoogleMapState.points[key].id;
			document.getElementById(SaladoPlayerJSGoogleMapSettings.player_name).jsgm_in_loadPano(id);
			if (SaladoPlayerJSGoogleMapSettings.higlight_callback != null) {
				SaladoPlayerJSGoogleMapSettings.higlight_callback(id);
			}
		}
	};
	
	// Method calling logic
	$.fn.SaladoPlayerJSGoogleMap = function( method ) {
		if ( methods[method] ) {
			return methods[method].apply( this, Array.prototype.slice.call( arguments, 1 ));
		} else if (typeof method === 'object' || !method) {
			return methods.init.apply( this, arguments );
		} else {
			$.error( 'Method ' +  method + ' does not exist on jQuery.tooltip' );
		}
	};
})( jQuery );
