<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html>

                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                    <title>Chỉnh sửa phiếu nhập</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/medicine-dashboard.css">
                </head>

                <body>
                    <jsp:include page="/view/common/header.jsp" />
                    <jsp:include page="/view/common/sidebar.jsp" />

                    <div class="main-content">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h3 class="fw-bold mb-0"><i class="fas fa-file-import me-2 text-primary"></i>Chỉnh sửa phiếu nhập</h3>
                        </div>
                        <div class="medicine-card">
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    <i class="fas fa-exclamation-circle me-2"></i>${error}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"
                                        aria-label="Close"></button>
                                </div>
                            </c:if>

                            <c:if test="${not empty importRecord}">
                                <form action="${pageContext.request.contextPath}/admin/imports" method="POST">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="importId" value="${importRecord.importId}">

                                    <div class="import-card-layout">
                                        <div class="import-flex-content">
                                            <!-- LEFT PANEL -->
                                            <div class="left-panel">
                                                <div class="custom-input-group">
                                                    <label class="custom-input-label">Mã phiếu</label>
                                                    <input type="text" class="custom-input"
                                                        value="${importRecord.importCode}" readonly
                                                        style="background-color: #f0f0f0; cursor: not-allowed;">
                                                </div>

                                                <div class="custom-input-group">
                                                    <label class="custom-input-label">Nhà cung cấp</label>
                                                    <select name="supplierId" class="custom-input" required>
                                                        <option value="">-- Chọn nhà cung cấp --</option>
                                                        <c:forEach var="supplier" items="${suppliers}">
                                                            <option value="${supplier[0]}"
                                                                ${supplier[0]==importRecord.supplierId ? 'selected' : ''
                                                                }>${supplier[1]}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>

                                                <div class="custom-input-group">
                                                    <label class="custom-input-label">Ngày nhập</label>
                                                    <input type="date" name="importDate" class="custom-input" required
                                                        value="<fmt:formatDate value='${importRecord.importDate}' pattern='yyyy-MM-dd'/>">
                                                </div>

                                                <div class="custom-input-group">
                                                    <label class="custom-input-label">Người nhập</label>
                                                    <input type="text" class="custom-input"
                                                        value="${importRecord.staffName}" readonly
                                                        style="background-color: #f0f0f0; cursor: not-allowed;">
                                                    <input type="hidden" name="importerId"
                                                        value="${importRecord.staffId}">
                                                </div>

                                                <div class="custom-input-group">
                                                    <label class="custom-input-label">Trạng thái</label>
                                                    <select name="status" class="custom-input">
                                                        <option value="Đang chờ" ${importRecord.status=='Đang chờ'
                                                            ? 'selected' : '' }>Đang chờ</option>
                                                        <option value="Chưa duyệt" ${importRecord.status=='Chưa duyệt'
                                                            ? 'selected' : '' }>Chưa duyệt</option>
                                                        <option value="Đã duyệt" ${importRecord.status=='Đã duyệt'
                                                            ? 'selected' : '' }>Đã duyệt</option>
                                                    </select>
                                                </div>

                                                <div class="total-amount-display">
                                                    Tổng tiền: <span class="amount-highlight" id="totalDisplay">
                                                        <fmt:formatNumber value='${importRecord.totalAmount}'
                                                            type='number' maxFractionDigits='0' />₫
                                                    </span>
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
                                                        <c:choose>
                                                            <c:when test="${not empty details}">
                                                                <c:forEach var="detail" items="${details}">
                                                                    <tr>
                                                                        <td>${detail.medicineCode}</td>
                                                                        <td>${detail.quantity}</td>
                                                                        <td class="price-text">
                                                                            <fmt:formatNumber
                                                                                value='${detail.unitPrice}'
                                                                                type='number' maxFractionDigits='0' />₫
                                                                        </td>
                                                                        <td class="price-text">
                                                                            <fmt:formatNumber
                                                                                value='${detail.quantity * detail.unitPrice}'
                                                                                type='number' maxFractionDigits='0' />₫
                                                                        </td>
                                                                        <td style="text-align: center;">
                                                                            <form action="${pageContext.request.contextPath}/admin/imports" method="POST" style="display: inline;">
                                                                                <input type="hidden" name="action" value="deleteDetail">
                                                                                <input type="hidden" name="detailId" value="${detail.detailId}">
                                                                                <input type="hidden" name="importId" value="${importRecord.importId}">
                                                                                <button type="submit" style="background: none; border: none; color: #dc3545; text-decoration: none; cursor: pointer; padding: 0;" onclick="return confirm('Xóa thuốc này? (Phiếu phải có ít nhất 1 loại thuốc)')">
                                                                                    <i class="fas fa-trash"></i>
                                                                                </button>
                                                                            </form>
                                                                        </td>
                                                                    </tr>
                                                                </c:forEach>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <tr>
                                                                    <td colspan="5" class="empty-state"
                                                                        style="padding: 40px 0; text-align: center;">
                                                                        <div>
                                                                            <i
                                                                                style="font-size: 32px; color: #ddd; display: block; margin-bottom: 10px;">📋</i>
                                                                            <p style="font-size: 13px; color: #999;">
                                                                                Chưa có dữ liệu</p>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </tbody>
                                                </table>
                                                <div id="hiddenInputsContainer"></div>
                                            </div>
                                        </div>

                                        <!-- FOOTER ACTIONS -->
                                        <div class="footer-row mt-4">
                                            <div style="display: flex; gap: 10px;">
                                                <a href="${pageContext.request.contextPath}/admin/imports"
                                                    class="btn btn-secondary">
                                                    <i class="fas fa-arrow-left me-2"></i>Trở lại
                                                </a>
                                                <button type="button" class="btn btn-primary"
                                                    onclick="openAddMedicineModal()">
                                                    <i class="fas fa-plus me-2"></i>Thêm thuốc
                                                </button>
                                            </div>
                                            <div>
                                                <button type="submit" class="btn btn-success"
                                                    style="padding-left: 30px; padding-right: 30px;">
                                                    <i class="fas fa-save me-2"></i>Cập nhật phiếu
                                                </button>
                                            </div>
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
                                <div class="modal-title">Thêm thuốc vào phiếu nhập</div>
                                <button class="close-btn" onclick="closeAddMedicineModal()">&times;</button>
                            </div>
                            <div class="form-group mb-3">
                                <label class="form-label">Mã thuốc</label>
                                <select id="modalMedicineId" class="form-select">
                                    <option value="">-- Chọn thuốc --</option>
                                    <c:forEach var="med" items="${medicines}">
                                        <option value="${med.medicineId}">${med.medicineCode} - ${med.medicineName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group mb-3">
                                <label class="form-label">Số lượng</label>
                                <input type="number" id="modalQuantity" class="form-control" min="1"
                                    placeholder="Nhập số lượng" oninput="calculateModalTotal()">
                            </div>
                            <div class="form-group mb-3">
                                <label class="form-label">Giá</label>
                                <input type="number" id="modalPrice" class="form-control" min="0" step="0.01"
                                    placeholder="Nhập giá" oninput="calculateModalTotal()">
                            </div>
                            <div class="form-group">
                                <div style="font-size: 18px; font-weight: bold; color: #28a745; padding: 10px 0;">
                                    Thành tiền: <span id="modalTotalDisplay">0₫</span>
                                </div>
                            </div>
                            <div class="form-actions d-flex justify-content-end gap-2 mt-3">
                                <button type="button" class="btn btn-secondary"
                                    onclick="closeAddMedicineModal()">Hủy</button>
                                <button type="button" class="btn btn-primary" onclick="addMedicineFromModal()">+
                                    Thêm</button>
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
                                    medicineCode: '${detail.medicineCode}',
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

                        function addMedicineFromModal() {
                            const medicineId = document.getElementById('modalMedicineId').value;
                            const quantity = parseInt(document.getElementById('modalQuantity').value);
                            const price = parseFloat(document.getElementById('modalPrice').value);

                            if (!medicineId || !quantity || !price) {
                                alert("Vui lòng nhập đầy đủ thông tin thuốc.");
                                return;
                            }

                            const selectElement = document.getElementById('modalMedicineId');
                            const selectedOption = selectElement.options[selectElement.selectedIndex];
                            const medicineCode = selectedOption.text.split(' - ')[0];

                            const total = quantity * price;
                            medicineList.push({
                                medicineId: medicineId,
                                medicineCode: medicineCode,
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

                            if (medicineList.length === 0) {
                                tbody.innerHTML = `<tr><td colspan="5" class="empty-state" style="padding: 40px 0; text-align: center;"><div><i>📋</i><p>Chưa có dữ liệu</p></div></td></tr>`;
                            } else {
                                medicineList.forEach((item, index) => {
                                    let deleteBtn = '';
                                    if (item.detailId) {
                                        // Existing item from database - delete via server
                                        deleteBtn = `<form action="${pageContext.request.contextPath}/admin/imports" method="POST" style="display: inline;"><input type="hidden" name="action" value="deleteDetail"><input type="hidden" name="detailId" value="\${item.detailId}"><input type="hidden" name="importId" value="${importRecord.importId}"><button type="submit" style="background: none; border: none; color: #dc3545; text-decoration: none; cursor: pointer; padding: 0;" onclick="return confirm('Xóa thuốc này?')"><i class="fas fa-trash"></i></button></form>`;
                                    } else {
                                        // New item - delete client-side
                                        deleteBtn = `<button type="button" style="background: none; border: none; color: #dc3545; text-decoration: none; cursor: pointer; padding: 0;" onclick="removeMedicine(\${index})"><i class="fas fa-trash"></i></button>`;
                                    }
                                    tbody.innerHTML += `<tr><td>\${item.medicineCode}</td><td>\${item.quantity}</td><td class="price-text">\${formatCurrency(item.price)}</td><td class="price-text">\${formatCurrency(item.total)}</td><td style="text-align: center;">\${deleteBtn}</td></tr>`;
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