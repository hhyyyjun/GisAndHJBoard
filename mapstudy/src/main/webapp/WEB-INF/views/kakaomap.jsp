<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>kakaomap</title>

<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.12.4.min.js"></script>
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
</head>
<body>
	<div>
		<jsp:include page="/WEB-INF/views/common/header.jsp" />
	</div>

	<div id="map"></div>
	<div id="apps">
		<div>
			<div id="search">
				<div id="searchmap">
					�ּ� �˻� : <input type="text" name="query" id="searchadd"> <input
						id="searchBtn" type="button" value="�˻�">
				</div>
			</div>
			<div>
				<button onclick="addpolygon()">�߰��� ��Ŀ ������ �����ϱ�</button>
				<select id="colorsel">
					<option>red</option>
					<option>blue</option>
					<option>orange</option>
					<option>green</option>
					<option>pink</option>
					<option>yellow</option>
					<option>purple</option>
				</select> <select id="polygonW">
					<option>3</option>
					<option>4</option>
					<option>5</option>
					<option>6</option>
					<option>7</option>
					<option>8</option>
					<option>9</option>
				</select>
			</div>
			<div>
				<button onclick="showMarkers()">��Ŀ ���̱�</button>
				<button onclick="hideMarkers()">��Ŀ �����</button>
			</div>
		</div>
		<div id="clickLatlng"></div>
		<div id="buttons">
			<button onClick="me()">�� ��ġ ã��</button>
			<button onclick="move()">���￪</button>
			<button onclick="addPin()">�� �����ϱ�</button>
			<button onclick="pinchk()" id="pinchk">�� Ȯ��</button>
			<button onclick='pindel()' id="pindel" disabled>�� ����</button>
			<button onclick="polygon()" id="polygon" disabled>������ ����</button>
			<button onclick="circle()" id="circle" disabled>ȸ�� �ֺ� Ȯ��</button>
		</div>
		<div>
			<button onclick="letsDraw()">���� �׸���</button>
			<button class="draw" onclick="selectOverlay('MARKER')" disabled>��Ŀ</button>
			<button class="draw" onclick="selectOverlay('POLYLINE')" disabled>��</button>
			<button class="draw" onclick="selectOverlay('CIRCLE')" disabled>��</button>
			<button class="draw" onclick="selectOverlay('RECTANGLE')" disabled>�簢��</button>
			<button class="draw" onclick="selectOverlay('POLYGON')" disabled>�ٰ���</button>
		</div>
	</div>
	<script type="text/javascript"
		src="//dapi.kakao.com/v2/maps/sdk.js?appkey=5a1f9ffba7242dca60963ad07d1d79b3&libraries=drawing"></script>
	<script src="js/common.js"></script>

	<script type="text/javascript"
		src="//dapi.kakao.com/v2/maps/sdk.js?appkey=5a1f9ffba7242dca60963ad07d1d79b3"></script>
	<script>
		//////////////////���� ����
		var container = document.getElementById('map');
		var options = {
			center : new kakao.maps.LatLng(openmateLat, openmateLng),
			level : 3
		};
		var map = new kakao.maps.Map(container, options);

		/////////////////���� ��Ʈ��
		// �Ϲ� ������ ��ī�̺�� ���� Ÿ���� ��ȯ�� �� �ִ� ����Ÿ�� ��Ʈ���� �����մϴ�
		var mapTypeControl = new kakao.maps.MapTypeControl();

		// ������ ��Ʈ���� �߰��ؾ� �������� ǥ�õ˴ϴ�
		// kakao.maps.ControlPosition�� ��Ʈ���� ǥ�õ� ��ġ�� �����ϴµ� TOPRIGHT�� ������ ���� �ǹ��մϴ�
		map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);

		// ���� Ȯ�� ��Ҹ� ������ �� �ִ�  �� ��Ʈ���� �����մϴ�
		var zoomControl = new kakao.maps.ZoomControl();
		map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

		//////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////�� Ȯ��
		//���￪, ��û��, ���¸���Ʈ�� ��Ŀ�� �����ǰ� ��� ��Ŀ�� ���̴� ������ ����
		function pinchk() {
			// ��Ŀ�� ǥ���� ��ġ�� title ��ü �迭�Դϴ� 
			var positions = [
					{
						title : '��û��',
						content : '<div>��û���̴�</div>',
						latlng : new kakao.maps.LatLng(cityhallLat, cityhallLng)
					},
					{
						title : '���¸���Ʈ',
						content : '<div>�����̴�</div>',
						latlng : new kakao.maps.LatLng(openmateLat, openmateLng)
					},
					{
						title : '���￪',
						content : '<div>�����̴�</div>',
						latlng : new kakao.maps.LatLng(seoulstationLat,
								seoulstationLng)
					}, ];
			//���� ���� ����
			map.setLevel(5);

			// �̵��� ���� �浵 ��ġ�� �����մϴ� 
			var moveToPinCenter = new kakao.maps.LatLng(moveToPinCenterLat,
					moveToPinCenterLng);
			// ���� �߽��� �ε巴�� �̵���ŵ�ϴ�
			// ���� �̵��� �Ÿ��� ���� ȭ�麸�� ũ�� �ε巯�� ȿ�� ���� �̵��մϴ�
			map.panTo(moveToPinCenter);

			// ��Ŀ �̹����� �̹��� �ּ��Դϴ�
			var imageSrc = "https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png";

			for (var i = 0; i < positions.length; i++) {

				// ��Ŀ �̹����� �̹��� ũ�� �Դϴ�
				var imageSize = new kakao.maps.Size(24, 35);

				// ��Ŀ �̹����� �����մϴ�    
				var markerImage = new kakao.maps.MarkerImage(imageSrc,
						imageSize);

				// ��Ŀ�� �����մϴ�
				var marker = new kakao.maps.Marker({
					map : map, // ��Ŀ�� ǥ���� ����
					position : positions[i].latlng, // ��Ŀ�� ǥ���� ��ġ
					title : positions[i].title, // ��Ŀ�� Ÿ��Ʋ, ��Ŀ�� ���콺�� �ø��� Ÿ��Ʋ�� ǥ�õ˴ϴ�
					image : markerImage
				// ��Ŀ �̹��� 
				});
				// ��Ŀ�� ǥ���� ���������츦 �����մϴ� 
				var infowindow = new kakao.maps.InfoWindow({
					content : positions[i].content
				// ���������쿡 ǥ���� ����
				});
				// ��Ŀ�� mouseover �̺�Ʈ�� mouseout �̺�Ʈ�� ����մϴ�
				// �̺�Ʈ �����ʷδ� Ŭ������ ����� ����մϴ� 
				// for������ Ŭ������ ����� ���� ������ ������ ��Ŀ���� �̺�Ʈ�� ��ϵ˴ϴ�
				kakao.maps.event.addListener(marker, 'mouseover',
						makeOverListener(map, marker, infowindow));
				kakao.maps.event.addListener(marker, 'mouseout',
						makeOutListener(infowindow));
			}
			// ���������츦 ǥ���ϴ� Ŭ������ ����� �Լ��Դϴ� 
			function makeOverListener(map, marker, infowindow) {
				return function() {
					infowindow.open(map, marker);
				};
			}
			// ���������츦 �ݴ� Ŭ������ ����� �Լ��Դϴ� 
			function makeOutListener(infowindow) {
				return function() {
					infowindow.close();
				};
			}

		}

		/*
		// ������ Ŭ�� �̺�Ʈ�� ����մϴ�
		// ������ Ŭ���ϸ� ������ �Ķ���ͷ� �Ѿ�� �Լ��� ȣ���մϴ�
		kakao.maps.event.addListener(map, 'click', function(mouseEvent) {        
		    
		    // Ŭ���� ����, �浵 ������ �����ɴϴ� 
		    var latlng = mouseEvent.latLng; 
		    
		    // ��Ŀ ��ġ�� Ŭ���� ��ġ�� �ű�ϴ�
		    marker.setPosition(latlng);
		    
		    var message = 'Ŭ���� ��ġ�� ������ ' + latlng.getLat() + ' �̰�, ';
		    message += '�浵�� ' + latlng.getLng() + ' �Դϴ�';
		    
		    var resultDiv = document.getElementById('clickLatlng'); 
		    resultDiv.innerHTML = message;
		    
		});
		 */

		//////////////////////////////////////////////////////////////////////////////////////////////
		//�� �߰��ϱ�
		var flag = true;
		var latLng = "";
		var infowindow = "";
		function addPin() {
			// ������ ��Ŀ �߰����� ��ư ����
			var makeMarker = "<button style='padding : 5px;' onclick='plusPin()'>��Ŀ�߰�</button>";
			// ��Ŀ�� Ŭ���̺�Ʈ�� ����մϴ�
			flag = true;
			kakao.maps.event.addListener(map, 'click', function(mouseEvent) {
				if (flag) {
					//���� ������ ����
					infowindow = new kakao.maps.InfoWindow({
						map : map,
						position : mouseEvent.latLng,
						content : makeMarker,
						removable : true
					});

					latLng = mouseEvent.latLng;
					flag = false;
				}
			});
		}

		function plusPin() {
			//alert(latLng);
			addMarker(latLng);
			infowindow.close();
		}

		//////////////////////////////////////////////////////////////////////////////////////////////
		// ������ ǥ�õ� ��Ŀ ��ü�� ������ ���� �迭�Դϴ�
		//Ŭ�� �� ���� ��Ŀ ��ü ����
		var markers4clk = [];
		//Ŭ�� �� ���� ��Ŀ ���浵 ��
		var markers4polygon = [];
		// ��Ŀ�� �����ϰ� �������� ǥ���ϴ� �Լ��Դϴ�
		function addMarker(position) {

			// ��Ŀ�� �����մϴ�
			var clkmarker = new kakao.maps.Marker({
				position : position
			});
			// ��Ŀ�� ���� ���� ǥ�õǵ��� �����մϴ�
			clkmarker.setMap(map);
			// ������ ��Ŀ�� �迭�� �߰��մϴ�
			markers4polygon.push(position);
			markers4clk.push(clkmarker);
			console.log(markers4polygon);
		}

		// �迭�� �߰��� ��Ŀ���� ������ ǥ���ϰų� �����ϴ� �Լ��Դϴ�
		function setMarkers(map) {
			console.log(markers4clk);
			for (var i = 0; i < markers4clk.length; i++) {
				markers4clk[i].setMap(map);
			}
		}
		// "��Ŀ ���̱�" ��ư�� Ŭ���ϸ� ȣ��Ǿ� �迭�� �߰��� ��Ŀ�� ������ ǥ���ϴ� �Լ��Դϴ�
		function showMarkers() {
			setMarkers(map)
		}
		// "��Ŀ ���߱�" ��ư�� Ŭ���ϸ� ȣ��Ǿ� �迭�� �߰��� ��Ŀ�� �������� �����ϴ� �Լ��Դϴ�
		function hideMarkers() {
			setMarkers(null);
		}

		//Ŭ���� ��Ŀ���� ������ �����ϱ�
		function addpolygon() {
			console.log("����");
			var colorsel = document.getElementById("colorsel").value;
			var polygonW = document.getElementById("polygonW").value;
			// �ٰ����� �����ϴ� ��ǥ �迭�Դϴ�. �� ��ǥ���� �̾ �ٰ����� ǥ���մϴ�
			// markers4polygon �迭�� ����Ǿ� ����.
			console.log("�迭��Ȯ��1 : " + markers4polygon);
			// ������ ǥ���� �ٰ����� �����մϴ�
			var polygon = new kakao.maps.Polygon({
				path : markers4polygon, // �׷��� �ٰ����� ��ǥ �迭�Դϴ�
				strokeWeight : polygonW, // ���� �β��Դϴ�
				strokeColor : '#39DE2A', // ���� �����Դϴ�
				strokeOpacity : 0.8, // ���� ������ �Դϴ� 1���� 0 ������ ���̸� 0�� �������� �����մϴ�
				strokeStyle : 'longdash', // ���� ��Ÿ���Դϴ�
				fillColor : colorsel, // ä��� �����Դϴ�
				fillOpacity : 0.7
			// ä��� ������ �Դϴ�
			});
			console.log("���� ������?");
			// ������ �ٰ����� ǥ���մϴ�
			if (markers4polygon.length >= 3) {
				polygon.setMap(map);
				markers4polygon = [];
			} else {
				alert("��Ŀ�� 3�� �̻� �������ּ���.");
			}
			console.log("�迭��Ȯ��2 : " + markers4polygon);
		}

		/*
		// ��Ŀ�� ǥ�õ� ��ġ�Դϴ� 
		var markerPosition = new kakao.maps.LatLng(37.56249213, 126.96849315);

		// ��Ŀ�� �����մϴ�
		var marker = new kakao.maps.Marker({
			position : markerPosition
		});

		// ��Ŀ�� ���� ���� ǥ�õǵ��� �����մϴ�
		marker.setMap(map);

		// ��Ŀ�� �巡�� �����ϵ��� �����մϴ� 
		marker.setDraggable(true);
		 */

		//////////////////////////////////////////////////////////////////////////////////////////////
		//��ư Ŭ�� �� �̵�
		function move() {
			// �̵��� ���� �浵 ��ġ�� �����մϴ� 
			var moveLatLon = new kakao.maps.LatLng(seoulstationLat,
					seoulstationLng);

			// ���� �߽��� �ε巴�� �̵���ŵ�ϴ�
			// ���� �̵��� �Ÿ��� ���� ȭ�麸�� ũ�� �ε巯�� ȿ�� ���� �̵��մϴ�
			map.panTo(moveLatLon);
		}

		//////////////////////////////////////////////////////////////////////////////////////////////
		// �׸��� ����
		function letsDraw() {
			console.log($(".draw"));
			$(".draw").prop("disabled", false);
		}
		// ���� ��Ÿ���� ������ �����մϴ�
		var strokeColor = '#39f', fillColor = '#cce6ff', fillOpacity = 0.5, hintStrokeStyle = 'dash';
		var drawOptions = { // Drawing Manager�� ������ �� ����� �ɼ��Դϴ�
			map : map, // Drawing Manager�� �׸��� ��Ҹ� �׸� map ��ü�Դϴ�
			drawingMode : [ // drawing manager�� ������ �׸��� ��� ����Դϴ�
			kakao.maps.drawing.OverlayType.MARKER,
					kakao.maps.Drawing.OverlayType.ARROW,
					kakao.maps.drawing.OverlayType.POLYLINE,
					kakao.maps.drawing.OverlayType.RECTANGLE,
					kakao.maps.drawing.OverlayType.CIRCLE,
					kakao.maps.Drawing.OverlayType.ELLIPSE,
					kakao.maps.drawing.OverlayType.POLYGON ],
			// ����ڿ��� ������ �׸��� ���̵� �����Դϴ�
			// ����ڿ��� ������ �׸���, �巡���Ҷ�, �����Ҷ� ���̵� ������ ǥ���ϵ��� �����մϴ�
			guideTooltip : [ 'draw', 'drag', 'edit' ],
			markerOptions : { // ��Ŀ �ɼ��Դϴ� 
				draggable : true, // ��Ŀ�� �׸��� ���� �巡�� �����ϰ� �մϴ� 
				removable : true
			// ��Ŀ�� ���� �� �� �ֵ��� x ��ư�� ǥ�õ˴ϴ�  
			},
			arrowOptions : {
				draggable : true,
				removable : true,
				strokeColor : strokeColor,
				hintStrokeStyle : hintStrokeStyle
			},
			polylineOptions : { // �� �ɼ��Դϴ�
				draggable : true, // �׸� �� �巡�װ� �����ϵ��� �����մϴ�
				removable : true, // �׸� �� ���� �� �� �ֵ��� x ��ư�� ǥ�õ˴ϴ�
				editable : true, // �׸� �� ������ �� �ֵ��� �����մϴ� 
				strokeColor : '#39f', // �� ��
				hintStrokeStyle : 'dash', // �׸��� ���콺�� ����ٴϴ� �������� �� ��Ÿ��
				hintStrokeOpacity : 0.5
			// �׸��� ���콺�� ����ٴϴ� �������� ����
			},
			rectangleOptions : {
				draggable : true,
				removable : true,
				editable : true,
				strokeColor : '#39f', // �ܰ��� ��
				fillColor : '#39f', // ä��� ��
				fillOpacity : 0.5
			// ä���� ����
			},
			circleOptions : {
				draggable : true,
				removable : true,
				editable : true,
				strokeColor : '#39f',
				fillColor : '#39f',
				fillOpacity : 0.5
			},
			ellipseOptions : {
				draggable : true,
				removable : true,
				strokeColor : strokeColor,
				fillColor : fillColor,
				fillOpacity : fillOpacity
			},
			polygonOptions : {
				draggable : true,
				removable : true,
				editable : true,
				strokeColor : '#39f',
				fillColor : '#39f',
				fillOpacity : 0.5,
				hintStrokeStyle : 'dash',
				hintStrokeOpacity : 0.5
			}
		};

		// ���� �ۼ��� �ɼ����� Drawing Manager�� �����մϴ�
		var manager = new kakao.maps.drawing.DrawingManager(drawOptions);

		// Toolbox�� �����մϴ�. 
		// Toolbox ���� �� ������ ������ DrawingManager ��ü�� �����մϴ�.
		// DrawingManager ��ü�� �� �����ؾ߸� �׸��� ���� �Ŵ����� ���¸� ���ڽ��� ������ �� �ֽ��ϴ�.
		var toolbox = new kakao.maps.Drawing.Toolbox({
			drawingManager : manager
		});
		// ���� ���� Toolbox�� ǥ���մϴ�
		// kakao.maps.ControlPosition�� ��Ʈ���� ǥ�õ� ��ġ�� �����ϴµ� TOP�� �� ����� �ǹ��մϴ�.
		map.addControl(toolbox.getElement(), kakao.maps.ControlPosition.TOP);

		// ��ư Ŭ�� �� ȣ��Ǵ� �ڵ鷯 �Դϴ�
		function selectOverlay(type) {
			console.log("������ �Ȱ�?");
			// �׸��� ���̸� �׸��⸦ ����մϴ�
			//manager.cancel();

			// Ŭ���� �׸��� ��� Ÿ���� �����մϴ�
			manager.select(kakao.maps.drawing.OverlayType[type]);
		}
	</script>
</body>
</html>