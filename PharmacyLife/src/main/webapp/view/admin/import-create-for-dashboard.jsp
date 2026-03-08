<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Tạo phiếu nhập - Admin</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/medicine-dashboard.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/import.css">
                    <script type="text/javascript">
                        // Nuclear option: Define functions in Head
                        window.openAddMedicineModal = function (event) {
                            if (event) event.stopPropagation();
                            console.log("CRITICAL: openAddMedicineModal triggered!");
                            // alert("DEBUG: Nút 'Thêm thuốc' đã được nhấn!"); // Uncomment if needed

                            var modalObj = document.getElementById('addMedicineModal');
                            if (!modalObj) {
                                console.error("Could not find addMedicineModal");
                                return;
                            }
                            modalObj.style.setProperty('display', 'flex', 'important');
                            modalObj.style.setProperty('z-index', '9999999', 'important');

                            if (typeof window.filterMedicinesByCategory === 'function') {
                                window.filterMedicinesByCategory();
                            }
                        };
                        window.closeAddMedicineModal = function (event) {
                            if (event) event.stopPropagation();
                            var modalObj = document.getElementById('addMedicineModal');
                            if (modalObj) modalObj.style.setProperty('display', 'none', 'important');
                        };
                    </script>
                </head>

                <body class="bg-light">
                    <jsp:include page="/view/common/header.jsp" />
                    <jsp:include page="/view/common/sidebar.jsp" />

                    <!-- Move modal to top of body for safer stacking -->
                    <div id="addMedicineModal" class="modal" style="display: none; z-index: 9999999 !important;">
                        <div class="modal-content" style="max-width: 600px; margin: auto;">
                            <div class="modal-header">
                                <h5 class="modal-title">
                                    <i class="fas fa-pills me-2 text-primary"></i>
                                    Thêm thuốc nhập
                                </h5>
                                <button type="button" class="close-btn" onclick="window.closeAddMedicineModal(event)">
                                    <i class="fas fa-times"></i>
                                </button>
                            </div>
                            <div class="modal-body">
                                <div class="row g-3">
                                    <div class="col-12">
                                        <label class="form-label fw-semibold">Danh mục</label>
                                        <select id="modalCategoryId" class="form-select"
                                            onchange="window.filterMedicinesByCategory()">
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
                                            placeholder="0"
                                            oninput="window.validateQuantityInput(); window.calculateModalTotal();">
                                        <div id="quantityError" class="text-danger small mt-1" style="display: none;">
                                        </div>
                                    </div>
                                    <div class="col-6">
                                        <label class="form-label fw-semibold">Đơn giá nhập</label>
                                        <div class="input-group">
                                            <input type="number" id="modalPrice" class="form-control" min="0"
                                                step="1000" placeholder="0" oninput="window.calculateModalTotal()">
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
                                    onclick="window.closeAddMedicineModal(event)">Hủy</button>
                                <button type="button" class="btn btn-primary px-4 fw-bold" style="border-radius: 12px;"
                                    onclick="window.addMedicineFromModal()">
                                    Xác nhận thêm
                                </button>
                            </div>
                        </div>
                    </div>

                    <div class="main-content" style="pointer-events: auto !important; position: relative; z-index: 10;">
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
                                                <div class="d-flex align-items-center gap-2">
                                                    <select name="supplierId" id="supplierId" required
                                                        class="form-select border-0 bg-transparent p-0"
                                                        style="box-shadow: none; flex-grow: 1;">
                                                        <option value="">-- Chọn nhà cung cấp --</option>
                                                        <c:forEach var="supplier" items="${suppliers}">
                                                            <option value="${supplier.supplierId}">
                                                                ${supplier.supplierName}
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
                                            <button type="button" id="btnAddMedicine" class="btn btn-add-medicine"
                                                onclick="window.openAddMedicineModal(event)"
                                                style="position: relative; z-index: 20000 !important; pointer-events: auto !important; cursor: pointer !important;">
                                                <i class="fas fa-plus me-2"></i>Thêm thuốc
                                            </button>
                                            <script>
                                                // Immediate backup listener
                                                (function () {
                                                    var b = document.getElementById('btnAddMedicine');
                                                    if (b) b.addEventListener('click', function (e) {
                                                        console.log("Listener fired for btnAddMedicine");
                                                        window.openAddMedicineModal(e);
                                                    });
                                                })();
                                            </script>
                                        </div>

                                        <div class="table-responsive" style="position: relative; z-index: 1;">
                                            <table class="table medicine-table align-middle" style="margin-bottom: 0;">
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
                                                    <tr>
                                                        <td colspan="7" class="empty-state">
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

                    <!-- JS Implementation -->
                    <script type="text/javascript">
                        (function () {
                            try {
                                console.log("PharmacyLife: Initializing data and secondary logic...");

                                // ==========================================
                                // 1. Data Initialization & Setup
                                // ==========================================
                                let medicineList = [];
                                let totalAmount = 0;

                                // Data from JSP populated into window-scope for access by functions
                                window.allMedicineOptions = [
                                    <c:if test="${not empty medicines}">
                                        <c:forEach var="med" items="${medicines}" varStatus="status">
                                            {
                                                "value": "${med.medicineId}",
                                            "text": "${fn:escapeXml(med.medicineCode)} - ${fn:escapeXml(med.medicineName)}",
                                            "categoryId": "${med.categoryId}" 
                                            }${status.last ? '' : ','}
                                        </c:forEach>
                                    </c:if>
                                ];

                                window.allMedicineUnits = [
                                    <c:if test="${not empty medicineUnits}">
                                        <c:forEach var="unit" items="${medicineUnits}" varStatus="status">
                                            {
                                                "unitId": "${unit.unitId}",
                                            "medicineId": "${unit.medicineId}",
                                            "unitName": "${fn:escapeXml(unit.unitName)}",
                                            "isBaseUnit": ${unit.isBaseUnit == true} 
                                            }${status.last ? '' : ','}
                                        </c:forEach>
                                    </c:if>
                                ];

                                // ==========================================
                                // 2. UI Helper Functions
                                // ==========================================
                                function formatCurrency(amount) {
                                    return new Intl.NumberFormat('vi-VN').format(amount || 0) + '₫';
                                }

                                window.calculateModalTotal = function () {
                                    const qty = parseFloat(document.getElementById('modalQuantity')?.value) || 0;
                                    const price = parseFloat(document.getElementById('modalPrice')?.value) || 0;
                                    const display = document.getElementById('modalTotalDisplay');
                                    if (display) display.textContent = formatCurrency(qty * price);
                                };

                                // ==========================================
                                // 3. Business Logic Functions
                                // ==========================================
                                window.filterMedicinesByCategory = function () {
                                    const categoryId = document.getElementById('modalCategoryId')?.value;
                                    const medicineSelect = document.getElementById('modalMedicineId');
                                    if (!medicineSelect) return;

                                    const currentValue = medicineSelect.value;
                                    medicineSelect.innerHTML = '<option value="">-- ' + (categoryId ? 'Chọn thuốc' : 'Chọn danh mục hoặc tìm tất cả') + ' --</option>';

                                    if (window.allMedicineOptions && Array.isArray(window.allMedicineOptions)) {
                                        window.allMedicineOptions.forEach(opt => {
                                            if (!categoryId || String(opt.categoryId) === String(categoryId)) {
                                                const newOpt = document.createElement('option');
                                                newOpt.value = opt.value;
                                                newOpt.textContent = opt.text;
                                                newOpt.setAttribute('data-category', opt.categoryId);
                                                if (opt.value === currentValue) newOpt.selected = true;
                                                medicineSelect.appendChild(newOpt);
                                            }
                                        });
                                    }
                                };

                                window.updateUnitOptions = function () {
                                    const medId = document.getElementById('modalMedicineId')?.value;
                                    const unitSelect = document.getElementById('modalUnitId');
                                    if (!unitSelect) return;

                                    unitSelect.innerHTML = '<option value="">-- Chọn đơn vị --</option>';
                                    if (!medId || !window.allMedicineUnits) return;

                                    window.allMedicineUnits.filter(u => String(u.medicineId) === String(medId)).forEach(u => {
                                        let opt = document.createElement('option');
                                        opt.value = u.unitId;
                                        opt.textContent = u.unitName;
                                        if (u.isBaseUnit) opt.selected = true;
                                        unitSelect.appendChild(opt);
                                    });
                                };

                                window.validateQuantityInput = function () {
                                    const input = document.getElementById('modalQuantity');
                                    const errorDiv = document.getElementById('quantityError');
                                    if (!input || !errorDiv) return;

                                    const val = input.value;
                                    let msg = '';
                                    if (val === '' || val === null) msg = 'Vui lòng nhập số lượng.';
                                    else if (isNaN(val) || parseInt(val) <= 0) msg = 'Số lượng phải lớn hơn 0.';
                                    else if (parseInt(val) > 1000) msg = 'Số lượng không được vượt quá 1000.';

                                    if (msg) { errorDiv.textContent = msg; errorDiv.style.display = 'block'; }
                                    else { errorDiv.textContent = ''; errorDiv.style.display = 'none'; }
                                };

                                window.addMedicineFromModal = function () {
                                    const medicineId = document.getElementById('modalMedicineId')?.value;
                                    const unitSelect = document.getElementById('modalUnitId');
                                    const unitId = unitSelect?.value;
                                    const unitName = unitSelect?.options[unitSelect.selectedIndex]?.text || '';
                                    const quantityInput = document.getElementById('modalQuantity');
                                    const price = parseFloat(document.getElementById('modalPrice')?.value);
                                    const quantity = parseInt(quantityInput?.value);

                                    if (!medicineId || !unitId || !price || isNaN(quantity) || quantity <= 0) {
                                        alert("Vui lòng nhập đầy đủ và chính xác thông tin thuốc.");
                                        return;
                                    }

                                    const selectedOption = document.getElementById('modalMedicineId')?.options[document.getElementById('modalMedicineId').selectedIndex];
                                    const optionText = selectedOption?.text || '';
                                    const medicineCode = optionText.split(' - ')[0];
                                    const medicineName = optionText.split(' - ')[1] || '';

                                    medicineList.push({
                                        medicineId: medicineId,
                                        unitId: unitId,
                                        unitName: unitName,
                                        medicineCode: medicineCode,
                                        medicineName: medicineName,
                                        quantity: quantity,
                                        price: price,
                                        total: quantity * price
                                    });
                                    updateTable();
                                    window.closeAddMedicineModal();
                                };

                                window.removeMedicine = function (index) {
                                    medicineList.splice(index, 1);
                                    updateTable();
                                };

                                function updateTable() {
                                    const tbody = document.getElementById('medicineListBody');
                                    const hiddenContainer = document.getElementById('hiddenInputsContainer');
                                    if (!tbody || !hiddenContainer) return;

                                    tbody.innerHTML = '';
                                    hiddenContainer.innerHTML = '';
                                    totalAmount = 0;

                                    if (medicineList.length === 0) {
                                        tbody.innerHTML = `<tr><td colspan="7" class="empty-state"><div><i class="fas fa-clipboard-list mb-3"></i><p>Chưa có dữ liệu thuốc nhập</p></div></td></tr>`;
                                    } else {
                                        medicineList.forEach((item, index) => {
                                            totalAmount += item.total;
                                            tbody.innerHTML += `<tr>
                                                <td><strong>\${item.medicineCode}</strong></td>
                                                <td>\${item.medicineName || '-'}</td>
                                                <td>\${item.unitName || '-'}</td>
                                                <td>\${item.quantity}</td>
                                                <td><span class="price">\${formatCurrency(item.price)}</span></td>
                                                <td><span class="price">\${formatCurrency(item.total)}</span></td>
                                                <td style="text-align: center;">
                                                    <button type="button" class="btn-action btn-delete" onclick="removeMedicine(\${index})">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </td>
                                            </tr>`;
                                            hiddenContainer.innerHTML += `<input type="hidden" name="medicines[\${index}].medicineId" value="\${item.medicineId}">` +
                                                `<input type="hidden" name="medicines[\${index}].unitId" value="\${item.unitId}">` +
                                                `<input type="hidden" name="medicines[\${index}].quantity" value="\${item.quantity}">` +
                                                `<input type="hidden" name="medicines[\${index}].price" value="\${item.price}">`;
                                        });
                                    }
                                    const totalDisp = document.getElementById('totalDisplay');
                                    if (totalDisp) totalDisp.textContent = formatCurrency(totalAmount);
                                }

                                window.saveQuickSupplier = function () {
                                    const name = document.getElementById('qsName').value.trim();
                                    const address = document.getElementById('qsAddress').value.trim();
                                    const contact = document.getElementById('qsContact').value.trim();
                                    const errorDiv = document.getElementById('qsError');
                                    const btn = document.getElementById('btnSaveSupplier');
                                    const spinner = document.getElementById('qsSpinner');

                                    if (!name) {
                                        if (errorDiv) { errorDiv.textContent = 'Vui lòng nhập tên nhà cung cấp'; errorDiv.style.display = 'block'; }
                                        return;
                                    }

                                    if (errorDiv) errorDiv.style.display = 'none';
                                    if (btn) btn.disabled = true;
                                    if (spinner) spinner.style.display = 'inline-block';

                                    const params = new URLSearchParams();
                                    params.append('supplierName', name);
                                    params.append('supplierAddress', address);
                                    params.append('contactInfo', contact);

                                    fetch('${pageContext.request.contextPath}/admin/suppliers/quick-add', {
                                        method: 'POST',
                                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                        body: params
                                    })
                                        .then(response => response.json())
                                        .then(data => {
                                            if (data.success) {
                                                const select = document.getElementById('supplierId');
                                                if (select) {
                                                    const option = new Option(data.name, data.id);
                                                    select.add(option);
                                                    select.value = data.id;
                                                }
                                                window.closeQuickSupplierModal();
                                                alert('Đã thêm nhà cung cấp: ' + data.name);
                                            } else {
                                                if (errorDiv) { errorDiv.textContent = data.message || 'Lỗi khi thêm nhà cung cấp'; errorDiv.style.display = 'block'; }
                                            }
                                        })
                                        .catch(error => {
                                            console.error('Error:', error);
                                            if (errorDiv) { errorDiv.textContent = 'Lỗi hệ thống khi kết nối server'; errorDiv.style.display = 'block'; }
                                        })
                                        .finally(() => {
                                            if (btn) btn.disabled = false;
                                            if (spinner) spinner.style.display = 'none';
                                        });
                                };

                                window.openQuickSupplierModal = function () {
                                    const modal = document.getElementById('quickSupplierModal');
                                    if (!modal) return;
                                    modal.style.setProperty('display', 'flex', 'important');
                                    document.getElementById('qsName').value = '';
                                    document.getElementById('qsAddress').value = '';
                                    document.getElementById('qsContact').value = '';
                                    document.getElementById('qsError').style.display = 'none';
                                };

                                window.closeQuickSupplierModal = function () {
                                    const modal = document.getElementById('quickSupplierModal');
                                    if (modal) modal.style.setProperty('display', 'none', 'important');
                                };

                                // Initialization & Event Binding
                                document.addEventListener('DOMContentLoaded', function () {
                                    console.log("DOM loaded, initializing listeners...");
                                    const modalMedSelect = document.getElementById('modalMedicineId');
                                    if (modalMedSelect) {
                                        modalMedSelect.addEventListener('change', function () {
                                            const p = document.getElementById('modalPrice');
                                            if (p) p.value = '';
                                            window.calculateModalTotal();
                                            window.updateUnitOptions();
                                        });
                                    }

                                    const importForm = document.getElementById('importForm');
                                    if (importForm) {
                                        importForm.addEventListener('submit', function (e) {
                                            if (medicineList.length === 0) {
                                                alert('Vui lòng thêm ít nhất một loại thuốc.');
                                                e.preventDefault();
                                            }
                                        });
                                    }
                                });

                                // Event for outside click
                                window.onclick = function (event) {
                                    const modalMed = document.getElementById('addMedicineModal');
                                    const modalSup = document.getElementById('quickSupplierModal');
                                    if (event.target === modalMed) window.closeAddMedicineModal(event);
                                    if (event.target === modalSup) window.closeQuickSupplierModal();
                                };

                            } catch (err) {
                                console.error("Critical error in PharmacyLife JS initialization:", err);
                            }
                        })();
                    </script>

                    <!-- Quick Add Supplier Modal -->
                    <div id="quickSupplierModal" class="modal" style="display: none; z-index: 9999999 !important;">
                        <div class="modal-content" style="max-width: 500px;">
                            <div class="modal-header">
                                <h5 class="modal-title"><i class="fas fa-truck-field me-2 text-primary"></i>Thêm nhà
                                    cung cấp mới</h5>
                                <button type="button" class="close-btn"
                                    onclick="closeQuickSupplierModal()">&times;</button>
                            </div>
                            <div class="modal-body">
                                <form id="quickSupplierForm">
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">Tên nhà cung cấp <span
                                                class="text-danger">*</span></label>
                                        <input type="text" id="qsName" class="form-control" required
                                            placeholder="Nhập tên nhà cung cấp">
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">Địa chỉ</label>
                                        <input type="text" id="qsAddress" class="form-control"
                                            placeholder="Số nhà, đường, quận/huyện...">
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">Thông tin liên hệ</label>
                                        <input type="text" id="qsContact" class="form-control"
                                            placeholder="Số điện thoại hoặc email">
                                    </div>
                                </form>
                                <div id="qsError" class="alert alert-danger"
                                    style="display: none; padding: 8px; font-size: 0.9rem;"></div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-light"
                                    onclick="closeQuickSupplierModal()">Hủy</button>
                                <button type="button" class="btn btn-primary" id="btnSaveSupplier"
                                    onclick="saveQuickSupplier()">
                                    <span id="qsSpinner" class="spinner-border spinner-border-sm me-2"
                                        style="display: none;"></span>
                                    Lưu nhà cung cấp
                                </button>
                            </div>
                        </div>
                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>