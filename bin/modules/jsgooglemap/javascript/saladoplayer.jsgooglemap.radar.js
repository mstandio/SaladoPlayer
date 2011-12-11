(function( $ ){
	
	var position = {
		fov: 90,
		pan: 0
	}
	
	var style = {
		borderColor: '#000000',
		borderWidth: 1,
		fillColor: '#ffffff',
		alpha: 0.4,
		radius: 70
	}
	
	var r = null;
	var canvas = null;
	var self = null;
	
	var methods = {
		
		// plugin initialization
		init: function(options) {
			if(self == null) {
				self = this;
			}
			if (options && options.style) {
				$.extend(style, options.style);
			}
			
			methods.build(options.marker);
		},
		
		build: function(marker) {
			ol.prototype = new google.maps.OverlayView();
			function ol(_marker) {
				this.position = _marker.getPosition();
				this.map = _marker.getMap();
				google.maps.OverlayView.call(this);
				this.setMap(this.map);
			}
			
			ol.prototype.onAdd = function() {
				var panes = this.getPanes() ;
				if (canvas == null) {
					div = document.getElementById($(self).attr('id'));
					canvas = div.getElementsByTagName('canvas')[0];
					//canvas = document.getElementById('radar_canvas');
					$(self).css({display: 'block'});
					panes.overlayLayer.appendChild(div);
				}
			}
			
			ol.prototype.draw = function() {
				if (!canvas) {
					return ;
				}
				var projection = this.getProjection();
				var pos = projection.fromLatLngToDivPixel(this.get('position'));
				$(self).css({top: (pos.y - style.radius) + 'px', left: (pos.x - style.radius) + 'px'});
				if (canvas.getContext){
					ctx = canvas.getContext('2d');
					ctx.save();
					
					ctx.clearRect(0,0,style.radius*2+2,style.radius*2+2);
					ctx.translate(style.radius+1,style.radius+1);
					
					ctx.lineWidth = style.borderWidth;
					ctx.strokeStyle = style.borderColor;
					ctx.fillStyle = style.fillColor;
					ctx.globalAlpha = style.alpha;
					
					ctx.beginPath();
					ctx.arc(0,0,1,0,Math.PI*2,true);
					ctx.stroke();
					ctx.save();
					
					ctx.beginPath();
					ctx.arc(0,0,style.radius-10,0,Math.PI*2,true);
					ctx.closePath();
					ctx.fill();
					ctx.stroke();
					ctx.restore();
					ctx.save();
					
					ctx.moveTo(0,0);
					
					angle = (Math.PI/180)*Math.floor(position.pan - position.fov/2 - 90);
					arc_angle = (Math.PI/180)*position.fov;
					
					x = Math.ceil(style.radius * Math.cos(angle));
					y = Math.ceil(style.radius * Math.sin(angle));
					
					ctx.beginPath();
					ctx.lineTo(x,y);
					ctx.arc(0, 0, style.radius, angle, angle + arc_angle, false);
					ctx.lineTo(0,0);
					ctx.closePath();
					ctx.fill();
					ctx.stroke();
					ctx.save();
					ctx.restore();
					
					ctx.translate(-style.radius-1,-style.radius-1);
					ctx.save();
					ctx.restore();
				}else {
					alert('Your browser didn\'t support canwas, there is no way to show Radar, sorry.');
				}
			}
			
			ol.prototype.onRemove = function() {
				if (canvas) {
					this.setMap(null);
					div = document.getElementById($(self).attr('id'));
					div.parentNode.removeChild(div);
					canvas = null;
				}
			}
			
			r = new ol(marker);
		},
		
		bind: function(marker) {
			if(r == null) {
				self = this;
				methods.init({marker: marker});
			}
			if(r != null) {
				r.bindTo('position', marker, 'position');
			}
		},
		
		unbind: function() {
			if(r != null) {
				r.unbind('position');
			}
		},
		
		refresh: function(fov, pan) {
			position.fov = fov;
			position.pan = pan;
			r.draw();
		}
	};
	
	// Method calling logic
	$.fn.SaladoPlayerJSGoogleMapRadar = function( method ) {
		if ( methods[method] ) {
			return methods[method].apply( this, Array.prototype.slice.call( arguments, 1 ));
		} else if (typeof method === 'object' || !method) {
			return methods.init.apply( this, arguments );
		} else {
			$.error( 'Method ' +  method + ' does not exist on jQuery.tooltip' );
		}
	};
})( jQuery );