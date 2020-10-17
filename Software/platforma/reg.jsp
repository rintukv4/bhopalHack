<%@ page import ="java.sql.*" %>
<%@ page import ="javax.sql.*" %>
<html>
<head>
</head>
<body>
<%! int in=1; %>
<%
String user=request.getParameter("user");
//session.putValue("user",user);
String pass=request.getParameter("pass");
String phone=request.getParameter("phone");
String email=request.getParameter("email");
if(!(user.equals(null) || user.equals("")) && !(pass.equals(null) || pass.equals("")) && !(phone.equals(null) || phone.equals("")))
	{

			try{


					Class.forName("com.mysql.jdbc.Driver");
					java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bhack","root","");

					Statement st= con.createStatement();
					ResultSet rs;
					int i=st.executeUpdate("insert into userbase values ('"+in+"','"+user+"','"+pass+"','"+phone+"','"+email+"')");
					in = in+1;
					response.sendRedirect("login.html");
				}
				catch(Exception sq){

			}
		
		}
		else
		{

			%>
			out.println("Error")
			<%

		}


%>
</body>
</html>