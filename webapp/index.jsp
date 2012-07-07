<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		
		<title>Team0w Downloading Interface</title>
		
		<link type="text/css" href="css/smoothness/jquery-ui-1.8.20.custom.css" rel="stylesheet" />	
		<link type="text/css" href="style.css" rel="stylesheet" />	

		<script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
		<script type="text/javascript" src="js/jquery-ui-1.8.20.custom.min.js"></script>
		<script type="text/javascript">
		
		var last_dir = "";
		var directory_data;
		var current_dir="";
		
		$(function() {

		    var $sidebar   = $("#sidebar"), 
		        $window    = $(window),
		        offset     = $sidebar.offset(),
		        topPadding = 15;

		    $window.scroll(function() {
		        if ($window.scrollTop() > offset.top) {
		            $sidebar.stop().animate({
		                marginTop: $window.scrollTop() - offset.top + topPadding
		            }, 0);
		        } else {
		            $sidebar.stop().animate({
		                marginTop: 0
		            }, 0);
		        }
		    });
		    
		});
		
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
		
		function link_for(path) {
			
			var base = current_dir != "" ? current_dir + "/" : "";
			var encoded_pathname = encodeURIComponent(path.name);
			
			if(path.type=="file") {
				return "<a href=\"/downloads/" + base + encoded_pathname + "\" class=\"file\">" + path.name + "</a>";
			}
			else {
				return "<a href=\"index.jsp?path="+ base + encoded_pathname + "\" class=\"directory\">" + path.name + "</a>";
			}
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
		
		
		function build_table(data) {

			directory_data = data;
			$("tr.path_entry").remove();
				
				$.each(data, function(index, path) { 
						var last_line = $("#directory_list").append("<tr class=\"path_entry\"></tr>").children(':last-child');
						
						last_line.
							append("<td class=\"link\">" + link_for(path) + "</td>").
							append("<td class=\"date\">" + readable_date(path.date) + "</td>").
							append("<td class=\"type\">"+ (path.type=="file" ? "File" : "Directory") + "</td>").
							append("<td class=\"size\">" + path.size + "</td>").
							append("<td></td>");
					}
				);
				$("a.directory").bind('click', click_handler);
			}
		
		function show_downloads(dir) {
		
			if(dir==null) dir='<%
					String path = request.getParameter("path");
					out.print(path==null ? "" : path); 
					%>';
			
			last_dir = dir;
			
			$.getJSON("<% out.print(request.getContextPath()); %>/DirectoryListingProvider", { path: dir }, build_table);
			
			//alert("Noob !");
		}
		
		function sort_by(field) {
			var n=directory_data.length;
			var new_n, temp;
			
			do {
				new_n = 0;
				
				for(var i=1;i<n;i++) {
					if(directory_data[i-1][field] > directory_data[i][field]) {
						
						temp = directory_data[i];
						directory_data[i] = directory_data[i-1];
						directory_data[i-1] = temp;

						new_n = i;
					}
				}
				n = new_n;
			}
			while(n!=0);
			
			build_table(directory_data);
		}
		
		
		//history.replaceState(current_dir, document.title, document.location.href);
		
		
		</script>
	</head>
	
	<body>

		<table width="100%" height="100%" border="0">
			<tr> <!-- Header : first line of the table -->
				<td colspan="2" style="background-color:#FFFFFF;">
					<h1>Team0w Download Interface</h1>
				</td>
			</tr>
			<tr valign="top"> <!-- Menu and content : second line of the table -->
				<td style="background-color:#FFFFFF;width:20%;text-align:top;"> <!-- Menu : 20% -->
					<div id="sidebar">	
						<b>Menu :</b>
						<ul>
							<li><a href="javascript:show_downloads('');">Downloads list</a></li>
							<li>Add a download</li>
						</ul>
					</div>
				</td>
				<td style="background-color:#FFFFFF;width:100%;text-align:top;"> <!-- Content : 80% -->
					<div id="content">
						<table id="scrollable_table">
							<thead class="fixed_table_header">
								<tr>
									<th>File/Directory name&nbsp;<img alt="Sort Arrow" src="icon_down_sort_arrow.png" onclick="javascript:sort_by('name');"/> </th>
									<th>Date&nbsp;<img alt="Sort Arrow" src="icon_down_sort_arrow.png" onclick="javascript:sort_by('date');"/></th>
									<th>Type</th>
									<th>Size</th>
									<th></th>
								</tr>
							</thead>
							<tbody id="directory_list"></tbody>
						</table>
					</div>
				</td>
			</tr>
			<tr> <!-- Footer : third line of the table -->
				<td colspan="2" style="background-color:#FFFFFF;text-align:center;">
					Copyright © Team0w.fr - Nic0w</td>
			</tr>
		</table>
	
		<%
		
			//out.println("Hello world in JSP, bitches ! Context path = " +request.getContextPath());
		%>
	</body>
</html>