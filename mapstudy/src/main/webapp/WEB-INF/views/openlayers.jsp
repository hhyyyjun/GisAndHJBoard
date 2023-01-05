<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>openlayers</title>

<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet"
	href="https://openlayers.org/en/v4.6.5/css/ol.css" type="text/css">
<!-- The line below is only needed for old environments like Internet Explorer and Android 4.x -->


<script
	src="https://cdn.polyfill.io/v2/polyfill.min.js?features=requestAnimationFrame,Element.prototype.classList,URL"></script>
<script src="https://openlayers.org/en/v4.6.5/build/ol.js"></script>

<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.12.4.min.js"></script>
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>

<style>
#map:focus {
	outline: #4A74A8 solid 0.15em;
}
#marker {
        width: 20px;
        height: 20px;
        border: 1px solid #088;
        border-radius: 10px;
        background-color: #0FF;
        opacity: 0.5;
}
.tooltip {
	position: relative;
	background: rgba(0, 0, 0, 0.5);
	border-radius: 4px;
	color: white;
	padding: 4px 8px;
	opacity: 0.7;
	white-space: nowrap;
}

.tooltip-measure {
	opacity: 1;
	font-weight: bold;
}

.tooltip-static {
	background-color: #1DDB16;
	color: #fff;
	border: 1px solid white;
}

.tooltip-measure:before, .tooltip-static:before {
	border-top: 6px solid rgba(0, 0, 0, 0.5);
	border-right: 6px solid transparent;
	border-left: 6px solid transparent;
	content: "";
	position: absolute;
	bottom: -6px;
	margin-left: -7px;
	left: 50%;
}

.tooltip-static:before {
	border-top-color: #1DDB16;
}
</style>

</head>
<body>
	<div>
		<jsp:include page="/WEB-INF/views/common/header.jsp" />
	</div>
	<div id="map" class="map" tabindex="0"></div>
