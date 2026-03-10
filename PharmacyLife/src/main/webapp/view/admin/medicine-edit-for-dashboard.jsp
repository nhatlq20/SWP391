<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Chỉnh sửa thuốc - PharmacyLife</title>
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
                            <h3><i class="fas fa-edit me-2 text-primary"></i>Chỉnh sửa thuốc</h3>
                        </div>
                        <div class="form-card-body">
                            <c:if test="${not empty errorMessage}">
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    ${errorMessage}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                            </c:if>

                            <form method="post"
                                action="${pageContext.request.contextPath}/admin/medicine-edit-dashboard">
                                <input type="hidden" name="medicineId" value="${medicine.medicineId}">
                                <div class="row g-4">
                                    <div class="col-md-6">
                                        <label class="form-label">Mã thuốc</label>
                                        <input name="medicineCode" class="form-control" value="${medicine.medicineCode}"
                                            required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Danh mục</label>
                                        <select name="categoryId" class="form-select" required>
                                            <option value="">Chọn danh mục</option>
                                            <c:forEach var="cat" items="${categories}">
                                                <option value="${cat.categoryId}" ${cat.categoryId==medicine.categoryId
                                                    ? 'selected' : '' }>${cat.categoryName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Ảnh</label>
                                        <input name="imageUrl" class="form-control" value="${medicine.imageUrl}">
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label">Tên thuốc</label>
                                        <input name="medicineName" class="form-control" value="${medicine.medicineName}"
                                            required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Giá bán (đ)</label>
                                        <input name="sellingPrice" type="number" step="1" min="1" class="form-control"
                                            value="${medicine.sellingPrice}" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Thương hiệu / xuất xứ</label>
                                        <input name="brandOrigin" class="form-control" value="${medicine.brandOrigin}">
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label">Đơn vị chính</label>
                                        <select name="unit" class="form-select" id="mainUnitSelect">
                                            <option value="Hộp" ${medicine.unit=='Hộp' ? 'selected' : '' }>Hộp</option>
                                            <option value="Chai" ${medicine.unit=='Chai' ? 'selected' : '' }>Chai
                                            </option>
                                            <option value="Tuýp" ${medicine.unit=='Tuýp' ? 'selected' : '' }>Tuýp
                                            </option>
                                            <option value="Lọ" ${medicine.unit=='Lọ' ? 'selected' : '' }>Lọ</option>
                                            <option value="Hũ" ${medicine.unit=='Hũ' ? 'selected' : '' }>Hũ</option>
                                            <option value="Phần" ${medicine.unit=='Phần' ? 'selected' : '' }>Phần
                                            </option>
                                            <option value="Lốc" ${medicine.unit=='Lốc' ? 'selected' : '' }>Lốc</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3" id="subUnit1Wrapper">
                                        <label class="form-label">Đơn vị quy đổi 1</label>
                                        <select name="subUnit1" class="form-select" id="subUnit1Select">
                                            <option value="">-- Không --</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3" id="subUnit2Wrapper" style="display:none;">
                                        <label class="form-label">Đơn vị quy đổi 2</label>
                                        <select name="subUnit2" class="form-select" id="subUnit2Select">
                                            <option value="">-- Không --</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label">Thành phần</label>
                                        <input name="ingredients" class="form-control" value="${medicine.ingredients}"
                                            placeholder="Nhập thành phần thuốc">
                                    </div>

                                    <!-- Sub Unit Conversion Rates (shown dynamically) -->
                                    <div id="subUnit1RateSection" class="col-12" style="display:none;">
                                        <div class="row g-3 align-items-end"
                                            style="background: #f8f9fa; padding: 15px; border-radius: 8px; border-left: 4px solid #0d6efd;">
                                            <div class="col-md-4">
                                                <label class="form-label fw-bold text-primary">
                                                    1 <span class="main-unit-name">Hộp</span> =
                                                </label>
                                                <div class="input-group">
                                                    <input name="subRate1" type="number" min="1" class="form-control"
                                                        placeholder="Số lượng">
                                                    <span class="input-group-text subunit1-name">đơn vị</span>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <label class="form-label">Giá bán tương ứng (đ)</label>
                                                <input name="subPrice1" type="number" min="0" class="form-control"
                                                    placeholder="Giá bán">
                                            </div>
                                        </div>
                                    </div>

                                    <div id="subUnit2RateSection" class="col-12" style="display:none;">
                                        <div class="row g-3 align-items-end"
                                            style="background: #f8f9fa; padding: 15px; border-radius: 8px; border-left: 4px solid #0d6efd;">
                                            <div class="col-md-4">
                                                <label class="form-label fw-bold text-primary">
                                                    1 <span class="subunit1-name-display">đơn vị</span> =
                                                </label>
                                                <div class="input-group">
                                                    <input name="subRate2" type="number" min="1" class="form-control"
                                                        placeholder="Số lượng">
                                                    <span class="input-group-text subunit2-name">đơn vị</span>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <label class="form-label">Giá bán tương ứng (đ)</label>
                                                <input name="subPrice2" type="number" min="0" class="form-control"
                                                    placeholder="Giá bán">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label">Mô tả</label>
                                        <textarea name="shortDescription" rows="4"
                                            class="form-control">${medicine.shortDescription}</textarea>
                                    </div>
                                </div>

                                <div class="d-flex justify-content-between mt-4">
                                    <a href="${pageContext.request.contextPath}/admin/medicines-dashboard"
                                        class="btn-back">
                                        <i class="fas fa-chevron-left"></i> Trở lại
                                    </a>
                                    <button type="submit" class="btn-submit">
                                        <i class="fas fa-save"></i> Lưu
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Hidden data for units initialization -->
                <div id="unitsContainer" style="display:none;">
                    <c:forEach var="u" items="${units}">
                        <span class="unit-data" data-name="${u.unitName}" data-rate="${u.conversionRate}"
                            data-price="${u.sellingPrice}" data-base="${u.baseUnit}"></span>
                    </c:forEach>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    // ========== Mapping Rules ==========
                    // Main Unit → Sub-unit 1 options
                    var subUnit1Map = {
                        'Hộp': ['Vỉ', 'Gói', 'Ống', 'Miếng', 'Viên'],
                        'Tuýp': ['Viên'],
                        'Phần': ['Viên'],
                        'Lốc': ['Chai', 'Gói']
                        // Chai, Hũ, Lọ → no sub-units
                    };

                    // Sub-unit 1 → Sub-unit 2 options
                    var subUnit2Map = {
                        'Vỉ': ['Viên'],
                        'Gói': ['Miếng', 'Viên']
                    };

                    // ========== DOM References ==========
                    var mainUnitSelect = document.getElementById('mainUnitSelect');
                    var subUnit1Select = document.getElementById('subUnit1Select');
                    var subUnit2Select = document.getElementById('subUnit2Select');
                    var subUnit1Wrapper = document.getElementById('subUnit1Wrapper');
                    var subUnit2Wrapper = document.getElementById('subUnit2Wrapper');
                    var subUnit1RateSection = document.getElementById('subUnit1RateSection');
                    var subUnit2RateSection = document.getElementById('subUnit2RateSection');

                    var sellingPriceInput = document.querySelector('input[name="sellingPrice"]');
                    var subRate1Input = document.querySelector('input[name="subRate1"]');
                    var subPrice1Input = document.querySelector('input[name="subPrice1"]');
                    var subRate2Input = document.querySelector('input[name="subRate2"]');
                    var subPrice2Input = document.querySelector('input[name="subPrice2"]');

                    // ========== Functions ==========
                    function populateSelect(selectEl, options, placeholder) {
                        selectEl.innerHTML = '<option value="">' + placeholder + '</option>';
                        options.forEach(function (name) {
                            var o = document.createElement('option');
                            o.value = name;
                            o.textContent = name;
                            selectEl.appendChild(o);
                        });
                    }

                    function updateSubUnit1() {
                        var mainUnit = mainUnitSelect.value;
                        var opts = subUnit1Map[mainUnit] || [];

                        if (opts.length > 0) {
                            subUnit1Wrapper.style.display = '';
                            populateSelect(subUnit1Select, opts, '-- Chọn đơn vị --');
                        } else {
                            subUnit1Wrapper.style.display = 'none';
                            subUnit1Select.innerHTML = '<option value="">-- Không --</option>';
                        }

                        // Update main unit name labels
                        document.querySelectorAll('.main-unit-name').forEach(function (el) {
                            el.textContent = mainUnit;
                        });

                        // Reset sub-unit 1 rate section
                        subUnit1RateSection.style.display = 'none';
                        clearInputs(['subRate1', 'subPrice1']);

                        // Reset sub-unit 2
                        resetSubUnit2();
                    }

                    function updateSubUnit2() {
                        var sub1 = subUnit1Select.value;

                        if (sub1) {
                            // Show rate section for sub-unit 1
                            subUnit1RateSection.style.display = '';
                            document.querySelectorAll('.subunit1-name').forEach(function (el) { el.textContent = sub1; });
                            document.querySelectorAll('.subunit1-name-display').forEach(function (el) { el.textContent = sub1; });
                        } else {
                            subUnit1RateSection.style.display = 'none';
                            clearInputs(['subRate1', 'subPrice1']);
                        }

                        // Check sub-unit 2
                        var opts2 = subUnit2Map[sub1] || [];
                        if (opts2.length > 0) {
                            subUnit2Wrapper.style.display = '';
                            populateSelect(subUnit2Select, opts2, '-- Chọn đơn vị --');
                        } else {
                            resetSubUnit2();
                        }
                    }

                    function onSubUnit2Change() {
                        var sub2 = subUnit2Select.value;
                        if (sub2) {
                            subUnit2RateSection.style.display = '';
                            document.querySelectorAll('.subunit2-name').forEach(function (el) { el.textContent = sub2; });
                        } else {
                            subUnit2RateSection.style.display = 'none';
                            clearInputs(['subRate2', 'subPrice2']);
                        }
                    }

                    function resetSubUnit2() {
                        subUnit2Wrapper.style.display = 'none';
                        subUnit2Select.innerHTML = '<option value="">-- Không --</option>';
                        subUnit2RateSection.style.display = 'none';
                        clearInputs(['subRate2', 'subPrice2']);
                    }

                    function clearInputs(names) {
                        names.forEach(function (name) {
                            var el = document.querySelector('[name="' + name + '"]');
                            if (el) el.value = '';
                        });
                    }

                    function autoCalculatePrices() {
                        var sp = parseFloat(sellingPriceInput.value);
                        if (isNaN(sp) || sp <= 0) return; // Không có giá bán chính thì bỏ qua

                        var r1 = parseFloat(subRate1Input.value);
                        if (!isNaN(r1) && r1 > 0) {
                            var p1 = Math.round(sp / r1);
                            subPrice1Input.value = p1;

                            var r2 = parseFloat(subRate2Input.value);
                            if (!isNaN(r2) && r2 > 0) {
                                var p2 = Math.round(p1 / r2);
                                subPrice2Input.value = p2;
                            }
                        }
                    }

                    // ========== Event Listeners ==========
                    mainUnitSelect.addEventListener('change', updateSubUnit1);
                    subUnit1Select.addEventListener('change', updateSubUnit2);
                    subUnit2Select.addEventListener('change', onSubUnit2Change);

                    sellingPriceInput.addEventListener('input', autoCalculatePrices);
                    subRate1Input.addEventListener('input', autoCalculatePrices);
                    subRate2Input.addEventListener('input', autoCalculatePrices);

                    // Initialize on page load with existing units from server
                    (function () {
                        var units = [];
                        document.querySelectorAll('.unit-data').forEach(function (el) {
                            units.push({
                                unitName: el.getAttribute('data-name'),
                                conversionRate: Number(el.getAttribute('data-rate')),
                                sellingPrice: Number(el.getAttribute('data-price')),
                                isBase: el.getAttribute('data-base') === 'true'
                            });
                        });

                        // Sort by conversion rate DESC
                        units.sort(function (a, b) { return b.conversionRate - a.conversionRate; });

                        if (units.length > 0) {
                            // Main unit is already set by JSTL in the HTML select
                            updateSubUnit1();

                            if (units.length > 1) {
                                // Set sub-unit 1
                                subUnit1Select.value = units[1].unitName;
                                updateSubUnit2();

                                // Calculate subRate1: 1 Main Unit = X SubUnit1
                                var rate1 = units[0].conversionRate / units[1].conversionRate;
                                subRate1Input.value = rate1;
                                subPrice1Input.value = units[1].sellingPrice;

                                if (units.length > 2) {
                                    // Set sub-unit 2
                                    subUnit2Select.value = units[2].unitName;
                                    onSubUnit2Change();

                                    // Calculate subRate2: 1 SubUnit1 = Y SubUnit2
                                    var rate2 = units[1].conversionRate / units[2].conversionRate;
                                    subRate2Input.value = rate2;
                                    subPrice2Input.value = units[2].sellingPrice;
                                }
                            }
                        }
                    })();
                </script>
            </body>

            </html>