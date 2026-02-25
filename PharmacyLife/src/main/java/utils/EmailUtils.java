package utils;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;
import java.util.Random;

public class EmailUtils {

    private static final String HOST = "smtp.gmail.com";
    private static final String PORT = "587"; // Use 587 for STARTTLS
    private static final String EMAIL = "phainon33m5@gmail.com";
    private static final String PASSWORD = "qknl cwhu swnr vaod";

    public static String generateOTP() {
        Random random = new Random();
        int otp = 100000 + random.nextInt(900000);
        return String.valueOf(otp);
    }

    public static boolean sendOTPEmail(String toEmail, String otp) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", HOST);
        props.put("mail.smtp.port", PORT);

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL, PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL, "PharmacyLife Support"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Mã xác thực OTP - PharmacyLife");

            String htmlContent = "<div style=\"font-family: Helvetica,Arial,sans-serif;min-width:1000px;overflow:auto;line-height:2\">"
                    + "  <div style=\"margin:50px auto;width:70%;padding:20px 0\">"
                    + "    <div style=\"border-bottom:1px solid #eee\">"
                    + "      <a href=\"\" style=\"font-size:1.4em;color: #00466a;text-decoration:none;font-weight:600\">PharmacyLife</a>"
                    + "    </div>"
                    + "    <p style=\"font-size:1.1em\">Xin chào,</p>"
                    + "    <p>Cảm ơn bạn đã lựa chọn PharmacyLife. Sử dụng mã OTP sau đây để hoàn tất thủ tục thay đổi mật khẩu. Mã OTP có hiệu lực trong vòng 5 phút.</p>"
                    + "    <h2 style=\"background: #00466a;margin: 0 auto;width: max-content;padding: 0 10px;color: #fff;border-radius: 4px;\">" + otp + "</h2>"
                    + "    <p style=\"font-size:0.9em;\">Trân trọng,<br />Đội ngũ PharmacyLife</p>"
                    + "    <hr style=\"border:none;border-top:1px solid #eee\" />"
                    + "    <div style=\"float:right;padding:8px 0;color:#aaa;font-size:0.8em;line-height:1;font-weight:300\">"
                    + "      <p>PharmacyLife Inc</p>"
                    + "      <p>123 Street, City</p>"
                    + "      <p>Vietnam</p>"
                    + "    </div>"
                    + "  </div>"
                    + "</div>";

            message.setContent(htmlContent, "text/html; charset=utf-8");

            Transport.send(message);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
