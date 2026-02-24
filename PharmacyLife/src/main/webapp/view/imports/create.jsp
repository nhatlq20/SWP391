<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <title>Tạo phiếu nhập thuốc</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/import.css">
            </head>

            <body>
                <%@include file="header.jsp" %>

                    <div class="container">
                        <%@include file="sidebar.jsp" %>

                            <div class="main-content">
                                <div class="page-title">
                                    <i>📥</i>
                                    <span>Quản lý nhập thuốc</span>
                                </div>

                                <c:if test="${not empty error}">
                                    <div
                                        style="background-color: #f8d7da; color: #721c24; padding: 15px; border-radius: 5px; margin-bottom: 20px;">
                                        ${error}
                                    </div>
                                </c:if>

                                <!-- Main Form -->
                                <form method="POST" action="${pageContext.request.contextPath}/ImportController"
                                    id="importForm">
                                    <input type="hidden" name="action" value="create">
                                    <input type="hidden" name="importCode"
                                        value="${newCode != null ? newCode : 'IP001'}">

                                    <div class="import-card-layout">

                                        <!-- Flex Content: Left Input Panel + Right Table Panel -->
                                        <div class="import-flex-content">

                                            <!-- LEFT PANEL -->
                                            <div class="left-panel">
                                                <div class="custom-input-group">
                                                    <label class="custom-input-label">Nhà cung cấp</label>
                                                    <input type="text" name="supplierId" required class="custom-input"
                                                        placeholder="Công ty dược phẩm X">
                                                </div>

                                                <div class="custom-input-group">
                                                    <label class="custom-input-label">Ngày nhập</label>
                                                    <input type="date" name="importDate" required class="custom-input"
                                                        value="<fmt:formatDate value='<%=new java.util.Date()%>' pattern='yyyy-MM-dd'/>">
                                                </div>

                                                <div class="custom-input-group">
                                                    <label class="custom-input-label">Người nhập</label>
                                                    <input type="text" name="importerId" required class="custom-input"
                                                        placeholder="Nguyễn Văn A">
                                                </div>

                                                <!-- Visual-only Status -->
                                                <div class="custom-input-group">
                                                    <label class="custom-input-label">Trạng thái</label>
                                                    <select name="status" class="custom-input">
                                                        <option value="Đang chờ">Đang chờ</option>
                                                        <option value="Đã duyệt">Đã duyệt</option>
                                                        <option value="Chưa duyệt">Chưa duyệt</option>
                                                    </select>
                                                </div>

                                                <div class="total-amount-display">
                                                    Tổng tiền: <span class="amount-highlight"
                                                        id="totalDisplay">0₫</span>
                                                </div>
                                            </div>

                                            <!-- RIGHT PANEL -->
                                            <div class="right-panel">
                                                <div class="right-panel-title">Danh sách thuốc nhập</div>

                                                <table class="clean-table">
                                                    <thead>
                                                        <tr>
                                                            <th>Mã thuốc</th>
                                                            <th>SL</th>
                                                            <th>Giá</th>
                                                            <th>Thành tiền</th>
                                                            <th style="text-align: center;">Xóa</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody id="medicineListBody">
                                                        <tr>
                                                            <td colspan="5" class="empty-state"
                                                                style="padding: 40px 0; text-align: center;">
                                                                <div>
                                                                    <i
                                                                        style="font-size: 32px; color: #ddd; display: block; margin-bottom: 10px;">📋</i>
                                                                    <p style="font-size: 13px; color: #999;">Chưa có dữ
                                                                        liệu</p>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>

                                                <!-- Container for hidden inputs -->
                                                <div id="hiddenInputsContainer"></div>
                                            </div>

                                        </div>

                                        <!-- FOOTER ACTIONS -->
                                        <div class="footer-row">
                                            <div style="display: flex; gap: 10px;">
                                                <a href="${pageContext.request.contextPath}/ImportController"
                                                    class="btn-pill btn-pill-gray">
                                                    <span>‹</span> Trở lại
                                                </a>
                                                <button type="button" class="btn-pill btn-pill-blue"
                                                    onclick="openAddMedicineModal()">
                                                    <span>+</span> Thêm thuốc
                                                </button>
                                            </div>
                                            <div>
                                                <button type="submit" class="btn-pill btn-pill-blue"
                                                    style="padding-left: 30px; padding-right: 30px;">
                                                    <span>💾</span> Lưu phiếu nhập
                                                </button>
                                            </div>
                                        </div>

                                    </div>
                                </form>
                            </div>
                    </div>

                    <!-- Modal Form (Overlaid) -->
                    <div id="addMedicineModal" class="modal">
                        <div class="modal-content">
                            <div class="modal-header">
                                <div class="modal-title">Thêm thuốc vào phiếu nhập</div>
                                <button class="close-btn" onclick="closeAddMedicineModal()">&times;</button>
                            </div>

                            <div class="form-group">
                                <label>Mã thuốc</label>
                                <select id="modalMedicineCode" class="custom-input">
                                    <option value="">-- Chọn thuốc --</option>
                                    <c:forEach var="med" items="${medicines}">
                                        <option value="${med.medicineCode}">${med.medicineCode} - ${med.medicineName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Số lượng</label>
                                <input type="number" id="modalQuantity" class="custom-input" min="1"
                                    placeholder="Nhập số lượng" oninput="calculateModalTotal()">
                            </div>
                            <div class="form-group">
                                <label>Giá</label>
                                <input type="number" id="modalPrice" class="custom-input" min="0" step="0.01"
                                    placeholder="Nhập giá" oninput="calculateModalTotal()">
                            </div>
                            <div class="form-group">
                                <div style="font-size: 16px; font-weight: bold; color: #28a745; padding: 10px 0;">
                                    Thành tiền: <span id="modalTotalDisplay">0₫</span>
                                </div>
                            </div>

                            <div class="form-actions">
                                <button type="button" class="btn-secondary"
                                    onclick="closeAddMedicineModal()">Hủy</button>
                                <button type="button" class="btn-primary" onclick="addMedicineFromModal()">+
                                    Thêm</button>
                            </div>
                        </div>
                    </div>

                    <script>
                        let medicineList = [];
                        let totalAmount = 0;

                        function openAddMedicineModal() {
                            document.getElementById('addMedicineModal').style.display = 'block';
                            document.getElementById('modalMedicineCode').value = '';
                            document.getElementById('modalQuantity').value = '';
                            document.getElementById('modalPrice').value = '';
                            document.getElementById('modalTotalDisplay').textContent = '0₫';
                        }

                        function closeAddMedicineModal() {
                            document.getElementById('addMedicineModal').style.display = 'none';
                        }

                        // --- NEW: AJAX to fetch price ---
                        // --- NEW: AJAX to fetch price ---
                        document.getElementById('modalMedicineCode').addEventListener('change', function () {
                            const code = this.value;
                            if (code && code.trim() !== '') {
                                fetch('${pageContext.request.contextPath}/MedicineAjaxController?action=getPrice&code=' + code)
                                    .then(response => response.json())
                                    .then(data => {
                                        if (data && data.price !== undefined) {
                                            document.getElementById('modalPrice').value = data.price;
                                            calculateModalTotal();
                                        }
                                    })
                                    .catch(err => console.error('Error fetching price:', err));
                            } else {
                                // Reset price if no medicine selected
                                document.getElementById('modalPrice').value = '';
                                calculateModalTotal();
                            }
                        });

                        function calculateModalTotal() {
                            const quantity = parseFloat(document.getElementById('modalQuantity').value) || 0;
                            const price = parseFloat(document.getElementById('modalPrice').value) || 0;
                            const total = quantity * price;
                            document.getElementById('modalTotalDisplay').textContent = formatCurrency(total);
                        }

                        function addMedicineFromModal() {
                            const code = document.getElementById('modalMedicineCode').value;
                            const quantity = parseInt(document.getElementById('modalQuantity').value);
                            const price = parseFloat(document.getElementById('modalPrice').value);

                            if (!code || !quantity || !price) {
                                alert("Vui lòng nhập đầy đủ thông tin thuốc.");
                                return;
                            }

                            const total = quantity * price;

                            medicineList.push({
                                medicineCode: code,
                                quantity: quantity,
                                price: price,
                                total: total
                            });

                            updateTable();
                            closeAddMedicineModal();
                        }

                        function removeMedicine(index) {
                            medicineList.splice(index, 1);
                            updateTable();
                        }

                        function updateTable() {
                            const tbody = document.getElementById('medicineListBody');
                            const hiddenContainer = document.getElementById('hiddenInputsContainer');

                            tbody.innerHTML = '';
                            hiddenContainer.innerHTML = '';
                            totalAmount = 0;

                            if (medicineList.length === 0) {
                                tbody.innerHTML = `
                    <tr>
                        <td colspan="5" class="empty-state" style="padding: 40px 0; text-align: center;">
                            <div>
                                <i style="font-size: 32px; color: #ddd; display: block; margin-bottom: 10px;">📋</i>
                                <p style="font-size: 13px; color: #999;">Chưa có dữ liệu</p>
                            </div>
                        </td>
                    </tr>`;
                            } else {
                                medicineList.forEach((item, index) => {
                                    totalAmount += item.total;

                                    // Add Row
                                    const row = `
                        <tr>
                            <td>\${item.medicineCode}</td>
                            <td>\${item.quantity}</td>
                            <td class="price-text">\${formatCurrency(item.price)}</td>
                            <td class="price-text">\${formatCurrency(item.total)}</td>
                            <td style="text-align: center;">
                                <button type="button" class="icon-trash" onclick="removeMedicine(\${index})" style="margin: 0 auto;">🗑</button>
                            </td>
                        </tr>
                    `;
                                    tbody.innerHTML += row;

                                    // Add Hidden Inputs
                                    hiddenContainer.innerHTML += `
                        <input type="hidden" name="medicines[\${index}].medicineCode" value="\${item.medicineCode}">
                        <input type="hidden" name="medicines[\${index}].quantity" value="\${item.quantity}">
                        <input type="hidden" name="medicines[\${index}].price" value="\${item.price}">
                    `;
                                });
                            }

                            document.getElementById('totalDisplay').textContent = formatCurrency(totalAmount);
                        }

                        function formatCurrency(amount) {
                            return new Intl.NumberFormat('vi-VN').format(amount) + '₫';
                        }

                        // Close modal when clicking outside
                        window.onclick = function (event) {
                            const modal = document.getElementById('addMedicineModal');
                            if (event.target === modal) {
                                closeAddMedicineModal();
                            }
                        }
                    </script>
            </body>

            </html>