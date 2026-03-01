package utils;

import io.github.cdimascio.dotenv.Dotenv;

public class Constants {

   private static final Dotenv appDotenv = Dotenv.configure()
       .filename(".env")
        .ignoreIfMissing()
        .ignoreIfMalformed()
        .load();

    public static final String GOOGLE_CLIENT_ID = appDotenv.get("GOOGLE_CLIENT_ID");
    public static final String GOOGLE_CLIENT_SECRET = appDotenv.get("GOOGLE_CLIENT_SECRET");
    public static final String ENV = normalizeEnv(appDotenv.get("ENV", "production"));

    private static final String GOOGLE_REDIRECT_URI_DEV = "http://localhost:8080/pharmacy/login";
    private static final String GOOGLE_REDIRECT_URI_PROD = "https://tactical-miserably-ebony.ngrok-free.dev/pharmacy/login";
    public static final String GOOGLE_REDIRECT_URI = "development".equalsIgnoreCase(ENV)
            ? GOOGLE_REDIRECT_URI_DEV
            : GOOGLE_REDIRECT_URI_PROD;
    public static final String GOOGLE_LINK_GET_TOKEN = "https://accounts.google.com/o/oauth2/token";
    public static final String GOOGLE_LINK_GET_USER_INFO = "https://www.googleapis.com/oauth2/v1/userinfo?access_token=";

    private static String normalizeEnv(String envValue) {
        if (envValue == null) {
            return "production";
        }

        String sanitized = envValue.split("#", 2)[0].trim();
        return sanitized.isEmpty() ? "production" : sanitized;
    }
}