<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Thêm voucher mới - PharmacyLife</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/medicine-dashboard.css">
                <style>
                    .form-label {
                        font-weight: 600;
                        color: #4b5563;
                    }

                    .card-form {
                        background: white;
                        border-radius: 12px;
                        box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1);
                        padding: 30px;
                        max-width: 800px;
                        margin: 0 auto;
                    }
                </style>
            </head>

            <body class="bg-light">
                <jsp:include page="/view/common/header.jsp" />
                <jsp:include page="/view/common/sidebar.jsp" />

                <div class="main-content">
                    <div class="d-flex align-items-center mb-4">
                        <a href="${pageContext.request.contextPath}/admin/vouchers" class="btn btn-light me-3">
                            <i class="fas fa-arrow-left"></i>
                        </a>
                        <h3 class="fw-bold mb-0">Thêm mã giảm giá mới</h3>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger ms-auto me-auto mb-4" style="max-width: 800px;">
                            <i class="fas fa-exclamation-circle me-2"></i> ${error}
                        </div>
                    </c:if>

                    <div class="card-form">
                        <form action="voucher-add" method="POST">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label for="voucherCode" class="form-label">Mã Voucher (Vd: SUMMER2024)</label>
                                    <input type="text" class="form-control" id="voucherCode" name="voucherCode" required
                                        maxlength="20">
                                </div>
                                <div class="col-md-6">
                                    <label for="quantity" class="form-label">Tổng số lượng phát hành</label>
                                    <input type="number" class="form-control" id="quantity" name="quantity" required
                                        min="1">
                                </div>

                                <div class="col-12">
                                    <label for="description" class="form-label">Mô tả chi tiết</label>
                                    <textarea class="form-control" id="description" name="description" rows="2"
                                        maxlength="255"></textarea>
                                </div>

                                <div class="col-md-3">
                                    <label for="discountType" class="form-label">Loại giảm giá</label>
                                    <select class="form-select" id="discountType" name="discountType" required
                                        onchange="toggleMaxAmt()">
                                        <option value="Percent">Phần trăm (%)</option>
                                        <option value="Fixed">Số tiền cố định (VND)</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label for="discountValue" class="form-label">Giá trị giảm</label>
                                    <input type="number" step="0.01" class="form-control" id="discountValue"
                                        name="discountValue" required>
                                </div>
                                <div class="col-md-3">
                                    <label for="minOrderValue" class="form-label">Đơn tối thiểu (VND)</label>
                                    <input type="number" step="0.01" class="form-control" id="minOrderValue"
                                        name="minOrderValue" value="0">
                                </div>
                                <div class="col-md-3" id="maxDiscountContainer">
                                    <label for="maxDiscountAmount" class="form-label">Giảm tối đa (VND)</label>
                                    <input type="number" step="0.01" class="form-control" id="maxDiscountAmount"
                                        name="maxDiscountAmount">
                                </div>

                                <div class="col-md-6">
                                    <label for="startDate" class="form-label">Ngày bắt đầu</label>
                                    <input type="datetime-local" class="form-control" id="startDate" name="startDate"
                                        required>
                                </div>
                                <div class="col-md-6">
                                    <label for="endDate" class="form-label">Ngày kết thúc</label>
                                    <input type="datetime-local" class="form-control" id="endDate" name="endDate"
                                        required>
                                </div>

                                <div class="col-md-6 d-flex align-items-center mt-auto">
                                    <div class="form-check form-switch ms-3">
                                        <input class="form-check-input" type="checkbox" id="isActive" name="isActive"
                                            checked>
                                        <label class="form-check-label fw-bold" for="isActive">Kích hoạt ngay</label>
                                    </div>
                                </div>

                                <div class="col-12 mt-4">
                                    <button type="submit" class="btn btn-primary w-100 py-3 fw-bold" id="submitBtn">TẠO
                                        VOUCHER</button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <script>
                    function validateDates() {
                        var startDate = new Date(document.getElementById('startDate').value);
                        var endDate = new Date(document.getElementById('endDate').value);
                        var endDateInput = document.getElementById('endDate');

                        if (endDate <= startDate) {
                            endDateInput.setCustomValidity('Ngày kết thúc phải muộn hơn ngày bắt đầu');
                        } else {
                            endDateInput.setCustomValidity('');
                        }
                    }

                    function toggleMaxAmt() {
                        var type = document.getElementById('discountType').value;
                        var container = document.getElementById('maxDiscountContainer');
                        var input = document.getElementById('maxDiscountAmount');
                        if (type === 'Fixed') {
                            container.style.opacity = '0.5';
                            input.disabled = true;
                            input.value = '';
                        } else {
                            container.style.opacity = '1';
                            input.disabled = false;
                        }
                    }

                    // Cài đặt ngày mặc định
                    window.onload = function () {
                        var now = new Date();
                        // Format current time to local ISO string
                        var tzoffset = (new Date()).getTimezoneOffset() * 60000;
                        var localISOTime = (new Date(Date.now() - tzoffset)).toISOString().slice(0, 16);

                        document.getElementById('startDate').value = localISOTime;
                        document.getElementById('startDate').min = localISOTime;

                        var nextMonth = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000);
                        var nextMonthISOTime = (new Date(nextMonth.getTime() - tzoffset)).toISOString().slice(0, 16);
                        document.getElementById('endDate').value = nextMonthISOTime;

                        document.getElementById('startDate').addEventListener('change', validateDates);
                        document.getElementById('endDate').addEventListener('change', validateDates);

                        validateDates(); // Initial check
                    };
                </script>
            </body>

            </html>