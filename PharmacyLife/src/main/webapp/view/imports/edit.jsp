<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html>

            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <title>Chỉnh sửa phiếu nhập</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/import.css">
                <style>
                    /* Shared overrides for the Edit Card to match design */
                    .edit-card {
                        background-color: white;
                        border-radius: 12px;
                        padding: 40px;
                        max-width: 900px;
                        margin: 0 auto;
                        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
                    }

                 
                        body {
                            background-color: #f4f6f9;
                        }

                        .sidebar-wrapper {
                            top: 115px !important;
                            height: calc(100vh - 115px) !important;
                            z-index: 100;
                        }

                        .main-content-dashboard {
                            margin-left: 250px;
                            padding: 30px;
                            margin-top: 115px;
                            max-width: 100%;
                            width: calc(100% - 250px);
                        }

                        .page-title-dashboard {
                            font-size: 28px;
                            font-weight: 700;
                            color: #2c3e50;
                            margin-bottom: 30px;
                            display: flex;
                            align-items: center;
                            gap: 15px;
                        }

                        .card-custom {
                            background: white;
                            border-radius: 12px;
                            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
                            border: 1px solid #eef2f7;
                            padding: 25px;
                        }
                    </style>
                </head>

                <body>
                    <jsp:include page="/view/common/header.jsp" />
                    <jsp:include page="/view/common/sidebar.jsp" />

                    <div class="main-content-dashboard">
                        <div class="page-title-dashboard">
                            <i class="fas fa-edit" style="color: #4F81E1;"></i>
                            <span>Cập nhật phiếu nhập thuốc</span>
                        </div>

                    .edit-footer {
                        display: flex;
                        justify-content: space-between;
                        /* Spread buttons */
                        margin-top: 40px;
                        align-items: center;
                    }

                    .btn-cancel {
                        background-color: #999;
                        color: white;
                        border: none;
                        padding: 10px 30px;
                        border-radius: 20px;
                        font-size: 16px;
                        cursor: pointer;
                        font-weight: bold;
                        transition: background 0.2s;
                        text-decoration: none;
                    }

                    .btn-cancel:hover {
                        background-color: #888;
                    }

                    .btn-save {
                        background-color: #4a86e8;
                        color: white;
                        border: none;
                        padding: 10px 40px;
                        border-radius: 20px;
                        font-size: 16px;
                        cursor: pointer;
                        font-weight: bold;
                        display: inline-flex;
                        align-items: center;
                        gap: 8px;
                        transition: background 0.2s;
                    }

                    .btn-save:hover {
                        background-color: #3b75d6;
                    }
                </style>
            </head>

            <body>
                <jsp:include page="/view/common/header.jsp" />
                <jsp:include page="/view/common/sidebar.jsp" />

                <div class="main-content-dashboard">
                    <div class="page-title-dashboard">
                        <i class="fas fa-edit" style="color: #4F81E1;"></i>
                        <span>Chỉnh sửa phiếu nhập thuốc</span>
                    </div>

                    <div class="card-custom">
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i>${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                                <c:if test="${not empty importRecord}">
                                    <form action="${pageContext.request.contextPath}/ImportController" method="POST">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="importId" value="${importRecord.importId}">
                                        <!-- Pass original ID if implicit -->

                                        <div class="edit-card">
                                            <div class="edit-title-center">Chỉnh sửa phiếu nhập</div>

                                            <div class="edit-grid">
                                                <!-- Row 1 -->
                                                <div>
                                                    <label class="edit-label">Mã</label>
                                                    <input type="text" class="edit-input-readonly"
                                                        value="${importRecord.importCode}" readonly>
                                                </div>
                                                <div>
                                                    <label class="edit-label">Nhà cung cấp</label>
                                                    <select name="supplierId" class="edit-select" required>
                                                        <option value="">-- Chọn nhà cung cấp --</option>
                                                        <c:forEach var="supplier" items="${suppliers}">
                                                            <option value="${supplier[0]}"
                                                                ${supplier[0]==importRecord.supplierId ? 'selected' : ''
                                                                }>
                                                                ${supplier[1]}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>

                                                <!-- Row 2 -->
                                                <div>
                                                    <label class="edit-label">Người nhập</label>
                                                    <input type="text" class="edit-input-readonly"
                                                        value="${importRecord.staffName}" readonly
                                                        style="cursor: not-allowed;">
                                                    <input type="hidden" name="importerId"
                                                        value="${importRecord.staffId}">
                                                </div>
                                                <div>
                                                    <label class="edit-label">Ngày nhập</label>
                                                    <input type="date" name="importDate" class="edit-input"
                                                        value="<fmt:formatDate value='${importRecord.importDate}' pattern='yyyy-MM-dd'/>">
                                                </div>

                                                <!-- Row 3 -->
                                                <div>
                                                    <label class="edit-label">Tổng tiền</label>
                                                    <input type="text" class="edit-input-readonly"
                                                        value="<fmt:formatNumber value='${importRecord.totalAmount}' type='number' maxFractionDigits='0'/>₫"
                                                        readonly>
                                                </div>
                                                <div>
                                                    <label class="edit-label">Trạng thái</label>
                                                    <select name="status" class="edit-select">
                                                        <option value="Đang chờ" ${importRecord.status=='Đang chờ'
                                                            ? 'selected' : '' }>Đang chờ</option>
                                                        <option value="Chưa duyệt" ${importRecord.status=='Chưa duyệt'
                                                            ? 'selected' : '' }>Chưa duyệt</option>
                                                        <option value="Đã duyệt" ${importRecord.status=='Đã duyệt'
                                                            ? 'selected' : '' }>Đã duyệt</option>
                                                    </select>
                                                </div>
                                            </div>

                                            <!-- Full Medicine List Editor (Reused from Create or similar) -->
                                            <!-- Requirements imply editing header mostly, but 'all info' likely includes items. -->
                                            <!-- For simplicity and to match the 'Edit Import Note' screenshot focus, we show the list but maybe as view-only or removable? -->
                                            <!-- The user said: "when editing medicine [import]... shows previous import note and allows editing all info". -->
                                            <!-- I will provide the list with DELETE buttons (similar to Create) and an Add button? -->
                                            <!-- To fully support editing items, we need complex logic. -->
                                            <!-- Let's start with matching the screenshot (Header Edit) and a simplified list. -->

                                            <c:if test="${not empty details}">
                                                <div
                                                    style="margin-top: 40px; border-top: 1px solid #eee; padding-top: 20px;">
                                                    <div
                                                        style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 20px;">
                                                        <label class="edit-label"
                                                            style="font-size: 18px; margin:0;">Danh sách thuốc</label>
                                                        <button type="button" class="btn-save" onclick="openAddMedicineModal()"
                                                            style="padding: 5px 15px; font-size:13px; border: none; cursor: pointer;">+
                                                            Thêm thuốc</button>
                                                    </div>

                                                    <table class="clean-table">
                                                        <thead>
                                                            <tr>
                                                                <th>Mã thuốc</th>
                                                                <th>Tên thuốc</th>
                                                                <th>Số lượng</th>
                                                                <th>Giá</th>
                                                                <th>Thành tiền</th>
                                                                <th>Thao tác</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <c:forEach var="detail" items="${details}">
                                                                <tr>
                                                                    <td>${detail.medicineCode}</td>
                                                                    <td>${detail.medicineName != null ?
                                                                        detail.medicineName : '-'}</td>
                                                                    <td>${detail.quantity}</td>
                                                                    <td class="amount-green">
                                                                        <fmt:formatNumber value="${detail.unitPrice}"
                                                                            type="number" maxFractionDigits="0" />₫
                                                                    </td>
                                                                    <td class="amount-green">
                                                                        <fmt:formatNumber value="${detail.totalAmount}"
                                                                            type="number" maxFractionDigits="0" />₫
                                                                    </td>
                                                                    <td>
                                                                        <a href="${pageContext.request.contextPath}/ImportController?action=deleteDetail&detailId=${detail.detailId}&importId=${importRecord.importId}"
                                                                            class="icon-trash"
                                                                            style="margin: 0 auto; text-decoration:none;"
                                                                            onclick="return confirm('Xóa thuốc này khỏi phiếu?')">🗑</a>
                                                                    </td>
                                                                </tr>
                                                            </c:forEach>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </c:if>

                                            <!-- New Medicines Section -->
                                            <div id="newMedicinesSection" style="margin-top: 40px; border-top: 1px solid #eee; padding-top: 20px; display: none;">
                                                <h6 style="font-weight: bold; margin-bottom: 15px;">Thuốc mới thêm</h6>
                                                <table class="clean-table">
                                                    <thead>
                                                        <tr>
                                                            <th>Mã thuốc</th>
                                                            <th>Tên thuốc</th>
                                                            <th>Số lượng</th>
                                                            <th>Giá</th>
                                                            <th>Thành tiền</th>
                                                            <th>Thao tác</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody id="newMedicineListBody">
                                                        <tr><td colspan="6" style="text-align: center; padding: 15px; color: #999;">Chưa thêm thuốc mới</td></tr>
                                                    </tbody>
                                                </table>
                                                <div id="newHiddenInputsContainer"></div>
                                            </div>

                                            <div class="edit-footer">
                                <a href="${pageContext.request.contextPath}/import" class="btn-cancel">Đóng</a>
                                <button type="submit" class="btn-save">
                                    <span>💾</span> Lưu
                                </button>
                            </div>
                        </div>
                    </form>
                </c:if>
                    </div>  <!-- closes card-custom -->
                </div>  <!-- closes main-content-dashboard -->

                <!-- Modal for Adding Medicines -->
                <div id="addMedicineModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000; justify-content: center; align-items: center;">
                    <div style="background: white; padding: 25px; border-radius: 8px; max-width: 500px; width: 90%; max-height: 80vh; overflow-y: auto;">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                            <h5 style="margin: 0; font-weight: bold;">Thêm thuốc vào phiếu nhập</h5>
                            <button type="button" onclick="closeAddMedicineModal()" style="background: none; border: none; font-size: 24px; cursor: pointer;">&times;</button>
                        </div>
                        <div class="form-group mb-3">
                            <label class="form-label">Mã thuốc</label>
                            <select id="modalMedicineId" class="form-select">
                                <option value="">-- Chọn thuốc --</option>
                                <c:forEach var="med" items="${medicines}">
                                    <option value="${med.medicineId}">${med.medicineCode} - ${med.medicineName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group mb-3">
                            <label class="form-label">Số lượng</label>
                            <input type="number" id="modalQuantity" class="form-control" min="1" placeholder="Nhập số lượng" oninput="calculateModalTotal()">
                        </div>
                        <div class="form-group mb-3">
                            <label class="form-label">Giá</label>
                            <input type="number" id="modalPrice" class="form-control" min="0" step="0.01" placeholder="Nhập giá" oninput="calculateModalTotal()">
                        </div>
                        <div class="form-group mb-3">
                            <div style="font-size: 16px; font-weight: bold; color: #28a745; padding: 10px 0;">
                                Thành tiền: <span id="modalTotalDisplay">0₫</span>
                            </div>
                        </div>
                        <div style="display: flex; justify-content: flex-end; gap: 10px; margin-top: 20px;">
                            <button type="button" class="btn btn-secondary" onclick="closeAddMedicineModal()">Hủy</button>
                            <button type="button" class="btn btn-primary" onclick="addMedicineFromModal()">+ Thêm</button>
                        </div>
                    </div>
                </div>

                <script>
                    let newMedicineList = [];

                    function openAddMedicineModal() {
                        document.getElementById('addMedicineModal').style.display = 'flex';
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
                            fetch('${pageContext.request.contextPath}/MedicineAjaxController?action=getPrice&id=' + medicineId)
                                .then(response => response.json())
                                .then(data => {
                                    if (data && data.price !== undefined) {
                                        document.getElementById('modalPrice').value = data.price;
                                        calculateModalTotal();
                                    }
                                })
                                .catch(err => console.error('Error fetching price:', err));
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
                        newMedicineList.push({ 
                            medicineId: medicineId, 
                            medicineCode: medicineCode, 
                            quantity: quantity, 
                            price: price, 
                            total: total 
                        });

                        updateNewMedicinesTable();
                        closeAddMedicineModal();
                    }

                    function removeNewMedicine(index) {
                        newMedicineList.splice(index, 1);
                        updateNewMedicinesTable();
                    }

                    function updateNewMedicinesTable() {
                        const tbody = document.getElementById('newMedicineListBody');
                        const hiddenContainer = document.getElementById('newHiddenInputsContainer');
                        const section = document.getElementById('newMedicinesSection');
                        
                        if (!tbody || !hiddenContainer) return;
                        
                        tbody.innerHTML = '';
                        hiddenContainer.innerHTML = '';
                        
                        if (newMedicineList.length === 0) {
                            tbody.innerHTML = '<tr><td colspan="6" style="text-align: center; padding: 15px; color: #999;">Chưa thêm thuốc mới</td></tr>';
                            section.style.display = 'none';
                        } else {
                            section.style.display = 'block';
                            newMedicineList.forEach((item, index) => {
                                tbody.innerHTML += `<tr><td>\${item.medicineCode}</td><td>\${item.medicineName || '-'}</td><td>\${item.quantity}</td><td class="price-text">\${formatCurrency(item.price)}</td><td class="price-text">\${formatCurrency(item.total)}</td><td><button type="button" class="btn btn-sm btn-danger" onclick="removeNewMedicine(\${index})"><i class="fas fa-trash"></i></button></td></tr>`;
                                hiddenContainer.innerHTML += `<input type="hidden" name="newMedicines[\${index}].medicineId" value="\${item.medicineId}"><input type="hidden" name="newMedicines[\${index}].quantity" value="\${item.quantity}"><input type="hidden" name="newMedicines[\${index}].price" value="\${item.price}">`;
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

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
            </body>

                                    <!-- Medicine List -->
                                    <div class="mt-5">
                                        <div class="d-flex justify-content-between align-items-center mb-3">
                                            <h5 class="fw-bold"><i class="fas fa-list me-2"></i>Danh sách thuốc</h5>
                                            <button type="button" class="btn btn-primary btn-sm"
                                                onclick="alert('Thêm thuốc mới sẽ được cập nhật sau')">
                                                <i class="fas fa-plus me-1"></i>Thêm thuốc
                                            </button>
                                        </div>
                                        <div class="table-responsive">
                                            <table class="table table-hover border">
                                                <thead class="table-light">
                                                    <tr>
                                                        <th>Mã thuốc</th>
                                                        <th>Tên thuốc</th>
                                                        <th>Số lượng</th>
                                                        <th>Giá</th>
                                                        <th>Thành tiền</th>
                                                        <th class="text-center">Thao tác</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="detail" items="${details}">
                                                        <tr>
                                                            <td><strong>${detail.medicineCode}</strong></td>
                                                            <td>${detail.medicineName != null ? detail.medicineName :
                                                                '-'}</td>
                                                            <td>${detail.quantity}</td>
                                                            <td class="text-success">
                                                                <fmt:formatNumber value="${detail.price}" type="number"
                                                                    maxFractionDigits="0" />₫
                                                            </td>
                                                            <td class="text-success fw-bold">
                                                                <fmt:formatNumber value="${detail.totalAmount}"
                                                                    type="number" maxFractionDigits="0" />₫
                                                            </td>
                                                            <td class="text-center">
                                                                <a href="${pageContext.request.contextPath}/import?action=deleteDetail&detailId=${detail.detailId}&id=${import.importId}"
                                                                    class="btn btn-sm btn-outline-danger"
                                                                    onclick="return confirm('Xóa thuốc này khỏi phiếu?')">
                                                                    <i class="fas fa-trash"></i>
                                                                </a>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>

                                    <div class="mt-5 d-flex justify-content-between">
                                        <a href="${pageContext.request.contextPath}/import"
                                            class="btn btn-secondary px-4">
                                            <i class="fas fa-arrow-left me-2"></i>Trở lại
                                        </a>
                                        <button type="submit" class="btn btn-success px-5">
                                            <i class="fas fa-save me-2"></i>Lưu thay đổi
                                        </button>
                                    </div>
                                </form>
                         
                        </div>
                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>