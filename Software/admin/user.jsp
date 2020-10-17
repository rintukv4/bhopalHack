<!DOCTYPE html>
<html>

<head>
  <style>
    /* Set the size of the div element that contains the map */
    #map {
      height: 60vh;
      /* The height is 400 pixels */
      width: 100%;
      /* The width is the width of the web page */
    }

      #logo{
      height: 100px;
      width: 100px;
      position: fixed;
      z-index: 2000;
    }
	
	#user{
      height: 50px;
      width: 50px;
      position: fixed;
      z-index: 2000;
	  left:90vw;
    }
	
	html{
		border: none;
	}
  </style>
</head>

    <%@ page import="java.io.*,java.util.*,java.sql.*" %> 
	<%!
			 String lat1,lat2,lon1,lon2;
			 String flow1, flow2, tur;
			 String img1, img2;
			 String c1, q;
	%>
	
	<% response.setIntHeader("Refresh",100);%>

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
  <img  id="logo" src="./logo.png" alt="logo">
   <img id="user" src="./account.svg" alt="user">
  <!--The div element for the map -->
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
						flow2 = rst.getString(2);
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
				q = "poor";
			}
			else
			{
				img1 = " 's.svg '";
				q = "Good";
			}
			
		%>
		
		<% 
				if(Math.abs((int) Math.round(Float.valueOf(flow1)) - (int) Math.round(Float.valueOf(flow2))) > 10)
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
        content: '<h2>Node 1</h2>'+'<br><span><strong>Water Quality: <%=q%></strong></span><br> '
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
				content: '<h2>Node 2 </h2>'+'<br><span><strong>Water Quality: - </strong></span>'
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
</body>
<div class="leak">
	<h2>Selected Node : Node 1</h2>
  <h3>Water timing at selected node :</h3>
  <span>
	<% 
			out.println("9:30am - 12:00am");
	%>
  
  </span>
</div>
<div>
  <h3>Water Quality: <%=q%></h3>
  <span>
  Turbidity : <%=tur%>
  
  
  </span>
</div>
<div id="complaint">
<h3>Any Complaint: </h3>
<textarea rows="4" cols="50">
</textarea>
</div>



</html>