<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Thêm thuốc mới - PharmacyLife</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/medicine-dashboard.css">
        </head>

        <body class="bg-light">
            <jsp:include page="/view/common/header.jsp" />
            <jsp:include page="/view/common/sidebar.jsp" />

            <div class="main-content">
                <div class="form-card">
                    <div class="form-card-header">
                        <h3><i class="fas fa-plus-circle me-2 text-primary"></i>Thêm thuốc mới</h3>
                    </div>
                    <div class="form-card-body">
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                ${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <form method="post" action="${pageContext.request.contextPath}/admin/medicine-add-dashboard">
                            <div class="row g-4">
                                <div class="col-md-6">
                                    <label class="form-label">Mã thuốc</label>
                                    <input id="medicineCodeInput" name="medicineCode" class="form-control"
                                        value="${nextMedicineCode}" readonly
                                        style="background-color:#e9ecef; cursor:not-allowed;">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Danh mục</label>
                                    <select name="categoryId" id="categorySelect" class="form-select" required
                                        onchange="fetchNextCode(this.value)">
                                        <option value="">Chọn danh mục của thuốc</option>
                                        <c:forEach var="cat" items="${categories}">
                                            <option value="${cat.categoryId}">${cat.categoryName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Ảnh <span class="text-danger">*</span></label>
                                    <input name="imageUrl" class="form-control" placeholder="Nhập đường dẫn ảnh"
                                        required>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label">Tên thuốc</label>
                                    <input name="medicineName" class="form-control" placeholder="Nhập tên thuốc"
                                        required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Giá bán (đ) <span class="text-danger">*</span></label>
                                    <input name="sellingPrice" type="number" step="1" min="1" class="form-control"
                                        placeholder="Nhập giá thuốc" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Thương hiệu / xuất xứ <span
                                            class="text-danger">*</span></label>
                                    <input name="brandOrigin" class="form-control"
                                        placeholder="Nhập thương hiệu / xuất xứ" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Đơn vị chính (ví dụ: Hộp)</label>
                                    <select name="unit" class="form-select" id="mainUnitSelect">
                                        <option value="Hộp">Hộp</option>
                                        <option value="Vỉ">Vỉ</option>
                                        <option value="Chai">Chai</option>
                                        <option value="Tuýp">Tuýp</option>
                                        <option value="Gói">Gói</option>
                                        <option value="Lọ">Lọ</option>
                                        <option value="Viên">Viên</option>
                                        <option value="Miếng">Miếng</option>
                                        <option value="Ống">Ống</option>
                                        <option value="Hũ">Hũ</option>
                                        <option value="Phần">Phần</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Thành phần</label>
                                    <input name="ingredients" class="form-control" placeholder="Nhập thành phần thuốc">
                                </div>

                                <!-- Sub Unit Toggle -->
                                <div class="col-12">
                                    <button type="button" class="btn btn-sm btn-outline-primary"
                                        onclick="toggleSubUnits()">
                                        <i class="fas fa-chevron-down me-1"></i> Thêm đơn vị quy đổi nhỏ hơn (Vỉ,
                                        Viên...)
                                    </button>
                                </div>

                                <!-- Sub Unit Section -->
                                <div id="subUnitSection" class="col-12"
                                    style="display:none; background: #f8f9fa; padding: 15px; border-radius: 8px; border-left: 4px solid #0d6efd;">
                                    <div class="row g-3">
                                        <div class="col-12 mt-0">
                                            <h6 class="text-primary fw-bold mb-0">Cấu hình đơn vị quy đổi</h6>
                                        </div>

                                        <!-- Sub Unit Level 1 -->
                                        <div class="col-md-4">
                                            <label class="form-label">Đơn vị quy đổi 1</label>
                                            <select name="subUnit1" class="form-select subunit-select">
                                                <option value="">-- Chọn đơn vị --</option>
                                                <option value="Vỉ">Vỉ</option>
                                                <option value="Gói">Gói</option>
                                                <option value="Viên">Viên</option>
                                                <option value="Miếng">Miếng</option>
                                                <option value="Ống">Ống</option>
                                            </select>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label">1 <span class="main-unit-name">Hộp</span> =
                                                ?</label>
                                            <div class="input-group">
                                                <input name="subRate1" type="number" class="form-control"
                                                    placeholder="Số lượng">
                                                <span class="input-group-text subunit1-name">đơn vị</span>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label">Giá bán tương ứng (đ)</label>
                                            <input name="subPrice1" type="number" class="form-control"
                                                placeholder="Giá bán">
                                        </div>

                                        <!-- Sub Unit Level 2 -->
                                        <div class="col-md-4">
                                            <label class="form-label">Đơn vị quy đổi 2</label>
                                            <select name="subUnit2" class="form-select subunit-select">
                                                <option value="">-- Chọn đơn vị --</option>
                                                <option value="Viên">Viên</option>
                                                <option value="Miếng">Miếng</option>
                                                <option value="Gói">Gói</option>
                                            </select>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label">1 <span class="subunit1-name-display">Vỉ</span> =
                                                ?</label>
                                            <div class="input-group">
                                                <input name="subRate2" type="number" class="form-control"
                                                    placeholder="Số lượng">
                                                <span class="input-group-text subunit2-name">đơn vị</span>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label">Giá bán tương ứng (đ)</label>
                                            <input name="subPrice2" type="number" class="form-control"
                                                placeholder="Giá bán">
                                        </div>
                                    </div>
                                </div>
                                <div class="col-12">
                                    <label class="form-label">Mô tả</label>
                                    <textarea name="shortDescription" rows="4" class="form-control"
                                        placeholder="Nhập mô tả của thuốc"></textarea>
                                </div>
                            </div>

                            <div class="d-flex justify-content-between mt-4">
                                <a href="${pageContext.request.contextPath}/admin/medicines-dashboard" class="btn-back">
                                    <i class="fas fa-chevron-left"></i> Trở lại
                                </a>
                                <button type="submit" class="btn-submit">
                                    <i class="fas fa-plus-circle"></i> Thêm thuốc
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                function toggleSubUnits() {
                    var section = document.getElementById('subUnitSection');
                    var icon = event.currentTarget.querySelector('i');
                    if (section.style.display === 'none') {
                        section.style.display = 'block';
                        icon.classList.replace('fa-chevron-down', 'fa-chevron-up');
                    } else {
                        section.style.display = 'none';
                        icon.classList.replace('fa-chevron-up', 'fa-chevron-down');
                    }
                }

                document.getElementById('mainUnitSelect').addEventListener('change', function () {
                    document.querySelectorAll('.main-unit-name').forEach(el => el.textContent = this.value);
                });

                document.querySelector('select[name="subUnit1"]').addEventListener('change', function () {
                    var val = this.value || 'đơn vị';
                    document.querySelectorAll('.subunit1-name').forEach(el => el.textContent = val);
                    document.querySelectorAll('.subunit1-name-display').forEach(el => el.textContent = val);
                });

                document.querySelector('select[name="subUnit2"]').addEventListener('change', function () {
                    var val = this.value || 'đơn vị';
                    document.querySelectorAll('.subunit2-name').forEach(el => el.textContent = val);
                });

                function fetchNextCode(categoryId) {
                    var codeInput = document.getElementById('medicineCodeInput');
                    if (!categoryId) {
                        codeInput.value = 'MED001';
                        return;
                    }
                    fetch('${pageContext.request.contextPath}/admin/medicine-next-code?categoryId=' + categoryId)
                        .then(function (resp) { return resp.text(); })
                        .then(function (code) { codeInput.value = code; })
                        .catch(function () { codeInput.value = 'MED001'; });
                }
            </script>
        </body>

        </html>