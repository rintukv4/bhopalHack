<html>
<head>
</head>
<%@ page import ="java.sql.*" %>
<%@ page import ="javax.sql.*" %>
<body>
<!-- <%! String userName, userPsw; %>  -->
<%
String user=request.getParameter("user1");
//session.putValue("user",user);
String pass=request.getParameter("pass1");
String test = "test";

if(user.equals(test) && pass.equals("1234"))
{
	response.sendRedirect("../admin/user.jsp");
}
else{
	Class.forName("com.mysql.jdbc.Driver");
java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bhack","root","");

Statement st= con.createStatement();
ResultSet rs=st.executeQuery("select * from userbase");
while(rs.next())
	{
		String userName = rs.getString("user");
		String userPsw = rs.getString("pass");
		
		if(user.equals(userName) && pass.equals(userPsw))
		{
				response.sendRedirect("../admin/index.jsp");				
				
				
		} 
		else{
		out.print("INVALID Credentials Go back and Try again");
	}
	}
	
	
}


%>
</body>
</html>