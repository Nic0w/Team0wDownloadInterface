<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		
		<title>Team0w Downloading Interface</title>
		
		<link type="text/css" href="css/smoothness/jquery-ui-1.8.20.custom.css" rel="stylesheet" />	

		<script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
		<script type="text/javascript" src="js/jquery-ui-1.8.20.custom.min.js"></script>
		<script type="text/javascript">
		
		var default_dir = "root";
		
		var pwet=3;
		
		var content_div = $("#content");
		
		function show_downloads() {
			
			$.getJSON("/DownloadInterface/DirectoryListingProvider", function(data) {
				
					$("#content").html("<table id=\"directory_list\"></table>");
					
					pwet = data;
					
					$.each(data, function(index, path) { 
							var last_line = $("#directory_list").append("<tr></tr>").children().children(':last-child');
							last_line.append("<td>" + path.name + "</td>");
							last_line.append("<td>" + path.size + "</td>");
							last_line.append("<td>Noob remove</td>");
						}
					);
					/*for(var path in data) {
						
						var last_line = $("#directory_list").append("<tr></tr>").children().children(':last-child');
						
						last_line.append("<td>" + path.name + "</td>");
						last_line.append("<td>" + path.size + "</td>");
						last_line.append("<td>Noob remove</td>");
					}*/
					
				}
			);
			
			alert("Noob !");
		}
		
		
		</script>
	</head>
	
	<body>
	
		<table width="100%" height="100%" border="0">
			<tr> <!-- Header : first line of the table -->
				<td colspan="2" style="background-color:#FFA500;">
					<h1>Team0w Download Interface</h1>
				</td>
			</tr>
			<tr valign="top"> <!-- Menu and content : second line of the table -->
				<td style="background-color:#FFD700;width:20%;text-align:top;"> <!-- Menu : 20% -->
					<b>Menu :</b>
					<ul>
						<li><a href="javascript:show_downloads();">Downloads list</a></li>
						<li>Add a download</li>
					</ul>
				</td>
				<td style="background-color:#EEEEEE;width:100%;text-align:top;"> <!-- Content : 80% -->
					<div id="content">Content goes here</div>
				</td>
			</tr>
			<tr> <!-- Footer : third line of the table -->
				<td colspan="2" style="background-color:#FFA500;text-align:center;">
					Copyright © Team0w.fr - Nic0w</td>
			</tr>
		</table>
	
		<%
		
			//out.println("Hello world in JSP, bitches !");
		%>
	</body>
</html>