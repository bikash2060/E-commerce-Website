package controller.servlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import utils.StringUtils;

@WebServlet(asyncSupported = true, urlPatterns = StringUtils.LOGOUT_SERVLET)
public class LogoutServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public LogoutServlet() {
        super();
    }

    /*
     * This method handles the logout process when a user submits a logout request via an HTTP POST request.
     * It retrieves cookies from the request, invalidates session if it exists
     * Then it removes cookies by setting their max age to 0 and redirects the user to the index page after logout.
    */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
    	Cookie[] cookies = request.getCookies();
		if (cookies != null) {
			for (Cookie cookie : cookies) {
				cookie.setMaxAge(0);
				response.addCookie(cookie);
			}
		}
		
		HttpSession session = request.getSession(false);
		if (session != null) {
			session.invalidate();
		}
		response.sendRedirect(request.getContextPath() + StringUtils.INDEX_URL);
	}

}