<!-- 	<div id="popup" class="ol-popup"> -->
<!-- 		<a href="#" id="popup-closer" class="ol-popup-closer"></a> -->
<!-- 		<div id="popup-content"></div> -->
<!-- 	</div> -->
	<div id="apps">
		<button id="zoom-out">Zoom out</button>
		<button id="zoom-in">Zoom in</button>
	</div>
	<div id="apps">
		<div>
			<div id="search">
				<div id="searchmap">
					�ּ� �˻� : <input type="text" name="query" id="searchadd"> <input
						id="searchBtn" type="button" value="�˻�">
				</div>
			</div>
		</div>
		<div id="buttons">
			<button onClick="me()">�� ��ġ ã��</button>
			<button onclick="move()">���￪</button>
		</div>
		<select id="type">
			<option value="None">None</option>
			<option value="Point">Point</option>
			<option value="LineString">LineString</option>
			<option value="Polygon">Polygon</option>
			<option value="Circle">Circle</option>
		</select> <span>shift Ŭ�� �� ���� �׸���</span>
		<select id="colorsel">
					<option value='rgba(255, 255, 255, 0.5)'>None</option>
					<option value='red'>red</option>
					<option value='blue'>blue</option>
					<option value='orange'>orange</option>
					<option value='green'>green</option>
					<option value='pink'>pink</option>
					<option value='yellow'>yellow</option>
					<option value='purple'>purple</option>
		</select>ä��� �� 
		<select id="stroke">
					<option value="3">3</option>
					<option value="4">4</option>
					<option value="5">5</option>
					<option value="6">6</option>
					<option value="7">7</option>
					<option value="8">8</option>
					<option value="9">9</option>
		</select> �� �β�
		<select id="strokeColor">
					<option value='black'>None</option>
					<option value='red'>red</option>
					<option value='blue'>blue</option>
					<option value='orange'>orange</option>
					<option value='green'>green</option>
					<option value='pink'>pink</option>
					<option value='yellow'>yellow</option>
					<option value='purple'>purple</option>
		</select> �� ����
	</div>
	<script src="js/common.js"></script>

	<script>
	
		//������ ���̾� ����
		var raster = new ol.layer.Tile({
			    source : new ol.source.OSM({
					url : 'https://{a-c}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png'
				}),
				visible : true
		});

		//��ǥ�� ������ ���� ����
		var source = new ol.source.Vector();
		//���� ���̾� ����
		var vector = new ol.layer.Vector({
			source : source,
			//���� ���̾��� ��Ÿ�� ����
			style: new ol.style.Style({
	            fill: new ol.style.Fill({
	                color: "rgba(255, 255, 255, 0.5)"
	            }),
	            stroke: new ol.style.Stroke({
	                color: '#1DDB16',
	                width: 3
	            })
	        })
		});
		
		//ó�� ������ �� ������ ���� ����
		var mapView = new ol.View({
			//���·��̾�� ���浵�� �ٸ� api�� �ݴ�� �־�� ��
			center : new ol.geom.Point([ NHLng, NHLat ]).transform('EPSG:4326',
					'EPSG:3857').getCoordinates(),
			maxZoon : 20,
			minZoon : 3,
			zoom : 15
			})
		//���� ����
		var map = new ol.Map({
					//�� ���� ����
					layers : [raster, vector ],
					//������ ǥ���� ����� id
					target : 'map',
					controls : ol.control.defaults({
						//�����ϴ� ���� ǥ��
						attributionOptions : {
							//���� ��ư �������� ����
							collapsible : false
						}
					}),
					view : mapView
				});
	</script>

	<script>
		//���� �׷��� ����
		var sketch;
		//�ȳ� ���� ���
		var helpTooltipElement;
		//���콺 ���� �޼���
		var helpTooltip;
		//������ ���� ���
		var measureTooltipElement;
		//���������� ������ ����
		var measureTooltip;
		//������ �׸� �� ���� ����
		var continuePolygonMsg = 'Click to continue drawing the polygon';
		//���� �׸� �� ���� ����
		var continueLineMsg = 'Click to continue drawing the line';
		//�� �׸� �� ���� ����
		var continueCircle = 'Drag to continue drawing circle';
	
		
		////////////////////////////////////////�ڵ� ������
		var pointerMoveHandler = function(e) {
	        if (e.dragging) {
	          return;
	        }
	        //�׸��� ���� ���� �� �ȳ� ����
	        var helpMsg = 'Click to start drawing';
			if(typeSelect == 'none'){
	        	helpMsg = '';
			}
			
	        if (sketch) {
	          //���� ������ ��� �Ǻ�
	          var geom = (sketch.getGeometry());
	          if (geom instanceof ol.geom.Polygon) {
	            helpMsg = continuePolygonMsg;
	          } else if (geom instanceof ol.geom.LineString) {
	            helpMsg = continueLineMsg;
	          } else if	(geom instanceof ol.geom.Circle){
	        	helpMsg = continueCircle;
	          }
	        }
	        //HTML ����
	        helpTooltipElement.innerHTML = helpMsg;
	        //helpMsg�� ���콺 �����Ϳ� ���� ����
	        helpTooltip.setPosition(e.coordinate);
	        helpTooltipElement.classList.remove('hidden');
	      };
	
		///////////////////////////////////////���� �׸��� �� ���� ���
		var modify = new ol.interaction.Modify({
			source : source
		});
		map.addInteraction(modify);

		///////////////////////////////////////�� ���� ����
		var formatLength = function(line) {
			//�� ���� ����
	        var length = ol.Sphere.getLength(line);
	        var output;
	        // m���� ���̰� 100�� �ʰ��ϸ�
	        if (length > 1000) {
	        	//km ������ ����, math.round �ݿø� �Լ�
	          output = (Math.round(length / 1000 * 100) / 100) +
	              ' ' + 'km';
	        } else {
	          output = (Math.round(length * 100) / 100) +
	              ' ' + 'm';
	        }
	        return output;
	      };
	    ////////////////////////////////////�������� ���� ����
	    var formatArea = function(polygon) {
	    	//������ ���� ����
	        var area = ol.Sphere.getArea(polygon);
	        var output;
	        if (area > 10000) {
	          output = (Math.round(area / 1000000 * 100) / 100) +
	              ' ' + 'km<sup>2</sup>';
	        } else {
	          output = (Math.round(area * 100) / 100) +
	              ' ' + 'm<sup>2</sup>';
	        }
	        return output;
	      };
	    ///////////////////////////////////////���� �ݰ� ����
	    var formatCircle = function(circle){
	    	//���� �ݰ�
	    	var radius = circle.getRadius();
	    	console.log("�ݰ�"+radius);
	    	var output;
	        // m���� ���̰� 100�� �ʰ��ϸ�
	        if (radius > 1000) {
	        	//km ������ ����, math.round �ݿø� �Լ�
	          output = '�ݰ� ' + (Math.round(radius / 1000 * 100) / 100) +
	              ' ' + 'km';
	        } else {
	          output = '�ݰ� ' + (Math.round(radius * 100) / 100) +
	              ' ' + 'm';
	        }
	        return output;
	    }
	    
	    var draw, snap;
		//id���� type�� ���
		var typeSelect = document.getElementById('type');
		//�� ���� ���
		var fillSelect = document.getElementById('colorsel');
		//�� �β�
		var stroke = document.getElementById('stroke');
		//�� ����
		var strokeColor = document.getElementById('strokeColor');
		////////////////////////////////////////�׸��� ���� ����
		function addInteractions() {
			draw = new ol.interaction.Draw({
				source : source,
				type : typeSelect.value,
				stopClick : true,
				style: new ol.style.Style({
		            fill: new ol.style.Fill({
		                color: 'rgba(255, 255, 255, 0.2)',
		            }),
		            stroke: new ol.style.Stroke({
		                color: 'red',
		                lineDash: [10, 10],
		                width: 2,
		            }),
		            image: new ol.style.Circle({
		                radius: 5,
		                stroke: new ol.style.Stroke({
		                    color: 'rgba(0, 0, 0, 0.7)'
		                }),
		                fill: new ol.style.Fill({
		                  color: 'rgba(255, 255, 255, 0.2)'
		                })
		            }),
				}),
			});
			//�ʿ� �׸��� ��� ����
			map.addInteraction(draw);
			createMeasureTooltip();
	        createHelpTooltip();
			
			//////////////////////////////////////���ο� ������ ���� ���콺 �����Ͱ� �ٴ´�.
			snap = new ol.interaction.Snap({
				source : source
			});
			map.addInteraction(snap);
			
			
			var listener;
			//////////////////////////////////////////////�׸��� �����ϸ�
	        draw.on('drawstart',function(e) {
	              //���� �׸� ������ ���
	              sketch = e.feature;

	              /** @type {ol.Coordinate|undefined} */
	              var tooltipCoord = e.coordinate;
				  //���� �׸� ������ ����Ǹ�
	              listener = sketch.getGeometry().on('change', function(e) {
	                var geom = e.target;
	                var output;
	                if (geom instanceof ol.geom.Polygon) {
	                  output = formatArea(geom);
	                  tooltipCoord = geom.getInteriorPoint().getCoordinates();
	                } else if (geom instanceof ol.geom.LineString) {
	                  output = formatLength(geom);
	                  tooltipCoord = geom.getLastCoordinate();
	                } else if (geom instanceof ol.geom.Circle){
	                  output = formatCircle(geom);
	                  tooltipCoord = geom.getCenter();
	                }
	                measureTooltipElement.innerHTML = output;
	                measureTooltip.setPosition(tooltipCoord);
	              });
	            }, this);
			
			/////////////////////////////////////////�׸��� �Ϸ� ��
			draw.on('drawend', function(e){
				//��� �׸� ���� ����
	 			var feature = e.feature;
				//��� �׸� ������ ������ ������ ����
	 			var features = source.getFeatures();
				//��� ������ ����
	 			var allFeats = features.concat(feature);
// 	 			console.log(feature);
// 	 			console.log(features);
// 	 			console.log(allFeats);
	 			
	 			measureTooltipElement.className = 'tooltip tooltip-static';
	            measureTooltip.setOffset([0, -7]);
	            // unset sketch
	            sketch = null;
	            // unset tooltip so that a new one can be created
	            measureTooltipElement = null;
	            createMeasureTooltip();
	            ol.Observable.unByKey(listener);
	            
	            //���� �� ������� ���� �ɼǿ� ���� ��, �� ����
	            feature.setStyle([
	            	new ol.style.Style({
	        			fill: new ol.style.Fill({
	    	           	    color: fillSelect.value
	    	          	}),
	    	          	stroke: new ol.style.Stroke({
	    	                color: strokeColor.value,
	    	                width: stroke.value
	    	            })
	            	})
	        	]);
	            vector.setOpacity(0.2);
	        	console.log(fillSelect.value);
	        	console.log(vector.getOpacity);
	        	
			}, this);
		}
		///////////////////////////////////���� ����
		function createHelpTooltip() {
			//���� ��Ұ� �����ϸ�
	        if (helpTooltipElement) {
	          //�ش� ��� ����
	          helpTooltipElement.parentNode.removeChild(helpTooltipElement);
	        }
			//���� ��ҿ� div html �±� �߰�
	        helpTooltipElement = document.createElement('div');
			//�߰��� �±׿� Ŭ������ �߰�
	        helpTooltipElement.className = 'tooltip hidden';
			//������ �¾��� ����� �ɼ� ����
	        helpTooltip = new ol.Overlay({
	          element: helpTooltipElement,
	          offset: [15, 0],
	          positioning: 'center-left'
	        });
	        map.addOverlay(helpTooltip);
	      }
		////////////////////////////////////������ ���� ����
		function createMeasureTooltip() {
	        if (measureTooltipElement) {
	          measureTooltipElement.parentNode.removeChild(measureTooltipElement);
	        }
	        measureTooltipElement = document.createElement('div');
	        measureTooltipElement.className = 'tooltip tooltip-measure';
	        measureTooltip = new ol.Overlay({
	          element: measureTooltipElement,
	          offset: [0, -15],
	          positioning: 'bottom-center'
	        });
	        map.addOverlay(measureTooltip);
	      }

		///////////////////////////////////�׸��� ���� ����
		typeSelect.onchange = function() {
			map.removeInteraction(draw);
			map.removeInteraction(snap);
			//�׸��� Ÿ���� none�� ���
			if(typeSelect.value === 'None'){
				//��� ����
				map.un('pointermove', pointerMoveHandler);
				//���� ����
				map.removeOverlay(helpTooltip);
				return;
			}
			addInteractions();
			map.on('pointermove', pointerMoveHandler);
		};
		
	</script>

	<script>
	//Ŭ�� �� ���浵�� �޴´�.
		map.on('click', function(e){
			var coordinate = ol.proj.transform(e.coordinate, 'EPSG:3857', 'EPSG:4326');
		    console.log(coordinate);
// 		    mapView.animate({zoom: 12}, {center: [0, 0]});
		})
		
	</script>



	<script>
		/*
			//select �±��� option �����͵�
			var drawObject = $("#type");
			var drawControl;
			
			var updateDrawControl = function () {
				//������ option �� �� ����
				var geometryType = drawObject.val();
				console.log(geometryType);
				
				//�׸��� ���� ���� ����
				map.removeInteraction(drawControl);
				if(geometryType === 'None') return;
				
				drawControl = new ol.interaction.Draw({
					type : geometryType,
					source : vectorLayer1.getSource()
				});
				
				map.addInteraction(drawControl);
			}
			//Ŭ�� �� updateDrawControl function ����
			drawObject.on('click', updateDrawControl);
		 */
	</script>

	<script>

		//�� �� Ŭ�� �� �˾� ���
		/*
		 * Elements that make up the popup.
		 */
