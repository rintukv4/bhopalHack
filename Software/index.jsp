<!DOCTYPE html>
<html>

<head>
  <style>
    /* Set the size of the div element that contains the map */
    #map {
      height: 70vh;
      /* The height is 400 pixels */
      width: 100%;
      /* The width is the width of the web page */
    }

    img {
      height: 100px;
      width: 100px;
      position: fixed;
      z-index: 2000;
    }
	
	body{
		border: none;
	}
  </style>
</head>

    <%@ page import="java.io.*,java.util.*,java.sql.*" %> 
	<%!
			 String lat1,lat2,lon1,lon2;
			 String flow1, flow2, tur;
			 String img1, img2;
			 String c1;
	%>

    <%

    

	 String connectionURL = "jdbc:mysql://localhost:3306/bhack";

	  String url=request.getParameter("WEB_URL");

	  String Content=new String("");

	  Statement stmt=null;

      Connection con=null;

    try

    {

	Class.forName("com.mysql.jdbc.Driver").newInstance();

	con=DriverManager.getConnection(connectionURL,"root",""); 

	stmt=con.createStatement();
	%>
	

<body>
  <img src="./logo.png" alt="logo">
  <!--The div element for the map -->
  <div id="sec1">
		 <div id="map"></div>
  <script>
    // Initialize and add the map
    function initMap() {
      var options = {
        zoom: 14,
        center: {
          lat: 23.2599,
          lng: 77.4126
        },
        mapTypeId: 'roadmap'
      }
      // For lat and lan of node1
      var map = new google.maps.Map(
        document.getElementById('map'), options);
		<%
			String qry = "select * from location where node ="+"1";

			ResultSet rst= stmt.executeQuery(qry);

			while(rst.next())
			{
				lat1 = rst.getString(2);
				lon1 = rst.getString(3);
			
			}
			}
			catch(Exception e){
			e.printStackTrace();
			}

			%>
			
	//for sensor values of node1
			<%
			try
			{
			String qry3 = "SELECT * FROM node1 WHERE time = (SELECT MAX(time) FROM node1)";

			ResultSet rst= stmt.executeQuery(qry3);

			while(rst.next())

			{
				tur = rst.getString(2);
				flow1 = rst.getString(3);
			}
			}
			catch(Exception e){
			e.printStackTrace();
			}

			%>
	//lat and lon of node2
		<%
		try
			{
			String qry2 = "select * from location where node ="+"2";

			ResultSet rst= stmt.executeQuery(qry2);

			while(rst.next())

			{
				lat2 = rst.getString(2);
				lon2 = rst.getString(3);
			}
			}

			catch(Exception e){

			e.printStackTrace();

			}

			%>
			
	//sensors value of node2
			
		<%
					try
					{
					String qry4 = "SELECT * FROM node2 WHERE time = (SELECT MAX(time) FROM node2)";

					ResultSet rst= stmt.executeQuery(qry4);

					while(rst.next())

					{
						flow2 = rst.getString(3);
					}
					}
					catch(Exception e){
					e.printStackTrace();
					}

		%>
		
		
		<%
		
			if(Float.valueOf(tur) < 1.40)
			{
				img1 = " 'f.png' ";
			}
			else
			{
				img1 = " 's.svg '";
			}
			
		%>
		
		<% 
				if((int) Math.round(Float.valueOf(flow1)) != (int) Math.round(Float.valueOf(flow2)))
				{

					c1 = " '#FF0000' ";
				}
				else
				{
					c1 = " '#00ff00' ";
				}
					
		
		%>
			
			
		
			
			// Add marker
			  var mark = new google.maps.Marker({
				position: {
				  lat: <%=lat1%>,
				  lng: <%=lon1%>
				},
				map: map,
				icon: <%=img1%>
			  });


      var infoWindow = new google.maps.InfoWindow({
        content: '<h2>Node 2</h2>'+'<br><span>Flow rate : <%=flow1%> l/min</span>'+'<br><span>Turbidity : <%=tur%> NTU </span>'
      });
			
	  
		
			
			// Add marker
			  var marker = new google.maps.Marker({
				position: {
				  lat: <%=lat2%>,
				  lng: <%=lon2%>
				},
				map: map,
				icon: 's.svg'
			  });

			
	
			  

			  var info = new google.maps.InfoWindow({
				content: '<h2>Node 1 </h2>'+'<br><span>Flow rate : <%=flow2%> l/min </span>'+'<br><span>Turbidity : <%=tur%> NTU </span>'
			  });
			  

					

      mark.addListener('click', function () {
        infoWindow.open(map, mark);
      });

      marker.addListener('click', function () {
        info.open(map, marker);
      });

      var flightPlanCoordinates = [{
          lat: <%=lat1%>,
          lng: <%=lon1%>
        },
        {
          lat: <%=lat2%>,
          lng: <%=lon2%>  
		  }
      ];
      var flightPath = new google.maps.Polyline({
        path: flightPlanCoordinates,
        geodesic: true,
        strokeColor: <%=c1%>,
        strokeOpacity: 0.75,
        strokeWeight: 5
      });

      flightPath.setMap(map);

    }
  </script>
  <script async defer
    src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBm3VtMEVke9gOJnhOpDxggETNKoibS3CQ&callback=initMap">
  </script>
  </div>
 

	<div class="leak">
	  <h2>Leak:</h2>
	  <span>
		<% 
					if((int) Math.round(Float.valueOf(flow1)) != (int) Math.round(Float.valueOf(flow2)))
					{
							out.println("N1 - N2 has a possible leakage ");
					}
					else
					{
							out.println("No leakage Detected");
					}
		
		%>
	  
	  </span>
	</div>
	<div class="quality">
	  <h2>Quality:</h2>
	  <span>
	  <%
			if(Float.valueOf(tur) < 1.40)
				{
					out.println("Poor Water Quality Detected at node N1");
				}
				else{
					out.println("Everything is good ");
				}
	  %>
	  
	  </span>
	</div>



</body>
</html>