package fr.team0w.dl_iface.servlet;

import java.io.File;
import java.io.IOException;
import java.nio.file.DirectoryStream;
import java.nio.file.FileSystem;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * Servlet implementation class DirectoryListingProvider
 */
@WebServlet("/DirectoryListingProvider")
public class DirectoryListingProvider extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String ROOT = "/var/lib/transmission-daemon/downloads/";
      
	//private static final String ROOT = "C:\\Users\\Nic0w\\Videos";
	private final FileSystem defaultFileSystem;
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DirectoryListingProvider() {
        super();
        this.defaultFileSystem = FileSystems.getDefault();
    }

    private Path requestedPath(HttpServletRequest request) {
    	String requestedPath =  request.getParameter("path");
		requestedPath = requestedPath == null ? "" : requestedPath;
		
		return this.defaultFileSystem.getPath(ROOT, requestedPath);
    }
    
    private DirectoryStream<Path> directoryStreamFor(Path p) throws IOException {
    	return Files.newDirectoryStream(p);
    }
    
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		File fileObject;
		String type;
		JSONObject object;
		JSONArray array = new JSONArray();
		
		for(Path element : directoryStreamFor(requestedPath(request))) {
			
			object = new JSONObject();
			
			Path file = element.getFileName();
			try {
				object.accumulate("name", file.toString());
				
				fileObject = element.toFile();
				object.accumulate("size", fileObject.length());
				if(fileObject.isFile()) {
					type = "file";
					//object.append("size", fileObject.length());
				}
				else {
					type = "directory";
				}
				object.accumulate("type", type);
				
			} catch (JSONException e) {
				e.printStackTrace();
			}
				
			array.put(object);
		}
		
		try {
			array.write(response.getWriter());
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

}
