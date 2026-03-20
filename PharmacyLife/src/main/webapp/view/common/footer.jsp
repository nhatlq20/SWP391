<%-- Document : footer Created on : Oct 24, 2025, 10:57:23 AM Author : qnhat --%>

    <%@page pageEncoding="UTF-8" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

                <link rel="stylesheet" href="<c:url value='/assets/css/footer.css'/>">

                <footer class="footer">
                    <div class="footer-container">

                        <!-- Cột 1: Hỗ trợ khách hàng -->
                        <div class="footer-column">
                            <h4>HỖ TRỢ KHÁCH HÀNG</h4>
                            <p>Tư vấn khách hàng (07h30 - 21h30)</p>
                            <p class="hotline">1800 55 88 98 <span>(Nhánh 1)</span></p>
                            <p>Góp ý khiếu nại (08h00 - 17h00)</p>
                            <p class="hotline">1800 55 88 98 <span>(Nhánh 2)</span></p>
                        </div>

                        <!-- Cột 2: Về PharmacyLife -->
                        <div class="footer-column">
                            <h4>VỀ PHARMACYLIFE</h4>
                            <ul>
                                <li><a href="#">Giới thiệu</a></li>
                                <li><a href="#">Tích điểm thành viên</a></li>
                                <li><a href="#">Chính sách bảo mật</a></li>
                                <li><a href="#">Chính sách mua hàng</a></li>
                                <li><a href="#">Chính sách giao hàng</a></li>
                                <li><a href="#">Chính sách đổi trả</a></li>
                                <li><a href="#">Thanh toán & hoàn tiền</a></li>
                                <li><a href="#">Hệ thống cửa hàng</a></li>
                            </ul>
                        </div>

                        <!-- Cột 3: Danh mục -->
                        <div class="footer-column">
                            <h4>DANH MỤC</h4>
                            <ul>
                                <li><a href="#">Thuốc</a></li>
                                <li><a href="#">Thực phẩm chức năng</a></li>
                                <li><a href="#">Mỹ phẩm</a></li>
                                <li><a href="#">Chăm sóc cá nhân</a></li>
                                <li><a href="#">Mẹ & Bé</a></li>
                                <li><a href="#">Thiết bị y tế</a></li>
                                <li><a href="#">Tuyển dụng</a></li>
                            </ul>
                        </div>

                        <!-- Cột 4: Tìm hiểu thêm -->
                        <div class="footer-column">
                            <h4>TÌM HIỂU THÊM</h4>
                            <ul>
                                <li><a href="#">Thông tin bệnh lý</a></li>
                                <li><a href="#">Sức khỏe tổng quát</a></li>
                                <li><a href="#">Chăm sóc mẹ và bé</a></li>
                                <li><a href="#">Ưu đãi & khuyến mãi</a></li>
                                <li><a href="#">Khai trương nhà thuốc</a></li>
                                <li><a href="#">Thông tin tuyển dụng</a></li>
                                <li><a href="#">Hoạt động cộng đồng</a></li>
                            </ul>
                        </div>
                    </div>


                </footer>

                <c:set var="role" value="${fn:toLowerCase(fn:trim(sessionScope.roleName))}" />
                <c:if test="${role ne 'admin' and role ne 'staff'}">

                    <!-- AI Chatbot Launcher -->
                    <div id="chat-launcher" onclick="toggleChatWindow()">
                        <img src="${pageContext.request.contextPath}/assets/img/banner/chatbox.png" alt="AI Chat">
                    </div>

                    <!-- AI Chatbot Window -->
                    <div id="chat-window" class="hidden">
                        <div class="chat-header">
                            <div class="d-flex align-items-center">
                                <img src="${pageContext.request.contextPath}/assets/img/banner/chatbox.png" alt="Logo"
                                    class="chat-logo">
                                <span>Pharmacy Life AI</span>
                            </div>
                            <button onclick="toggleChatWindow()">×</button>
                        </div>
                        <div class="chat-body" id="chatBody">
                            <div class="chat-placeholder" id="chatPlaceholder">
                                👋 Chào bạn! Tôi là trợ lý AI của Pharmacy Life. <br>
                                Tôi có thể giúp gì được cho bạn?
                            </div>
                        </div>
                        <div class="chat-footer">
                            <input type="text" id="chatInput" placeholder="Nhập tin nhắn..."
                                onkeypress="handleKeyPress(event)">
                            <button onclick="sendMessage()">
                                <i class="fas fa-paper-plane"></i>
                            </button>
                        </div>
                    </div>

                    <script>
                        function toggleChatWindow() {
                            const chatWindow = document.getElementById('chat-window');
                            chatWindow.classList.toggle('show');
                            chatWindow.classList.toggle('hidden');
                        }

                        function handleKeyPress(e) {
                            if (e.key === 'Enter') {
                                sendMessage();
                            }
                        }

                        function sendMessage() {
                            const input = document.getElementById('chatInput');
                            const message = input.value.trim();
                            if (!message) return;

                            // Clear input
                            input.value = '';

                            // Hide placeholder
                            const placeholder = document.getElementById('chatPlaceholder');
                            if (placeholder) placeholder.style.display = 'none';

                            // Add user message to UI
                            appendMessage('user', message);

                            // Add typing indicator
                            const typingId = 'typing-' + Date.now();
                            appendTypingIndicator(typingId);

                            // Send to backend
                            const formData = new URLSearchParams();
                            formData.append('message', message);

                            fetch('${pageContext.request.contextPath}/chat-ai', {
                                method: 'POST',
                                body: formData,
                                headers: {
                                    'Content-Type': 'application/x-www-form-urlencoded'
                                }
                            })
                                .then(response => response.text())
                                .then(data => {
                                    removeTypingIndicator(typingId);
                                    appendMessage('ai', data);
                                })
                                .catch(error => {
                                    removeTypingIndicator(typingId);
                                    appendMessage('ai', 'Xin lỗi, có lỗi xảy ra. Vui lòng thử lại sau.');
                                    console.error('Chat AI Error:', error);
                                });
                        }

                        function appendMessage(role, text) {
                            const chatBody = document.getElementById('chatBody');
                            const messageDiv = document.createElement('div');
                            messageDiv.className = 'chat-message ' + role;

                            const bubble = document.createElement('div');
                            bubble.className = 'bubble';
                            bubble.innerText = text;

                            messageDiv.appendChild(bubble);
                            chatBody.appendChild(messageDiv);

                            // Scroll to bottom
                            chatBody.scrollTop = chatBody.scrollHeight;
                        }

                        function appendTypingIndicator(id) {
                            const chatBody = document.getElementById('chatBody');
                            const typingDiv = document.createElement('div');
                            typingDiv.className = 'chat-message ai';
                            typingDiv.id = id;

                            const bubble = document.createElement('div');
                            bubble.className = 'bubble';
                            bubble.innerHTML = '<span class="chat-typing"></span><span class="chat-typing" style="animation-delay: 0.2s"></span><span class="chat-typing" style="animation-delay: 0.4s"></span>';

                            typingDiv.appendChild(bubble);
                            chatBody.appendChild(typingDiv);
                            chatBody.scrollTop = chatBody.scrollHeight;
                        }

                        function removeTypingIndicator(id) {
                            const el = document.getElementById(id);
                            if (el) el.remove();
                        }
                    </script>
                </c:if>