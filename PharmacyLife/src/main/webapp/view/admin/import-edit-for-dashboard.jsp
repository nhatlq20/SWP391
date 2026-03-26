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
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger alert-dismissible fade show m-3" role="alert">
                                    <i class="fas fa-exclamation-circle me-2"></i>${error}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"
                                        aria-label="Close"></button>
                                </div>
                            </c:if>
                            <c:if test="${not empty sessionScope.message}">
                                <div class="alert alert-success alert-dismissible fade show m-3" role="alert">
                                    <i class="fas fa-check-circle me-2"></i>${sessionScope.message}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"
                                        aria-label="Close"></button>
                                </div>
                                <c:remove var="message" scope="session" />
                            </c:if>

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
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <label class="info-label" for="supplierId">Nhà cung cấp</label>
                                                    <button type="button" class="btn btn-sm text-primary p-0"
                                                        onclick="openAddSupplierModal()" title="Thêm nhà cung cấp mới">
                                                        <i class="fas fa-plus-circle"></i>
                                                    </button>
                                                </div>
                                                <div class="info-value" style="min-width: 0; display: block; width: 100%;">
                                                    <select name="supplierId" id="supplierId" required
                                                        class="form-select border-0 bg-transparent p-0"
                                                        style="box-shadow: none; text-overflow: ellipsis; overflow: hidden; white-space: nowrap; width: 100%; padding-right: 1.25rem !important; background-position: right 0px center !important;">
                                                        <option value="">-- Chọn nhà cung cấp --</option>
                                                        <c:forEach var="supplier" items="${suppliers}">
                                                            <option value="${supplier.supplierId}"
                                                                ${supplier.supplierId==importRecord.supplierId
                                                                ? 'selected' : '' }>${supplier.supplierName}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="info-item">
                                                <label class="info-label" for="importDate">Ngày nhập</label>
                                                <div class="info-value">
                                                    <input type="date" name="importDate" id="importDate" required
                                                        readonly class="form-control border-0 bg-transparent p-0"
                                                        style="box-shadow: none; pointer-events: none;"
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
                                                    style="background-color: #4F81E1; color: white; border: none;"
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
                                                        <tr>
                                                            <td colspan="6" class="empty-state">
                                                                <div>
                                                                    <i class="fas fa-spinner fa-spin mb-3"></i>
                                                                    <p>Đang tải dữ liệu...</p>
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
                                                <i class="fas fa-save me-2"></i>Cập nhật phiếu
                                            </button>
                                        </div>
                                    </div>
                                </form>
                            </c:if>
                        </div>
                    </div>

                    <!-- Hidden form for deleting details to avoid nested forms -->
                    <form id="deleteDetailForm" action="${pageContext.request.contextPath}/admin/imports" method="POST"
                        style="display: none;">
                        <input type="hidden" name="action" value="deleteDetail">
                        <input type="hidden" name="detailId" id="deleteDetailId">
                        <input type="hidden" name="importId" value="${importRecord.importId}">
                    </form>

                    <!-- Modal Thêm Thuốc -->
                    <div id="addMedicineModal" class="modal">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title"><i class="fas fa-plus-circle me-2 text-primary"></i>Thêm thuốc
                                    vào phiếu nhập</h5>
                                <button type="button" class="close-btn"
                                    onclick="closeAddMedicineModal()">&times;</button>
                            </div>
                            <div class="modal-body">
                                <div class="form-group mb-3">
                                    <label class="form-label fw-bold">Danh mục thuốc</label>
                                    <select id="modalCategoryId" class="form-select shadow-sm"
                                        onchange="filterMedicinesByCategory()"
                                        style="text-overflow: ellipsis; overflow: hidden; white-space: nowrap; padding-right: 2.25rem !important;">
                                        <option value="">-- Tất cả danh mục --</option>
                                        <c:forEach var="cat" items="${categories}">
                                            <option value="${cat.categoryId}">${cat.categoryName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="form-group mb-4">
                                    <label class="form-label fw-bold">Chọn thuốc nhập</label>
                                    <select id="modalMedicineId" class="form-select shadow-sm"
                                        style="text-overflow: ellipsis; overflow: hidden; white-space: nowrap; padding-right: 2.25rem !important;">
                                        <option value="">-- Tìm và chọn thuốc --</option>
                                        <c:forEach var="med" items="${medicines}">
                                            <option value="${med.medicineId}" data-category="${med.categoryId}"
                                                data-unit="${not empty med.unit ? med.unit : ''}"
                                                                                                 data-unit-id="${not empty med.baseUnit ? med.baseUnit.unitId : 0}"
                                                 data-original-price="${med.originalPrice}"
                                                 data-conversion-rate="${not empty med.baseUnit ? med.baseUnit.conversionRate : 1}">
                                                ${med.medicineCode} - ${med.medicineName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="form-group mb-4">
                                    <label class="form-label fw-bold">Đơn vị</label>
                                    <input type="text" id="modalUnit" class="form-control shadow-sm bg-light" readonly
                                        placeholder="Tự động hiện đơn vị">
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
                                            <input type="number" id="modalPrice" class="form-control shadow-sm" min="1"
                                                max="100000000" step="1000" placeholder="Nhập đơn giá"
                                                oninput="validatePrice(); calculateModalTotal();">
                                            <div id="priceError"
                                                style="color: #dc3545; font-size: 0.8rem; margin-top: 4px; display: none;">
                                            </div>
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
                                    style="border-radius: 8px; background-color: #4F81E1; border: none;"
                                    onclick="addMedicineFromModal()">Thêm vào danh sách</button>
                            </div>

                            <!-- Modal Thêm Nhà Cung Cấp Mới -->
                            <div id="addSupplierModal" class="modal">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title"><i class="fas fa-truck me-2 text-primary"></i>Thêm nhà
                                            cung cấp
                                            mới</h5>
                                        <button type="button" class="close-btn"
                                            onclick="closeAddSupplierModal()">&times;</button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="form-group mb-4">
                                            <label class="form-label fw-bold">Tên nhà cung cấp <span
                                                    class="text-danger">*</span></label>
                                            <input type="text" id="newSupplierName" class="form-control shadow-sm"
                                                placeholder="Nhập tên nhà cung cấp">
                                        </div>
                                        <div class="form-group mb-4">
                                            <label class="form-label fw-bold">Địa chỉ</label>
                                            <input type="text" id="newSupplierAddress" class="form-control shadow-sm"
                                                placeholder="Nhập địa chỉ">
                                        </div>
                                        <div class="form-group mb-4">
                                            <label class="form-label fw-bold">Thông tin liên hệ</label>
                                            <input type="text" id="newSupplierContact" class="form-control shadow-sm"
                                                placeholder="Số điện thoại / Email">
                                        </div>
                                        <div id="supplierError"
                                            style="color: #dc3545; font-size: 0.8rem; margin-top: 4px; display: none;">
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-light px-4 py-2 fw-semibold"
                                            style="border-radius: 8px;" onclick="closeAddSupplierModal()">Hủy
                                            bỏ</button>
                                        <button type="button" class="btn btn-primary px-4 py-2 fw-semibold"
                                            style="border-radius: 8px; background-color: #4F81E1; border: none;"
                                            onclick="saveNewSupplier()">Lưu thông tin</button>
                                    </div>
                                </div>
                            </div>

                            <script>
                                let medicineList = [];

                                // Initialize medicineList from server-side details
                                <c:if test="${not empty details}">
                                    <c:forEach var="detail" items="${details}">
                                        medicineList.push({
                                            detailId: ${not empty detail.detailId ? detail.detailId : 0},
                                            medicineId: ${not empty detail.medicineId ? detail.medicineId : 0},
                                            medicineCode: "${not empty detail.medicineCode ? detail.medicineCode : ''}",
                                            medicineName: "${not empty detail.medicineName ? detail.medicineName : ''}",
                                            quantity: ${not empty detail.quantity ? detail.quantity : 0},
                                            price: ${not empty detail.unitPrice ? detail.unitPrice : 0},
                                            total: ${detail.totalAmount}
                                        });
                                    </c:forEach>
                                </c:if>
                                console.log("Medicine List initialized:", medicineList);

                                function openAddMedicineModal() {
                                    document.getElementById('addMedicineModal').style.display = 'block';
                                    document.getElementById('modalCategoryId').value = '';
                                    filterMedicinesByCategory(); // Reset filter
                                    document.getElementById('modalMedicineId').value = '';
                                    document.getElementById('modalUnit').value = '';
                                    document.getElementById('modalQuantity').value = '';
                                    document.getElementById('modalPrice').value = '';
                                    document.getElementById('modalTotalDisplay').textContent = '0₫';
                                    document.getElementById('quantityError').style.display = 'none';
                                    document.getElementById('priceError').style.display = 'none';
                                }

                                function closeAddMedicineModal() {
                                    document.getElementById('addMedicineModal').style.display = 'none';
                                }

                                function filterMedicinesByCategory() {
                                    const categoryId = document.getElementById('modalCategoryId').value;
                                    const medicineSelect = document.getElementById('modalMedicineId');
                                    const options = medicineSelect.querySelectorAll('option');

                                    options.forEach(option => {
                                        if (option.value === "") { // Header option
                                            option.style.display = "block";
                                            return;
                                        }

                                        const medCategory = option.getAttribute('data-category');
                                        if (!categoryId || categoryId.trim() === "" || medCategory == categoryId) {
                                            option.style.display = "block";
                                        } else {
                                            option.style.display = "none";
                                            if (medicineSelect.value === option.value) {
                                                medicineSelect.value = "";
                                            }
                                        }
                                    });
                                }

                                function openAddSupplierModal() {
                                    document.getElementById('addSupplierModal').style.display = 'block';
                                    document.getElementById('newSupplierName').value = '';
                                    document.getElementById('newSupplierAddress').value = '';
                                    document.getElementById('newSupplierContact').value = '';
                                    document.getElementById('supplierError').style.display = 'none';
                                }

                                function closeAddSupplierModal() {
                                    document.getElementById('addSupplierModal').style.display = 'none';
                                }

                                async function saveNewSupplier() {
                                    const name = document.getElementById('newSupplierName').value.trim();
                                    const address = document.getElementById('newSupplierAddress').value.trim();
                                    const contact = document.getElementById('newSupplierContact').value.trim();
                                    const errorDiv = document.getElementById('supplierError');

                                    if (!name) {
                                        errorDiv.textContent = 'Vui lòng nhập tên nhà cung cấp';
                                        errorDiv.style.display = 'block';
                                        return;
                                    }

                                    try {
                                        const params = new URLSearchParams();
                                        params.append('action', 'createSupplier');
                                        params.append('supplierName', name);
                                        params.append('supplierAddress', address);
                                        params.append('contactInfo', contact);

                                        const response = await fetch(`${pageContext.request.contextPath}/admin/imports`, {
                                            method: 'POST',
                                            headers: {
                                                'Content-Type': 'application/x-www-form-urlencoded',
                                            },
                                            body: params
                                        });

                                        const result = await response.json();
                                        if (result.success) {
                                            // Thêm vào select box
                                            const select = document.getElementById('supplierId');
                                            const option = new Option(result.supplierName, result.supplierId);
                                            select.add(option);
                                            select.value = result.supplierId;

                                            closeAddSupplierModal();
                                            alert('Đã thêm nhà cung cấp mới thành công!');
                                        } else {
                                            errorDiv.textContent = result.message || 'Có lỗi xảy ra khi tạo nhà cung cấp';
                                            errorDiv.style.display = 'block';
                                        }
                                    } catch (error) {
                                        console.error('Error:', error);
                                        errorDiv.textContent = 'Lỗi kết nối server';
                                        errorDiv.style.display = 'block';
                                    }
                                }

                                document.getElementById('modalMedicineId').addEventListener('change', function () {
                                    const medicineId = this.value;
                                    const selectedOption = this.options[this.selectedIndex];
                                    const unit = selectedOption.getAttribute('data-unit') || '';
                                    const originalPrice = parseFloat(selectedOption.getAttribute('data-original-price')) || 0;
                                    const conversionRate = parseInt(selectedOption.getAttribute('data-conversion-rate')) || 1;

                                    document.getElementById('modalUnit').value = unit;

                                    if (medicineId && medicineId.trim() !== '') {
                                        // Pre-populate price based on OriginalPrice and ConversionRate
                                         const calculatedPrice = originalPrice;
                                        document.getElementById('modalPrice').value = calculatedPrice > 0 ? calculatedPrice : '';
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

                                function validatePrice() {
                                    const priceInput = document.getElementById('modalPrice');
                                    const errorDiv = document.getElementById('priceError');
                                    const value = priceInput.value;
                                    let isValid = true;
                                    if (value === '' || value === null) {
                                        errorDiv.textContent = "Vui lòng nhập đơn giá.";
                                        errorDiv.style.display = 'block';
                                        isValid = false;
                                    } else {
                                        const numValue = parseFloat(value);
                                        if (isNaN(numValue) || numValue <= 0) {
                                            errorDiv.textContent = "Giá nhập phải lớn hơn 0.";
                                            errorDiv.style.display = 'block';
                                            isValid = false;
                                        } else if (numValue > 100000000) {
                                            errorDiv.textContent = "Giá nhập không được vượt quá 100.000.000 VNĐ.";
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
                                    const selectElement = document.getElementById('modalMedicineId');
                                    const medicineId = selectElement.value;
                                    const selectedOption = selectElement.options[selectElement.selectedIndex];
                                    const unitId = selectedOption.getAttribute('data-unit-id');
                                    const quantityInput = document.getElementById('modalQuantity');
                                    const priceInput = document.getElementById('modalPrice');
                                    const quantity = parseInt(quantityInput.value);
                                    const price = parseFloat(priceInput.value);

                                    const isQtyValid = validateQuantity();
                                    const isPriceValid = validatePrice();

                                    if (!medicineId) {
                                        alert("Vui lòng chọn thuốc.");
                                        return;
                                    }

                                    if (!isQtyValid) {
                                        quantityInput.focus();
                                        return;
                                    }

                                    if (!isPriceValid) {
                                        priceInput.focus();
                                        return;
                                    }
                                    if (!validateQuantity()) {
                                        quantityInput.focus();
                                        return;
                                    }

                                    const optionText = selectedOption.text;
                                    const medicineCode = optionText.split(' - ')[0];
                                    const medicineName = optionText.split(' - ')[1] || '';

                                    const total = quantity * price;
                                    medicineList.push({
                                        medicineId: medicineId,
                                        medicineCode: medicineCode,
                                        medicineName: medicineName,
                                        quantity: quantity,
                                        unitId: unitId,
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

                                function updateItem(index, field, value) {
                                    const numValue = parseFloat(value) || 0;
                                    if (field === 'quantity') {
                                        if (numValue <= 0) {
                                            alert("Số lượng phải lớn hơn 0.");
                                            updateTable();
                                            return;
                                        }
                                        medicineList[index].quantity = parseInt(numValue);
                                    } else if (field === 'price') {
                                        if (numValue <= 0 || numValue > 100000000) {
                                            alert("Giá nhập phải lớn hơn 0 và không vượt quá 100.000.000 VNĐ.");
                                            updateTable();
                                            return;
                                        }
                                        medicineList[index].price = numValue;
                                    }
                                    medicineList[index].total = medicineList[index].quantity * medicineList[index].price;
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
                                                deleteBtn = `<button type="button" class="btn-action btn-delete" onclick="submitDeleteDetail(\${item.detailId})">
                                            <i class="fas fa-trash"></i>
                                        </button>`;
                                                // Hidden inputs for existing details updates
                                                hiddenContainer.innerHTML += `
                                            <input type="hidden" name="existingDetails[\${item.detailId}].quantity" value="\${item.quantity}">
                                            <input type="hidden" name="existingDetails[\${item.detailId}].price" value="\${item.price}">
                                        `;
                                            } else {
                                                deleteBtn = `<button type="button" class="btn-action btn-delete" onclick="removeMedicine(\${index})">
                                            <i class="fas fa-trash"></i>
                                        </button>`;
                                                // Hidden inputs for new items
                                                hiddenContainer.innerHTML += `
                                            <input type="hidden" name="newMedicines[\${index}].medicineId" value="\${item.medicineId}">
                                            <input type="hidden" name="newMedicines[\${index}].unitId" value="\${item.unitId}">
                                            <input type="hidden" name="newMedicines[\${index}].quantity" value="\${item.quantity}">
                                            <input type="hidden" name="newMedicines[\${index}].price" value="\${item.price}">
                                        `;
                                            }

                                            tbody.innerHTML += `<tr>
                                        <td><strong>\${item.medicineCode}</strong></td>
                                        <td>\${item.medicineName || '-'}</td>
                                        <td>
                                            <input type="number" class="form-control form-control-sm" style="width: 80px;" 
                                                value="\${item.quantity}" onchange="updateItem(\${index}, 'quantity', this.value)">
                                        </td>
                                        <td>
                                            <input type="number" class="form-control form-control-sm" style="width: 120px;" 
                                                value="\${item.price}" onchange="updateItem(\${index}, 'price', this.value)">
                                        </td>
                                        <td><span class="price">\${formatCurrency(item.total)}</span></td>
                                        <td style="text-align: center;">\${deleteBtn}</td>
                                    </tr>`;
                                        });
                                    }
                                }

                                function formatCurrency(amount) {
                                    return new Intl.NumberFormat('vi-VN').format(amount) + '₫';
                                }

                                window.onclick = function (event) {
                                    const medicineModal = document.getElementById('addMedicineModal');
                                    const supplierModal = document.getElementById('addSupplierModal');
                                    if (event.target === medicineModal) closeAddMedicineModal();
                                    if (event.target === supplierModal) closeAddSupplierModal();
                                }
                                function submitDeleteDetail(detailId) {
                                    if (confirm('Xóa thuốc này? (Phiếu phải có ít nhất 1 loại thuốc)')) {
                                        document.getElementById('deleteDetailId').value = detailId;
                                        document.getElementById('deleteDetailForm').submit();
                                    }
                                }

                                // Initialize table on load
                                document.addEventListener('DOMContentLoaded', function () {
                                    updateTable();
                                });
                            </script>
                            <script
                                src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>