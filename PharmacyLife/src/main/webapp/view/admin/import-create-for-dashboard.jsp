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
                </head>

                <body class="bg-light">
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
                            <c:if test="${not empty sessionScope.message}">
                                <div class="alert alert-success alert-dismissible fade show m-3" role="alert">
                                    <i class="fas fa-check-circle me-2"></i>${sessionScope.message}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"
                                        aria-label="Close"></button>
                                </div>
                                <c:remove var="message" scope="session" />
                            </c:if>

                            <form method="POST" action="${pageContext.request.contextPath}/admin/imports"
                                id="importForm">
                                <input type="hidden" name="action" value="create">
                                <input type="hidden" name="importCode" value="${newCode != null ? newCode : 'IP001'}">

                                <div class="form-card-body">
                                    <!-- Info Grid for Form Fields -->
                                    <div class="info-grid mb-4">
                                        <div class="info-item">
                                            <div class="info-label">Mã phiếu nhập</div>
                                            <div class="info-value text-muted">${newCode != null ? newCode : 'Sẽ được
                                                tạo tự động'}</div>
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
                                                        <option value="${supplier.supplierId}">${supplier.supplierName}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="info-item">
                                            <label class="info-label" for="importDate">Ngày nhập</label>
                                            <div class="info-value">
                                                <input type="date" name="importDate" id="importDate" required readonly
                                                    class="form-control border-0 bg-transparent p-0"
                                                    style="box-shadow: none; pointer-events: none;"
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
                                            <button type="button" class="btn btn-add-medicine btn-primary"
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
                                                data-unit="${med.unit}" data-unit-id="${med.baseUnit.unitId}">
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
                                            <input type="number" id="modalPrice" class="form-control shadow-sm" min="1"
                                                max="100000000" step="1000" placeholder="Nhập đơn giá"
                                                oninput="validatePriceInput(); calculateModalTotal();">
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
                        </div>
                    </div>

                    <!-- Modal Thêm Nhà Cung Cấp Mới -->
                    <div id="addSupplierModal" class="modal">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title"><i class="fas fa-truck me-2 text-primary"></i>Thêm nhà cung cấp
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
                                    style="color: #dc3545; font-size: 0.8rem; margin-top: 4px; display: none;"></div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-light px-4 py-2 fw-semibold"
                                    style="border-radius: 8px;" onclick="closeAddSupplierModal()">Hủy bỏ</button>
                                <button type="button" class="btn btn-primary px-4 py-2 fw-semibold"
                                    style="border-radius: 8px; background-color: #4F81E1; border: none;"
                                    onclick="saveNewSupplier()">Lưu thông tin</button>
                            </div>
                        </div>
                    </div>

                    <script>
                        let medicineList = [];
                        let totalAmount = 0;

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

                            let firstVisible = true;
                            options.forEach(option => {
                                if (option.value === "") { // Header option
                                    option.style.display = "block";
                                    return;
                                }

                                const medCategory = option.getAttribute('data-category');
                                if (!categoryId || medCategory === categoryId) {
                                    option.style.display = "block";
                                    if (firstVisible && medicineSelect.value === "") {
                                        // firstVisible = false;
                                    }
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
                            document.getElementById('modalUnit').value = unit;

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
                            let isValid = true;
                            if (value === '' || value === null) {
                                errorDiv.textContent = 'Vui lòng nhập số lượng.';
                                errorDiv.style.display = 'block';
                                isValid = false;
                            } else if (isNaN(value) || parseInt(value) <= 0) {
                                errorDiv.textContent = 'Số lượng phải lớn hơn 0.';
                                errorDiv.style.display = 'block';
                                isValid = false;
                            } else if (parseInt(value) > 1000) {
                                errorDiv.textContent = 'Số lượng không được vượt quá 1000.';
                                errorDiv.style.display = 'block';
                                isValid = false;
                            } else {
                                errorDiv.textContent = '';
                                errorDiv.style.display = 'none';
                            }
                            calculateModalTotal();
                            return isValid;
                        }

                        function validatePriceInput() {
                            const priceInput = document.getElementById('modalPrice');
                            const errorDiv = document.getElementById('priceError');
                            const value = priceInput.value;
                            let isValid = true;
                            if (value === '' || value === null) {
                                errorDiv.textContent = 'Vui lòng nhập đơn giá.';
                                errorDiv.style.display = 'block';
                                isValid = false;
                            } else {
                                const numValue = parseFloat(value);
                                if (isNaN(numValue) || numValue <= 0) {
                                    errorDiv.textContent = 'Giá nhập phải lớn hơn 0.';
                                    errorDiv.style.display = 'block';
                                    isValid = false;
                                } else if (numValue > 100000000) {
                                    errorDiv.textContent = 'Giá nhập không được vượt quá 100.000.000 VNĐ.';
                                    errorDiv.style.display = 'block';
                                    isValid = false;
                                } else {
                                    errorDiv.textContent = '';
                                    errorDiv.style.display = 'none';
                                }
                            }
                            calculateModalTotal();
                            return isValid;
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

                            const isQtyValid = validateQuantityInput();
                            const isPriceValid = validatePriceInput();

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

                            // Lấy tên thuốc từ option
                            const optionText = selectedOption.text;

                            const total = quantity * price;
                            medicineList.push({
                                medicineId: medicineId,
                                medicineCode: selectedOption.text.split(' - ')[0],
                                medicineName: selectedOption.text.split(' - ')[1],
                                quantity: quantity,
                                unitId: unitId,
                                price: price,
                                total: quantity * price
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
                                    hiddenContainer.innerHTML += `
                                        <input type="hidden" name="medicines[\${index}].medicineId" value="\${item.medicineId}">
                                        <input type="hidden" name="medicines[\${index}].unitId" value="\${item.unitId}">
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

                        window.onclick = function (event) {
                            const medicineModal = document.getElementById('addMedicineModal');
                            const supplierModal = document.getElementById('addSupplierModal');
                            if (event.target === medicineModal) closeAddMedicineModal();
                            if (event.target === supplierModal) closeAddSupplierModal();
                        }
                        // Prevent form submit if empty or any invalid quantity
                        document.getElementById('importForm').addEventListener('submit', function (e) {
                            if (medicineList.length === 0) {
                                alert('Vui lòng thêm ít nhất 1 loại thuốc vào phiếu nhập.');
                                e.preventDefault();
                                return;
                            }
                            let hasError = false;
                            for (let i = 0; i < medicineList.length; i++) {
                                const qty = medicineList[i].quantity;
                                const price = medicineList[i].price;
                                if (!qty || qty <= 0 || qty > 1000 || !price || price <= 0 || price > 100000000) {
                                    hasError = true;
                                    break;
                                }
                            }
                            if (hasError) {
                                alert('Có thuốc với số lượng hoặc đơn giá không hợp lệ. Vui lòng kiểm tra lại.');
                                e.preventDefault();
                            }
                        });

                        // Initialize table on load
                        document.addEventListener('DOMContentLoaded', function () {
                            updateTable();
                        });
                    </script>
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>