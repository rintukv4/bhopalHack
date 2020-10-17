<html>
<title>
  Reg Page
</title>
<body>
<h1 align="center"><b>Value IR</b></h1>
<%
String flow =request.getParameter("value");
%>
<button name="start" type="button" onclick="location.href='log.jsp'">Refresh</button>
<div class="marginTable" data-pubid="<%=flow%>" data-count="5"></div>
<style>
  canvas{
    border:1px solid black;
  position: center;
    top: 50%;
    left: 0%;
    margin-left: -320px;
    margin-top: -320px;
  }
  button{
    position:center; 
    margin-left:45%;   
    width:150px;
    bottom:280px;
  }
</style>

</body>
</html>