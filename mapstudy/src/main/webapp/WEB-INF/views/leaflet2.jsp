<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>leaflet</title>

<link rel="stylesheet"
	href="https://unpkg.com/leaflet@1.9.3/dist/leaflet.css"
	integrity="sha256-kLaT2GOSpHechhsozzB+flnD+zUyjE2LlfWPgU04xyI="
	crossorigin="" />

<link rel="stylesheet" href="css/style.css">
<!-- Make sure you put this AFTER Leaflet's CSS -->
<script src="https://unpkg.com/leaflet@1.9.3/dist/leaflet.js"
	integrity="sha256-WBkoXOwTeyKclOHuWtc+i2uENFpDZ9YPdf5Hf+D7ewM="
	crossorigin=""></script>

<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.12.4.min.js"></script>
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/leaflet.draw/0.4.2/leaflet.draw.css" />
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/leaflet.draw/0.4.2/leaflet.draw.js"></script>

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
				<button onclick="addPin()">�� �߰��ϱ�</button>
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
		</div>
		<div id="buttons">
			<button onClick="me()">�� ��ġ ã��</button>
			<button onclick="move()">���￪</button>
			<button onclick="pinchk()" id="pinchk">�� Ȯ��</button>
			<button onclick='pindel()' id="pindel" disabled>�� ����</button>
			<button onclick="polygon()" id="polygon" disabled>������ ����</button>
			<button onclick="circle()" id="circle" disabled>nh �ֺ� Ȯ��</button>
		</div>
		<div>
			<button onclick="delLayer()">���̾� ���� �����</button>
		</div>
	</div>


	<script src="js/common.js"></script>

	<script>
		var map = L.map("map").setView([ NHLat, NHLng ], 18);
		L
				.tileLayer(
						'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
						{
							maxZoom : 19,
							attribution : '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
						}).addTo(map);
		console.log("�ʱ�ȭdd");
		
		// �׸��� ���� �߰�
		var drawnItems = new L.FeatureGroup();
		map.addLayer(drawnItems);
		var drawControl = new L.Control.Draw({
			draw : true,
			edit : {
				featureGroup : drawnItems
			}
		});
		map.addControl(drawControl);
		
		
		//���� ����
		//map.on(L.Draw.Event.CREATED, function (e) {
		map.on('draw:created', function (e) {
			   var type = e.layerType,
			       layer = e.layer;
			   // Do whatever else you need to. (save to db; add to map etc)
			   if(type === 'marker'){
				   layer.bindPopup("hihi");
			   }
			   drawnItems.addLayer(layer);
			});
		
		
		//�� ��ġ ã��
		function me() {
			map.on('locationfound', function(e) {
				console.log(e);
				var radius = e.accuracy / 2;
				var locationMarker = L.marker(e.latlng).addTo(map).bindPopup(
						'����� �ݰ� ' + radius.toFixed(6) * 50 + '���� �ȿ� ��ðڱ���.')
						.openPopup();
				var locationCircle = L.circle(e.latlng, radius * 50).addTo(map);
				console.log(radius.toFixed(6));
			});
			map.on('locationerror', function(e) {
				console.log(e.message)
			});

			map.locate({
				setView : true,
				maxZoom : 16
			});
		}

		//���￪ �̵�
		function move() {
			map.panTo(new L.LatLng(seoulstationLat, seoulstationLng));
		}
	</script>

	<script>
		//��û��, ���￪, ���¸���Ʈ �� ǥ��
		function pinchk() {
			console.log("�� ����");
			//�� Ŭ�� �� �ش� ��ǥ�� �̵� �� �ܷ��� 15
			map.panTo(new L.LatLng(moveToPinCenterLat, moveToPinCenterLng))
					.locate({
						setView : true,
						maxZoom : 15
					});

			cityhall = L.marker([ cityhallLat, cityhallLng ], {
				//�� �巡�� ��� ���� ����
				draggable : true
			}).addTo(map);
			NH = L.marker([ NHLat, NHLng ]).addTo(map);
			seoulstation = L.marker([ seoulstationLat, seoulstationLng ])
					.addTo(map);

			cityhall.bindPopup("<b>�ý�ûû����</b>");
			NH.bindPopup("<b>��������</b>");
			seoulstation.bindPopup("<b>������￪��</b>");

			//������ư show
			$("#pindel").removeAttr("disabled");
			//������ ��ư show 
			$("#polygon").removeAttr("disabled");
			//��Ŭ ��ư show
			$("#circle").removeAttr("disabled");
			//�� Ȯ�� ��ư none
			$("#pinchk").attr("disabled", "disabled");
		}

		//�ɻ���
		function pindel() {
			console.log("�� ����");
			map.removeLayer(cityhall);
			map.removeLayer(NH);
			map.removeLayer(seoulstation);
			$("#pindel").attr("disabled", "disabled")
			$("#polygon").attr("disabled", "disabled")
			$("#circle").attr("disabled", "disabled")
			$("#pinchk").removeAttr("disabled");
		}

		//������ ����
		function polygon() {
			console.log("������ ����");
			var latlngs = [ [ cityhallLat, cityhallLng ],
					[ NHLat, NHLng ],
					[ seoulstationLat, seoulstationLng ] ];
			var polygon = L.polygon(latlngs, {
				color : 'yellow'
			}).addTo(map);
			//������ �߽�
			map.fitBounds(polygon.getBounds());

			polygon.bindPopup("������");
			$("#polygon").attr("disabled", "disabled")
		}

		//���׶�� ������ ǥ��
		function circle() {
			console.log("�� ����");
			var circle = L.circle([ NHLat, NHLng ], {
				//��
				color : 'red',
				//ä���
				fillColor : 'blue',
				fillOpacity : 0.5,
				radius : 500
			}).addTo(map);

			circle.bindPopup("�������� �ݰ� 500m");
			$("#circle").attr("disabled", "disabled")
		}

		// �� �� �ȳ� & ��Ŀ �߰�
		var popup = L.popup();
		var polyLatlng = [];

		function addPin() {
			//�� Ŭ�� �� �ش� �����浵 �� ���
			map.on('click', onMapClick);
			function onMapClick(e) {
				popup.setLatLng(e.latlng).setContent(
						"Ŭ���� ��<br>" + e.latlng.toString()
								+ "<br><button id='addMarker'>��Ŀ�߰�</button>")
						.openOn(map);

				//��Ŀ�߰� ��ư Ŭ�� �� �ش� �����浵 ������ ��Ŀ �߰�
				$('#addMarker').click(function() {
					var marker = L.marker(e.latlng).addTo(map);
					polyLatlng.push(e.latlng);
					console.log("��ǥ " + e.latlng);
					console.log(polyLatlng);
					//�� Ŭ�� ����
					map.off('click', onMapClick);
				});
			}
		};

		//�߰��� ��Ŀ���� ������ ����
		function addpolygon() {
			//option�±��� ���� ��
			var colorsel = document.getElementById("colorsel").value;
			var polygonW = document.getElementById("polygonW").value;
			console.log(colorsel + " / " + polygonW);

			//��Ŀ�� 3�� �̻��� �� ������ ���� ����
			if(polyLatlng.length >= 3){
			//if (myset.size >= 3) {
				console.log(polyLatlng.length);
				var addpoly = L.polygon(polyLatlng, {
					color : colorsel,
					weight : polygonW,
					opacity : 0.7
				}).addTo(map);
				map.fitBounds(addpoly.getBounds());

				//�߰� ������ bindpopup ���� �� ������ �� Ŭ���� �ȵ�
				//addpoly.bindPopup("�߰��� ������");

				//���ο� �������� ����� ���� ���浵 �� �ʱ�ȭ
				polyLatlng = [];
			} else {
				alert("��Ŀ�� 3�� �̻� �߰����ּ���.");
			}
		}
		//alert �ȳ�
		// function onMapClick(e) {
		// alert("You clicked the map at " + e.latlng);
		// }

		// map.on('click', onMapClick);
	</script>

	<script>
	//�Ÿ����
	var measure = map.distance([NHLat, NHLng], [seoulstationLat, seoulstationLng]);
	$("#buttons").after("<div>"+measure+"</div>");
	console.log("measure : "+measure);
	
	</script>

	<script>
		var x = "";
		var y = "";
		var markers = [];

		$("#searchBtn")
				.click(
						function() {

							//������ ����� ��Ŀ ����
							for (var i = 0; i < markers.length; i++) {
								map.removeLayer(markers[i]);
							}

							var params = {
								service : "search",
								request : "search",
								version : "2.0",
								crs : "EPSG:4326",
								size : 10,
								page : 1,
								query : $.trim($("#searchadd").val()),
								type : "address",
								category : "road",
								format : "json",
								errorformat : "json",
								key : "E375A39D-7B0F-39D2-ADDD-97066A55263A"
							}
							console.log(params);

							$
									.ajax({
										type : 'POST',
										url : '/search',
										contentType : 'application/json',
										dataType : 'json',
										data : JSON.stringify(params),
										success : function(result) {

											var status = result.response.status;
											console.log(status);
											//��ȸ ������ ��츸
											if (status == "OK") {
												console.log(result);

												//leaflet ���� ���� (EPSG : 4326)
												//			 				leafletMap.panTo(new L.LatLng(y, x), 10);

												var flyX = "";
												var flyY = "";

												for (var i = 0; i < result.response.result.items.length; i++) {
													x = result.response.result.items[i].point.x;
													y = result.response.result.items[i].point.y;

													var title = result.response.result.items[i].title;
													var address = result.response.result.items[i].address.road;

													//�ɸ�Ŀ ���
													leafletAddMarker(y, x,
															title, address);

												}

												//		 					leafletMap.flyTo([flyY, flyX], 15);

											}

											else {
												alert("�ش� ��Ҹ� ã���� �����ϴ�.");
											}

										},
										error : function(request, status, error) {

										}
									});

						})

		//��Ŀ �߰�
		function leafletAddMarker(lon, lat, title, address) {
			//�ɸ�Ŀ
			var marker = L.marker([ lon, lat ]).addTo(map);

			//�˾� Ŭ����
			marker.bindPopup("<b>" + address + "</b><br><b>" + title + "</b>");
			markers.push(marker);

			map.panTo(new L.LatLng(lon, lat), 10);
		}
	</script>
</body>
</html>