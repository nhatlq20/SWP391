package utils;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;
import java.util.Random;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class EmailUtils {

    private static final String HOST = "smtp.gmail.com";
    private static final String PORT = "587";
    private static final String EMAIL = "pharmacylifeg2@gmail.com";
    private static final String PASSWORD = "oeer qkry weja mbkk";

    private static final ExecutorService executor = Executors.newFixedThreadPool(5);

    private static final Properties props = new Properties();

    static {
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", HOST);
        props.put("mail.smtp.port", PORT);
        props.put("mail.smtp.connectiontimeout", "10000");
        props.put("mail.smtp.timeout", "10000");
        props.put("mail.smtp.writetimeout", "10000");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
    }

    private static final Session session = Session.getInstance(props, new Authenticator() {
        @Override
        protected PasswordAuthentication getPasswordAuthentication() {
            return new PasswordAuthentication(EMAIL, PASSWORD);
        }
    });

    // ================= OTP =================
    public static String generateOTP() {
        Random random = new Random();
        int otp = 100000 + random.nextInt(900000);
        return String.valueOf(otp);
    }

    public static boolean sendOTPEmail(String toEmail, String otp, String action) {
        executor.submit(() -> {
            try {
                Message message = new MimeMessage(session);
                message.setFrom(new InternetAddress(EMAIL, "PharmacyLife Support", "UTF-8"));
                message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
                message.setSubject("Mã xác thực OTP - PharmacyLife"); // FIX

                String actionText;
                switch (action) {
                    case "register":
                        actionText = "hoàn tất đăng ký tài khoản";
                        break;
                    case "change-email":
                        actionText = "xác thực việc đổi email";
                        break;
                    case "verify-new-email":
                        actionText = "xác thực email mới";
                        break;
                    default:
                        actionText = "đổi mật khẩu";
                        break;
                }

                String textContent = "Xin chào,\n\n"
                        + "Sử dụng mã OTP sau để " + actionText + ".\n\n"
                        + "OTP: " + otp + "\n\n"
                        + "Mã có hiệu lực trong 5 phút.\n\n"
                        + "Trân trọng,\n"
                        + "PharmacyLife";

                message.setContent(textContent, "text/plain; charset=UTF-8");

                Transport.send(message);
                System.out.println("OTP email sent to " + toEmail);

            } catch (Exception e) {
                e.printStackTrace();
            }
        });
        return true;
    }

    public static boolean sendOTPEmail(String toEmail, String otp) {
        return sendOTPEmail(toEmail, otp, "reset");
    }

    // ================= STAFF ACCOUNT =================
    public static boolean sendStaffAccountEmail(String toEmail, String fullName, String password) {
        executor.submit(() -> {
            try {
                Message message = new MimeMessage(session);
                message.setFrom(new InternetAddress(EMAIL, "PharmacyLife HR", "UTF-8"));
                message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
                message.setSubject("Cấp tài khoản nhân viên - PharmacyLife"); // FIX

                String textContent = "Xin chào " + fullName + ",\n\n"
                        + "Bạn đã trở thành thành viên của PharmacyLife chúng tôi, tài khoản nhân viên được cấp:\n"
                        + "Email: " + toEmail + "\n"
                        + "Mật khẩu: " + password + "\n\n"
                        + "Vui lòng đổi mật khẩu sau khi đăng nhập.\n\n"
                        + "Trân trọng,\nPharmacyLife";

                message.setContent(textContent, "text/plain; charset=UTF-8");

                Transport.send(message);
                System.out.println("Staff account email sent");

            } catch (Exception e) {
                e.printStackTrace();
            }
        });
        return true;
    }

    // ================= TERMINATION =================
    public static boolean sendStaffTerminationEmail(String toEmail, String fullName) {
        executor.submit(() -> {
            try {
                Message message = new MimeMessage(session);
                message.setFrom(new InternetAddress(EMAIL, "PharmacyLife HR", "UTF-8"));
                message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
                message.setSubject("Dừng hợp tác - PharmacyLife"); // FIX

                String textContent = "Xin chào " + fullName + ",\n\n"
                        + "Tài khoản của bạn đã bị thu hồi.\n\n"
                        + "Cảm ơn bạn đã đồng hành cùng PharmacyLife.\n\n"
                        + "Trân trọng,\nPharmacyLife";

                message.setContent(textContent, "text/plain; charset=UTF-8");

                Transport.send(message);
                System.out.println("Termination email sent");

            } catch (Exception e) {
                e.printStackTrace();
            }
        });
        return true;
    }
}