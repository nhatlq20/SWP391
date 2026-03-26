package controllers;

import com.google.common.collect.ImmutableList;
import com.google.genai.Client;
import com.google.genai.ResponseStream;
import com.google.genai.types.*;
import utils.Constants;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ChatAIController", urlPatterns = { "/chat-ai" })
public class ChatAIController extends HttpServlet {

    private static final String API_KEY = Constants.GEMINI_API_KEY;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String userInput = request.getParameter("message");

        if (userInput == null || userInput.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Message is empty");
            return;
        }

        String fileContext = "";

        // Read the local knowledge base file (Static data)
        try {
            String filePath = request.getServletContext().getRealPath("/WEB-INF/classes/medicine_data.txt");
            // If running in dev environment, try the absolute path the user provided
            if (filePath == null) {
                filePath = "d:\\SWP391\\SWP391\\SWP391\\PharmacyLife\\src\\main\\resources\\medicine_data.txt";
            }
            java.nio.file.Path path = java.nio.file.Paths.get(filePath);
            if (java.nio.file.Files.exists(path)) {
                fileContext = java.nio.file.Files.readString(path, java.nio.charset.StandardCharsets.UTF_8);
            }
        } catch (Exception e) {
            System.err.println("Warning: Could not read medicine_data.txt: " + e.getMessage());
        }

        try {
            // 1. GENERATIVE AI CONSULTATION (RAG)
            String prompt = "Bạn là Dược sĩ ảo tại PharmacyLife. "
                    + "Hãy dùng DANH MỤC THUỐC này để tư vấn khách hàng: \n\n" + fileContext
                    + "\n\nKhách hỏi: " + userInput
                    + "\n(Trả lời lịch sự, chuyên nghiệp, khuyên đi khám nếu bệnh nặng)";

            Client client = Client.builder().apiKey(API_KEY).build();
            List<Content> contents = ImmutableList.of(
                    Content.builder().role("user").parts(ImmutableList.of(Part.fromText(prompt))).build());

            // Using gemini-1.5-flash for speed/cost efficiency
            ResponseStream<GenerateContentResponse> responseStream = client.models
                    .generateContentStream("gemini-1.5-flash", contents, null);
            StringBuilder aiReply = new StringBuilder();
            for (GenerateContentResponse res : responseStream) {
                res.candidates().ifPresent(c -> c.get(0).content().ifPresent(
                        cnt -> cnt.parts().ifPresent(ps -> ps.forEach(p -> p.text().ifPresent(aiReply::append)))));
            }
            responseStream.close();

            response.setContentType("text/plain;charset=UTF-8");
            response.getWriter().write(aiReply.toString());

        } catch (Exception e) {
            // 2. LOCAL FALLBACK (If AI service is down)
            StringBuilder matches = new StringBuilder();
            String[] queryWords = userInput.toLowerCase().split("\\s+");
            List<String> keySymptoms = new java.util.ArrayList<>();
            String fillers = " tôi mình bạn mua thuốc cái cho bị đang là có một những ";
            for (String w : queryWords)
                if (w.length() >= 2 && !fillers.contains(" " + w + " "))
                    keySymptoms.add(w);
            if (keySymptoms.isEmpty())
                keySymptoms.add(userInput.toLowerCase());

            String[] lines = fileContext.split("\n");
            int found = 0;
            for (String line : lines) {
                if (line.contains("|")) {
                    for (String part : keySymptoms) {
                        String regex = "(?i).*(\\s|^|[.,/!?;:|])" + java.util.regex.Pattern.quote(part)
                                + "(\\s|$|[.,/!?;:|]).*";
                        if (line.toLowerCase().matches(regex)) {
                            String[] p = line.split("\\|");
                            if (p.length >= 5) {
                                matches.append("💊 ").append(p[1]).append(" (").append(p[2]).append(")\n");
                                matches.append("   - Công dụng: ").append(p[4]).append("\n");
                                matches.append("   - Giá bán: ").append(p[5]).append("\n\n");
                                found++;
                                break;
                            }
                        }
                    }
                }
                if (found >= 5)
                    break;
            }

            response.setContentType("text/plain;charset=UTF-8");
            if (matches.length() > 0) {
                response.getWriter().write("⚠️ Hệ thống bận, tôi đã tra cứu nhanh cho bạn:\n\n" + matches.toString());
            } else {
                String in = userInput.toLowerCase();
                if (in.contains("chào") || in.contains("hi"))
                    response.getWriter()
                            .write("Chào bạn! Tôi có thể giúp bạn tra cứu thuốc theo triệu chứng (vd: ho, sốt) nhé!");
                else
                    response.getWriter()
                            .write("Hiện tại tôi đang bận, vui lòng thử lại sau hoặc liên hệ dược sĩ trực tiếp!");
            }
        }
    }
}