// 		var container = document.getElementById('popup');
// 		var content = document.getElementById('popup-content');
// 		var closer = document.getElementById('popup-closer');

		/**
		 * Create an overlay to anchor the popup to the map.
		 */
// 		var overlay = new ol.Overlay({
// 			element : container,
// 			autoPan : true,
// 			autoPanAnimation : {
// 				duration : 250
// 			}
// 		});

		/**
		 * Add a click handler to hide the popup.
		 * @return {boolean} Don't follow the href.
		 */
// 		closer.onclick = function() {
// 			overlay.setPosition(undefined);
// 			closer.blur();
// 			return false;
// 		};

// 		map.on('singleclick', function(evt) {
// 			var coordinate = evt.coordinate;
// 			var hdms = ol.coordinate.toStringHDMS(ol.proj.transform(coordinate,
// 					'EPSG:3857', 'EPSG:4326'));

// 			content.innerHTML = '<p>You clicked here:</p><code>' + hdms
// 					+ '</code>';
// 			overlay.setPosition(coordinate);
// 		});

	</script>

	<script>
	//�� �ƿ�
	document.getElementById('zoom-out').onclick = function() {
		var view = map.getView();
		var zoom = view.getZoom();
		view.setZoom(zoom - 1);
	};
	//�� ��
	document.getElementById('zoom-in').onclick = function() {
		var view = map.getView();
		var zoom = view.getZoom();
		view.setZoom(zoom + 1);
	};
	// ���￪ �̵�
	function move() {
		var view = map.getView();
		view.setZoom(15);
		map.getView().setCenter(
				new ol.geom.Point([ seoulstationLng, seoulstationLat ])
						.transform('EPSG:4326', 'EPSG:3857')
						.getCoordinates());
	}
	</script>
</body>
</html>