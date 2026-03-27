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

/* Controller for handling AI-powered pharmacy consultation and search queries. */
@WebServlet(name = "ChatAIController", urlPatterns = { "/chat-ai" })
public class ChatAIController extends HttpServlet {

    private static final String API_KEY = Constants.GEMINI_API_KEY; // API Key for Google Gemini model

    /*
     * Processes chat messages from users, using AI consultation with a local RAG
     * fallback.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String userInput = request.getParameter("message");

        // Validate user input
        if (userInput == null || userInput.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Message is empty");
            return;
        }

        String fileContext = "";

        // Attempt to load the knowledge base from a local text file
        try {
            String filePath = request.getServletContext().getRealPath("/WEB-INF/classes/medicine_data.txt");
            if (filePath == null) {
                // Absolute path fallback for local development environments
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
            // STEP 1: GENERATIVE AI CONSULTATION (using RAG)
            // System prompt instructing the AI to act as a pharmacist
            String prompt = "You are a virtual Pharmacist at PharmacyLife. "
                    + "Use this MEDICINE CATALOG to advise the customer: \n\n" + fileContext
                    + "\n\nCustomer question: " + userInput
                    + "\n(Reply politely and professionally. Advise seeing a doctor for serious symptoms.)";

            Client client = Client.builder().apiKey(API_KEY).build();
            List<Content> contents = ImmutableList.of(
                    Content.builder().role("user").parts(ImmutableList.of(Part.fromText(prompt))).build());

            // Utilize gemini-1.5-flash for optimized performance and cost efficiency
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
            // STEP 2: LOCAL RULE-BASED FALLBACK (If AI service is unavailable)
            StringBuilder matches = new StringBuilder();
            String[] queryWords = userInput.toLowerCase().split("\\s+");
            List<String> keySymptoms = new java.util.ArrayList<>();
            // Filtering common stop words in Vietnamese
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
                        // Regex matching for symptom keywords in the catalog data
                        String regex = "(?i).*(\\s|^|[.,/!?;:|])" + java.util.regex.Pattern.quote(part)
                                + "(\\s|$|[.,/!?;:|]).*";
                        if (line.toLowerCase().matches(regex)) {
                            String[] p = line.split("\\|");
                            if (p.length >= 5) {
                                matches.append("💊 ").append(p[1]).append(" (").append(p[2]).append(")\n");
                                matches.append("   - Use: ").append(p[4]).append("\n");
                                matches.append("   - Price: ").append(p[5]).append("\n\n");
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
                response.getWriter()
                        .write("⚠️ System busy. Here are quick look-up results for you:\n\n" + matches.toString());
            } else {
                String in = userInput.toLowerCase();
                // Basic greeting handling
                if (in.contains("hello") || in.contains("hi") || in.contains("chào"))
                    response.getWriter()
                            .write("Hello! I can help you search for medicines by symptoms (e.g., cough, fever).");
                else
                    response.getWriter()
                            .write("I'm currently busy. Please try again later or contact our pharmacist directly!");
            }
        }
    }
}
