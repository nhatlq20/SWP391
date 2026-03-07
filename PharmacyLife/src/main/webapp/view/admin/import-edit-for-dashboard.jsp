<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Chỉnh sửa phiếu nhập</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/medicine-dashboard.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/import.css">
                </head>

                <body class="bg-light">
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
                                                    <div class="d-flex align-items-center gap-2">
                                                        <select name="supplierId" id="supplierId" required
                                                            class="form-select border-0 bg-transparent p-0"
                                                            style="box-shadow: none; flex-grow: 1;">
                                                            <option value="">-- Chọn nhà cung cấp --</option>
                                                            <c:forEach var="supplier" items="${suppliers}">
                                                                <option value="${supplier.supplierId}"
                                                                    ${supplier.supplierId==importRecord.supplierId
                                                                    ? 'selected' : '' }>${supplier.supplierName}
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                        <button type="button"
                                                            class="btn btn-sm btn-outline-primary rounded-circle"
                                                            style="width: 24px; height: 24px; padding: 0; line-height: 22px;"
                                                            onclick="openQuickSupplierModal()"
                                                            title="Thêm nhà cung cấp mới">
                                                            <i class="fas fa-plus" style="font-size: 0.75rem;"></i>
                                                        </button>
                                                    </div>
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
                                                            <th>Đơn vị</th>
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
                                                                        <td>-</td>
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
                                                                            <button type="submit"
                                                                                form="deleteForm_${detail.detailId}"
                                                                                class="btn-action btn-delete"
                                                                                onclick="return confirm('Xóa thuốc này? (Phiếu phải có ít nhất 1 loại thuốc)')">
                                                                                <i class="fas fa-trash"></i>
                                                                            </button>
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

                    <c:if test="${not empty importRecord and not empty details}">
                        <c:forEach var="detail" items="${details}">
                            <form id="deleteForm_${detail.detailId}"
                                action="${pageContext.request.contextPath}/admin/imports" method="POST"
                                style="display: none;">
                                <input type="hidden" name="action" value="deleteDetail">
                                <input type="hidden" name="detailId" value="${detail.detailId}">
                                <input type="hidden" name="importId" value="${importRecord.importId}">
                            </form>
                        </c:forEach>
                    </c:if>

                    <script>
                        let medicineList = [];
                        let totalAmount = 0;
                        let allMedicineOptions = [
                            <c:forEach var="med" items="${medicines}" varStatus="status">
                                {
                                    value: "${med.medicineId}",
                                text: "${med.medicineCode} - ${fn:escapeXml(med.medicineName)}",
                                categoryId: "${med.categoryId}"
                                }${status.last ? '' : ','}
                            </c:forEach>
                        ];
                        let allMedicineUnits = [
                            <c:forEach var="unit" items="${medicineUnits}" varStatus="status">
                                {
                                    unitId: ${unit.unitId},
                                medicineId: ${unit.medicineId},
                                unitName: "${fn:escapeXml(unit.unitName)}",
                                isBaseUnit: ${unit.isBaseUnit}
                                }${status.last ? '' : ','}
                            </c:forEach>
                        ];

                        document.addEventListener('DOMContentLoaded', function () {
                            // Add change listener for price reset
                            const modalMedSelect = document.getElementById('modalMedicineId');
                            if (modalMedSelect) {
                                modalMedSelect.addEventListener('change', function () {
                                    document.getElementById('modalPrice').value = '';
                                    calculateModalTotal();
                                    updateUnitOptions();
                                });
                            }
                        });

                        // Initialize medicineList from server-side details
                        <c:if test="${not empty details}">
                            <c:forEach var="detail" items="${details}">
                                medicineList.push({
                                    detailId: parseInt("${detail.detailId}"),
                                medicineId: parseInt("${detail.medicineId}"),
                                medicineCode: "${detail.medicineCode}",
                                medicineName: "${fn:escapeXml(detail.medicineName)}",
                                quantity: parseInt("${detail.quantity}"),
                                price: parseFloat("${detail.unitPrice}"),
                                total: parseFloat("${detail.quantity * detail.unitPrice}")
                                });
                            </c:forEach>
                        </c:if>

                        function openAddMedicineModal() {
                            document.getElementById('addMedicineModal').style.display = 'flex';
                            document.getElementById('modalCategoryId').value = '';
                            document.getElementById('modalMedicineId').value = '';
                            document.getElementById('modalUnitId').innerHTML = '<option value="">-- Chọn thuốc trước --</option>';
                            document.getElementById('modalQuantity').value = '';
                            document.getElementById('modalPrice').value = '';
                            document.getElementById('modalTotalDisplay').textContent = '0₫';
                            filterMedicinesByCategory(); // Clear initially
                        }

                        function updateUnitOptions() {
                            const medId = document.getElementById('modalMedicineId').value;
                            const unitSelect = document.getElementById('modalUnitId');
                            unitSelect.innerHTML = '<option value="">-- Chọn đơn vị --</option>';
                            if (!medId) return;

                            let possibleUnits = allMedicineUnits.filter(u => u.medicineId == medId);
                            possibleUnits.forEach(u => {
                                let opt = document.createElement('option');
                                opt.value = u.unitId;
                                opt.textContent = u.unitName;
                                if (u.isBaseUnit) opt.selected = true;
                                unitSelect.appendChild(opt);
                            });
                        }

                        function filterMedicinesByCategory() {
                            const categoryId = document.getElementById('modalCategoryId').value;
                            const medicineSelect = document.getElementById('modalMedicineId');
                            if (!medicineSelect) return;

                            const currentValue = medicineSelect.value;

                            // Rebuild options list
                            medicineSelect.innerHTML = '<option value="">-- ' + (categoryId ? 'Chọn thuốc' : 'Chọn danh mục hoặc tìm tất cả') + ' --</option>';

                            allMedicineOptions.forEach(opt => {
                                // Show all if no category selected, or filter by categoryId
                                if (!categoryId || String(opt.categoryId) === String(categoryId).trim()) {
                                    const newOpt = document.createElement('option');
                                    newOpt.value = opt.value;
                                    newOpt.textContent = opt.text;
                                    newOpt.setAttribute('data-category', opt.categoryId);
                                    if (opt.value === currentValue) newOpt.selected = true;
                                    medicineSelect.appendChild(newOpt);
                                }
                            });

                            // If current selection is no longer valid in filtered list, reset it
                            if (currentValue && medicineSelect.value === "") {
                                calculateModalTotal();
                            }
                        }

                        function closeAddMedicineModal() {
                            document.getElementById('addMedicineModal').style.display = 'none';
                        }

                        // Quick Supplier Logic
                        function openQuickSupplierModal() {
                            document.getElementById('quickSupplierModal').style.display = 'flex';
                            document.getElementById('qsName').value = '';
                            document.getElementById('qsAddress').value = '';
                            document.getElementById('qsContact').value = '';
                            document.getElementById('qsError').style.display = 'none';
                        }

                        function closeQuickSupplierModal() {
                            document.getElementById('quickSupplierModal').style.display = 'none';
                        }

                        function saveQuickSupplier() {
                            const name = document.getElementById('qsName').value.trim();
                            const address = document.getElementById('qsAddress').value.trim();
                            const contact = document.getElementById('qsContact').value.trim();
                            const errorDiv = document.getElementById('qsError');
                            const btn = document.getElementById('btnSaveSupplier');
                            const spinner = document.getElementById('qsSpinner');

                            if (!name) {
                                errorDiv.textContent = 'Vui lòng nhập tên nhà cung cấp';
                                errorDiv.style.display = 'block';
                                return;
                            }

                            errorDiv.style.display = 'none';
                            btn.disabled = true;
                            spinner.style.display = 'inline-block';

                            const params = new URLSearchParams();
                            params.append('supplierName', name);
                            params.append('supplierAddress', address);
                            params.append('contactInfo', contact);

                            fetch('${pageContext.request.contextPath}/admin/suppliers/quick-add', {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/x-www-form-urlencoded',
                                },
                                body: params
                            })
                                .then(response => response.json())
                                .then(data => {
                                    if (data.success) {
                                        // Add to dropdown
                                        const select = document.getElementById('supplierId');
                                        const option = new Option(data.name, data.id);
                                        select.add(option);
                                        select.value = data.id;

                                        // Close modal
                                        closeQuickSupplierModal();

                                        // Optional: notify user
                                        alert('Đã thêm nhà cung cấp: ' + data.name);
                                    } else {
                                        errorDiv.textContent = data.message || 'Lỗi khi thêm nhà cung cấp';
                                        errorDiv.style.display = 'block';
                                    }
                                })
                                .catch(error => {
                                    console.error('Error:', error);
                                    errorDiv.textContent = 'Lỗi hệ thống khi kết nối server';
                                    errorDiv.style.display = 'block';
                                })
                                .finally(() => {
                                    btn.disabled = false;
                                    spinner.style.display = 'none';
                                });
                        }

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
                                } else if (intValue > 5000) {
                                    errorDiv.textContent = "Số lượng quá lớn (tối đa 5000).";
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

                        function addMedicineFromModal() {
                            const medicineId = document.getElementById('modalMedicineId').value;
                            const unitSelect = document.getElementById('modalUnitId');
                            const unitId = unitSelect.value;
                            const unitName = unitSelect.options[unitSelect.selectedIndex]?.text || '';
                            const quantityInput = document.getElementById('modalQuantity');
                            const quantity = quantityInput.value;
                            const price = parseFloat(document.getElementById('modalPrice').value);

                            if (!medicineId || !unitId || quantity === '' || quantity === null || isNaN(parseInt(quantity)) || !price) {
                                validateQuantity();
                                alert("Vui lòng nhập đầy đủ thông tin thuốc (bao gồm cả đơn vị và số lượng).");
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
                                unitId: unitId,
                                unitName: unitName,
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
                                        deleteBtn = `<button type="submit" form="deleteForm_\${item.detailId}" class="btn-action btn-delete" onclick="return confirm('Xóa thuốc này?')">
                                                <i class="fas fa-trash"></i>
                                            </button>`;
                                    } else {
                                        // New item - delete client-side
                                        deleteBtn = `<button type="button" class="btn-action btn-delete" onclick="removeMedicine(\${index})">
                                            <i class="fas fa-trash"></i>
                                        </button>`;
                                    }
                                    tbody.innerHTML += `<tr>
                                        <td><strong>\${item.medicineCode}</strong></td>
                                        <td>\${item.medicineName || '-'}</td>
                                        <td>\${item.unitName || '-'}</td>
                                        <td>\${item.quantity}</td>
                                        <td><span class="price">\${formatCurrency(item.price)}</span></td>
                                        <td><span class="price">\${formatCurrency(item.total)}</span></td>
                                        <td style="text-align: center;">\${deleteBtn}</td>
                                    </tr>`;
                                    if (!item.detailId) {
                                        // Only add hidden inputs for new items
                                        hiddenContainer.innerHTML += `<input type="hidden" name="newMedicines[\${index}].medicineId" value="\${item.medicineId}"><input type="hidden" name="newMedicines[\${index}].unitId" value="\${item.unitId}"><input type="hidden" name="newMedicines[\${index}].quantity" value="\${item.quantity}"><input type="hidden" name="newMedicines[\${index}].price" value="\${item.price}">`;
                                    }
                                });
                            }
                        }

                        function formatCurrency(amount) {
                            return new Intl.NumberFormat('vi-VN').format(amount) + '₫';
                        }

                        window.onclick = function (event) {
                            const modalMed = document.getElementById('addMedicineModal');
                            const modalSup = document.getElementById('quickSupplierModal');
                            if (event.target === modalMed) closeAddMedicineModal();
                            if (event.target === modalSup) closeQuickSupplierModal();
                        }
                    </script>

                    <!-- Modal Form (Overlaid) -->
                    <div id="addMedicineModal" class="modal" style="z-index: 9999999 !important;">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">
                                    <i class="fas fa-pills me-2 text-primary"></i>
                                    Thêm thuốc nhập
                                </h5>
                                <button type="button" class="close-btn" onclick="closeAddMedicineModal()">
                                    <i class="fas fa-times"></i>
                                </button>
                            </div>
                            <div class="modal-body">
                                <div class="row g-3">
                                    <div class="col-12">
                                        <label class="form-label fw-semibold">Danh mục</label>
                                        <select id="modalCategoryId" class="form-select"
                                            onchange="filterMedicinesByCategory()">
                                            <option value="">-- Tất cả danh mục --</option>
                                            <c:forEach var="cat" items="${categories}">
                                                <option value="${cat.categoryId}">${cat.categoryName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label fw-semibold">Tên thuốc</label>
                                        <select id="modalMedicineId" class="form-select">
                                            <option value="">-- Chọn danh mục trước --</option>
                                            <c:forEach var="med" items="${medicines}">
                                                <option value="${med.medicineId}" data-category="${med.categoryId}">
                                                    ${med.medicineCode} - ${med.medicineName}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label fw-semibold">Đơn vị</label>
                                        <select id="modalUnitId" class="form-select">
                                            <option value="">-- Chọn thuốc trước --</option>
                                        </select>
                                    </div>
                                    <div class="col-6">
                                        <label class="form-label fw-semibold">Số lượng</label>
                                        <input type="number" id="modalQuantity" class="form-control" min="1"
                                            placeholder="0" oninput="validateQuantity(); calculateModalTotal();">
                                        <div id="quantityError" class="text-danger small mt-1" style="display: none;">
                                        </div>
                                    </div>
                                    <div class="col-6">
                                        <label class="form-label fw-semibold">Đơn giá nhập</label>
                                        <div class="input-group">
                                            <input type="number" id="modalPrice" class="form-control" min="0"
                                                step="1000" placeholder="0" oninput="calculateModalTotal()">
                                            <span class="input-group-text small">đ</span>
                                        </div>
                                    </div>
                                </div>

                                <div class="modal-total-box mt-4">
                                    <span class="modal-total-label">Thành tiền dự kiến</span>
                                    <span id="modalTotalDisplay" class="modal-total-amount text-primary">0₫</span>
                                </div>
                            </div>
                            <div class="modal-footer border-0">
                                <button type="button"
                                    class="btn btn-link text-secondary text-decoration-none fw-semibold"
                                    onclick="closeAddMedicineModal()">Hủy</button>
                                <button type="button" class="btn btn-primary px-4 fw-bold" style="border-radius: 12px;"
                                    onclick="addMedicineFromModal()">
                                    Xác nhận thêm
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Quick Add Supplier Modal -->
                    <div id="quickSupplierModal" class="modal" style="z-index: 9999999 !important;">
                        <div class="modal-content" style="max-width: 480px;">
                            <div class="modal-header">
                                <h5 class="modal-title">
                                    <i class="fas fa-truck-field me-2 text-primary"></i>
                                    Nhà cung cấp mới
                                </h5>
                                <button type="button" class="close-btn" onclick="closeQuickSupplierModal()">
                                    <i class="fas fa-times"></i>
                                </button>
                            </div>
                            <div class="modal-body">
                                <form id="quickSupplierForm" class="row g-3">
                                    <div class="col-12">
                                        <label class="form-label fw-semibold">Tên nhà cung cấp <span
                                                class="text-danger">*</span></label>
                                        <input type="text" id="qsName" class="form-control" required
                                            placeholder="Nhập tên NCC">
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label fw-semibold">Địa chỉ</label>
                                        <input type="text" id="qsAddress" class="form-control"
                                            placeholder="Địa chỉ chi tiết">
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label fw-semibold">Thông tin liên hệ</label>
                                        <input type="text" id="qsContact" class="form-control"
                                            placeholder="SĐT hoặc Email">
                                    </div>
                                </form>
                                <div id="qsError" class="alert alert-danger mt-3 py-2 small" style="display: none;">
                                </div>
                            </div>
                            <div class="modal-footer border-0">
                                <button type="button"
                                    class="btn btn-link text-secondary text-decoration-none fw-semibold"
                                    onclick="closeQuickSupplierModal()">Hủy</button>
                                <button type="button" class="btn btn-primary px-4 fw-bold" style="border-radius: 12px;"
                                    id="btnSaveSupplier" onclick="saveQuickSupplier()">
                                    <span id="qsSpinner" class="spinner-border spinner-border-sm me-2"
                                        style="display: none;"></span>
                                    Lưu thông tin
                                </button>
                            </div>
                        </div>
                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>