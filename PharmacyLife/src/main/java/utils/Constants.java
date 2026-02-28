package utils;

import io.github.cdimascio.dotenv.Dotenv;

public class Constants {

   private static final Dotenv dotenv = Dotenv.configure()
        .filename("Google.env")
        .ignoreIfMissing()
        .ignoreIfMalformed()
        .load();

    public static final String GOOGLE_CLIENT_ID = dotenv.get("GOOGLE_CLIENT_ID");
    public static final String GOOGLE_CLIENT_SECRET = dotenv.get("GOOGLE_CLIENT_SECRET");

    public static final String GOOGLE_REDIRECT_URI = "http://localhost:8080/pharmacy/login";
    public static final String GOOGLE_LINK_GET_TOKEN = "https://accounts.google.com/o/oauth2/token";
    public static final String GOOGLE_LINK_GET_USER_INFO = "https://www.googleapis.com/oauth2/v1/userinfo?access_token=";
}