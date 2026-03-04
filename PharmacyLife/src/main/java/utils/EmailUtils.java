package utils;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;
import java.util.Random;

public class EmailUtils {

    private static final String HOST = "smtp.gmail.com";
    private static final String PORT = "587"; // Use 587 for STARTTLS
    private static final String EMAIL = "pharmacylifeg2@gmail.com";
    private static final String PASSWORD = "oeer qkry weja mbkk";

    public static String generateOTP() {
        Random random = new Random();
        int otp = 100000 + random.nextInt(900000);
        return String.valueOf(otp);
    }

    public static boolean sendOTPEmail(String toEmail, String otp, String action) {
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

            String actionText = "";
            switch (action) {
                case "register":
                    actionText = "hoàn tất đăng ký tài khoản";
                    break;
                case "change-email":
                    actionText = "xác thực việc đổi địa chỉ email (email cũ)";
                    break;
                case "verify-new-email":
                    actionText = "xác thực địa chỉ email mới của bạn";
                    break;
                default:
                    actionText = "hoàn tất thủ tục thay đổi mật khẩu";
                    break;
            }

            String htmlContent = "<div style=\"font-family: Helvetica,Arial,sans-serif;min-width:1000px;overflow:auto;line-height:2\">"
                    + "  <div style=\"margin:50px auto;width:70%;padding:20px 0\">"
                    + "    <div style=\"border-bottom:1px solid #eee\">"
                    + "      <a href=\"\" style=\"font-size:1.4em;color: #4F81E1;text-decoration:none;font-weight:600\">PharmacyLife</a>"
                    + "    </div>"
                    + "    <p style=\"font-size:1.1em\">Xin chào,</p>"
                    + "    <p>Cảm ơn bạn đã lựa chọn PharmacyLife. Sử dụng mã OTP sau đây để " + actionText + ". Mã OTP có hiệu lực trong vòng 5 phút.</p>"
                    + "    <h2 style=\"background: #4F81E1;margin: 0 auto;width: max-content;padding: 0 10px;color: #fff;border-radius: 4px;\">" + otp + "</h2>"
                    + "    <p style=\"font-size:0.9em;\">Trân trọng,<br />Đội ngũ PharmacyLife</p>"
                    + "    <hr style=\"border:none;border-top:1px solid #eee\" />"
                    + "    <div style=\"float:right;padding:8px 0;color:#aaa;font-size:0.8em;line-height:1;font-weight:300\">"
                    + "      <p>PharmacyLife Inc</p>"
                    + "      <p>123 Nguyen Van Cu Street, Can Tho, Viet Nam</p>"
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

    public static boolean sendOTPEmail(String toEmail, String otp) {
        return sendOTPEmail(toEmail, otp, "reset");
    }

    public static boolean sendStaffAccountEmail(String toEmail, String fullName, String password) {
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
            message.setFrom(new InternetAddress(EMAIL, "PharmacyLife HR"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Thông báo cấp tài khoản nhân viên - PharmacyLife");

            String htmlContent = "<div style=\"font-family: Helvetica,Arial,sans-serif;min-width:1000px;overflow:auto;line-height:2\">"
                    + "  <div style=\"margin:50px auto;width:70%;padding:20px 0\">"
                    + "    <div style=\"border-bottom:1px solid #eee\">"
                    + "      <a href=\"\" style=\"font-size:1.4em;color: #00466a;text-decoration:none;font-weight:600\">PharmacyLife</a>"
                    + "    </div>"
                    + "    <p style=\"font-size:1.1em\">Xin chào " + fullName + ",</p>"
                    + "    <p>Chào mừng bạn đã gia nhập đội ngũ PharmacyLife. Chúng tôi vui mừng thông báo rằng bạn đã được tiếp nhận làm nhân viên chính thức.</p>"
                    + "    <p>Dưới đây là thông tin tài khoản đăng nhập vào hệ thống quản lý của bạn:</p>"
                    + "    <div style=\"background: #f4f4f4; padding: 15px; border-radius: 5px; margin: 20px 0;\">"
                    + "      <p style=\"margin: 5px 0;\"><strong>Email:</strong> " + toEmail + "</p>"
                    + "      <p style=\"margin: 5px 0;\"><strong>Mật khẩu:</strong> " + password + "</p>"
                    + "    </div>"
                    + "    <p>Vui lòng đăng nhập và đổi mật khẩu ngay trong lần đầu tiên để đảm bảo tính bảo mật.</p>"
                    + "    <p style=\"font-size:0.9em;\">Trân trọng,<br />Ban quản trị PharmacyLife</p>"
                    + "    <hr style=\"border:none;border-top:1px solid #eee\" />"
                    + "    <div style=\"float:right;padding:8px 0;color:#aaa;font-size:0.8em;line-height:1;font-weight:300\">"
                    + "      <p>PharmacyLife Inc</p>"
                    + "      <p>123 Nguyen Van Cu Street, Can Tho, Viet Nam</p>"
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

    public static boolean sendStaffTerminationEmail(String toEmail, String fullName) {
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
            message.setFrom(new InternetAddress(EMAIL, "PharmacyLife HR"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Thông báo dừng hợp tác - PharmacyLife");

            String htmlContent = "<div style=\"font-family: Helvetica,Arial,sans-serif;min-width:1000px;overflow:auto;line-height:2\">"
                    + "  <div style=\"margin:50px auto;width:70%;padding:20px 0\">"
                    + "    <div style=\"border-bottom:1px solid #eee\">"
                    + "      <a href=\"\" style=\"font-size:1.4em;color: #00466a;text-decoration:none;font-weight:600\">PharmacyLife</a>"
                    + "    </div>"
                    + "    <p style=\"font-size:1.1em\">Xin chào " + fullName + ",</p>"
                    + "    <p>Chúng tôi rất tiếc phải thông báo rằng kể từ ngày hôm nay, PharmacyLife sẽ chính thức dừng hợp tác và thu hồi tài khoản nhân viên của bạn trên hệ thống.</p>"
                    + "    <p>Mọi quyền truy cập vào hệ thống nội bộ của bạn đã bị vô hiệu hóa. Vui lòng bàn giao lại các công việc và tài liệu liên quan cho quản lý trực tiếp (nếu có).</p>"
                    + "    <p>Cảm ơn bạn đã đồng hành cùng PharmacyLife trong thời gian qua. Chúc bạn gặp nhiều may mắn trong hành trình sắp tới.</p>"
                    + "    <p style=\"font-size:0.9em;\">Trân trọng,<br />Ban quản trị PharmacyLife</p>"
                    + "    <hr style=\"border:none;border-top:1px solid #eee\" />"
                    + "    <div style=\"float:right;padding:8px 0;color:#aaa;font-size:0.8em;line-height:1;font-weight:300\">"
                    + "      <p>PharmacyLife Inc</p>"
                    + "      <p>123 Nguyen Van Cu Street, Can Tho, Viet Nam</p>"
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
