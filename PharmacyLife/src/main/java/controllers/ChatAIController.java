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
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "ChatAIController", urlPatterns = { "/chat-ai" })
public class ChatAIController extends HttpServlet {

    private static final String API_KEY = Constants.GEMINI_API_KEY;
    // Gemini 2.5 Flash is the current stable Flash model in 2026.
    private static final String MODEL = "gemini-2.5-flash";

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
            // STEP 1: AI Prompt Construction
            String systemInstruction = "Bạn là dược sĩ trợ lý ảo của nhà thuốc PharmacyLife. "
                    + "Nhiệm vụ của bạn là CHỈ trả lời dựa trên 'DANH MỤC THUỐC' (file dữ liệu) bên dưới. "
                    + "Hãy trả lời một cách chuyên nghiệp, tận tâm, lễ phép và luôn luôn kết thúc bằng lời khuyên khách hàng nên thăm khám bác sĩ nếu triệu chứng nặng.";

            StringBuilder fullInput = new StringBuilder();
            fullInput.append("--- HƯỚNG DẪN HỆ THỐNG ---\n").append(systemInstruction).append("\n\n");

            if (!fileContext.isEmpty()) {
                fullInput.append("--- DANH MỤC THUỐC ---\n").append(fileContext).append("\n\n");
            }

            fullInput.append("Câu hỏi của khách hàng: ").append(userInput);

            Client client = Client.builder().apiKey(API_KEY).build();

            List<Tool> tools = new ArrayList<>();
            tools.add(
                    Tool.builder()
                            .googleSearch(
                                    GoogleSearch.builder().build())
                            .build());

            // Build request with only 'user' role
            List<Content> contents = ImmutableList.of(
                    Content.builder()
                            .role("user")
                            .parts(ImmutableList.of(
                                    Part.fromText(fullInput.toString())))
                            .build());

            GenerateContentConfig config = GenerateContentConfig.builder()
                    .tools(tools)
                    .build();

            ResponseStream<GenerateContentResponse> responseStream = client.models.generateContentStream(MODEL,
                    contents, config);
            StringBuilder fullResponse = new StringBuilder();

            for (GenerateContentResponse res : responseStream) {
                if (res.candidates().isPresent() && !res.candidates().get().isEmpty()) {
                    Content content = res.candidates().get().get(0).content().get();
                    if (content.parts().isPresent()) {
                        List<Part> parts = content.parts().get();
                        for (Part part : parts) {
                            if (part.text().isPresent()) {
                                fullResponse.append(part.text().get());
                            }
                        }
                    }
                }
            }
            responseStream.close();

            response.setContentType("text/plain;charset=UTF-8");
            response.getWriter().write(fullResponse.toString());

        } catch (Exception e) {
            e.printStackTrace();

            // Simple fallback if AI fails or Quota exceeded
            response.setContentType("text/plain;charset=UTF-8");
            response.getWriter().write(
                    "Rất tiếc, AI đang bận hoặc hết lượt tư vấn. Bạn có thể tra cứu thông tin trực tiếp trên website hoặc liên hệ dược sĩ tại quầy để được hỗ trợ nhanh nhất!");
        }
    }
}
