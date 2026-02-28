<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html>

                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                    <title>Tạo phiếu nhập - Admin</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/medicine-dashboard.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/import.css">
                </head>

                <body>
                    <jsp:include page="/view/common/header.jsp" />
                    <jsp:include page="/view/common/sidebar.jsp" />

                    <div class="main-content">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h3 class="fw-bold mb-0"><i class="fas fa-file-import me-2 text-primary"></i>Tạo phiếu nhập
                            </h3>
                        </div>
                        <div class="form-card">
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger alert-dismissible fade show m-3" role="alert">
                                    <i class="fas fa-exclamation-circle me-2"></i>${error}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"
                                        aria-label="Close"></button>
                                </div>
                            </c:if>

                            <form method="POST" action="${pageContext.request.contextPath}/admin/imports"
                                id="importForm">
                                <input type="hidden" name="action" value="create">
                                <input type="hidden" name="importCode" value="${newCode != null ? newCode : 'IP001'}">

                                <div class="form-card-body">
                                    <!-- Info Grid for Form Fields -->
                                    <div class="info-grid mb-4">
                                        <div class="info-item">
                                            <div class="info-label">Mã phiếu nhập (Tạm tính)</div>
                                            <div class="info-value text-muted">${newCode != null ? newCode : 'Sẽ được
                                                tạo tự động'}</div>
                                        </div>
                                        <div class="info-item">
                                            <label class="info-label" for="supplierId">Nhà cung cấp</label>
                                            <div class="info-value">
                                                <select name="supplierId" id="supplierId" required
                                                    class="form-select border-0 bg-transparent p-0"
                                                    style="box-shadow: none;">
                                                    <option value="">-- Chọn nhà cung cấp --</option>
                                                    <c:forEach var="supplier" items="${suppliers}">
                                                        <option value="${supplier[0]}">${supplier[1]}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="info-item">
                                            <label class="info-label" for="importDate">Ngày nhập</label>
                                            <div class="info-value">
                                                <input type="date" name="importDate" id="importDate" required
                                                    class="form-control border-0 bg-transparent p-0"
                                                    style="box-shadow: none;"
                                                    value="<fmt:formatDate value='<%=new java.util.Date()%>' pattern='yyyy-MM-dd'/>">
                                            </div>
                                        </div>
                                        <div class="info-item">
                                            <div class="info-label">Người nhập</div>
                                            <div class="info-value">${sessionScope.userName}</div>
                                            <input type="hidden" name="importerId" value="${sessionScope.userId}">
                                        </div>
                                        <div class="info-item">
                                            <label class="info-label" for="status">Trạng thái</label>
                                            <div class="info-value">
                                                <select name="status" id="status"
                                                    class="form-select border-0 bg-transparent p-0"
                                                    style="box-shadow: none;">
                                                    <option value="Đang chờ">Đang chờ</option>
                                                    <option value="Đã duyệt">Đã duyệt</option>
                                                    <option value="Chưa duyệt">Chưa duyệt</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="info-item">
                                            <div class="info-label">Tổng tiền</div>
                                            <div class="info-value price-value" id="totalDisplay">0₫</div>
                                        </div>
                                    </div>

                                    <!-- Medicine List -->
                                    <div style="margin-top: 36px;">
                                        <div class="d-flex justify-content-between align-items-center mb-3">
                                            <h5 class="fw-bold mb-0" style="color: #1e293b; font-size: 1.1rem;">
                                                <i class="fas fa-list me-2 text-primary"></i>Danh sách thuốc nhập
                                            </h5>
                                            <button type="button" class="btn btn-add-medicine"
                                                onclick="openAddMedicineModal()">
                                                <i class="fas fa-plus me-2"></i>Thêm thuốc
                                            </button>
                                        </div>

                                        <div class="table-responsive">
                                            <table class="table medicine-table align-middle" style="margin-bottom: 0;">
                                                <thead>
                                                    <tr>
                                                        <th>Mã thuốc</th>
                                                        <th>Tên thuốc</th>
                                                        <th>Số lượng</th>
                                                        <th>Đơn giá</th>
                                                        <th>Thành tiền</th>
                                                        <th style="text-align: center;">Thao tác</th>
                                                    </tr>
                                                </thead>
                                                <tbody id="medicineListBody">
                                                    <tr>
                                                        <td colspan="6" class="empty-state">
                                                            <div>
                                                                <i class="fas fa-clipboard-list mb-3"></i>
                                                                <p>Chưa có dữ liệu thuốc nhập</p>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                        <div id="hiddenInputsContainer"></div>
                                    </div>

                                    <!-- Footer Actions -->
                                    <div
                                        style="margin-top: 36px; padding-top: 24px; border-top: 1px solid #f1f5f9; display: flex; justify-content: space-between; align-items: center;">
                                        <a href="${pageContext.request.contextPath}/admin/imports" class="btn-back">
                                            <i class="fas fa-arrow-left me-2"></i>Trở lại
                                        </a>
                                        <button type="submit" class="btn-submit">
                                            <i class="fas fa-save me-2"></i>Lưu phiếu nhập
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Modal Form (Overlaid) -->
                    <div id="addMedicineModal" class="modal">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title"><i class="fas fa-plus-circle me-2 text-primary"></i>Thêm thuốc
                                    vào phiếu nhập</h5>
                                <button type="button" class="close-btn"
                                    onclick="closeAddMedicineModal()">&times;</button>
                            </div>
                            <div class="modal-body">
                                <div class="form-group mb-4">
                                    <label class="form-label fw-bold">Chọn thuốc nhập</label>
                                    <select id="modalMedicineId" class="form-select shadow-sm">
                                        <option value="">-- Tìm và chọn thuốc --</option>
                                        <c:forEach var="med" items="${medicines}">
                                            <option value="${med.medicineId}">${med.medicineCode} - ${med.medicineName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group mb-4">
                                            <label class="form-label fw-bold">Số lượng</label>
                                            <div class="input-group">
                                                <input type="number" id="modalQuantity" class="form-control shadow-sm"
                                                    min="1" placeholder="Nhập SL"
                                                    oninput="validateQuantityInput(); calculateModalTotal();">
                                            </div>
                                            <div id="quantityError"
                                                style="color: #dc3545; font-size: 0.8rem; margin-top: 4px; display: none;">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group mb-4">
                                            <label class="form-label fw-bold">Giá nhập (VNĐ)</label>
                                            <input type="number" id="modalPrice" class="form-control shadow-sm" min="0"
                                                step="1000" placeholder="Nhập đơn giá" oninput="calculateModalTotal()">
                                        </div>
                                    </div>
                                </div>

                                <div class="modal-total-box">
                                    <span class="modal-total-label">Tổng cộng dự kiến:</span>
                                    <span id="modalTotalDisplay" class="modal-total-amount">0₫</span>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-light px-4 py-2 fw-semibold"
                                    style="border-radius: 8px;" onclick="closeAddMedicineModal()">Hủy bỏ</button>
                                <button type="button" class="btn btn-primary px-4 py-2 fw-semibold"
                                    style="border-radius: 8px; background: linear-gradient(135deg, #3b82f6, #2563eb);"
                                    onclick="addMedicineFromModal()">Thêm vào danh sách</button>
                            </div>
                        </div>
                    </div>

                    <script>
                        let medicineList = [];
                        let totalAmount = 0;

                        function openAddMedicineModal() {
                            document.getElementById('addMedicineModal').style.display = 'block';
                            document.getElementById('modalMedicineId').value = '';
                            document.getElementById('modalQuantity').value = '';
                            document.getElementById('modalPrice').value = '';
                            document.getElementById('modalTotalDisplay').textContent = '0₫';
                        }

                        function closeAddMedicineModal() {
                            document.getElementById('addMedicineModal').style.display = 'none';
                        }

                        document.getElementById('modalMedicineId').addEventListener('change', function () {
                            const medicineId = this.value;
                            if (medicineId && medicineId.trim() !== '') {
                                // Clear price field - user must enter manually
                                document.getElementById('modalPrice').value = '';
                                calculateModalTotal();
                            } else {
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

                        function validateQuantityInput() {
                            const quantityInput = document.getElementById('modalQuantity');
                            const errorDiv = document.getElementById('quantityError');
                            const value = quantityInput.value;
                            let errorMsg = '';
                            if (value === '' || value === null) {
                                errorMsg = 'Vui lòng nhập số lượng.';
                            } else if (isNaN(value) || parseInt(value) <= 0) {
                                errorMsg = 'Số lượng phải lớn hơn 0.';
                            } else if (parseInt(value) > 1000) {
                                errorMsg = 'Số lượng không được vượt quá 1000.';
                            }
                            if (errorMsg !== '') {
                                errorDiv.textContent = errorMsg;
                                errorDiv.style.display = 'block';
                            } else {
                                errorDiv.textContent = '';
                                errorDiv.style.display = 'none';
                            }
                            calculateModalTotal();
                        }

                        function addMedicineFromModal() {
                            const medicineId = document.getElementById('modalMedicineId').value;
                            const quantityInput = document.getElementById('modalQuantity');
                            const price = parseFloat(document.getElementById('modalPrice').value);
                            const errorDiv = document.getElementById('quantityError');
                            const quantity = parseInt(quantityInput.value);

                            // Validate quantity
                            let errorMsg = '';
                            if (quantityInput.value === '' || quantityInput.value === null) {
                                errorMsg = 'Vui lòng nhập số lượng.';
                            } else if (isNaN(quantity) || quantity <= 0) {
                                errorMsg = 'Số lượng phải lớn hơn 0.';
                            } else if (quantity > 1000) {
                                errorMsg = 'Số lượng không được vượt quá 1000.';
                            }
                            if (!medicineId || !price) {
                                alert("Vui lòng nhập đầy đủ thông tin thuốc.");
                                return;
                            }
                            if (errorMsg !== '') {
                                errorDiv.textContent = errorMsg;
                                errorDiv.style.display = 'block';
                                quantityInput.focus();
                                return;
                            } else {
                                errorDiv.textContent = '';
                                errorDiv.style.display = 'none';
                            }

                            // Lấy tên thuốc từ option
                            const selectElement = document.getElementById('modalMedicineId');
                            const selectedOption = selectElement.options[selectElement.selectedIndex];
                            const optionText = selectedOption.text;
                            const medicineCode = optionText.split(' - ')[0];
                            const medicineName = optionText.split(' - ')[1] || '';

                            const total = quantity * price;
                            medicineList.push({
                                medicineId: medicineId,
                                medicineCode: medicineCode,
                                medicineName: medicineName,
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
                                tbody.innerHTML = `<tr><td colspan="6" class="empty-state"><div><i class="fas fa-clipboard-list mb-3"></i><p>Chưa có dữ liệu thuốc nhập</p></div></td></tr>`;
                            } else {
                                medicineList.forEach((item, index) => {
                                    totalAmount += item.total;
                                    tbody.innerHTML += `<tr>
                                        <td><strong>\${item.medicineCode}</strong></td>
                                        <td>\${item.medicineName || '-'}</td>
                                        <td>\${item.quantity}</td>
                                        <td><span class="price">\${formatCurrency(item.price)}</span></td>
                                        <td><span class="price">\${formatCurrency(item.total)}</span></td>
                                        <td style="text-align: center;">
                                            <button type="button" class="btn-action btn-delete" onclick="removeMedicine(\${index})">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </td>
                                    </tr>`;
                                    hiddenContainer.innerHTML += `<input type="hidden" name="medicines[\${index}].medicineId" value="\${item.medicineId}"><input type="hidden" name="medicines[\${index}].quantity" value="\${item.quantity}"><input type="hidden" name="medicines[\${index}].price" value="\${item.price}">`;
                                });
                            }
                            document.getElementById('totalDisplay').textContent = formatCurrency(totalAmount);
                        }

                        function formatCurrency(amount) {
                            return new Intl.NumberFormat('vi-VN').format(amount) + '₫';
                        }

                        window.onclick = function (event) {
                            const modal = document.getElementById('addMedicineModal');
                            if (event.target === modal) closeAddMedicineModal();
                        }
                        // Prevent form submit if any invalid quantity
                        document.getElementById('importForm').addEventListener('submit', function (e) {
                            let hasError = false;
                            for (let i = 0; i < medicineList.length; i++) {
                                const qty = medicineList[i].quantity;
                                if (!qty || qty <= 0 || qty > 1000) {
                                    hasError = true;
                                    break;
                                }
                            }
                            if (hasError) {
                                alert('Có thuốc với số lượng không hợp lệ. Vui lòng kiểm tra lại.');
                                e.preventDefault();
                            }
                        });
                    </script>
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>