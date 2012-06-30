package fr.team0w.dl_iface.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.catalina.comet.CometEvent;
import org.apache.catalina.comet.CometProcessor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import ch.qos.logback.classic.Level;

/**
 * Servlet implementation class TransmissionInterface
 */
@WebServlet(description = "Interface the web page with the Transmission daemon running on the server.", urlPatterns = { "/TransmissionInterface" })
public class TransmissionInterface extends HttpServlet implements CometProcessor {
	private static final long serialVersionUID = 1L;
	
	private static final Logger tiLogger = LoggerFactory.getLogger(TransmissionInterface.class);
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public TransmissionInterface() {
        super();
    }

    
	@Override
	public void init() throws ServletException {
		super.init();
		
        ((ch.qos.logback.classic.Logger)
				LoggerFactory.getLogger(Logger.ROOT_LOGGER_NAME)).
					setLevel(Level.ALL);  //Set debug level for the whole programm. Noob
	}
    
    
	/**
     * @see CometProcessor#event(CometEvent)
     */
    public void event(CometEvent event) {
    	HttpServletRequest request = event.getHttpServletRequest();
        HttpServletResponse response = event.getHttpServletResponse();
        
        //request.
        
        tiLogger.debug("evnet received !");
        
        switch(event.getEventType()) {
        
			case BEGIN :
					tiLogger.debug("Connection opened by {}.", request.getRemoteAddr());
				
				break;
			case END :
				tiLogger.debug("Connection closed by {}.", request.getRemoteAddr());
			try {
				event.close();
			} catch (IOException e) {
				tiLogger.error("{}", e);
			}
			finally {
				tiLogger.debug("Connection ended !");
			}
				
				break;
			case ERROR:
				break;
			case READ:
				
				
				//request.getI
				
				//tiLogger.debug("Just read : '{}'.", event.);
				
				break;
        }
    }

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		tiLogger.debug("GET request from {}.", req.getRemoteAddr());
	}


	@Override
	public void destroy() {
		// TODO Auto-generated method stub
		super.destroy();
	}
}
