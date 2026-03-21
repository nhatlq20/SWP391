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

        try {
            // STEP 1: Search for relevant medicines from the database (RAG)
            dao.MedicineDAO medicineDAO = new dao.MedicineDAO();
            String dbContext = medicineDAO.searchMedicineByKeyword(userInput);

            // STEP 2: Configure system prompt and context
            String systemInstruction = "Bạn là dược sĩ trợ lý ảo của nhà thuốc PharmacyLife. "
                    + "Tên của bạn là 'Dược sĩ AI'. "
                    + "Hãy ưu tiên sử dụng 'DỮ LIỆU HỆ THỐNG' bên dưới để trả lời chính xác về tên thuốc, giá cả và công dụng. "
                    + "Nếu dữ liệu không có, hãy trả lời theo kiến thức y khoa chung nhưng luôn bắt đầu bằng: 'Dựa trên kiến thức y khoa chung, ...' "
                    + "và kết thúc bằng lời khuyên khách hàng nên thăm khám bác sĩ. "
                    + "Hãy trả lời một cách chuyên nghiệp, tận tâm và lễ phép.";

            // Combine System instruction and user message into one prompt to avoid
            // role('system') error
            StringBuilder fullInput = new StringBuilder();
            fullInput.append("--- HƯỚNG DẪN HỆ THỐNG ---\n")
                    .append(systemInstruction)
                    .append("\n-------------------------\n\n");

            if (dbContext != null && !dbContext.isEmpty()) {
                fullInput.append("--- DỮ LIỆU HỆ THỐNG ---\n")
                        .append(dbContext)
                        .append("\n------------------------\n\n");
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
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Lỗi hệ thống AI: " + e.getMessage());
        }
    }
}
