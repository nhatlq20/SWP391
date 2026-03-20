package controllers;

import com.google.common.collect.ImmutableList;
import com.google.genai.Client;
import com.google.genai.ResponseStream;
import com.google.genai.types.*;
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

    private static final String API_KEY = "AIzaSyCKbKbDAZoTNHzazpOUbYEk4V_fNa9o9Wg";
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
            Client client = Client.builder().apiKey(API_KEY).build();

            List<Tool> tools = new ArrayList<>();
            tools.add(
                    Tool.builder()
                            .googleSearch(
                                    GoogleSearch.builder().build())
                            .build());

            List<Content> contents = ImmutableList.of(
                    Content.builder()
                            .role("user")
                            .parts(ImmutableList.of(
                                    Part.fromText(userInput)))
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
