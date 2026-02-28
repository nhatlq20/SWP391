<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html>

                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                    <title>Chỉnh sửa phiếu nhập</title>
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
                            <h3 class="fw-bold mb-0"><i class="fas fa-file-import me-2 text-primary"></i>Chỉnh sửa phiếu
                                nhập</h3>
                        </div>
                        <div class="form-card">
                            <c:if test="${not empty importRecord}">
                                <form action="${pageContext.request.contextPath}/admin/imports" method="POST">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="importId" value="${importRecord.importId}">

                                    <div class="form-card-body">
                                        <!-- Info Grid for Form Fields -->
                                        <div class="info-grid mb-4">
                                            <div class="info-item">
                                                <div class="info-label">Mã phiếu nhập</div>
                                                <div class="info-value text-muted">${importRecord.importCode}</div>
                                            </div>
                                            <div class="info-item">
                                                <label class="info-label" for="supplierId">Nhà cung cấp</label>
                                                <div class="info-value">
                                                    <select name="supplierId" id="supplierId" required
                                                        class="form-select border-0 bg-transparent p-0"
                                                        style="box-shadow: none;">
                                                        <option value="">-- Chọn nhà cung cấp --</option>
                                                        <c:forEach var="supplier" items="${suppliers}">
                                                            <option value="${supplier[0]}"
                                                                ${supplier[0]==importRecord.supplierId ? 'selected' : ''
                                                                }>${supplier[1]}</option>
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
                                                        value="<fmt:formatDate value='${importRecord.importDate}' pattern='yyyy-MM-dd'/>">
                                                </div>
                                            </div>
                                            <div class="info-item">
                                                <div class="info-label">Người nhập</div>
                                                <div class="info-value">${importRecord.staffName}</div>
                                                <input type="hidden" name="importerId" value="${importRecord.staffId}">
                                            </div>
                                            <div class="info-item">
                                                <label class="info-label" for="status">Trạng thái</label>
                                                <div class="info-value">
                                                    <select name="status" id="status"
                                                        class="form-select border-0 bg-transparent p-0"
                                                        style="box-shadow: none;">
                                                        <option value="Đang chờ" ${importRecord.status=='Đang chờ'
                                                            ? 'selected' : '' }>Đang chờ</option>
                                                        <option value="Chưa duyệt" ${importRecord.status=='Chưa duyệt'
                                                            ? 'selected' : '' }>Chưa duyệt</option>
                                                        <option value="Đã duyệt" ${importRecord.status=='Đã duyệt'
                                                            ? 'selected' : '' }>Đã duyệt</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="info-item">
                                                <div class="info-label">Tổng tiền</div>
                                                <div class="info-value price-value" id="totalDisplay">
                                                    <fmt:formatNumber value='${importRecord.totalAmount}' type='number'
                                                        maxFractionDigits='0' />₫
                                                </div>
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
                                                <table class="table medicine-table align-middle"
                                                    style="margin-bottom: 0;">
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
                                                        <c:choose>
                                                            <c:when test="${not empty details}">
                                                                <c:forEach var="detail" items="${details}">
                                                                    <tr>
                                                                        <td><strong>${detail.medicineCode}</strong></td>
                                                                        <td>${detail.medicineName != null ?
                                                                            detail.medicineName : '-'}</td>
                                                                        <td>${detail.quantity}</td>
                                                                        <td><span class="price">
                                                                                <fmt:formatNumber
                                                                                    value='${detail.unitPrice}'
                                                                                    type='number'
                                                                                    maxFractionDigits='0' />₫
                                                                            </span></td>
                                                                        <td><span class="price">
                                                                                <fmt:formatNumber
                                                                                    value='${detail.quantity * detail.unitPrice}'
                                                                                    type='number'
                                                                                    maxFractionDigits='0' />₫
                                                                            </span></td>
                                                                        <td style="text-align: center;">
                                                                            <form
                                                                                action="${pageContext.request.contextPath}/admin/imports"
                                                                                method="POST" style="display: inline;">
                                                                                <input type="hidden" name="action"
                                                                                    value="deleteDetail">
                                                                                <input type="hidden" name="detailId"
                                                                                    value="${detail.detailId}">
                                                                                <input type="hidden" name="importId"
                                                                                    value="${importRecord.importId}">
                                                                                <button type="submit"
                                                                                    class="btn-action btn-delete"
                                                                                    onclick="return confirm('Xóa thuốc này? (Phiếu phải có ít nhất 1 loại thuốc)')">
                                                                                    <i class="fas fa-trash"></i>
                                                                                </button>
                                                                            </form>
                                                                        </td>
                                                                    </tr>
                                                                </c:forEach>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <tr>
                                                                    <td colspan="6" class="empty-state">
                                                                        <div>
                                                                            <i class="fas fa-clipboard-list mb-3"></i>
                                                                            <p>Chưa có dữ liệu thuốc nhập</p>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                            </c:otherwise>
                                                        </c:choose>
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
                                                <i class="fas fa-save me-2"></i>Cập nhật phiếu
                                            </button>
                                        </div>
                                    </div>
                                </form>
                            </c:if>
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
                                            <input type="number" id="modalQuantity" class="form-control shadow-sm"
                                                min="1" placeholder="Nhập SL"
                                                oninput="validateQuantity(); calculateModalTotal();">
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

                        // Initialize medicineList from server-side details
                        <c:if test="${not empty details}">
                            <c:forEach var="detail" items="${details}">
                                medicineList.push({
                                    detailId: ${detail.detailId},
                                medicineId: ${detail.medicineId},
                                medicineCode: "${detail.medicineCode}",
                                medicineName: "${detail.medicineName != null ? detail.medicineName : ''}",
                                quantity: ${detail.quantity},
                                price: ${detail.unitPrice},
                                total: ${detail.quantity * detail.unitPrice}
                                });
                            </c:forEach>
                        </c:if>

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

                        function validateQuantity() {
                            const quantityInput = document.getElementById('modalQuantity');
                            const errorDiv = document.getElementById('quantityError');
                            const value = quantityInput.value;
                            let isValid = true;
                            if (value === '' || value === null) {
                                errorDiv.textContent = "Vui lòng nhập số lượng.";
                                errorDiv.style.display = 'block';
                                isValid = false;
                            } else {
                                const intValue = parseInt(value);
                                if (isNaN(intValue) || intValue <= 0) {
                                    errorDiv.textContent = "Số lượng phải lớn hơn 0.";
                                    errorDiv.style.display = 'block';
                                    isValid = false;
                                } else if (intValue > 1000) {
                                    errorDiv.textContent = "Số lượng không được vượt quá 1000.";
                                    errorDiv.style.display = 'block';
                                    isValid = false;
                                } else {
                                    errorDiv.textContent = "";
                                    errorDiv.style.display = 'none';
                                }
                            }
                            calculateModalTotal();
                            return isValid;
                        }

                        function calculateModalTotal() {
                            const quantity = parseFloat(document.getElementById('modalQuantity').value) || 0;
                            const price = parseFloat(document.getElementById('modalPrice').value) || 0;
                            const total = quantity * price;
                            document.getElementById('modalTotalDisplay').textContent = formatCurrency(total);
                        }

                        function addMedicineFromModal() {
                            const medicineId = document.getElementById('modalMedicineId').value;
                            const quantityInput = document.getElementById('modalQuantity');
                            const quantity = quantityInput.value;
                            const price = parseFloat(document.getElementById('modalPrice').value);

                            if (!medicineId || quantity === '' || quantity === null || isNaN(parseInt(quantity)) || !price) {
                                validateQuantity();
                                alert("Vui lòng nhập đầy đủ thông tin thuốc.");
                                return;
                            }
                            if (!validateQuantity()) {
                                quantityInput.focus();
                                return;
                            }

                            const selectElement = document.getElementById('modalMedicineId');
                            const selectedOption = selectElement.options[selectElement.selectedIndex];
                            const optionText = selectedOption.text;
                            const medicineCode = optionText.split(' - ')[0];
                            const medicineName = optionText.split(' - ')[1] || '';

                            const total = parseInt(quantity) * price;
                            medicineList.push({
                                medicineId: medicineId,
                                medicineCode: medicineCode,
                                medicineName: medicineName,
                                quantity: parseInt(quantity),
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

                            if (medicineList.length === 0) {
                                tbody.innerHTML = `<tr><td colspan="6" class="empty-state"><div><i class="fas fa-clipboard-list mb-3"></i><p>Chưa có dữ liệu thuốc nhập</p></div></td></tr>`;
                            } else {
                                medicineList.forEach((item, index) => {
                                    let deleteBtn = '';
                                    if (item.detailId) {
                                        // Existing item from database - delete via server
                                        deleteBtn = `<form action="${pageContext.request.contextPath}/admin/imports" method="POST" style="display: inline;">
                                            <input type="hidden" name="action" value="deleteDetail">
                                            <input type="hidden" name="detailId" value="\${item.detailId}">
                                            <input type="hidden" name="importId" value="${importRecord.importId}">
                                            <button type="submit" class="btn-action btn-delete" onclick="return confirm('Xóa thuốc này?')">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </form>`;
                                    } else {
                                        // New item - delete client-side
                                        deleteBtn = `<button type="button" class="btn-action btn-delete" onclick="removeMedicine(\${index})">
                                            <i class="fas fa-trash"></i>
                                        </button>`;
                                    }
                                    tbody.innerHTML += `<tr>
                                        <td><strong>\${item.medicineCode}</strong></td>
                                        <td>\${item.medicineName || '-'}</td>
                                        <td>\${item.quantity}</td>
                                        <td><span class="price">\${formatCurrency(item.price)}</span></td>
                                        <td><span class="price">\${formatCurrency(item.total)}</span></td>
                                        <td style="text-align: center;">\${deleteBtn}</td>
                                    </tr>`;
                                    if (!item.detailId) {
                                        // Only add hidden inputs for new items
                                        hiddenContainer.innerHTML += `<input type="hidden" name="newMedicines[\${index}].medicineId" value="\${item.medicineId}"><input type="hidden" name="newMedicines[\${index}].quantity" value="\${item.quantity}"><input type="hidden" name="newMedicines[\${index}].price" value="\${item.price}">`;
                                    }
                                });
                            }
                        }

                        function formatCurrency(amount) {
                            return new Intl.NumberFormat('vi-VN').format(amount) + '₫';
                        }

                        window.onclick = function (event) {
                            const modal = document.getElementById('addMedicineModal');
                            if (event.target === modal) closeAddMedicineModal();
                        }
                    </script>
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>