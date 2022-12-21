<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>leaflet</title>

<link rel="stylesheet"
	href="https://unpkg.com/leaflet@1.9.3/dist/leaflet.css"
	integrity="sha256-kLaT2GOSpHechhsozzB+flnD+zUyjE2LlfWPgU04xyI="
	crossorigin="" />

<!-- Make sure you put this AFTER Leaflet's CSS -->
<script src="https://unpkg.com/leaflet@1.9.3/dist/leaflet.js"
	integrity="sha256-WBkoXOwTeyKclOHuWtc+i2uENFpDZ9YPdf5Hf+D7ewM="
	crossorigin=""></script>



<style>
#mapwrap {
	width: 100%;
	display: flex;
	/* justify-content: space-between; */
}

#map {
	height: 700px;
	width: 900px;
}
</style>
</head>
<body>
	<div id="mapwrap">
		<div id="map"></div>
		<div id="search">
			<div>�˻��ϱ�</div>
			<div>
				<form action="search" method="get">
					�ּ� �˻��� : <input type="text" name="query"> <input
						id="searchbtn" type="submit" value="�˻�">
				</form>
			</div>
		</div>
	</div>
	<button onClick="me()">�� ��ġ ã��</button>
	<button onclick="move()">���￪</button>


	<script>
		//var map = L.map("map").setView([37.55236577, 126.97077348], 15);
		var map = L.map("map").setView([ 37.56249213, 126.96849315 ], 15);
		L
				.tileLayer(
						'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
						{
							maxZoom : 19,
							attribution : '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
						}).addTo(map);
		console.log("�ʱ�ȭ")

		//�� ��ġ ã��
		function me(){
		map.on('locationfound',
				function(e) {
					console.log(e);
					var radius = e.accuracy / 2;
					var locationMarker = L.marker(e.latlng).addTo(map)
							.bindPopup(
									'����� �ݰ� ' + radius.toFixed(6)
											+ '���� �ȿ� ��ðڱ���.').openPopup();
					var locationCircle = L.circle(e.latlng, radius).addTo(map);
					console.log(radius);
				});
		map.on('locationerror', function(e) {
			console.log(e.message)
		});

		map.locate({
			setView : true,
			maxZoom : 16
		});
		}
	</script>

	<script>
		var openmate = L.marker([ 37.56249213, 126.96849315 ]).addTo(map);
		// var marker2 = L.marker([51.494423, -0.076561]).addTo(map);

		//���׶�� ������ ǥ��
		// var circle = L.circle([51.508, -0.11], {
		// color: 'red',
		// fillColor: '#f03',
		// fillOpacity: 0.5,
		// radius: 500
		// }).addTo(map);

		//������ ǥ��
		// var polygon = L.polygon([
		// [51.509, -0.08],
		// [51.503, -0.06],
		// [51.51, -0.047]
		// ]).addTo(map);

		//�˾�����
		openmate.bindPopup("<b>Openmate</b>").openPopup();
		// circle.bindPopup("I am a circle.");
		// polygon.bindPopup("I am a polygon.");

		//alert �ȳ�
		// function onMapClick(e) {
		// alert("You clicked the map at " + e.latlng);
		// }

		// map.on('click', onMapClick);

		// �� �� �ȳ�
		var popup = L.popup();

		function onMapClick(e) {
			popup.setLatLng(e.latlng).setContent(
					"You clicked the map at<br>" + e.latlng.toString()
							+ "<br><button>���ã��</button>").openOn(map);
		}

		map.on('click', onMapClick);

		//���￪ �̵�
		function move() {
			map.panTo(new L.LatLng(37.55236577, 126.97077348));
		}
	</script>
</body>
</html>