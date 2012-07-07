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
		
		var last_dir = "";
		var directory_data;
		var current_dir="";
		
		window.addEventListener("popstate", function(event) { 
				console.log("PopState Fired ! event state :" + event.state);
			
				
				if(event.state==null) 
					current_dir ="";
				else
					current_dir = event.state;
				
				//if(last_dir != "") current_dir = last_dir +"/"+current_dir+"/"
				show_downloads(event.state);
				

				
			}
		);
		
		$(document).ready(function() {
				//history.replaceState({current_path: 'root'}, "Plop");
			
				console.log("Noob");
			}
		);
		
		function load_from_history(pop_event) {
			if(pop_event.state.path != null)
				show_downloads(pop_event.state.path);
		}
		
		function link_for_file(path) {
			if(path.type=="file") {
				var base = current_dir != "" ? current_dir + "/" : "";
				return "<a href=\"/downloads/" + base + encodeURIComponent(path.name) + "\" class=\"file\">" + path.name + "</a>";
			}
			else return path.name;
		}

		function link_for_dir(path) {
			
			if(path.type=="directory") {
				var encoded_path = encodeURIComponent(path.name);
				var base = current_dir != "" ? current_dir + "/" : "";
				return "<a href=\"index.jsp?path="+ base + encoded_path + "\" class=\"directory\">Explore</a>";
			}
			else return "";
		}
		
		function click_handler(event) {
			
			console.log("Click Fired !");
			
			var directory_clicked = $(event.target).attr("href").split("=").pop();
			
			directory_clicked = decodeURIComponent(directory_clicked);
			
			last_dir=current_dir;
			current_dir=directory_clicked;
			show_downloads(directory_clicked);
			
			history.pushState(directory_clicked, event.target.textContent, event.target.href);
			
			return event.preventDefault();
		}
		
		
		function readable_date(timestamp) {
			var date = new Date(timestamp);
			
			var day = date.getDate();
			day = day<10 ? '0'+day : day;
			
			var month = date.getMonth() + 1;
			month = month<10 ? '0'+month : month;
			
			var year  = date.getFullYear();
			
			var hours  = date.getHours();
			hours = hours<10 ? '0'+hours : hours;
			
			var minutes = date.getMinutes();
			minutes = minutes<10 ? '0'+minutes : minutes;
			
			
			return day+'/'+month+'/'+year+' '+hours+':'+minutes
		}
		
		function show_downloads(dir) {
		
			if(dir==null) dir='<%
					String path = request.getParameter("path");
					out.print(path==null ? "" : path); 
					%>';
			
			last_dir = dir;
			
			$.getJSON("/DownloadInterface-0.0.1-SNAPSHOT/DirectoryListingProvider", { path: dir }, 
				function(data) {

				directory_data = data;
				$("tr.path_entry").remove();
					
					$.each(data, function(index, path) { 
							var last_line = $("#directory_list").append("<tr class=\"path_entry\"></tr>").children().children(':last-child');
							
							last_line.
								append("<td>" + link_for_file(path) + "</td>").
								append("<td>" + readable_date(path.date) + "</td>").
								append("<td>" + path.size + "</td>").
								append("<td>" + link_for_dir(path) + "</td>").
								append("<td></td>");
						}
					);
					$("a.directory").bind('click', click_handler);
				}
			);
			
			//alert("Noob !");
		}
		
		function sort() {
			
		}
		
		
		//history.replaceState(current_dir, document.title, document.location.href);
		
		
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
						<li><a href="javascript:show_downloads('');">Downloads list</a></li>
						<li>Add a download</li>
					</ul>
				</td>
				<td style="background-color:#EEEEEE;width:100%;text-align:top;"> <!-- Content : 80% -->
					<div id="content">
						<table id="directory_list">
							<tr>
								<th>File/Directory name</th>
								<th>Date</th>
								<th>Size</th>
								<th></th>
								<th></th>
							</tr>
						</table>
					</div>
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