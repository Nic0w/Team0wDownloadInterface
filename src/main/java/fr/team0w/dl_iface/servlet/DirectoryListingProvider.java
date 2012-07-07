package fr.team0w.dl_iface.servlet;

import java.io.File;
import java.io.IOException;
import java.nio.file.DirectoryStream;
import java.nio.file.FileSystem;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;

import javax.annotation.Nullable;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.google.common.base.Function;
import com.google.common.collect.Iterables;
import com.google.common.collect.Iterators;

/**
 * Servlet implementation class DirectoryListingProvider
 */
@WebServlet("/DirectoryListingProvider")
public class DirectoryListingProvider extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String ROOT = "/var/lib/transmission-daemon/downloads/";
      
	//private static final String ROOT = "C:\\Users\\Nic0w\\Videos";
	
	private final FileSystem defaultFileSystem;
	private final DateFormat shortDate;
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DirectoryListingProvider() {
        super();
        
        this.defaultFileSystem = FileSystems.getDefault();
        this.shortDate = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    }

    private Path requestedPath(HttpServletRequest request) {
    	String requestedPath =  request.getParameter("path");
		requestedPath = requestedPath == null ? "" : requestedPath;
		
		return this.defaultFileSystem.getPath(ROOT, requestedPath);
    }
    
    private DirectoryStream<Path> directoryStreamFor(Path p) throws IOException {
    	return Files.newDirectoryStream(p);
    }
    
    private String formatSize(File file) {
    	if(file.isFile()) {
    		
    		long fileSize = file.length();
    		int power = (int) Math.log10(fileSize);
    		int divisor = 0;
    		String unit = "B";
    		
    		if(power>2)  { unit ="KB"; divisor = 3; }
    		if(power>5)  { unit ="MB"; divisor = 6; }
    		if(power>8)  { unit ="GB"; divisor = 9; }
    		if(power>11) { unit ="TB"; divisor = 12; }
    		
    		divisor = (int) Math.pow(10, divisor);
    		
    		return String.format("%d %s", fileSize / divisor, unit);
    	}
    	else 
    		return "";
    }
    
    
    private Iterable<JSONObject> toJSON(DirectoryStream<Path> pathStream) {
    
    	return Iterables.transform(pathStream, new Function<Path, JSONObject>() {
				@Nullable
				public JSONObject apply(@Nullable Path path) {
					String type, size;
					File file = path.toFile();
					JSONObject jsonifiedFile = new JSONObject();
					
					try {
						jsonifiedFile.
							accumulate("name", path.getFileName().toString()).
							accumulate("size", formatSize(file)).
							accumulate("date", file.lastModified()).
							accumulate("type", file.isFile() ? "file" : "directory");
					} catch (JSONException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					return jsonifiedFile;
				}
			}
    	);

    }
    
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		File fileObject;
		String type;
		JSONObject object;
		JSONArray array = new JSONArray();
		
		for(JSONObject element : toJSON(directoryStreamFor(requestedPath(request)))) {
		
				
			array.put(element);
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
